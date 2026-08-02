# Lab 01.4: System Documentation & Key-Based SSH Access on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/01-essential-tools/04-system-documentation-and-ssh.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Search and query system documentation using `man`, `apropos`, and `/usr/share/doc`.
2. Generate SSH keypairs (Ed25519) and configure passwordless authentication.
3. Deploy public keys using `ssh-copy-id`.
4. Create an SSH client configuration file (`~/.ssh/config`) to streamline remote access.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* A standard user account (`<username>`).

---

## 🛠️ Scenario

You are establishing a secure remote administration environment for RHEL 10 servers. You need to use manual pages to determine precise configuration file formats, generate an Ed25519 SSH keypair, deploy the public key to a local loopback account, and configure a client SSH alias.

---

## 📝 Lab Tasks

### Task 1: System Documentation Search
1. Use `apropos` (or `man -k`) to search for manual pages related to `systemd.unit`.
2. Locate the specific manual section for the `/etc/fstab` file format.
3. Find installed package documentation for `sshd` under `/usr/share/doc`.

### Task 2: SSH Key Generation & Deployment
1. Generate an Ed25519 SSH keypair without a passphrase for non-interactive logins.
2. Verify the public and private key files created in `~/.ssh/`.
3. Copy the public key to the local user account on `localhost` using `ssh-copy-id`.
4. Test passwordless SSH connectivity to `localhost`.

### Task 3: SSH Client Configuration
1. Create an SSH client configuration file at `~/.ssh/config`.
2. Define a host alias named `labhost` pointing to `127.0.0.1`, using your current username and specifying the identity file `~/.ssh/id_ed25519`.
3. Set appropriate POSIX permissions on `~/.ssh/config` (`600`).
4. Test connection using `ssh labhost`.

---

## 🔍 Verification & Self-Test

Run these commands to verify your setup:

```bash
# 1. Verify SSH key permissions
ls -la ~/.ssh/

# 2. Verify passwordless SSH via alias
ssh -q labhost "hostname -f"
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Documentation Search
```bash
# 1. Search man pages for keywords
apropos systemd.unit

# 2. View section 5 man page for file formats
man 5 fstab

# 3. Inspect package documentation directory
ls -la /usr/share/doc/openssh*
```
Task 2 Solutions: SSH Key Generation
```bash
# 1. Generate Ed25519 keypair (-t algorithm, -N passphrase, -f file)
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519

# 2. Verify generated files
ls -l ~/.ssh/id_ed25519*

# 3. Copy public key to target user on localhost
ssh-copy-id -i ~/.ssh/id_ed25519.pub $USER@localhost

# 4. Test SSH connection
ssh $USER@localhost "uptime"
```
Task 3 Solutions: SSH Client Configuration
```bash
# 1. Create SSH client configuration file
cat << 'EOF' > ~/.ssh/config
Host labhost
    HostName 127.0.0.1
    User <username>
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking ask
EOF

# 2. Set strict file permissions
chmod 600 ~/.ssh/config

# 3. Test alias connection
ssh labhost
```
