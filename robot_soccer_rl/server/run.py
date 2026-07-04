"""Convenience entrypoint: `python -m server.run`.

Equivalent to `uvicorn server.app:app --host 0.0.0.0 --port 8000`, provided
so the whole stack (training thread + websocket server + static viewer)
starts with a single command.
"""

import os

import uvicorn

if __name__ == "__main__":
    uvicorn.run(
        "server.app:app",
        host="0.0.0.0",
        port=int(os.environ.get("PORT", 8000)),
        reload=False,
    )
