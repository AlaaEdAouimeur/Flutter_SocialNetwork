import numpy as np

from soccer_rl.env import SoccerEnv


def test_reset_returns_valid_obs():
    env = SoccerEnv()
    obs, info = env.reset(seed=0)
    assert env.observation_space.contains(obs)
    env.close()


def test_step_shapes_and_types():
    env = SoccerEnv()
    env.reset(seed=1)
    obs, reward, terminated, truncated, info = env.step(np.array([0.5, -0.5]))
    assert env.observation_space.contains(obs)
    assert isinstance(reward, float)
    assert isinstance(terminated, bool)
    assert isinstance(truncated, bool)
    env.close()


def test_episode_truncates_within_max_steps():
    env = SoccerEnv()
    env.reset(seed=2)
    steps = 0
    done = False
    while not done and steps < env.cfg.max_episode_steps + 5:
        _, _, terminated, truncated, _ = env.step(env.action_space.sample())
        done = terminated or truncated
        steps += 1
    assert steps <= env.cfg.max_episode_steps
    env.close()


def test_dribbling_pulls_ball_toward_agent_velocity():
    env = SoccerEnv()
    env.reset(seed=3)
    env.agent_pos = np.array([5.0, 5.0])
    env.ball_pos = np.array([5.2, 5.0])
    env.agent_vel = np.zeros(2)
    env.ball_vel = np.zeros(2)

    # Push the agent to the right; the ball should pick up rightward velocity
    # because it's within the control radius.
    for _ in range(5):
        env.step(np.array([1.0, 0.0]))

    assert env.ball_vel[0] > 0
    env.close()


def test_scoring_ends_episode_with_bonus_reward():
    env = SoccerEnv()
    env.reset(seed=4)
    env.agent_pos = np.array([env.cfg.field_width - 1.0, env.cfg.field_height / 2])
    env.ball_pos = np.array([env.cfg.field_width - 0.3, env.cfg.field_height / 2])
    env.ball_vel = np.array([10.0, 0.0])

    terminated = False
    reward = 0.0
    for _ in range(10):
        _, reward, terminated, _, info = env.step(np.array([0.0, 0.0]))
        if terminated:
            break

    assert terminated
    assert info["scored"]
    assert reward > 50.0
    env.close()


def test_renders_rgb_array_with_correct_shape():
    env = SoccerEnv(render_mode="rgb_array")
    env.reset(seed=5)
    frame = env.render()
    assert frame.shape == (int(env.cfg.field_height * 40), int(env.cfg.field_width * 40), 3)
    env.close()
