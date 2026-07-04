"""Gymnasium environment: one robot dribbling a ball into a goal.

State is tracked in meters on a field of size (field_width x field_height),
with the goal centered on the right wall (x = field_width). The agent
controls its own 2D acceleration; the ball follows simple physics and is
"dribbled" (nudged toward the agent's velocity) whenever the agent is close
enough to it.
"""

from __future__ import annotations

import numpy as np
import gymnasium as gym
from gymnasium import spaces

from soccer_rl.config import SoccerConfig


class SoccerEnv(gym.Env):
    metadata = {"render_modes": ["rgb_array", "human"], "render_fps": 20}

    def __init__(self, config: SoccerConfig | None = None, render_mode: str | None = None):
        super().__init__()
        self.cfg = config or SoccerConfig()
        self.render_mode = render_mode
        self._renderer = None  # lazily created so headless training never imports pygame display

        self.action_space = spaces.Box(low=-1.0, high=1.0, shape=(2,), dtype=np.float32)
        self.observation_space = spaces.Box(low=-2.0, high=2.0, shape=(16,), dtype=np.float32)

        self.agent_pos = np.zeros(2, dtype=np.float64)
        self.agent_vel = np.zeros(2, dtype=np.float64)
        self.ball_pos = np.zeros(2, dtype=np.float64)
        self.ball_vel = np.zeros(2, dtype=np.float64)

        self.steps = 0
        self.episode_reward = 0.0
        self.np_random_ = np.random.default_rng()

    # ------------------------------------------------------------------ #
    # Gymnasium API
    # ------------------------------------------------------------------ #
    def reset(self, *, seed: int | None = None, options: dict | None = None):
        super().reset(seed=seed)
        if seed is not None:
            self.np_random_ = np.random.default_rng(seed)

        cfg = self.cfg
        margin = cfg.agent_radius + 0.5
        self.agent_pos = np.array(
            [
                self.np_random_.uniform(margin, cfg.field_width * 0.45),
                self.np_random_.uniform(margin, cfg.field_height - margin),
            ]
        )
        self.ball_pos = np.array(
            [
                self.np_random_.uniform(cfg.field_width * 0.3, cfg.field_width * 0.7),
                self.np_random_.uniform(margin, cfg.field_height - margin),
            ]
        )
        self.agent_vel = np.zeros(2)
        self.ball_vel = np.zeros(2)
        self.steps = 0
        self.episode_reward = 0.0

        return self._get_obs(), self._get_info()

    def step(self, action: np.ndarray):
        cfg = self.cfg
        action = np.clip(np.asarray(action, dtype=np.float64), -1.0, 1.0)

        prev_agent_ball_dist = np.linalg.norm(self.ball_pos - self.agent_pos)
        prev_ball_goal_dist = self._ball_to_goal_dist()

        self._simulate_step(action)

        new_agent_ball_dist = np.linalg.norm(self.ball_pos - self.agent_pos)
        new_ball_goal_dist = self._ball_to_goal_dist()
        in_control = new_agent_ball_dist <= cfg.control_radius

        reward = 0.0
        reward += cfg.w_approach_ball * (prev_agent_ball_dist - new_agent_ball_dist)
        reward += cfg.w_ball_to_goal * (prev_ball_goal_dist - new_ball_goal_dist)
        reward += cfg.w_possession * (1.0 if in_control else 0.0)
        reward -= cfg.w_time_penalty

        scored = self._check_goal()
        terminated = False
        if scored:
            reward += cfg.goal_reward
            terminated = True

        self.steps += 1
        truncated = self.steps >= cfg.max_episode_steps
        self.episode_reward += reward

        return self._get_obs(), float(reward), terminated, truncated, self._get_info(scored=scored)

    def render(self):
        if self.render_mode not in ("rgb_array", "human"):
            return None
        if self._renderer is None:
            from soccer_rl.renderer import Renderer

            self._renderer = Renderer(self.cfg, headless=(self.render_mode == "rgb_array"))
        surface = self._renderer.draw(self.get_state(), hud=self._get_info())
        if self.render_mode == "human":
            self._renderer.blit_to_window(surface)
            return None
        return self._renderer.to_rgb_array(surface)

    def close(self):
        if self._renderer is not None:
            self._renderer.close()
            self._renderer = None

    # ------------------------------------------------------------------ #
    # Physics
    # ------------------------------------------------------------------ #
    def _simulate_step(self, action: np.ndarray):
        cfg = self.cfg

        # --- Agent dynamics ---
        self.agent_vel += action * cfg.max_agent_accel * cfg.dt
        self.agent_vel *= (1.0 - cfg.agent_friction)
        speed = np.linalg.norm(self.agent_vel)
        if speed > cfg.max_agent_speed:
            self.agent_vel *= cfg.max_agent_speed / speed
        self.agent_pos += self.agent_vel * cfg.dt
        self._clamp_to_field(self.agent_pos, self.agent_vel, cfg.agent_radius)

        # --- Ball dynamics ---
        dist_to_agent = np.linalg.norm(self.ball_pos - self.agent_pos)
        if dist_to_agent <= cfg.control_radius:
            direction = self.agent_vel.copy()
            dir_norm = np.linalg.norm(direction)
            push = direction / dir_norm * cfg.kick_push if dir_norm > 1e-6 else np.zeros(2)
            self.ball_vel = (
                (1 - cfg.dribble_strength) * self.ball_vel
                + cfg.dribble_strength * self.agent_vel
                + push
            )
        else:
            self.ball_vel *= (1.0 - cfg.ball_friction)

        ball_speed = np.linalg.norm(self.ball_vel)
        if ball_speed > cfg.max_ball_speed:
            self.ball_vel *= cfg.max_ball_speed / ball_speed

        self.ball_pos += self.ball_vel * cfg.dt
        self._bounce_ball_off_walls()

        # Keep bodies from overlapping (simple separation, no momentum transfer beyond above)
        overlap = cfg.agent_radius + cfg.ball_radius - np.linalg.norm(self.ball_pos - self.agent_pos)
        if overlap > 0:
            delta = self.ball_pos - self.agent_pos
            n = np.linalg.norm(delta)
            if n > 1e-6:
                self.ball_pos += (delta / n) * overlap

    def _clamp_to_field(self, pos: np.ndarray, vel: np.ndarray, radius: float):
        cfg = self.cfg
        if pos[0] < radius:
            pos[0] = radius
            vel[0] = 0.0
        elif pos[0] > cfg.field_width - radius:
            pos[0] = cfg.field_width - radius
            vel[0] = 0.0
        if pos[1] < radius:
            pos[1] = radius
            vel[1] = 0.0
        elif pos[1] > cfg.field_height - radius:
            pos[1] = cfg.field_height - radius
            vel[1] = 0.0

    def _bounce_ball_off_walls(self):
        cfg = self.cfg
        r = cfg.ball_radius

        # Top / bottom walls always bounce.
        if self.ball_pos[1] < r:
            self.ball_pos[1] = r
            self.ball_vel[1] = -self.ball_vel[1] * cfg.wall_restitution
        elif self.ball_pos[1] > cfg.field_height - r:
            self.ball_pos[1] = cfg.field_height - r
            self.ball_vel[1] = -self.ball_vel[1] * cfg.wall_restitution

        # Left wall always bounces (no goal there).
        if self.ball_pos[0] < r:
            self.ball_pos[0] = r
            self.ball_vel[0] = -self.ball_vel[0] * cfg.wall_restitution

        # Right wall bounces unless the ball is passing through the goal mouth.
        in_goal_mouth = cfg.goal_y_min <= self.ball_pos[1] <= cfg.goal_y_max
        if self.ball_pos[0] > cfg.field_width - r and not in_goal_mouth:
            self.ball_pos[0] = cfg.field_width - r
            self.ball_vel[0] = -self.ball_vel[0] * cfg.wall_restitution

    def _check_goal(self) -> bool:
        cfg = self.cfg
        return (
            self.ball_pos[0] >= cfg.field_width
            and cfg.goal_y_min <= self.ball_pos[1] <= cfg.goal_y_max
        )

    def _ball_to_goal_dist(self) -> float:
        return float(np.linalg.norm(np.array(self.cfg.goal_center) - self.ball_pos))

    # ------------------------------------------------------------------ #
    # Observation helpers
    # ------------------------------------------------------------------ #
    def _get_obs(self) -> np.ndarray:
        cfg = self.cfg
        wh = np.array([cfg.field_width, cfg.field_height])
        goal = np.array(cfg.goal_center)

        agent_pos_n = self.agent_pos / wh
        ball_pos_n = self.ball_pos / wh
        agent_vel_n = self.agent_vel / cfg.max_agent_speed
        ball_vel_n = self.ball_vel / cfg.max_ball_speed
        goal_pos_n = goal / wh

        vec_agent_ball = (self.ball_pos - self.agent_pos) / cfg.field_diag
        vec_ball_goal = (goal - self.ball_pos) / cfg.field_diag

        dist_agent_ball = np.array([np.linalg.norm(self.ball_pos - self.agent_pos) / cfg.field_diag])
        dist_ball_goal = np.array([self._ball_to_goal_dist() / cfg.field_diag])

        obs = np.concatenate(
            [
                agent_pos_n,
                agent_vel_n,
                ball_pos_n,
                ball_vel_n,
                goal_pos_n,
                vec_agent_ball,
                vec_ball_goal,
                dist_agent_ball,
                dist_ball_goal,
            ]
        ).astype(np.float32)
        return obs

    def _get_info(self, scored: bool = False) -> dict:
        return {
            "step": self.steps,
            "episode_reward": self.episode_reward,
            "scored": scored,
            "in_control": bool(
                np.linalg.norm(self.ball_pos - self.agent_pos) <= self.cfg.control_radius
            ),
        }

    def get_state(self) -> dict:
        """Plain-data snapshot consumed by the renderer / websocket layer."""
        return {
            "agent_pos": tuple(self.agent_pos.tolist()),
            "agent_vel": tuple(self.agent_vel.tolist()),
            "ball_pos": tuple(self.ball_pos.tolist()),
            "ball_vel": tuple(self.ball_vel.tolist()),
        }
