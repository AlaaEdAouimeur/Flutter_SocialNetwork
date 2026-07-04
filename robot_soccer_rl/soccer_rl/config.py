"""Shared constants for the robot-soccer environment and renderer.

All physical quantities are in meters / (m/s) / (m/s^2); the renderer
converts to pixels using PX_PER_METER.
"""

from dataclasses import dataclass


@dataclass(frozen=True)
class SoccerConfig:
    # Field
    field_width: float = 24.0
    field_height: float = 16.0
    goal_width: float = 6.0  # opening centered on the right wall

    # Bodies
    agent_radius: float = 0.35
    ball_radius: float = 0.18
    control_radius: float = 0.75  # distance within which the agent can dribble the ball

    # Dynamics
    dt: float = 0.05  # 20 Hz simulation
    max_agent_speed: float = 5.5
    max_agent_accel: float = 9.0
    agent_friction: float = 0.10  # fraction of velocity lost per step
    max_ball_speed: float = 9.0
    ball_friction: float = 0.03
    dribble_strength: float = 0.55  # how strongly the ball follows the agent's velocity
    kick_push: float = 1.6  # extra push imparted to the ball while dribbling
    wall_restitution: float = 0.65

    # Episode
    max_episode_steps: int = 600

    # Reward shaping weights
    w_approach_ball: float = 1.0
    w_ball_to_goal: float = 2.5
    w_possession: float = 0.02
    w_time_penalty: float = 0.01
    goal_reward: float = 100.0

    @property
    def goal_y_min(self) -> float:
        return (self.field_height - self.goal_width) / 2.0

    @property
    def goal_y_max(self) -> float:
        return (self.field_height + self.goal_width) / 2.0

    @property
    def goal_center(self) -> tuple:
        return (self.field_width, self.field_height / 2.0)

    @property
    def field_diag(self) -> float:
        return (self.field_width ** 2 + self.field_height ** 2) ** 0.5


PX_PER_METER = 40
