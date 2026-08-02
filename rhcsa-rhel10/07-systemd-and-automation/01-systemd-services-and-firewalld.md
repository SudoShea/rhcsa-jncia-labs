# Lab 07.1: Systemd Service Management, Custom Unit Files & Firewalld Configuration on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/07-systemd-and-network-services/01-systemd-services-and-firewalld.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Manage systemd service lifecycles (`start`, `stop`, `restart`, `reload`, `enable`, `disable`, `mask`, `unmask`).
2. Author, deploy, and validate custom systemd service unit files (`.service`) with dependency ordering and automatic restart policies.
3. Configure `firewalld` operational zones, default zone assignments, and active network interface bindings.
4. Manage persistent `firewalld` service definitions, port allowances, and rich rules using `firewall-cmd --permanent`.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Administrative access via `sudo` or the `root` account.
* Active `firewalld` service installed on the lab VM.

---

## 🛠️ Scenario

You are deploying an internal API service application on a RHEL 10 server. The application runs via a custom Python/Bash daemon listening on TCP port `8090`. You must write a custom systemd service unit file (`custom-app.service`) to ensure the process starts automatically on system boot, automatically restarts upon failure, and respects system ordering dependencies. Additionally, you must secure the network boundary by configuring `firewalld` to allow TCP port `8090` persistently in the active firewall zone.

---

## 📝 Lab Tasks

### Task 1: Systemd Service Lifecycle & Unit Masking
1. Query the operational status, enablement state, and unit properties of the `firewalld` service using `systemctl`.
2. Stop and disable `firewalld` temporarily.
3. Mask `firewalld` to prevent any user or process from manually or automatically starting the daemon, then verify that execution attempts are blocked.
4. Unmask, enable, and start `firewalld` to restore operational firewall protection.

### Task 2: Authoring a Custom Systemd Service Unit
1. Create a daemon binary script at `/usr/local/bin/custom-app.sh` with the following content and make it executable (`chmod 755`):
```bash
#!/usr/bin/env bash
echo "Starting Custom App Daemon on port 8090..."
exec /usr/bin/python3 -m http.server 8090
```
2. Create a custom systemd service unit file at `/etc/systemd/system/custom-app.service` containing:
    * [Unit]: Description, documentation link, and ordering after `network-online.target` (`After=` and `Wants=`).
    * [Service]: Execution type (`simple`), binary path (`ExecStart`), restart policy (`on-failure`), restart delay (`RestartSec=5s`), and process user (`nobody`).
    * [Install]: Multi-user target integration (`WantedBy=multi-user.target`).
3. Reload the systemd manager configuration (`systemctl daemon-reload`).
4. Enable and start `custom-app.service`, verifying that the service transitions to an `active (running)` state.
5. Validate unit file syntax using `systemd-analyze verify /etc/systemd/system/custom-app.service`.

### Task 3: Firewalld Zone Assignment & Persistent Port Rules
1. Query the default `firewalld` zone, active zones, and associated network interfaces using `firewall-cmd`.
2. Temporarily allow TCP port `8090` in the active default zone and verify that port `8090/tcp` appears in the runtime rule list.
3. Reload `firewalld` (`firewall-cmd --reload`) and observe that runtime-only rules are purged.
4. Add TCP port `8090` persistently to the default zone using `firewall-cmd --permanent`.
5. Create a persistent rich rule in `firewalld` allowing SSH access (`port 22/tcp`) exclusively from a specific subnet (e.g. `192.168.1.0/24`) while logging dropped connection attempts.
6. Reload `firewalld` and confirm that all persistent rules are active.

---

## 🔍 Verification & Self-Test
Run these commands to verify your service, unit file, and firewall configuration:
```bash
# 1. Verify custom app systemd status
systemctl status custom-app.service

# 2. Confirm socket binding on TCP port 8090
ss -tulpn | grep 8090

# 3. List active persistent firewalld rules
sudo firewall-cmd --list-all
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Service Lifecycle & Masking
```bash
# 1. Query service status and properties
systemctl status firewalld
systemctl is-enabled firewalld

# 2. Stop and disable service
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# 3. Mask service to block activation
sudo systemctl mask firewalld
# Attempting to start will fail with "Unit firewalld.service is masked."
sudo systemctl start firewalld 2>&1 | grep "masked"

# 4. Unmask, enable, and start service
sudo systemctl unmask firewalld
sudo systemctl enable --now firewalld
systemctl is-active firewalld
```
Task 2 Solutions: Custom Unit File Authoring
```bash
# 1. Create executable script
sudo cat << 'EOF' | sudo tee /usr/local/bin/custom-app.sh
#!/usr/bin/env bash
echo "Starting Custom App Daemon on port 8090..."
exec /usr/bin/python3 -m http.server 8090
EOF

sudo chmod 755 /usr/local/bin/custom-app.sh

# 2. Create custom unit file definition
sudo cat << 'EOF' | sudo tee /etc/systemd/system/custom-app.service
[Unit]
Description=Custom Internal API Application Daemon
Documentation=[https://docs.local/custom-app](https://docs.local/custom-app)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/custom-app.sh
Restart=on-failure
RestartSec=5s
User=nobody
Group=nobody

[Install]
WantedBy=multi-user.target
EOF

# 3. Reload systemd manager configuration
sudo systemctl daemon-reload

# 4. Enable and start service
sudo systemctl enable --now custom-app.service

# 5. Verify service state and syntax
systemctl status custom-app.service
systemd-analyze verify /etc/systemd/system/custom-app.service
```
Task 3 Solutions: Firewalld Configuration
```bash
# 1. Query current default zone and interfaces
sudo firewall-cmd --get-default-zone
sudo firewall-cmd --get-active-zones

# 2. Add runtime port rule
sudo firewall-cmd --add-port=8090/tcp
sudo firewall-cmd --list-ports

# 3. Demonstrate runtime rule purge on reload
sudo firewall-cmd --reload
sudo firewall-cmd --list-ports  # Port 8090 disappears

# 4. Add persistent port rule
sudo firewall-cmd --permanent --add-port=8090/tcp

# 5. Add persistent rich rule for targeted SSH subnet access
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" port protocol="tcp" port="22" accept'

# 6. Reload firewalld to apply persistent rules
sudo firewall-cmd --reload

# 7. Verify active firewall ruleset
sudo firewall-cmd --list-all
```
