# 04 — Docker Image Versioning

## What was planned

Extend the `Makefile` and Docker workflow to tag built images with both a specific version (e.g. `v1.0`) and `latest`, including a decision on where the version number is stored (e.g. a `VERSION` file, a `Makefile` variable, or a Git tag) and how it gets bumped over time.

## What was implemented

**`VERSION` file** — added at the project root, containing a single line: `v0.4.0`. This is the one place the version number lives; every other piece (Makefile, README) reads from it rather than hardcoding a number.

**`Makefile` changes**:

```makefile
VERSION=$(shell cat VERSION)

.PHONY: build release run run-version stop clean logs restart images

build:
	docker build -t $(IMAGE_NAME):$(VERSION) .

release: build
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):latest

run:
	docker run -d -p $(PORT):$(PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME):latest

run-version:
	docker run -d -p $(PORT):$(PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION)

clean: stop
	docker rm $(CONTAINER_NAME)
	docker rmi $(IMAGE_NAME):latest $(IMAGE_NAME):$(VERSION)

images:
	docker images $(IMAGE_NAME)
```

`build` now tags **only** the version (e.g. `flask-app:v0.4.0`) — it deliberately does *not* touch `latest`, so a new version can be built and tested (via `run-version`) without disturbing whatever `latest` currently serves. `release` depends on `build`, then runs a plain `docker tag` (no rebuild) to point `latest` at the version that was just built — promoting to `latest` is a separate, explicit step rather than something that happens automatically on every build. `clean` and `images` were updated to be aware of both tags.

**`README.md` updates** — added a `## Versioning` section documenting: what the `VERSION` file is and how to bump it; the `build` → `run-version` → `release` promotion flow; the manual `docker build -t ...` / `docker tag ...` equivalents (matching the existing "Lifecycle Commands" style of showing raw commands next to their `make` shortcuts); and a plain-language explanation of the difference between a **Git tag** (marks a commit in source history) and a **Docker image tag** (marks a built image) — see the Notes below. The existing "Using the Makefile" table and the "Lifecycle Commands" walkthrough were updated where they referenced the old single-tag `build`/`clean` behavior.

**Git tag checkpoint** — this change is committed and tagged `v0.4.0`, matching the `VERSION` file's content.

## Notes

**Why a `VERSION` file instead of a bare Makefile variable?** Both were considered. A Makefile variable (`VERSION=v0.4.0` at the top of the `Makefile`) would have been marginally simpler — one less file — but only the Makefile could see it. A `VERSION` file is readable by anything: a future CI step, another script, or just a human running `cat VERSION`. It keeps "what version are we on" (release metadata) separate from "how do we build" (build logic), which is the more common real-world pattern to learn.

**Why `build` doesn't also tag `latest`:** an earlier version of this plan had `build` tag both the version and `latest` in one `docker build -t v0.4.0 -t latest .` command. That was changed after realizing it defeats the purpose of versioning: if every build silently overwrites `latest`, there's no way to build and test a candidate version without immediately affecting the "known good" image everyone else runs. Splitting `build` (version only) from `release` (promote to `latest`) makes "try it" and "ship it" two distinct, deliberate actions — a build → test → promote pattern used in real deployment workflows.

**Git tags vs. Docker image tags stay in sync by convention, not automation.** They are two independent systems — a Git tag lives in the repository's history, a Docker image tag lives in the local Docker image store, and neither knows the other exists. This project chooses to give them matching version strings (bump `VERSION`, `make release`, then `git tag` with the same number) purely as a human-readable convention, per `CLAUDE.md`'s versioning workflow ("when the change affects the Docker image, also tag the built image with the matching version"). Nothing enforces this automatically — it's a discipline, not a guarantee.
