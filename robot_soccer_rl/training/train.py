"""PPO training entrypoint for the robot-soccer environment.

Usage (headless CLI training, no web viewer):
    python -m training.train --timesteps 2000000 --n-envs 8

The `run_training` function is also imported by `server/run.py`, which
passes a `FrameBroadcaster` so the in-progress policy can be watched live
in a browser while training continues.
"""

from __future__ import annotations

import argparse
import os

from stable_baselines3 import PPO
from stable_baselines3.common.callbacks import CallbackList, CheckpointCallback
from stable_baselines3.common.env_util import make_vec_env
from stable_baselines3.common.vec_env import DummyVecEnv, SubprocVecEnv

from soccer_rl.env import SoccerEnv
from training.callbacks import StreamingCallback

DEFAULT_MODEL_DIR = os.path.join(os.path.dirname(__file__), "..", "models")
DEFAULT_MODEL_PATH = os.path.join(DEFAULT_MODEL_DIR, "ppo_soccer_latest.zip")


def make_env():
    return SoccerEnv()


def build_vec_env(n_envs: int):
    vec_cls = DummyVecEnv if n_envs == 1 else SubprocVecEnv
    return make_vec_env(make_env, n_envs=n_envs, vec_env_cls=vec_cls)


def build_model(vec_env, tensorboard_log: str | None = None, seed: int | None = None) -> PPO:
    return PPO(
        "MlpPolicy",
        vec_env,
        learning_rate=3e-4,
        n_steps=1024,
        batch_size=256,
        n_epochs=10,
        gamma=0.99,
        gae_lambda=0.95,
        clip_range=0.2,
        ent_coef=0.005,
        policy_kwargs=dict(net_arch=[256, 256]),
        tensorboard_log=tensorboard_log,
        seed=seed,
        verbose=1,
    )


def run_training(
    broadcaster=None,
    total_timesteps: int = 2_000_000,
    n_envs: int = 8,
    save_path: str = DEFAULT_MODEL_DIR,
    save_freq: int = 50_000,
    tensorboard_log: str | None = None,
    resume_from: str | None = None,
    seed: int | None = None,
) -> PPO:
    os.makedirs(save_path, exist_ok=True)
    vec_env = build_vec_env(n_envs)

    if resume_from and os.path.exists(resume_from):
        model = PPO.load(resume_from, env=vec_env)
    else:
        model = build_model(vec_env, tensorboard_log=tensorboard_log, seed=seed)

    callbacks = [
        CheckpointCallback(
            save_freq=max(save_freq // n_envs, 1),
            save_path=save_path,
            name_prefix="ppo_soccer",
        )
    ]
    if broadcaster is not None:
        callbacks.append(StreamingCallback(broadcaster))

    model.learn(total_timesteps=total_timesteps, callback=CallbackList(callbacks))
    model.save(os.path.join(save_path, "ppo_soccer_latest"))
    vec_env.close()
    return model


def main():
    parser = argparse.ArgumentParser(description="Train PPO on the robot-soccer environment.")
    parser.add_argument("--timesteps", type=int, default=2_000_000)
    parser.add_argument("--n-envs", type=int, default=8)
    parser.add_argument("--save-path", type=str, default=DEFAULT_MODEL_DIR)
    parser.add_argument("--save-freq", type=int, default=50_000)
    parser.add_argument("--tensorboard-log", type=str, default=None)
    parser.add_argument("--resume-from", type=str, default=None)
    parser.add_argument("--seed", type=int, default=None)
    args = parser.parse_args()

    run_training(
        broadcaster=None,
        total_timesteps=args.timesteps,
        n_envs=args.n_envs,
        save_path=args.save_path,
        save_freq=args.save_freq,
        tensorboard_log=args.tensorboard_log,
        resume_from=args.resume_from,
        seed=args.seed,
    )


if __name__ == "__main__":
    main()
