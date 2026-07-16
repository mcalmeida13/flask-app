# 04 — Docker Image Versioning

## What was planned

Extend the `Makefile` and Docker workflow to tag built images with both a specific version (e.g. `v1.0`) and `latest`, including a decision on where the version number is stored (e.g. a `VERSION` file, a `Makefile` variable, or a Git tag) and how it gets bumped over time.

## What was implemented

Not yet implemented. As of the current state of the repository (`HEAD` at commit `5b1b34bb`, tag `v0.2.0`), this stage is still purely planning:

- `Makefile`'s `build` target still builds a single untagged-version image — `docker build -t $(IMAGE_NAME) .`, which resolves to `flask-app:latest` implicitly. There is no `VERSION` variable, no second `docker tag` step, and no target that pushes or tags a specific version alongside `latest`.
- There is no `VERSION` file, `version.py`, or equivalent anywhere in the repository (`app.py`, `requirements.txt`, `Dockerfile`, `Makefile`, `README.md`, `.gitignore` are the only tracked files).
- `README.md` does not yet document a versioning workflow.
- The Git tags created so far (`v0.1.0`, `v0.2.0`, see [`03-makefile.md`](03-makefile.md)) version the *repository history*, not the *Docker image* — they aren't currently referenced by the `Makefile` or `Dockerfile`, so nothing automatically keeps an image tag in sync with a Git tag.

This document will be updated once the versioning work lands — expected additions include a version variable in the `Makefile` (or a `VERSION` file it reads from), a `build` target that runs `docker build -t $(IMAGE_NAME):$(VERSION) -t $(IMAGE_NAME):latest .`, and a documented process for bumping the version number in step with new Git tags.
