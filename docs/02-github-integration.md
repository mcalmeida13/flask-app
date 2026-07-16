# 02 — GitHub Integration

## What was planned

Set up Git locally, add a `.gitignore`, make the first commit, create a GitHub remote repository, and push the code for the first time.

## What was implemented

**`.gitignore`** — covers the categories relevant to a Python/Flask project:

```gitignore
# Python
__pycache__/
*.py[cod]
*.egg-info/

# Virtual environments
venv/
.venv/
env/

# Environment variables / secrets
.env
*.env

# Local databases
*.db
*.sqlite3

# Logs
*.log

# Editor / OS
.vscode/
.idea/
.DS_Store
```

**First commit** — `1b13d878` ("Initial commit: Flask app with Docker setup"). In practice this single commit bundled everything from stage 1 *and* the `.gitignore` from this stage in one go — `app.py`, `requirements.txt`, `Dockerfile`, `README.md`, and `.gitignore` were all added together rather than as two separate commits. So while the work was planned as two distinct stages (build the app, then wire up Git), the actual history shows them landing as one atomic commit. This commit is tagged `v0.1.0`.

**GitHub remote** — a repository was created on GitHub and wired up as `origin`:

```
git@github.com:mcalmeida13/flask-app.git
```

**First push** — the local `main` branch was pushed and now tracks `origin/main` (confirmed by `git status` reporting the branch up to date with `origin/main`, and by `origin/main` pointing at the latest commit in the history).

One deviation from the plan worth noting: the annotated tags `v0.1.0` and `v0.2.0` were both created at the same timestamp, immediately after the Makefile commit landed (see [`03-makefile.md`](03-makefile.md)) — meaning `v0.1.0` was applied retroactively to the initial commit rather than tagged at the moment it was first pushed.
