# README @ dockerization

Quick [local development tools based on Bash, Docker, and Docker Compose](https://github.com/grzechowski/dockerization).

---

## 🚀 First Steps

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed  
- [Docker Compose](https://docs.docker.com/compose/install/) installed

Your installation procedure may differ depending on OS.

### Network Setup
- Add the configuration lines from [./dockers/druids.me/hostnames-dockers](./dockers/druids.me/hostnames-dockers) to your system’s `hosts` file.  
- Ensure you are using the **latest version** of these configuration lines.

### Default Project Group
By default, the console script assumes the project group `dev`.  
You can override this by creating a `.env` file next to `console.sh`:

```bash
PROJECT_GROUP=druids.me
```

This has been already done.

---

## 🛠️ Utilities
You can use docker/host helper scripts from the [`scripts/`](./scripts/) directory to manage permissions, reset temporary files, and synchronize hostnames.


## 📨 Example: Mailcatcher

### Build the Mailcatcher container
```bash
./console.sh b mail
```

If errors occur, it may indicate that some base libraries have changed and the Dockerfile needs updating. For support, you can [contact @yodahack](https://github.com/yodahack).

### Start the Mailcatcher container
```bash
./console.sh u mail
```

### Verify the container is running
```bash
docker ps | grep druidsme_mail_1
```

### Access the Mailcatcher interface
Once running, open your browser at:  
👉 [http://mail.druidsme.dock/](http://mail.druidsme.dock/)  

Mailcatcher can be used with your other Dockerized applications to capture outgoing emails in a safe development environment.

---

## Example Static Website

This is a version consistent with the initial versions of the landing page, left here in case anyone wants to see it. It might also be useful as an example.

- [dockers/druids.me/static/README](./dockers/druids.me/static/README.md)  

**Important:** `static` is in IP/hostname conflict with `presale`, can not run at the same time.

---

## Example Presale Website

- [dockers/druids.me/presale/README](./dockers/druids.me/presale/README.md)  

---

## 🛠 Notes
- Always keep your Docker images up to date.  
- Rebuild containers when base images or libraries change. ``./console.sh r PROJECT-NAME``
- Ensure your `hosts` file matches the latest provided configuration.
- It is good idea to always put down containers or stop them when you are turning off your workstation ``./console.sh d mail,op``
- Once You have build multiple projects you can just up them together ``./console.sh u mail,op``
- If you want to keep live changes in instances ``./console.sh stop mail,op`` ``./console.sh start mail,op``

---
