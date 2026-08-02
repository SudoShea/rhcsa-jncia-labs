# RHCSA RHEL 10 Full Practice Mock Exam (EX200)

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/09-mock-exam/01-full-rhcsa-mock-exam.md`  
**Licence:** MIT  
**Suggested Time Limit:** 3 Hours  

---

## 🎯 Objectives

This comprehensive practice exam evaluates your operational competence across all Red Hat Certified System Administrator (RHCSA) domains for RHEL 10:
1. Essential Tools & Shell Scripting
2. Operating Running Systems & Systemd Integration
3. Local Storage, LVM & File System Management
4. System Maintenance, Software Management & Networking
5. User Management, Group Policies & Sudo Delegation
6. Security, SELinux & Firewalld Hardening
7. Rootless Container Management & Quadlet Automation

---

## 📋 Prerequisites & Exam Environment

* A fresh, running RHEL 10 virtual machine with administrative access via `sudo` or `root`.
* Two unformatted secondary block storage devices (referenced as `<device_name1>` and `<device_name2>`, e.g. `vdb` and `vdc`).
* Sanitised placeholder variables used throughout this exam:
  * Primary User Account: `<username>`
  * Primary Server IP: `<server_ip>`
  * Gateway IP: `<gateway_ip>`
  * DNS IP: `<dns_ip>`
  * Target Hostname: `<server_hostname>`

---

## 🛠️ Scenario & Exam Rules

You are appointed as the Lead System Engineer responsible for commissioning a newly provisioned RHEL 10 enterprise server. You must configure the node according to corporate security baseline policies, setup storage, write automation scripts, manage user access, enforce SELinux rules, and deploy containerised microservices.

**Crucial Exam Rules:**
* All configurations **must survive a system reboot**. Non-persistent changes will be marked as non-compliant.
* Do not alter the `root` account password unless explicitly instructed.
* Validate all syntax prior to restarting core daemons (`sshd -t`, `visudo -c`, `systemd-analyze verify`).

---

## 📝 Exam Tasks

### Domain 1: Networking, Hostname & Time Synchronisation
1. Set the static system hostname to `<server_hostname>`.
2. Configure network interface `<interface_name>` using `nmcli` with the following persistent settings:
   * **IPv4 Address:** `<server_ip>/24`
   * **Gateway:** `<gateway_ip>`
   * **DNS Server:** `<dns_ip>`
   * **Addressing Method:** `manual`
3. Configure `chronyd` to synchronise time against the NTP pool `pool.ntp.org` and verify operational status.

### Domain 2: Users, Groups & Sudo Delegation
1. Create a security group named `sysadmins` with GID `2000`.
2. Create a user account named `<username_1>` with UID `2000` and primary group `sysadmins`.
3. Create a secondary user account named `<username_2>`.
4. Configure password aging for `<username_1>`: maximum age of 90 days, minimum age of 7 days, warning period of 14 days.
5. Create a drop-in sudoers file at `/etc/sudoers.d/sysadmins-rules` granting members of group `sysadmins` permission to execute `/usr/bin/systemctl` and `/usr/bin/dnf` as `root` without password prompts (`NOPASSWD`). Enforce file mode `0440`.

### Domain 3: Permissions, Special Bits & POSIX ACLs
1. Create a collaborative directory at `/srv/projects` owned by user `root` and group `sysadmins`.
2. Configure permissions on `/srv/projects` so that:
   * Owner and group members have full read, write, and execute permissions (`rwx`).
   * Other users have no access (`---`).
   * Any file or directory created inside automatically inherits group ownership as `sysadmins` (SGID bit).
3. Apply a default POSIX ACL on `/srv/projects` granting user `<username_2>` read and execute permissions (`r-x`) on all future files and subdirectories.

### Domain 4: Local Storage, Swap & LVM Management
1. Partition block device `<device_name1>` to create a `2 GiB` Linux swap partition. Configure swap persistently in `/etc/fstab` using its UUID and activate it.
2. Initialise block device `<device_name2>` as an LVM Physical Volume.
3. Create a Volume Group named `vg_data` using `<device_name2>`.
4. Provision a `3 GiB` Logical Volume named `lv_store` inside `vg_data`.
5. Format `lv_store` with an `xfs` file system and configure a persistent mount at `/mnt/store` in `/etc/fstab` using UUID.
6. Extend `lv_store` online by an additional `1 GiB` (or consume remaining free extents) and resize the XFS file system without unmounting.

### Domain 5: Operating Running Systems & Automation
1. Change the default systemd boot target persistently to `multi-user.target`.
2. Enable and activate the `throughput-performance` profile using `tuned-adm`.
3. Configure `systemd-journald` to retain logs persistently across reboots in `/var/log/journal` with a total disk usage cap of `500M`.
4. Author a shell script at `/usr/local/bin/sys-report.sh` that appends system uptime and memory statistics (`free -m`) to `/var/log/sys-report.log`. Make it executable.
5. Create a `systemd` service (`sys-report.service`) and a matching timer (`sys-report.timer`) to execute `/usr/local/bin/sys-report.sh` automatically every hour.

### Domain 6: Security, SELinux & Firewalld
1. Ensure SELinux is operating in `enforcing` mode persistently.
2. Create a custom web directory at `/srv/www` and an index file `/srv/www/index.html`.
3. Configure persistent SELinux file contexts so that all files under `/srv/www` inherit the `httpd_sys_content_t` type context. Apply the context recursively using `restorecon`.
4. Configure `semanage` to label TCP port `8088` as a valid HTTP port (`http_port_t`).
5. Enable the SELinux boolean `httpd_enable_homedirs` persistently (`-P`).
6. Configure `firewalld` in the default zone to persistently allow incoming traffic on TCP port `8088` and service `ssh`.

### Domain 7: Rootless Containers & Quadlets
1. Enable user lingering for user `<username>` via `loginctl enable-linger`.
2. Configure rootless Podman search registries in `/etc/containers/registries.conf.d/00-search.conf` to include `registry.access.redhat.com`.
3. Create a directory at `/home/<username>/app_data` containing an `index.html` file with the string `"Mock Exam Microservice Active"`.
4. Create a Podman Quadlet container definition file at `/home/<username>/.config/containers/systemd/microservice.container`:
   * **Image:** `registry.access.redhat.com/ubi9/nginx-120:latest`
   * **ContainerName:** `microservice-app`
   * **PublishPort:** `8080:8080`
   * **Volume:** `/home/<username>/app_data:/usr/share/nginx/html:Z`
   * **Auto-Restart:** `Restart=on-failure`
5. Reload the user systemd daemon (`systemctl --user daemon-reload`), enable, and start `microservice.service`. Verify endpoint output via `curl http://localhost:8080`.

