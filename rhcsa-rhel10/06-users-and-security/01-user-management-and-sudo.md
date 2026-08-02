# Lab 06.1: User Management, Password Aging & Sudo Delegation on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/06-users-and-security/01-user-management-and-sudo.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Create and manage system users and local groups with specific UID/GID and shell properties.
2. Modify user account parameters, primary groups, and supplementary group memberships using `usermod`.
3. Configure password expiration policies, minimum/maximum age, and account lockouts using `chage`.
4. Delegate selective administrative privileges safely using drop-in files in `/etc/sudoers.d/` validated via `visudo`.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Administrative access via `sudo` or the `root` account.

---

## 🛠️ Scenario

You are onboarded as a security administrator for a RHEL 10 environment. You need to establish user accounts for an engineering team, assign primary and supplementary group memberships, enforce corporate password aging compliance, and delegate limited `sudo` privileges to allow specific administrative tasks without granting full root access.

---

## 📝 Lab Tasks

### Task 1: User & Group Creation
1. Create a system group named `sysadmins` with GID `2000`.
2. Create a system user named `<username_1>` with UID `2000`, primary group `sysadmins`, and default login shell `/bin/bash`.
3. Create a secondary system user named `<username_2>` with default parameters.
4. Create a supplementary group named `developers` and add both `<username_1>` and `<username_2>` to `developers` without overwriting existing supplementary group memberships.

### Task 2: Password Aging & Account Lifecycle
1. Set an initial password for user `<username_1>`.
2. Inspect the password aging parameters for `<username_1>` using `chage -l`.
3. Configure password policy requirements for `<username_1>`:
   * Maximum password age (`-M`): **90 days**.
   * Minimum password age (`-m`): **7 days**.
   * Password expiration warning (`-W`): **14 days**.
4. Set an absolute account expiration date (`-E`) for `<username_2>` set to **2028-12-31**.

### Task 3: Sudo Delegation & Drop-in Configuration
1. Create a drop-in sudoers rule file named `/etc/sudoers.d/sysadmins-rules`.
2. Grant members of the `sysadmins` group permission to execute `/usr/bin/systemctl` and `/usr/bin/dnf` as `root` without prompting for a password (`NOPASSWD`).
3. Set strict file permissions (`0440`) on `/etc/sudoers.d/sysadmins-rules`.
4. Validate the syntax of all sudoers configuration files using `visudo -c`.
5. Test rule enforcement by executing `sudo -l -U <username_1>` to verify delegated privileges.

---

## 🔍 Verification & Self-Test

Run these commands to verify account settings, aging rules, and sudo privileges:

```bash
# 1. Verify user IDs and group memberships
id <username_1>
id <username_2>

# 2. Inspect user password aging details
chage -l <username_1>

# 3. Test sudo privileges for user
sudo -l -U <username_1>
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: User & Group Creation
```bash
# 1. Create group sysadmins with GID 2000
sudo groupadd -g 2000 sysadmins

# 2. Create user with specific UID, primary group, and shell
sudo useradd -u 2000 -g sysadmins -s /bin/bash <username_1>

# 3. Create secondary user
sudo useradd <username_2>

# 4. Create supplementary group developers
sudo groupadd developers

# 5. Add users to supplementary group (-aG appends group membership)
sudo usermod -aG developers <username_1>
sudo usermod -aG developers <username_2>

# 6. Verify memberships
id <username_1>
id <username_2>
```
Task 2 Solutions: Password Aging
```bash
# 1. Set user password
sudo passwd <username_1>

# 2. Inspect initial aging status
sudo chage -l <username_1>

# 3. Apply password aging limits
sudo chage -M 90 -m 7 -W 14 <username_1>

# 4. Set account expiration date for secondary user
sudo chage -E 2028-12-31 <username_2>

# 5. Confirm updated policy settings
sudo chage -l <username_1>
sudo chage -l <username_2>
```
Task 3 Solutions: Sudo Delegation
```bash
# 1. Create drop-in sudoers configuration file
sudo cat << 'EOF' | sudo tee /etc/sudoers.d/sysadmins-rules
%sysadmins ALL=(ALL) NOPASSWD: /usr/bin/systemctl, /usr/bin/dnf
EOF

# 2. Set mandatory strict permissions
sudo chmod 0440 /etc/sudoers.d/sysadmins-rules

# 3. Validate sudoers syntax across all files
sudo visudo -c

# 4. Verify user's sudo capabilities
sudo -l -U <username_1>
```
