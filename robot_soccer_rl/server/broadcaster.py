"""Thread-safe bridge between the (synchronous) training thread and the
asyncio event loop that serves websocket clients.

Training runs in a plain Python thread so SB3/PyTorch can block freely;
`push_frame_threadsafe` is called from that thread and hops onto the
FastAPI event loop via `asyncio.run_coroutine_threadsafe`.
"""

from __future__ import annotations

import asyncio
import json
import logging

from fastapi import WebSocket

logger = logging.getLogger("soccer.broadcaster")


class FrameBroadcaster:
    def __init__(self):
        self._clients: set[WebSocket] = set()
        self._loop: asyncio.AbstractEventLoop | None = None
        self._lock = asyncio.Lock()
        self.latest_frame: dict | None = None

    def bind_loop(self, loop: asyncio.AbstractEventLoop) -> None:
        self._loop = loop

    async def register(self, ws: WebSocket) -> None:
        async with self._lock:
            self._clients.add(ws)
        if self.latest_frame is not None:
            try:
                await ws.send_text(json.dumps(self.latest_frame))
            except Exception:
                pass

    async def unregister(self, ws: WebSocket) -> None:
        async with self._lock:
            self._clients.discard(ws)

    def push_frame_threadsafe(self, payload: dict) -> None:
        """Called from the training thread (no event loop there)."""
        self.latest_frame = payload
        if self._loop is None:
            return
        asyncio.run_coroutine_threadsafe(self._broadcast(payload), self._loop)

    async def _broadcast(self, payload: dict) -> None:
        message = json.dumps(payload)
        async with self._lock:
            dead = []
            for ws in self._clients:
                try:
                    await ws.send_text(message)
                except Exception:
                    dead.append(ws)
            for ws in dead:
                self._clients.discard(ws)
