from .routes.users import router as user_router
from .application import app
import sys

sys.path.extend(["./"])


ROUTERS = (user_router,)

for r in ROUTERS:
    app.include_router(r)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8888, log_level="info")
