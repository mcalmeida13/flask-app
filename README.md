# flask-app

A minimal Flask app used to learn the full Docker lifecycle: build, run, stop, and clean up. Visiting the app in a browser shows "Hi, Docker!".

## Files

- `app.py` — Flask app with a single route (`/`) returning "Hi, Docker!"
- `requirements.txt` — the one dependency (Flask)
- `Dockerfile` — instructions to build a container image for the app

## Using the Makefile

A `Makefile` is a simple text file that defines shortcut commands. Instead of retyping a long `docker run ...` line every time, you type `make run`. It's a very common tool for automating repetitive project tasks — you'll see Makefiles in most real-world software projects.

Each `make` command below is just a shortcut for the raw `docker` commands explained in the next section — if you want to see exactly what's happening, or run things step-by-step for learning purposes, use the manual commands there instead.

| Command | What it does |
|---|---|
| `make build` | Builds the Docker image tagged with the current version only (e.g. `flask-app:v0.4.0`) — does **not** touch `latest` |
| `make release` | Builds the version tag, then points `latest` at it |
| `make run` | Starts the container from `flask-app:latest`, mapped to `localhost:5000` |
| `make run-version` | Starts the container from the exact versioned image, ignoring `latest` |
| `make stop` | Stops the running container |
| `make logs` | Tails the container's logs (`Ctrl+C` to exit the view) |
| `make restart` | Stops then starts the container again (useful after a rebuild) |
| `make clean` | Stops, removes the container, and removes both the version and `latest` images — full cleanup |
| `make images` | Lists every locally built tag for `flask-app`, so you can see what's actually on disk |

## Lifecycle Commands

Run these from this directory.

### 1. Build the image

```
docker build -t flask-app .
```

Builds a Docker image named `flask-app` from the `Dockerfile` in the current directory. This untagged form implicitly becomes `flask-app:latest`. (`make build` now does something slightly different — it tags the image with a version number instead. See [Versioning](#versioning) below.)

### 2. Run the container

```
docker run -d -p 5000:5000 --name flask-app flask-app
```

Starts a container named `flask-app` from the `flask-app` image, in detached mode (`-d`, runs in the background), mapping host port 5000 to container port 5000 (`-p 5000:5000`). (equivalent to running `make run`)

Visit **http://localhost:5000** in your browser — you should see "Hi, Docker!".

### 3. Check it's running

```
docker ps
```

Lists running containers; `flask-app` should show status `Up`.

### 4. Stop the container

```
docker stop flask-app
```

Gracefully stops the running container. (equivalent to running `make stop`)

### 5. Remove the container

```
docker rm flask-app
```

Deletes the stopped container. This does not remove the image. (steps 4 and 5, plus removing the image(s), are equivalent to running `make clean` — which now removes both the `latest` tag and the current version tag)

### 6. Remove the image

```
docker rmi flask-app
```

Deletes the built image, completing full cleanup.

### Verify cleanup

```
docker ps -a
docker images
```

`flask-app` should no longer appear in either list.

## Versioning

Every image build is tagged with a specific version (e.g. `flask-app:v0.4.0`), not just `latest`. That way you can build and test a new version without disturbing whatever `latest` currently points to — `latest` only moves when you deliberately say so.

### The `VERSION` file

The current version lives in a single file, [`VERSION`](VERSION), at the project root — just one line of text (e.g. `v0.4.0`). The Makefile reads it automatically. To release a new version, edit that one file and bump the number; nothing else needs to change.

### Build vs. release

```
docker build -t flask-app:v0.4.0 .
```

Builds the image and tags it with the version from `VERSION` — nothing else. `latest` is untouched. This is what `make build` runs. It's the safe way to try out a new version: build it, then use `make run-version` to run *that exact image* and check it works, without risking whatever `latest` currently serves.

```
docker tag flask-app:v0.4.0 flask-app:latest
```

Once you're happy with a version, this command points `latest` at it. Note this is `docker tag`, not `docker build` — no rebuilding happens, it just adds a second label to the image that already exists. This is what `make release` runs (after first running `make build`, so the version image is guaranteed to exist).

So the deliberate promotion flow is:

1. `make build` — build and tag the new version only
2. `make run-version` — run it, check `localhost:5000`, look at `make logs`
3. `make release` — happy with it? Promote it to `latest`

Run `make images` (`docker images flask-app`) at any point to see every tag you've built locally, side by side with its image ID — right after `make release`, you'll see `latest` and the version tag share the exact same ID, proving `docker tag` didn't create a new image.

### Git tag vs. Docker image tag

Both are called "tags" in this project, but they're two unrelated things:

- A **Git tag** (e.g. `v0.3.0`, created with `git tag`) marks a point in the *source code history* — it answers "what did the code look like at this commit?" It lives in the Git repository and has nothing to do with what's built or running.
- A **Docker image tag** (e.g. `flask-app:v0.3.0`, created with `docker build -t` or `docker tag`) marks a specific *built image* — it answers "what does a container actually run?" It lives in Docker's local image store on a machine and has nothing to do with Git.

Nothing forces the two to share a version number — they're independent systems. This project keeps them in sync by convention: bump `VERSION`, build/release the image, then create a matching Git tag (see `CLAUDE.md`'s versioning workflow) — purely so a human can mentally connect "this commit" to "the image it produced." That link is a habit this project follows, not something Docker or Git enforces for you.
