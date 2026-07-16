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
| `make build` | Builds the Docker image (`flask-app`) from the Dockerfile |
| `make run` | Starts the container in the background, mapped to `localhost:5000` |
| `make stop` | Stops the running container |
| `make logs` | Tails the container's logs (`Ctrl+C` to exit the view) |
| `make restart` | Stops then starts the container again (useful after a rebuild) |
| `make clean` | Stops, removes the container, and removes the image — full cleanup |

## Lifecycle Commands

Run these from this directory.

### 1. Build the image

```
docker build -t flask-app .
```

Builds a Docker image named `flask-app` from the `Dockerfile` in the current directory. (equivalent to running `make build`)

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

Deletes the stopped container. This does not remove the image. (steps 4 and 5, plus removing the image, are equivalent to running `make clean`)

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
