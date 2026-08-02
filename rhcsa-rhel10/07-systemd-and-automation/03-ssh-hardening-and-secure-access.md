# Lab 07.3: SSH Service Hardening & Secure Access Controls on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/07-systemd-and-network-services/03-ssh-hardening-and-secure-access.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Harden OpenSSH daemon (`sshd`) configurations using modular drop-in files in `/etc/ssh/sshd_config.d/`.
2. Disable direct `root` SSH logins and force key-based authentication (`PasswordAuthentication no`).
3. Restrict remote access using `AllowUsers` and `AllowGroups` directives.
4. Validate `sshd` configuration syntax using `sshd -t` and enforce strict POSIX permissions on SSH configuration files.
5. Audit and verify hardened SSH authentication controls against compliance requirements.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Administrative access via `sudo` or the `root` account.
* A standard user account (`<username>`) configured with SSH public key access.

---

## 🛠️ Scenario

You are securing a production RHEL 10 server against brute-force attacks and unauthorised remote access attempts. You must harden the OpenSSH server configuration by creating a dedicated drop-in file under `/etc/ssh/sshd_config.d/`. Corporate security policy mandates that direct `root` logins must be disabled, password-based authentication must be turned off in favour of mandatory SSH keys, idle sessions must time out automatically, and remote access must be restricted exclusively to members of the `sysadmins` group.

---

## 📝 Lab Tasks

### Task 1: SSH Key Verification & File Permission Auditing
1. Log in as `<username>` and verify that an Ed25519 key pair exists in `~/.ssh/`.
2. Enforce strict POSIX permissions on the user's SSH directory and authorization files:
   * `~/.ssh` directory permissions set to `700` (`drwx------`).
   * `~/.ssh/authorized_keys` file permissions set to `600` (`-rw-------`).
3. Verify passwordless SSH connectivity from a client workstation to `<username>@<server_ip>`.

### Task 2: Hardening OpenSSH via Drop-In Configuration
1. Create a drop-in configuration file named `/etc/ssh/sshd_config.d/50-hardening.conf`.
2. Configure the following security directives inside `/etc/ssh/sshd_config.d/50-hardening.conf`:
   * **Disable Direct Root Login:** `PermitRootLogin no`
   * **Disable Password Authentication:** `PasswordAuthentication no`
   * **Disable Empty Passwords:** `PermitEmptyPasswords no`
   * **Restrict Access to Group:** `AllowGroups sysadmins`
   * **Configure Session Idle Timeout:** `ClientAliveInterval 300` and `ClientAliveCountMax 2` (disconnects idle sessions after 10 minutes)
3. Set strict file permissions on `/etc/ssh/sshd_config.d/50-hardening.conf` (`600` owned by `root:root`).
4. Validate the syntax of all SSH configuration files using `sshd -t`.
5. Reload the `sshd` service using `systemctl` to apply the changes without dropping active sessions.

### Task 3: Access Control Validation & Auditing
1. Attempt a direct SSH login as `root` (`ssh root@<server_ip>`) and confirm that access is denied regardless of authentication method.
2. Ensure `<username>` is a member of the `sysadmins` group and test successful key-based authentication (`ssh <username>@<server_ip>`).
3. Create a test user account (`<test_user>`) that is **not** a member of the `sysadmins` group.
4. Attempt SSH access as `<test_user>` and confirm that access is rejected by OpenSSH due to the `AllowGroups` restriction.
5. Inspect `/var/log/secure` or `journalctl -u sshd` to verify log messages generated during blocked connection attempts.

---

## 🔍 Verification & Self-Test

Run these commands to verify SSH configuration syntax and active runtime options:

```bash
# 1. Validate SSH daemon configuration syntax
sudo sshd -t

# 2. Query active runtime SSH configuration parameters
sudo sshd -T | grep -E "(permitrootlogin|passwordauthentication|allowgroups)"

# 3. Verify sshd unit status
systemctl status sshd
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: SSH Key Verification & Permissions
```bash
# 1. Generate SSH keypair if not present
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519

# 2. Set strict file permissions on SSH key store
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# 3. Confirm permissions
ls -ld ~/.ssh
ls -l ~/.ssh/authorized_keys
```
Task 2 Solutions: Hardening OpenSSH Configuration
```bash
# 1. Ensure sysadmins group exists
sudo groupadd -g 2000 sysadmins 2>/dev/null || true

# 2. Create modular drop-in hardening file
sudo cat << 'EOF' | sudo tee /etc/ssh/sshd_config.d/50-hardening.conf
# OpenSSH Hardening Policy
PermitRootLogin no
PasswordAuthentication no
PermitEmptyPasswords no
AllowGroups sysadmins
ClientAliveInterval 300
ClientAliveCountMax 2
EOF

# 3. Set strict permissions on configuration drop-in file
sudo chmod 600 /etc/ssh/sshd_config.d/50-hardening.conf
sudo chown root:root /etc/ssh/sshd_config.d/50-hardening.conf

# 4. Test SSH configuration syntax for errors
sudo sshd -t

# 5. Reload sshd service to apply configuration dynamically
sudo systemctl reload sshd
```
Task 3 Solutions: Access Control Validation
```bash
# 1. Add target user to sysadmins group
sudo usermod -aG sysadmins <username>

# 2. Verify runtime config reflects hardening policies
sudo sshd -T | grep -i "permitrootlogin"
# Output: permitrootlogin no

sudo sshd -T | grep -i "passwordauthentication"
# Output: passwordauthentication no

sudo sshd -T | grep -i "allowgroups"
# Output: allowgroups sysadmins

# 3. Create unprivileged test user outside sysadmins group
sudo useradd <test_user>

# 4. Attempt SSH connection as root (Must fail)
ssh root@<server_ip>

# 5. Attempt SSH connection as test user outside sysadmins group (Must fail)
ssh <test_user>@<server_ip>

# 6. Audit blocked connection attempts in system log
sudo journalctl -u sshd --since "10 min ago" | grep -i "user"
```
