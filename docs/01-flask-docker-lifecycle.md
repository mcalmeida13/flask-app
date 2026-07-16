# 01 — Initial Flask + Docker Lifecycle Example

## What was planned

A minimal Flask app that displays "Hi, Docker!" in the browser, packaged with a `Dockerfile`, and used to walk through the full container lifecycle: development, building, running, stopping, and cleanup.

## What was implemented

**`app.py`** — a single-route Flask app:

```python
from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello():
    return "Hi, Docker!"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

It binds to `0.0.0.0:5000` (not `127.0.0.1`) so the port mapped out of the container is actually reachable from the host.

**`requirements.txt`** — pins the single dependency: `Flask==3.0.3`.

**`Dockerfile`** — builds on `python:3.12-slim`:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

Dependencies are installed before the application code is copied in, so Docker's layer cache is reused for `pip install` when only `app.py` changes.

**Lifecycle commands** — at this stage there was no Makefile yet (that came later, see [`03-makefile.md`](03-makefile.md)); the lifecycle was run and documented as raw `docker` commands in `README.md`:

| Step | Command |
|---|---|
| Build | `docker build -t flask-app .` |
| Run | `docker run -d -p 5000:5000 --name flask-app flask-app` |
| Check it's running | `docker ps` |
| Stop | `docker stop flask-app` |
| Remove container | `docker rm flask-app` |
| Remove image | `docker rmi flask-app` |
| Verify cleanup | `docker ps -a` and `docker images` |

Visiting `http://localhost:5000` after `docker run` returns the "Hi, Docker!" text served by the Flask route above.

All of the above — `app.py`, `requirements.txt`, `Dockerfile`, and the lifecycle instructions in `README.md` — were introduced together in the initial commit (`1b13d878` / tag `v0.1.0`), alongside the Git setup covered in [`02-github-integration.md`](02-github-integration.md).
