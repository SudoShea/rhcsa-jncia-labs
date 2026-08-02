# Lab 08.2: Running Containers, Port Mapping, Environment Variables & Persistent Storage Mounts on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/08-containers-and-podman/02-running-containers-ports-and-storage.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Run container workloads in detached and interactive modes using `podman run`.
2. Inject configuration runtime parameters using environment variables (`-e` / `--env`).
3. Expose and map network container ports to host interfaces (`-p` / `--publish`).
4. Mount host directory volumes into containers using `-v` / `--volume` with mandatory SELinux volume labelling flags (`:Z`).
5. Execute commands inside active containers using `podman exec` and inspect container logs using `podman logs`.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Standard user account access (`<username>`) configured with rootless Podman execution rights.
* Local availability of a web server or base image (e.g. `registry.access.redhat.com/ubi9/ubi` or `docker.io/library/nginx`).

---

## 🛠️ Scenario

You are deploying an unprivileged, microservice-based web server application on RHEL 10 using rootless Podman. The application requires custom environment variables to configure logging levels, host port publishing (`8080:80`) to allow external HTTP traffic, and persistent host directory binding (`/home/<username>/web_data`) to serve static content. Additionally, you must ensure SELinux policies permit the container to read host volume data without throwing access violations.

---

## 📝 Lab Tasks

### Task 1: Container Execution & Environment Variables
1. Run a detached container named `web-app` using the `registry.access.redhat.com/ubi9/ubi` image.
2. Inject two custom environment variables into the container environment:
   * `APP_ENV=production`
   * `LOG_LEVEL=debug`
3. Configure the container to execute an interactive background loop (e.g. `bash -c "while true; do sleep 30; done"`).
4. Verify the container state using `podman ps` and print the injected environment variables inside the container using `podman exec`.

### Task 2: Network Port Mapping & Service Exposure
1. Stop and remove the `web-app` container.
2. Launch a new container named `http-server` using `docker.io/library/nginx` (or an equivalent web server image like `registry.access.redhat.com/ubi9/nginx-120`).
3. Map host TCP port `8080` to container TCP port `80` (`-p 8080:80`).
4. Query host port bindings using `podman port http-server` and verify local HTTP access using `curl http://localhost:8080`.
5. Tail live container stdout logs using `podman logs -f http-server`.

### Task 3: Persistent Storage Mounts & SELinux Labelling (`:Z`)
1. Create a directory on the host at `/home/<username>/web_data`.
2. Create an `index.html` file inside `/home/<username>/web_data` containing the text: `Hello from RHEL 10 Host Storage!`.
3. Stop and remove the existing `http-server` container.
4. Redeploy `http-server` mapping host port `8080:80` and mounting host directory `/home/<username>/web_data` to `/usr/share/nginx/html` (or equivalent document root). Apply the private SELinux volume flag (`:Z`) to grant container access permissions.
5. Verify web content delivery via `curl http://localhost:8080`.
6. Modify `index.html` on the host system and verify that the updated content is immediately reflected when querying the running container.

---

## 🔍 Verification & Self-Test

Run these commands to verify container state, volume bindings, and port mapping:

```bash
# 1. Verify running containers and exposed host ports
podman ps

# 2. Query specific port mappings
podman port http-server

# 3. Test volume-backed web content
curl http://localhost:8080
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Environment Variables & Execution
```bash
# 1. Run detached container with environment variables
podman run -d --name web-app \
  -e APP_ENV=production \
  -e LOG_LEVEL=debug \
  [registry.access.redhat.com/ubi9/ubi](https://registry.access.redhat.com/ubi9/ubi) \
  bash -c "while true; do sleep 30; done"

# 2. List running containers
podman ps

# 3. Inspect injected variables inside container
podman exec web-app printenv | grep -E "(APP_ENV|LOG_LEVEL)"
```
Task 2 Solutions: Port Mapping
```bash
# 1. Stop and purge initial container
podman stop web-app
podman rm web-app

# 2. Deploy web server container with host port mapping (8080 -> 80)
podman run -d --name http-server \
  -p 8080:80 \
  docker.io/library/nginx

# 3. Inspect active port mappings
podman port http-server

# 4. Test HTTP endpoint from host
curl http://localhost:8080

# 5. Inspect container logs
podman logs --tail 10 http-server
```
Task 3 Solutions: Storage Mounts & SELinux (:Z)
```bash
# 1. Create host storage directory and content
mkdir -p ~/web_data
echo "Hello from RHEL 10 Host Storage!" > ~/web_data/index.html

# 2. Stop and remove existing web server container
podman stop http-server
podman rm http-server

# 3. Deploy container with volume mount and SELinux relabelling flag (:Z)
podman run -d --name http-server \
  -p 8080:80 \
  -v /home/<username>/web_data:/usr/share/nginx/html:Z \
  docker.io/library/nginx

# 4. Verify volume content delivery
curl http://localhost:8080
# Output: Hello from RHEL 10 Host Storage!

# 5. Modify host file and verify live update
echo "Updated content on host!" > ~/web_data/index.html
curl http://localhost:8080
# Output: Updated content on host!
```
