"""FastAPI app: serves the web viewer and streams training frames over a
WebSocket. Training runs in a background thread started on app startup so
a single `uvicorn server.app:app` command gives you both the trainer and
the live viewer.
"""

from __future__ import annotations

import asyncio
import logging
import os
import threading

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.staticfiles import StaticFiles

from server.broadcaster import FrameBroadcaster

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("soccer.server")

WEB_DIR = os.path.join(os.path.dirname(__file__), "..", "web")

app = FastAPI(title="Robot Soccer RL Live Viewer")
broadcaster = FrameBroadcaster()
_training_thread: threading.Thread | None = None


def _training_worker():
    from training.train import run_training

    run_training(
        broadcaster=broadcaster,
        total_timesteps=int(os.environ.get("SOCCER_TIMESTEPS", 2_000_000)),
        n_envs=int(os.environ.get("SOCCER_N_ENVS", 8)),
        save_freq=int(os.environ.get("SOCCER_SAVE_FREQ", 50_000)),
        resume_from=os.environ.get("SOCCER_RESUME_FROM"),
    )


@app.on_event("startup")
async def on_startup():
    broadcaster.bind_loop(asyncio.get_running_loop())

    if os.environ.get("SOCCER_AUTOSTART_TRAINING", "1") == "1":
        global _training_thread
        _training_thread = threading.Thread(target=_training_worker, daemon=True)
        _training_thread.start()
        logger.info("Training thread started.")


@app.get("/api/status")
async def status():
    return {
        "training_alive": bool(_training_thread and _training_thread.is_alive()),
        "clients": len(broadcaster._clients),
        "latest_frame_meta": (
            {k: v for k, v in broadcaster.latest_frame.items() if k != "data"}
            if broadcaster.latest_frame
            else None
        ),
    }


@app.websocket("/ws")
async def ws_stream(websocket: WebSocket):
    await websocket.accept()
    await broadcaster.register(websocket)
    try:
        while True:
            # Clients don't need to send anything; this just detects disconnects.
            await websocket.receive_text()
    except WebSocketDisconnect:
        pass
    except Exception:
        pass
    finally:
        await broadcaster.unregister(websocket)


# Must be mounted last: this catches "/" and every other unmatched path.
app.mount("/", StaticFiles(directory=WEB_DIR, html=True), name="web")
