# Changelog
All notable changes to **druids.me** will be documented in this file.  
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)  
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [0.0.5] – 2025-09-01
### Added
- `dockers/druids.me/presale/nginx-react.conf` – new Nginx config for React SPA routing.

### Changed
- `dockers/druids.me/presale/Dockerfile`:
  - Switched to multi-stage base with **Node.js 22 Alpine** + Nginx.
  - Cleaned up environment variables, added proper `WORKDIR`.
  - Updated config to use `nginx-react.conf` instead of `local.site.nginx.conf`.
- `dockers/druids.me/presale/README.md`:
  - Added instructions for container shell, `npm install`, and `npm run dev`.
- `dockers/druids.me/presale/docker-compose.yml.tpl`:
  - Updated volume mount from `/usr/share/nginx/html` to `/druids.me`.

### Removed
- `dockers/druids.me/presale/local.site.nginx.conf` – replaced by `nginx-react.conf`.

---

## [0.0.4] – 2025-08-31
### Added
- `dockers/druids.me/static/` docker service:
  - `pre-build.sh`, `post-start.sh`, `post-up.sh`
  - `docker-compose.yml.tpl`
  - `Dockerfile`
  - `local.site.nginx.conf`
  - `docker-project` (symlink to `../docker-project`)
- Documentation files:
  - `dockers/druids.me/static/README.md`

### Changed
- `README.md` updated with examples for **static** project.

---

## [0.0.3] – 2025-08-31
### Added
- `dockers/druids.me/presale/` docker service:
  - `pre-build.sh`, `post-start.sh`, `post-up.sh`
  - `docker-compose.yml.tpl`
  - `Dockerfile`
  - `local.site.nginx.conf`
  - `docker-project` (symlink to `../docker-project`)
- Documentation files:
  - `dockers/druids.me/presale/README.md`

### Changed
- `README.md` updated with examples for running **presale** project.

---
## [0.0.2] – 2025-08-31
### Added
- Documentation files:
  - Root `CHANGELOG.md`

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
