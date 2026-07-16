# 03 — Makefile Creation

## What was planned

Add a `Makefile` with targets wrapping the common Docker commands (build, run, stop, clean, logs, restart), update the `README` to document these commands in a beginner-friendly way, and create a Git tag as a version checkpoint before pushing.

## What was implemented

**`Makefile`** — added in commit `5b1b34bb` ("Add Makefile for Docker lifecycle commands"):

```makefile
IMAGE_NAME=flask-app
CONTAINER_NAME=flask-app
PORT=5000

.PHONY: build run stop clean logs restart

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -d -p $(PORT):$(PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME)

logs:
	docker logs -f $(CONTAINER_NAME)

clean: stop
	docker rm $(CONTAINER_NAME)
	docker rmi $(IMAGE_NAME)

restart: stop run
```

All six planned targets are present: `build`, `run`, `stop`, `clean`, `logs`, `restart`. `clean` depends on `stop` and additionally removes both the container and the image; `restart` is a composite of `stop` + `run`. Image/container naming and the port are pulled out into variables (`IMAGE_NAME`, `CONTAINER_NAME`, `PORT`) at the top of the file rather than hardcoded in each target.

**`README.md` updates** — the same commit added a "Using the Makefile" section with a beginner-friendly explanation of what a Makefile is and why it's useful, plus a table mapping each `make` target to what it does:

| Command | What it does |
|---|---|
| `make build` | Builds the Docker image (`flask-app`) from the Dockerfile |
| `make run` | Starts the container in the background, mapped to `localhost:5000` |
| `make stop` | Stops the running container |
| `make logs` | Tails the container's logs (`Ctrl+C` to exit the view) |
| `make restart` | Stops then starts the container again (useful after a rebuild) |
| `make clean` | Stops, removes the container, and removes the image — full cleanup |

The existing manual `docker` lifecycle walkthrough from stage 1 (see [`01-flask-docker-lifecycle.md`](01-flask-docker-lifecycle.md)) was kept in the README rather than replaced, with each manual step annotated as "equivalent to running `make X`" — so the README serves both as a Makefile reference and a from-scratch Docker tutorial.

**Git tag checkpoint** — the commit is tagged `v0.2.0` ("Add Makefile for Docker lifecycle commands"). Note that this tag and `v0.1.0` (covering the initial commit) were both created at the same timestamp, immediately after this commit — so in practice the "tag before push" checkpoint was applied retroactively to both commits together rather than incrementally as each stage was pushed.