---

## 🔍 Verification & Self-Test

Run these diagnostic commands to verify complete system compliance:

```bash
# 1. Network & Hostname Verification
hostnamectl status
ip addr show <interface_name>

# 2. Storage & Mount Verification
swapon --show
df -h /mnt/store
lvs vg_data/lv_store

# 3. Permissions & SELinux Verification
ls -ld /srv/projects
getfacl /srv/projects
ls -Zd /srv/www
semanage port -l | grep 8088

# 4. Container & Systemd Verification
systemctl --user status microservice.service
curl http://localhost:8080
```
---

## 💡 Step-by-Step Solution & Reference
Domain 1 Solutions: Networking & Time
```bash
# Set static hostname
sudo hostnamectl set-hostname <server_hostname>

# Configure network interface
sudo nmcli connection modify "<interface_name>" \
  ipv4.addresses "<server_ip>/24" \
  ipv4.gateway "<gateway_ip>" \
  ipv4.dns "<dns_ip>" \
  ipv4.method manual \
  connection.autoconnect yes

sudo nmcli connection up "<interface_name>"

# Configure Chrony time sync
sudo cat << 'EOF' | sudo tee -a /etc/chrony.conf
server pool.ntp.org iburst
EOF
sudo systemctl restart chronyd
```
Domain 2 Solutions: Users, Groups & Sudo
```bash
# Group and user creation
sudo groupadd -g 2000 sysadmins
sudo useradd -u 2000 -g sysadmins -s /bin/bash <username_1>
sudo useradd <username_2>

# Password aging configuration
sudo chage -M 90 -m 7 -W 14 <username_1>

# Sudo delegation
sudo cat << 'EOF' | sudo tee /etc/sudoers.d/sysadmins-rules
%sysadmins ALL=(ALL) NOPASSWD: /usr/bin/systemctl, /usr/bin/dnf
EOF
sudo chmod 0440 /etc/sudoers.d/sysadmins-rules
sudo visudo -c
```
Domain 3 Solutions: Permissions & ACLs
```bash
# Directory creation and SGID bit
sudo mkdir -p /srv/projects
sudo chown root:sysadmins /srv/projects
sudo chmod 2770 /srv/projects

# Default POSIX ACL assignment
sudo setfacl -m u:<username_2>:r-x /srv/projects
sudo setfacl -d -m u:<username_2>:r-x /srv/projects
```
Domain 4 Solutions: Storage, Swap & LVM
```bash
# Create swap partition on device 1
sudo fdisk /dev/<device_name1>  # Create 2G partition, change type to Linux swap
sudo mkswap /dev/<device_name1>1
SWAP_UUID=$(sudo blkid -s UUID -o value /dev/<device_name1>1)
echo "UUID=${SWAP_UUID} none swap defaults 0 0" | sudo tee -a /etc/fstab
sudo swapon -a

# Create LVM on device 2
sudo pvcreate /dev/<device_name2>
sudo vgcreate vg_data /dev/<device_name2>
sudo lvcreate -L 3G -n lv_store vg_data
sudo mkfs.xfs /dev/vg_data/lv_store

sudo mkdir -p /mnt/store
LV_UUID=$(sudo blkid -s UUID -o value /dev/vg_data/lv_store)
echo "UUID=${LV_UUID} /mnt/store xfs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a

# Online LVM and XFS expansion
sudo lvextend -r -l +100%FREE /dev/vg_data/lv_store
```
Domain 5 Solutions: Operating Systems & Timers
```bash
# Target and Tuned profile
sudo systemctl set-default multi-user.target
sudo tuned-adm profile throughput-performance

# Persistent Journald
sudo mkdir -p /etc/systemd/journald.conf.d/
sudo cat << 'EOF' | sudo tee /etc/systemd/journald.conf.d/00-persistent.conf
[Journal]
Storage=persistent
SystemMaxUse=500M
EOF
sudo systemctl restart systemd-journald

# Automation Script
sudo cat << 'EOF' | sudo tee /usr/local/bin/sys-report.sh
#!/usr/bin/env bash
echo "=== System Audit: $(date) ===" >> /var/log/sys-report.log
uptime >> /var/log/sys-report.log
free -m >> /var/log/sys-report.log
EOF
sudo chmod 755 /usr/local/bin/sys-report.sh

# Systemd Service & Timer
sudo cat << 'EOF' | sudo tee /etc/systemd/system/sys-report.service
[Unit]
Description=Periodic System Report Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/sys-report.sh
EOF

sudo cat << 'EOF' | sudo tee /etc/systemd/system/sys-report.timer
[Unit]
Description=Run System Report Hourly

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now sys-report.timer
```
Domain 6 Solutions: SELinux & Firewalld
```bash
# SELinux mode
sudo setenforce 1

# File contexts
sudo mkdir -p /srv/www
echo "Web Content" | sudo tee /srv/www/index.html
sudo semanage fcontext -a -t httpd_sys_content_t "/srv/www(/.*)?"
sudo restorecon -vFR /srv/www

# Port labelling and boolean
sudo semanage port -a -t http_port_t -p tcp 8088
sudo setsebool -P httpd_enable_homedirs on

# Firewalld rules
sudo firewall-cmd --permanent --add-port=8088/tcp
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```
Domain 7 Solutions: Rootless Containers & Quadlets
```bash
# Enable lingering & registry search
sudo loginctl enable-linger <username>
sudo cat << 'EOF' | sudo tee /etc/containers/registries.conf.d/00-search.conf
unqualified-search-registries = ["registry.access.redhat.com"]
EOF

# Quadlet file structure & directory creation
mkdir -p ~/.config/containers/systemd/
mkdir -p ~/app_data
echo "Mock Exam Microservice Active" > ~/app_data/index.html

# Author Quadlet definition
cat << 'EOF' > ~/.config/containers/systemd/microservice.container
[Unit]
Description=Mock Exam Quadlet Service
After=network-online.target

[Container]
Image=[registry.access.redhat.com/ubi9/nginx-120:latest](https://registry.access.redhat.com/ubi9/nginx-120:latest)
ContainerName=microservice-app
PublishPort=8080:8080
Volume=%h/app_data:/usr/share/nginx/html:Z

[Service]
Restart=on-failure

[Install]
WantedBy=default.target
EOF

# Service activation
systemctl --user daemon-reload
systemctl --user enable --now microservice.service
curl http://localhost:8080
```
