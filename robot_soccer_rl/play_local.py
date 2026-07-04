"""Watch the agent play in a real, on-screen Pygame window (no server, no
websocket) — useful for quickly sanity-checking a trained model or the
environment's physics.

    python play_local.py                          # random policy
    python play_local.py --model models/ppo_soccer_latest.zip
"""

from __future__ import annotations

import argparse
import os

import pygame

from soccer_rl.env import SoccerEnv


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", type=str, default=None)
    parser.add_argument("--episodes", type=int, default=10)
    parser.add_argument("--deterministic", action="store_true")
    args = parser.parse_args()

    env = SoccerEnv(render_mode="human")
    model = None
    if args.model and os.path.exists(args.model):
        from stable_baselines3 import PPO

        model = PPO.load(args.model)
        print(f"Loaded model from {args.model}")
    else:
        print("No model provided/found — running a random policy.")

    clock = pygame.time.Clock()
    fps = int(1.0 / env.cfg.dt)

    for ep in range(args.episodes):
        obs, info = env.reset()
        done = False
        while not done:
            for e in pygame.event.get():
                if e.type == pygame.QUIT:
                    env.close()
                    return

            if model is not None:
                action, _ = model.predict(obs, deterministic=args.deterministic)
            else:
                action = env.action_space.sample()

            obs, reward, terminated, truncated, info = env.step(action)
            env.render()
            clock.tick(fps)
            done = terminated or truncated

        print(f"Episode {ep + 1}: reward={info['episode_reward']:.2f} scored={info['scored']}")

    env.close()


if __name__ == "__main__":
    main()
