# flask-app

A minimal Flask app used to learn the full Docker lifecycle: build, run, stop, and clean up. Visiting the app in a browser shows "Hi, Docker!".

## Files

- `app.py` — Flask app with a single route (`/`) returning "Hi, Docker!"
- `requirements.txt` — the one dependency (Flask)
- `Dockerfile` — instructions to build a container image for the app

## Lifecycle Commands

Run these from this directory.

### 1. Build the image

```
docker build -t flask-app .
```

Builds a Docker image named `flask-app` from the `Dockerfile` in the current directory.

### 2. Run the container

```
docker run -d -p 5000:5000 --name flask-app flask-app
```

Starts a container named `flask-app` from the `flask-app` image, in detached mode (`-d`, runs in the background), mapping host port 5000 to container port 5000 (`-p 5000:5000`).

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

Gracefully stops the running container.

### 5. Remove the container

```
docker rm flask-app
```

Deletes the stopped container. This does not remove the image.

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
