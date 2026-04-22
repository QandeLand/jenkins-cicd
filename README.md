# Jenkins CI/CD Factory — Two-Tier App

![Jenkins](https://img.shields.io/badge/Jenkins-2.x-D24939?logo=jenkins&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containerised-2496ED?logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-Flask-3776AB?logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/Database-MySQL-4479A1?logo=mysql&logoColor=white)
![SonarQube](https://img.shields.io/badge/SonarQube-Passed-4E9BCD?logo=sonarqube&logoColor=white)
![Trivy](https://img.shields.io/badge/Security-Trivy-1904DA?logo=aqua&logoColor=white)
![GHCR](https://img.shields.io/badge/Registry-GHCR-181717?logo=github&logoColor=white)
![Slack](https://img.shields.io/badge/Notifications-Slack-4A154B?logo=slack&logoColor=white)

A full CI/CD pipeline built with Jenkins that automatically tests, builds, scans, and deploys a two-tier Flask and MySQL application on every git push. Includes SonarQube code quality gate, Trivy security scanning, and Slack notifications.

---

## Pipeline stages

| Stage | What it does | Blocks pipeline if |
|---|---|---|
| Checkout | Pulls latest code from GitHub | Git error |
| Run Tests | Runs 4 pytest unit tests | Any test fails |
| SonarQube Analysis | Scans code for bugs, smells, security issues | Scanner error |
| Quality Gate | Checks SonarQube result | Gate fails |
| Build Image | Multi-stage Alpine Docker build | Build error |
| Scan Image | Trivy scans for HIGH and CRITICAL CVEs | Scanner error |
| Push to GHCR | Pushes image with build number tag | Auth error |
| Deploy | Removes old container, deploys new one | Compose error |
| Health Check | Curls /health endpoint to verify app started | App not responding |

---

## Tech stack

| Tool | Purpose |
|---|---|
| Jenkins | CI/CD orchestration |
| Flask | Python web backend |
| MySQL | Database |
| Docker + Docker Compose | Containerisation and deployment |
| SonarQube | Code quality gate |
| Trivy | Container image security scanning |
| GHCR | Container image registry |
| ngrok | Exposes local Jenkins to GitHub webhooks |
| Slack | Pipeline notifications |
| pytest | Unit testing |

---

## Security highlights

- Alpine base image — 0 OS-level CVEs
- Trivy scans every image before deployment
- SonarQube quality gate blocks bad code from deploying
- Images tagged with build number for full traceability
- All credentials stored as Jenkins secrets — never in code

---

## Project structure

jenkins-cicd/
├── app/
│   ├── app.py               # Flask application
│   ├── Dockerfile           # Multi-stage Alpine Docker build
│   ├── requirements.txt     # Python dependencies
│   └── tests/
│       └── test_app.py      # Unit tests (4 tests)
├── docker-compose.yml        # Jenkins + MySQL tooling
├── docker-compose.app.yml    # Flask app + MySQL deployment
├── docker-compose-sonar.yml  # SonarQube
├── Dockerfile.jenkins        # Custom Jenkins image
├── Jenkinsfile              # Full pipeline definition
├── start.sh                 # Start all services + ngrok
└── stop.sh                  # Stop all services

---

## Quick start

```bash
./start.sh
```

The script will:
- Start Jenkins, MySQL, and app containers
- Install Python, Docker tools, and sonar-scanner inside Jenkins
- Start ngrok and print the public URL
- Show instructions for updating Jenkins URL and GitHub webhook

**Access Jenkins:**

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

Because ngrok generates a new URL on every restart, update two things:

**1. Jenkins URL:**
- `http://localhost:8090/manage/configure` → Jenkins URL → save

**2. GitHub webhook:**
- Repo Settings → Webhooks → Edit → update Payload URL to `https://YOUR-NGROK-URL/github-webhook/`

---

## Application endpoints

| Endpoint | Method | Description |
|---|---|---|
| `/health` | GET | Returns `{"status": "ok"}` |
| `/users` | GET | Returns list of users from MySQL |

---

## SonarQube

Start SonarQube when needed:
```bash
docker compose -f docker-compose-sonar.yml up -d
```

Access at `http://localhost:9000` — quality gate results appear after each pipeline run.

Stop when done to free RAM:
```bash
docker stop sonarqube
```

---

## Planned additions

- [ ] Harbor self-hosted registry
- [ ] Pipeline timing metrics dashboard
