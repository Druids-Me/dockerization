# Changelog
All notable changes to **druids.me** will be documented in this file.  
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)  
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [0.0.1] – 2025-08-08
### Added
- Project initialization
- `README.md` and base documentation
- Environment configuration (`.env`)
- Global helper scripts (`console.sh`)
- `scripts/` utilities:
  - `dockers/fix-hosts.sh`
  - `host/fix-owner.sh`
  - `host/reset-tmp.sh`
  - `host/copy-scripts.sh`
  - `host/copy-hostnames.sh`
- `dockers/druids.me/` base setup:
  - `hostnames-dockers`
  - `network-create.sh`
  - `.gitignore`
  - `docker-project`
- `dockers/druids.me/mail/` docker service:
  - `pre-build.sh`, `post-start.sh`, `post-up.sh`
  - `docker-compose.yml`
  - `Dockerfile`
  - `docker-project`
  - `docker/tmp/fix-hosts.sh`, `docker/tmp/hosts`
