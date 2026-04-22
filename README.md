# Jenkins CI/CD Factory — Two-Tier App

![Jenkins](https://img.shields.io/badge/Jenkins-2.x-D24939?logo=jenkins&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containerised-2496ED?logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-Flask-3776AB?logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/Database-MySQL-4479A1?logo=mysql&logoColor=white)
![Trivy](https://img.shields.io/badge/Security-Trivy-1904DA?logo=aqua&logoColor=white)
![GHCR](https://img.shields.io/badge/Registry-GHCR-181717?logo=github&logoColor=white)

A full CI/CD pipeline built with Jenkins that automatically tests, builds, scans, and deploys a two-tier Flask and MySQL application on every git push.

---

## Architecture
Git push → GitHub webhook → Jenkins pipeline
│
┌───────────────┼───────────────┐
▼               ▼               ▼
Run Tests        Build Image      Scan Image
(pytest)         (Docker)         (Trivy)
│
┌───────────────┼
▼               ▼
Push to GHCR       Deploy
(image registry)   (Docker Compose)

---

## Tech stack

| Tool | Purpose |
|---|---|
| Jenkins | CI/CD orchestration |
| Flask | Python web backend |
| MySQL | Database |
| Docker + Docker Compose | Containerisation and deployment |
| Trivy | Container image security scanning |
| GHCR | Container image registry |
| ngrok | Exposes local Jenkins to GitHub webhooks |
| pytest | Unit testing |

---

## Pipeline stages

| Stage | What it does |
|---|---|
| Checkout | Pulls latest code from GitHub |
| Run Tests | Runs pytest unit tests — pipeline stops if any test fails |
| Build Image | Multi-stage Docker build — produces a slim production image |
| Scan Image | Trivy scans for HIGH and CRITICAL CVEs |
| Push to GHCR | Pushes image to GitHub Container Registry with build number tag |
| Deploy | Removes old container and deploys new one via Docker Compose |

---

## Project structure
jenkins-cicd/
├── app/
│   ├── app.py               # Flask application
│   ├── Dockerfile           # Multi-stage Docker build
│   ├── requirements.txt     # Python dependencies
│   └── tests/
│       └── test_app.py      # Unit tests
├── jenkins/
│   └── run-tests.sh         # Test runner script
├── docker-compose.yml        # Jenkins + MySQL tooling
├── docker-compose.app.yml    # Flask app + MySQL deployment
├── Dockerfile.jenkins        # Custom Jenkins image with Docker + Python
├── Jenkinsfile              # Pipeline definition
├── start.sh                 # Start all services
└── stop.sh                  # Stop all services

---

## Prerequisites

- Docker Desktop or Docker Engine
- WSL2 (if on Windows)
- ngrok account (free) — ngrok.com

---

## Quick start

**Start everything:**
```bash
./start.sh
```

The script will:
- Start Jenkins and MySQL containers
- Install Python and Docker tools inside Jenkins
- Start ngrok and print the public URL
- Show instructions for updating Jenkins URL and GitHub webhook

**Access Jenkins:**
http://localhost:8090

**Stop everything:**
```bash
./stop.sh
```

---

## After each restart

Because ngrok generates a new URL on every restart, you need to update two things:

**1. Jenkins URL:**
- Go to `http://localhost:8090/manage/configure`
- Find **Jenkins URL** and update it to the new ngrok URL
- Click Save

**2. GitHub webhook:**
- Go to repo Settings → Webhooks → Edit
- Update Payload URL to: `https://YOUR-NGROK-URL/github-webhook/`
- Click Update webhook

---

## Application endpoints

| Endpoint | Method | Description |
|---|---|---|
| `/health` | GET | Returns `{"status": "ok"}` |
| `/users` | GET | Returns list of users from MySQL |

---

## Security

- Trivy scans every image for CVEs before deployment
- Images are tagged with build number for full traceability
- Credentials stored as Jenkins secrets — never in code
- Docker socket permissions locked down

---

## Planned additions

- [ ] SonarQube code quality gate
- [ ] Slack pipeline notifications
- [ ] Harbor self-hosted registry