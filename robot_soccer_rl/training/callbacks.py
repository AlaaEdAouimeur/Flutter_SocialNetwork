"""SB3 callback that streams live policy rollouts for the web viewer.

The callback drives its own `SoccerEnv` instance with the in-training
policy, completely separate from the (headless, vectorized) training
environments, so rendering and JPEG-encoding frames never slows down
the actual PPO updates.
"""

from __future__ import annotations

import time

from stable_baselines3.common.callbacks import BaseCallback

from soccer_rl.env import SoccerEnv
from soccer_rl.renderer import Renderer


class StreamingCallback(BaseCallback):
    def __init__(
        self,
        broadcaster,
        render_every_n_steps: int = 3,
        deterministic: bool = False,
        target_fps: float = 20.0,
        jpeg_quality: int = 65,
        verbose: int = 0,
    ):
        super().__init__(verbose)
        self.broadcaster = broadcaster
        self.render_every_n_steps = max(1, render_every_n_steps)
        self.deterministic = deterministic
        self.min_frame_interval = 1.0 / target_fps
        self.jpeg_quality = jpeg_quality
        self._last_sent = 0.0

        self.render_env: SoccerEnv | None = None
        self.renderer: Renderer | None = None
        self.obs = None
        self.episode_index = 0

    def _on_training_start(self) -> None:
        self.render_env = SoccerEnv()
        self.renderer = Renderer(self.render_env.cfg, headless=True)
        self.obs, _ = self.render_env.reset()

    def _on_step(self) -> bool:
        if self.n_calls % self.render_every_n_steps != 0:
            return True
        now = time.time()
        if now - self._last_sent < self.min_frame_interval:
            return True
        self._last_sent = now

        action, _ = self.model.predict(self.obs, deterministic=self.deterministic)
        self.obs, reward, terminated, truncated, info = self.render_env.step(action)

        surface = self.renderer.draw(self.render_env.get_state(), hud=info)
        frame_b64 = self.renderer.to_jpeg_base64(surface, quality=self.jpeg_quality)

        episode_done = terminated or truncated
        if episode_done and info.get("scored"):
            self.episode_index += 1

        self.broadcaster.push_frame_threadsafe(
            {
                "type": "frame",
                "data": frame_b64,
                "step": info["step"],
                "reward": round(float(reward), 3),
                "episode_reward": round(float(info["episode_reward"]), 2),
                "episode": self.episode_index,
                "scored": bool(info.get("scored")),
                "total_timesteps": int(self.num_timesteps),
            }
        )

        if episode_done:
            self.obs, _ = self.render_env.reset()

        return True

    def _on_training_end(self) -> None:
        if self.render_env is not None:
            self.render_env.close()
            self.render_env = None
