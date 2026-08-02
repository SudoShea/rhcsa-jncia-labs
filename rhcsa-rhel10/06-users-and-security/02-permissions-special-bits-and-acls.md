# Lab 06.2: File Permissions, Special Bits & POSIX ACLs on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/06-users-and-security/02-permissions-special-bits-and-acls.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Manage standard POSIX file and directory ownership (`chown`, `chgrp`) and access permissions (`chmod`).
2. Configure default file creation permissions using shell `umask` values.
3. Apply special permission bits: Set User ID (SUID), Set Group ID (SGID) for shared directory collaboration, and the Sticky Bit.
4. Configure and audit POSIX Access Control Lists (ACLs) using `getfacl` and `setfacl`, including default directory ACL inheritance rules.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Administrative access via `sudo` or the `root` account.
* Two test user accounts (`<username_1>` and `<username_2>`) and a shared group (`<group_name>`).

---

## 🛠️ Scenario

You are securing shared directory structures on a RHEL 10 file server. You must configure standard POSIX permissions for departmental storage, ensure new files created inside a collaborative directory automatically inherit the group ownership of the parent directory (SGID), protect public upload directories against unauthorized deletion (Sticky Bit), and grant granular access permissions to specific audit users without altering base group memberships using POSIX ACLs.

---

## 📝 Lab Tasks

### Task 1: Standard POSIX Permissions & umask Management
1. Create a directory named `/srv/finance`.
2. Set directory user ownership to `root` and group ownership to `<group_name>`.
3. Set base permissions on `/srv/finance` so that the owning user and group have full read, write, and execute permissions (`rwx`), while all other users have no access (`---`).
4. Temporarily set the session `umask` to `0027`.
5. Create a file `/srv/finance/test-file.txt` and verify that its default permissions reflect `0640` (`rw-r-----`).

### Task 2: Special Permission Bits (SGID & Sticky Bit)
1. Create a collaborative directory named `/srv/projects`.
2. Set group ownership of `/srv/projects` to `<group_name>` and apply permissions so group members have full access (`rwx`).
3. Apply the Set Group ID (**SGID**) bit to `/srv/projects` so that any file or directory created inside automatically inherits group ownership as `<group_name>`.
4. Create a public drop directory named `/srv/public_drop` with full access for all users (`777`).
5. Apply the **Sticky Bit** to `/srv/public_drop` so users can only delete or rename files that they personally own.

### Task 3: POSIX Access Control Lists (ACLs) & Default Rules
1. Display the current access control lists for `/srv/finance` using `getfacl`.
2. Grant explicit read, write, and execute ACL permissions (`rwx`) to user `<username_1>` on `/srv/finance`.
3. Grant explicit read and execute ACL permissions (`r-x`) to user `<username_2>` on `/srv/finance`.
4. Configure default ACLs on `/srv/finance` so that any future subdirectories or files created inside automatically inherit read-write access (`rw-`) for `<username_1>`.
5. Verify applied explicit and default ACLs using `getfacl`.

---

## 🔍 Verification & Self-Test

Run these commands to verify permission states, special bits, and ACL rules:

```bash
# 1. Verify SGID and Sticky Bit directory permissions
ls -ld /srv/projects /srv/public_drop

# 2. Verify POSIX ACL rules and default inheritance on target directory
getfacl /srv/finance
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Standard Permissions & umask
```bash
# 1. Create target directory
sudo mkdir -p /srv/finance

# 2. Set user and group ownership
sudo chown root:<group_name> /srv/finance

# 3. Set standard octal permissions 770 (rwxrwx---)
sudo chmod 770 /srv/finance

# 4. Set session umask
umask 0027

# 5. Create test file and inspect permissions
touch /srv/finance/test-file.txt
ls -l /srv/finance/test-file.txt
```
Task 2 Solutions: Special Permission Bits
```bash
# 1. Create collaborative directory
sudo mkdir -p /srv/projects
sudo chown root:<group_name> /srv/projects
sudo chmod 770 /srv/projects

# 2. Apply SGID bit (octal 2770 or symbolic g+s)
sudo chmod g+s /srv/projects
# OR: sudo chmod 2770 /srv/projects

# 3. Verify 's' in group execution field
ls -ld /srv/projects

# 4. Create public drop directory
sudo mkdir -p /srv/public_drop
sudo chmod 777 /srv/public_drop

# 5. Apply Sticky Bit (octal 1777 or symbolic o+t)
sudo chmod +t /srv/public_drop
# OR: sudo chmod 1777 /srv/public_drop

# 6. Verify 't' in other execution field
ls -ld /srv/public_drop
```
Task 3 Solutions: POSIX ACLs
```bash
# 1. Inspect existing ACL rules
getfacl /srv/finance

# 2. Assign explicit RWX permission to user_1
sudo setfacl -m u:<username_1>:rwx /srv/finance

# 3. Assign explicit R-X permission to user_2
sudo setfacl -m u:<username_2>:r-x /srv/finance

# 4. Set default ACL inheritance for future contents (-d)
sudo setfacl -d -m u:<username_1>:rw- /srv/finance

# 5. Verify active and default ACL rules
getfacl /srv/finance
```
