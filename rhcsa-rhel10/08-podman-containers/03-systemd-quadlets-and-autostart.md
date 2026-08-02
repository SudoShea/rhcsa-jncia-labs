# Lab 08.3: Container Systemd Integration, Quadlets & Auto-Start Policies on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/08-containers-and-podman/03-systemd-quadlets-and-autostart.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Author rootless Podman Quadlet container unit files (`.container`) under user configuration directories.
2. Define container specifications within Quadlets, including image sources, container names, volume mounts, and published ports.
3. Manage rootless systemd container service lifecycles using `systemctl --user`.
4. Configure container automatic restart policies and ensure services persist across system reboots without requiring active SSH sessions.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* A standard user account (`<username>`) configured with rootless Podman privileges.

---

## 🛠️ Scenario

You are deploying a persistent background microservice on RHEL 10 that must automatically start on system boot and restart upon failure. Rather than manually executing `podman run` commands, corporate policy mandates managing container lifecycles via native `systemd` integration using **Podman Quadlets**. You must author a rootless Quadlet file named `webapp.container`, integrate host storage and network port mappings, and configure `systemd` to manage the container service automatically.

---

## 📝 Lab Tasks

### Task 1: Environment Setup & User Lingering
1. Log in as `<username>`.
2. Enable user process lingering using `loginctl enable-linger <username>` to allow rootless systemd user units to start automatically during system boot without an active user session.
3. Create the required user Quadlet directory structure at `~/.config/containers/systemd/`.
4. Create a host web content directory at `/home/<username>/quadlet_data` containing a custom `index.html` file (`"Quadlet Service Active on RHEL 10"`).

### Task 2: Authoring a Podman Quadlet File (`webapp.container`)
1. Create a Quadlet container definition file named `webapp.container` inside `~/.config/containers/systemd/`.
2. Populate `webapp.container` with the following parameters:
   * **[Unit]:** Include a clear description and set network ordering (`After=network-online.target`).
   * **[Container]:**
     * `Image=registry.access.redhat.com/ubi9/nginx-120:latest`
     * `ContainerName=webapp-quadlet`
     * `PublishPort=8080:8080`
     * `Volume=/home/<username>/quadlet_data:/usr/share/nginx/html:Z`
   * **[Service]:** Set auto-restart behaviour (`Restart=on-failure`).
   * **[Install]:** Integrate with user default target (`WantedBy=default.target`).

### Task 3: Unit Generation, Service Activation & Auto-Start Testing
1. Instruct the systemd user manager to scan for new Quadlet definitions by executing `systemctl --user daemon-reload`.
2. Verify that Quadlet automatically generated a corresponding service unit named `webapp.service`.
3. Enable and start the service using `systemctl --user enable --now webapp.service`.
4. Verify container status using `systemctl --user status webapp.service` and `podman ps`.
5. Test endpoint reachability using `curl http://localhost:8080`.
6. Test automatic failure recovery by stopping or killing the running container process directly via `podman kill webapp-quadlet` and verifying that systemd automatically restarts it.

---

## 🔍 Verification & Self-Test

Run these commands to verify Quadlet generation, service status, and HTTP output:

```bash
# 1. Verify generated user service state
systemctl --user status webapp.service

# 2. Confirm container execution state
podman ps --filter name=webapp-quadlet

# 3. Test web server response
curl http://localhost:8080
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Lingering & Directory Setup
```bash
# 1. Enable user lingering for persistent user-level services
sudo loginctl enable-linger <username>

# 2. Confirm lingering state
loginctl show-user <username> | grep Linger

# 3. Create Quadlet user directory
mkdir -p ~/.config/containers/systemd/

# 4. Create local host data directory and content
mkdir -p ~/quadlet_data
echo "Quadlet Service Active on RHEL 10" > ~/quadlet_data/index.html
```
Task 2 Solutions: Quadlet File Authoring
```bash
# 1. Author the Quadlet definition file
cat << 'EOF' > ~/.config/containers/systemd/webapp.container
[Unit]
Description=Production Web Application Container Service
After=network-online.target
Wants=network-online.target

[Container]
Image=[registry.access.redhat.com/ubi9/nginx-120:latest](https://registry.access.redhat.com/ubi9/nginx-120:latest)
ContainerName=webapp-quadlet
PublishPort=8080:8080
Volume=%h/quadlet_data:/usr/share/nginx/html:Z

[Service]
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=default.target
EOF
```
    *Note: `%h` is a Quadlet specifier that automatically expands to the user's home directory path (`/home/<username>`).*
Task 3 Solutions: Activation & Verification
```bash
# 1. Reload user systemd daemon to process the .container file
systemctl --user daemon-reload

# 2. Enable and start the generated webapp service
systemctl --user enable --now webapp.service

# 3. Check systemd service status
systemctl --user status webapp.service

# 4. Check Podman container state
podman ps

# 5. Verify web application response
curl http://localhost:8080
# Output: Quadlet Service Active on RHEL 10

# 6. Test automatic restart recovery
podman kill webapp-quadlet
sleep 3
podman ps  # Container should reflect a recent uptime/restart
```
