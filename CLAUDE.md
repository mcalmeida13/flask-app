# Project Instructions for Claude Code

## About this project
This is an educational project to learn Docker and Git/GitHub fundamentals using a minimal Flask application. Every addition to this project should stay simple and beginner-friendly — the goal is learning, not production-readiness.

## Documentation workflow
Whenever you create a plan (in plan mode) or complete a non-trivial task (adding a feature, fixing something, changing the workflow), document it in the `/docs` folder:

- Create one markdown file per task, named with a number prefix and short description (e.g., `docs/05-add-healthcheck.md`), continuing the existing numbering in that folder.
- Each file should include:
  - **What was planned** — a short summary of the goal and approach
  - **What was implemented** — the actual commands run, files created or changed, and any Git tags created
  - **Notes** — any decisions, trade-offs, or things worth remembering later
- Keep the tone clear and didactic, as if explaining to someone learning Docker/Git for the first time.

## Versioning workflow
- Before pushing a meaningful change, create a Git checkpoint: commit the change with a clear message, then create an incrementing Git tag (e.g., v0.3.0).
- When the change affects the Docker image, also tag the built image with the matching version and update "latest" alongside it.
- Push both commits and tags (`git push && git push --tags`).

## General style
- Explain each command in plain language before running it, since I'm still learning.
- Keep everything minimal: avoid adding tools, dependencies, or complexity beyond what's needed to demonstrate the concept at hand.
