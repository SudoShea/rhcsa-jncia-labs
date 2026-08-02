# Lab 08.1: Rootless Podman Setup, Container Registries & Image Management on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/08-containers-and-podman/01-rootless-podman-and-image-management.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Configure non-root user accounts for rootless container execution using `/etc/subuid` and `/etc/subgid`.
2. Enable user lingering via `loginctl enable-linger` to allow rootless container processes to persist without an active SSH session.
3. Configure container registry search locations and short-name aliases in `/etc/containers/registries.conf.d/`.
4. Search, inspect, pull, tag, and purge container images using `podman` CLI commands.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* A standard, unprivileged user account (`<username>`) with `sudo` access for initial system configuration.

---

## 🛠️ Scenario

You are deploying a containerized microservices platform on RHEL 10. Security policies strictly mandate that containers must run in rootless mode under standard user accounts to prevent privilege escalation vulnerabilities. You are required to configure user namespace mappings for `<username>`, enable persistent user sessions, configure image registry search paths, and pull and manage container base images from Red Hat container registries.

---

## 📝 Lab Tasks

### Task 1: Rootless Prerequisites & User Lingering Configuration
1. Install the `podman` container engine package if it is not already present.
2. Verify that user subordinate user and group IDs (`subuid` and `subgid`) are mapped for `<username>` in `/etc/subuid` and `/etc/subgid`.
3. Enable user session lingering for `<username>` using `loginctl` so that background user processes and containers continue running after the user logs out.
4. Verify rootless execution context by running `podman info` as `<username>` and checking the rootless state flag.

### Task 2: Container Registry & Short-Name Configuration
1. Inspect the system-wide registry configuration files under `/etc/containers/registries.conf.d/`.
2. Create a custom registry configuration drop-in file at `/etc/containers/registries.conf.d/00-shortnames.conf` that configures `registry.access.redhat.com` and `docker.io` as default search registries.
3. Search `registry.access.redhat.com` for official Red Hat Universal Base Images (`ubi9` or `ubi10`) using `podman search`.

### Task 3: Image Management, Inspection & Tagging
1. Pull the official Red Hat minimal base image (`registry.access.redhat.com/ubi9/ubi-minimal:latest`) into your unprivileged user image storage.
2. Inspect image layers, architecture metadata, environment variables, and default user settings using `podman inspect`.
3. Tag the pulled image as `localhost/app-base:v1` using `podman tag`.
4. List all locally stored images, verify that the tag alias shares the same Image ID, and remove the original tag while retaining `localhost/app-base:v1`.

---

## 🔍 Verification & Self-Test

Run these commands to verify user subuid mappings, lingering status, and image store contents:

```bash
# 1. Check user subuid and subgid range assignments
grep "<username>" /etc/subuid /etc/subgid

# 2. Confirm lingering status for user
loginctl show-user <username> | grep Linger

# 3. Verify rootless Podman execution and available local images
podman info --format '{{.Host.Security.Rootless}}'
podman images
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Rootless Setup & Lingering
```bash
# 1. Install Podman package
sudo dnf install -y podman

# 2. Verify subuid and subgid range entries exist for the standard user
# If entries are missing, add a 65536 range manually using usermod:
# sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 <username>
grep "<username>" /etc/subuid
grep "<username>" /etc/subgid

# 3. Enable process lingering for user account
sudo loginctl enable-linger <username>

# 4. Confirm linger state (should display Linger=yes)
loginctl show-user <username> | grep Linger

# 5. Execute podman info as standard user and verify rootless mode
podman info --format '{{.Host.Security.Rootless}}'
# Expected output: true
```
Task 2 Solutions: Registry Configuration & Image Search
```bash
# 1. Create drop-in configuration for registry search paths
sudo cat << 'EOF' | sudo tee /etc/containers/registries.conf.d/00-shortnames.conf
unqualified-search-registries = ["registry.access.redhat.com", "docker.io"]
EOF

# 2. Search Red Hat registry for UBI images
podman search registry.access.redhat.com/ubi
```
Task 3 Solutions: Pulling, Inspecting & Tagging Images
```bash
# 1. Pull the UBI minimal image as non-root user
podman pull registry.access.redhat.com/ubi9/ubi-minimal:latest)

# 2. Display locally cached images
podman images

# 3. Inspect image details and metadata
podman inspect registry.access.redhat.com/ubi9/ubi-minimal:latest | head -n 30

# 4. Create a local custom image tag
podman tag registry.access.redhat.com/ubi9/ubi-minimal:latest localhost/app-base:v1

# 5. Verify image IDs match across tags
podman images

# 6. Remove the remote registry tag alias while retaining local tag
podman rmi registry.access.redhat.com/ubi9/ubi-minimal:latest

# 7. Confirm local tag remains intact
podman images
```
