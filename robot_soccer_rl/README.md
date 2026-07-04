# Robot Soccer RL

A self-contained reinforcement learning system where an agent learns to
dribble a ball and score goals in a 2D simulated soccer field, with a live
browser viewer (works on a phone via ngrok).

- **Environment**: custom [Gymnasium](https://gymnasium.farama.org/) env — one
  robot, one ball, one goal, continuous 2D acceleration control.
- **Training**: [Stable-Baselines3](https://stable-baselines3.readthedocs.io/) PPO
  (PyTorch backend).
- **Rendering**: headless [Pygame](https://www.pygame.org/) renderer producing
  JPEG frames.
- **Streaming**: [FastAPI](https://fastapi.tiangolo.com/) + WebSocket server
  broadcasting frames to any connected browser in real time.
- **Client**: a single static HTML/JS page that draws frames on a `<canvas>`.

## Project layout

```
robot_soccer_rl/
  soccer_rl/
    config.py      # physics + reward-shaping constants
    env.py         # SoccerEnv(gym.Env): physics, observations, reward
    renderer.py    # Pygame renderer -> rgb_array / base64 JPEG
  training/
    train.py       # PPO training loop (CLI-runnable on its own)
    callbacks.py   # StreamingCallback: renders live rollouts for the viewer
  server/
    app.py         # FastAPI app: websocket + static file serving
    broadcaster.py # thread-safe bridge from the training thread to asyncio
    run.py         # `python -m server.run` entrypoint
  web/
    index.html     # canvas + JS live viewer client
  play_local.py    # watch a model (or random policy) in a real Pygame window
  scripts/
    start_with_ngrok.sh
  tests/
    test_env.py
```

Training, simulation, rendering, and streaming are independent modules:
`soccer_rl` has no knowledge of FastAPI or SB3; `training` only depends on
`soccer_rl`; `server` wires `training` to a websocket without importing
Pygame directly.

## Setup

```bash
cd robot_soccer_rl
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Watch training live in a browser

Starts PPO training in a background thread and serves the live viewer on
`http://localhost:8000`:

```bash
python -m server.run
```

Open `http://localhost:8000` in a browser to watch the current policy play
in real time (episode counter, reward, goals, and total timesteps trained
are all shown).

Environment variables (all optional):

| Variable                     | Default | Meaning                                   |
|-------------------------------|---------|--------------------------------------------|
| `SOCCER_TIMESTEPS`             | 2000000 | Total PPO timesteps to train               |
| `SOCCER_N_ENVS`                | 8       | Parallel training environments             |
| `SOCCER_SAVE_FREQ`             | 50000   | Checkpoint frequency (timesteps)           |
| `SOCCER_RESUME_FROM`           | (unset) | Path to a `.zip` checkpoint to resume from |
| `SOCCER_AUTOSTART_TRAINING`    | 1       | Set to `0` to serve the viewer without training (e.g. to just watch a saved model — wire your own inference loop into `server/app.py` if needed) |
| `PORT`                         | 8000    | HTTP/WebSocket port                        |

## Watch from your phone (ngrok)

```bash
./scripts/start_with_ngrok.sh
```

This starts the server locally and opens an `ngrok http 8000` tunnel. Open
the printed `https://*.ngrok-free.app` URL on your phone's browser — no
extra setup on the phone required. (Requires `ngrok` installed and
authenticated: `ngrok config add-authtoken <token>`.)

## Headless training only (no viewer)

```bash
python -m training.train --timesteps 2000000 --n-envs 8
```

Checkpoints are saved to `models/`.

## Watch a trained model locally (real Pygame window, no server)

```bash
python play_local.py --model models/ppo_soccer_latest.zip --deterministic
```

## Environment design

- **Field**: 24m x 16m, goal is a 6m-wide opening centered on the right wall.
- **Action space**: `Box(2,)` in `[-1, 1]`, interpreted as the agent's desired
  2D acceleration direction/magnitude.
- **Observation**: 16-D vector — agent/ball positions & velocities, goal
  position, agent→ball and ball→goal vectors, and both distances (all
  normalized).
- **Ball physics**: rolls freely with friction; when the agent is within a
  small control radius, the ball's velocity is pulled toward the agent's
  velocity (dribbling) with an added forward push, so the agent learns to
  stay close to push the ball around rather than just bumping it.
- **Reward shaping** (dense, potential-based so it doesn't reward standing
  still near the ball):
  - `+` for reducing agent→ball distance (approach the ball)
  - `+` (larger weight) for reducing ball→goal distance (drive the ball
    toward the goal)
  - small `+` per step while in control of the ball (possession bonus)
  - small `-` per step (time penalty, encourages faster play)
  - large `+100` and episode end on scoring a goal

Tune weights in `soccer_rl/config.py:SoccerConfig`.

## Tests

```bash
pip install pytest
pytest tests/
```
