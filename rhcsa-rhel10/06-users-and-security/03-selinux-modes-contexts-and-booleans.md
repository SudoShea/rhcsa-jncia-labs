# Lab 06.3: SELinux Modes, File Contexts, Port Labelling & Booleans on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/06-users-and-security/03-selinux-modes-contexts-and-booleans.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Query and manage SELinux runtime execution modes (`enforcing`, `permissive`) and persistent configuration files.
2. Inspect file security contexts (`user:role:type:level`) and restore default context mappings using `restorecon`.
3. Create permanent file context policy rules using `semanage fcontext`.
4. Label non-standard network service ports using `semanage port`.
5. Audit and persistently toggle SELinux booleans using `getsebool` and `setsebool -P`.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine with Apache (`httpd`) installed.
* Administrative access via `sudo` or the `root` account.
* The `policycoreutils-python-utils` package installed (provides `semanage`).

---

## 🛠️ Scenario

You are deploying a web application on a RHEL 10 server running SELinux in `enforcing` mode. The application requires hosting files out of a non-standard web root directory (`/srv/web`) and listening on a custom TCP port (`8088`). Additionally, web scripts must be granted permission to read user home directories. You must configure persistent SELinux file contexts, update network port labelling policies, and enable required SELinux booleans to ensure service availability without disabling mandatory access controls.

---

## 📝 Lab Tasks

### Task 1: SELinux Execution Mode Management
1. Display the current runtime SELinux mode using `getenforce` and query detailed SELinux status using `sestatus`.
2. Temporarily switch SELinux to `permissive` mode using `setenforce 0`.
3. Verify that `getenforce` reflects `Permissive`.
4. Re-enable `enforcing` mode at runtime using `setenforce 1`.
5. Confirm that `/etc/selinux/config` is configured to `SELINUX=enforcing` for persistent protection across system reboots.

### Task 2: File Context Labelling & Policy Persistence
1. Create a custom web content directory `/srv/web` and an index file `/srv/web/index.html`.
2. Inspect the default security context assigned to `/srv/web/index.html` using `ls -Z`.
3. Temporarily relabel `/srv/web/index.html` to context type `httpd_sys_content_t` using `chcon`.
4. Run `restorecon -vR /srv/web` and observe that `chcon` modifications are reverted because no persistent policy exists.
5. Define a permanent file context rule for `/srv/web` and all nested contents (`/srv/web(/.*)?`) targeting type `httpd_sys_content_t` using `semanage fcontext`.
6. Apply the new policy definition to the filesystem using `restorecon -vFR /srv/web`.

### Task 3: Network Service Port Labelling
1. Install `httpd` if not present and configure Apache to listen on non-standard TCP port `8088` in `/etc/httpd/conf/httpd.conf`.
2. Query active SELinux port rules for HTTP using `semanage port -l | grep http_port_t`.
3. Register TCP port `8088` as a valid `http_port_t` context in the SELinux policy database using `semanage port`.
4. Start the `httpd` service using `systemctl` and confirm that it binds successfully to port `8088`.

### Task 4: SELinux Boolean Management
1. Query the state of the SELinux boolean controlling Apache home directory access (`httpd_enable_homedirs`).
2. Toggle `httpd_enable_homedirs` on persistently (`-P`) using `setsebool`.
3. Verify that the boolean is active (`on`) across service reloads and reboots using `getsebool`.

---

## 🔍 Verification & Self-Test

Run these commands to verify SELinux modes, file contexts, port rules, and booleans:

```bash
# 1. Verify file contexts on custom web directory
ls -dZ /srv/web
ls -Z /srv/web/index.html

# 2. Confirm custom port context binding
semanage port -l | grep 8088

# 3. Check persistent boolean status
getsebool httpd_enable_homedirs
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Mode Management
```bash
# 1. Inspect runtime mode and system status
getenforce
sestatus

# 2. Switch to permissive mode temporarily
sudo setenforce 0
getenforce

# 3. Switch back to enforcing mode
sudo setenforce 1
getenforce

# 4. Verify persistent configuration file
grep "^SELINUX=" /etc/selinux/config
```
Task 2 Solutions: File Context Management
```bash
# 1. Ensure policy utilities are installed
sudo dnf install -y policycoreutils-python-utils httpd

# 2. Create web directory structure
sudo mkdir -p /srv/web
echo "SELINUX Lab Content" | sudo tee /srv/web/index.html

# 3. Inspect default context (likely default_t or unconfined_u)
ls -Z /srv/web/index.html

# 4. Test temporary chcon modification
sudo chcon -t httpd_sys_content_t /srv/web/index.html
ls -Z /srv/web/index.html

# 5. Observe restorecon wiping temporary chcon changes
sudo restorecon -vR /srv/web
ls -Z /srv/web/index.html

# 6. Add permanent context rule to policy database
sudo semanage fcontext -a -t httpd_sys_content_t "/srv/web(/.*)?"

# 7. Apply persistent context recursively
sudo restorecon -vFR /srv/web
ls -Zd /srv/web
ls -Z /srv/web/index.html
```
Task 3 Solutions: Port Labelling
```bash
# 1. Modify HTTP port configuration
sudo sed -i 's/^Listen 80/Listen 8088/' /etc/httpd/conf/httpd.conf

# 2. List existing HTTP port bindings
sudo semanage port -l | grep http_port_t

# 3. Add port 8088 to http_port_t context
sudo semanage port -a -t http_port_t -p tcp 8088

# 4. Verify rule addition
sudo semanage port -l | grep 8088

# 5. Start and verify httpd service
sudo systemctl enable --now httpd
sudo systemctl status httpd
```
Task 4 Solutions: Boolean Management
```bash
# 1. Check current boolean state
getsebool httpd_enable_homedirs

# 2. Enable boolean persistently (-P)
sudo setsebool -P httpd_enable_homedirs on

# 3. Confirm updated state
getsebool httpd_enable_homedirs
```
