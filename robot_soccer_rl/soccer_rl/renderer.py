"""Pygame-based renderer for the soccer environment.

Works headlessly (no display / X server needed) by drawing onto an
in-memory pygame.Surface. A `human`-mode window is only opened on demand
via `blit_to_window`, for local debugging with `play_local.py`.
"""

from __future__ import annotations

import base64
import io
import os

import numpy as np
import pygame

from soccer_rl.config import SoccerConfig, PX_PER_METER

FIELD_GREEN = (34, 120, 60)
FIELD_LINE = (230, 230, 230)
GOAL_COLOR = (250, 250, 250)
BALL_COLOR = (245, 245, 245)
BALL_EDGE = (40, 40, 40)
AGENT_COLOR = (40, 110, 230)
AGENT_EDGE = (15, 45, 110)
HUD_COLOR = (255, 255, 255)


class Renderer:
    def __init__(self, config: SoccerConfig, headless: bool = True, px_per_meter: int = PX_PER_METER):
        self.cfg = config
        self.px = px_per_meter
        self.width_px = int(config.field_width * self.px)
        self.height_px = int(config.field_height * self.px)

        if headless and not pygame.get_init():
            os.environ.setdefault("SDL_VIDEODRIVER", "dummy")

        if not pygame.get_init():
            pygame.init()
        pygame.font.init()

        self._surface = pygame.Surface((self.width_px, self.height_px))
        self._font = pygame.font.SysFont("consolas,menlo,monospace", 18)
        self._window = None

    # ------------------------------------------------------------------ #
    def _m2px(self, pos) -> tuple:
        x, y = pos
        return int(x * self.px), int(y * self.px)

    def draw(self, state: dict, hud: dict | None = None) -> pygame.Surface:
        cfg = self.cfg
        surf = self._surface
        surf.fill(FIELD_GREEN)

        # Field boundary
        pygame.draw.rect(surf, FIELD_LINE, surf.get_rect(), width=3)
        # Halfway line
        pygame.draw.line(
            surf, FIELD_LINE, (self.width_px // 2, 0), (self.width_px // 2, self.height_px), 2
        )
        pygame.draw.circle(
            surf, FIELD_LINE, (self.width_px // 2, self.height_px // 2), int(1.5 * self.px), 2
        )

        # Goal mouth (right wall opening) + posts
        goal_top = self._m2px((cfg.field_width, cfg.goal_y_min))
        goal_bot = self._m2px((cfg.field_width, cfg.goal_y_max))
        pygame.draw.rect(
            surf,
            GOAL_COLOR,
            pygame.Rect(self.width_px - 6, goal_top[1], 6, goal_bot[1] - goal_top[1]),
        )
        depth = int(1.2 * self.px)
        net_rect = pygame.Rect(self.width_px, goal_top[1], depth, goal_bot[1] - goal_top[1])
        pygame.draw.rect(surf, (200, 200, 200), net_rect, width=2)

        # Ball
        ball_px = self._m2px(state["ball_pos"])
        r = int(cfg.ball_radius * self.px)
        pygame.draw.circle(surf, BALL_COLOR, ball_px, r)
        pygame.draw.circle(surf, BALL_EDGE, ball_px, r, width=2)

        # Agent (with a heading tick showing velocity direction)
        agent_px = self._m2px(state["agent_pos"])
        ra = int(cfg.agent_radius * self.px)
        pygame.draw.circle(surf, AGENT_COLOR, agent_px, ra)
        pygame.draw.circle(surf, AGENT_EDGE, agent_px, ra, width=2)
        vel = np.array(state["agent_vel"])
        speed = np.linalg.norm(vel)
        if speed > 1e-3:
            direction = vel / speed
            tip = (agent_px[0] + direction[0] * ra * 1.6, agent_px[1] + direction[1] * ra * 1.6)
            pygame.draw.line(surf, AGENT_EDGE, agent_px, tip, 3)

        if hud:
            self._draw_hud(surf, hud)

        return surf

    def _draw_hud(self, surf: pygame.Surface, hud: dict):
        lines = [
            f"step {hud.get('step', 0)}",
            f"reward {hud.get('episode_reward', 0.0):.2f}",
        ]
        if hud.get("scored"):
            lines.append("GOAL!")
        for i, text in enumerate(lines):
            img = self._font.render(text, True, HUD_COLOR)
            surf.blit(img, (8, 6 + i * 20))

    # ------------------------------------------------------------------ #
    def to_rgb_array(self, surface: pygame.Surface) -> np.ndarray:
        arr = pygame.surfarray.array3d(surface)
        return np.transpose(arr, (1, 0, 2))

    def to_jpeg_base64(self, surface: pygame.Surface, quality: int = 70) -> str:
        w, h = surface.get_size()
        raw = pygame.image.tostring(surface, "RGB")
        buf = io.BytesIO()
        try:
            from PIL import Image

            Image.frombytes("RGB", (w, h), raw).save(buf, format="JPEG", quality=quality)
        except ImportError:
            # Pillow not installed: fall back to pygame's own (uncompressed-quality) JPEG writer.
            pygame.image.save(surface, buf, "frame.jpg")
        data = base64.b64encode(buf.getvalue()).decode("ascii")
        buf.close()
        return data

    def blit_to_window(self, surface: pygame.Surface):
        if self._window is None:
            os.environ.pop("SDL_VIDEODRIVER", None)
            pygame.display.init()
            self._window = pygame.display.set_mode((self.width_px, self.height_px))
        self._window.blit(surface, (0, 0))
        pygame.display.flip()

    def close(self):
        if self._window is not None:
            pygame.display.quit()
            self._window = None
