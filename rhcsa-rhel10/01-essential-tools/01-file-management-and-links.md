# Lab 01.1: File Management, Navigation & Link Creation on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/01-essential-tools/01-file-management-and-links.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Navigate the RHEL 10 directory tree using absolute and relative paths.
2. Perform file and directory CRUD operations (`mkdir`, `cp`, `mv`, `rm`).
3. Create, inspect, and differentiate between hard links and symbolic (soft) links.
4. Verify inode numbers and link counts to understand filesystem index mechanics.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Basic command-line access via an unprivileged user account.

---

## 🛠️ Scenario

You are configuring a workspace for log archiving and system diagnostic tooling. You need to create a structured directory hierarchy under `/tmp/lab-workspace`, populate it with test data, and establish shortcuts (symbolic links) and immutable references (hard links) to critical configuration files.

---

## 📝 Lab Tasks

### Task 1: Directory Tree Creation & File Manipulation
1. Create a directory structure in `/tmp` named `/tmp/lab-workspace/logs/app` and `/tmp/lab-workspace/backups` in a single command.
2. Create an empty file named `server.log` inside `/tmp/lab-workspace/logs/app/`.
3. Copy `server.log` to `/tmp/lab-workspace/backups/server.log.bak`.
4. Move `/tmp/lab-workspace/backups/server.log.bak` to `/tmp/lab-workspace/backups/server.log.old`.

### Task 2: Hard Link Creation & Inode Inspection
1. Create a file named `/tmp/lab-workspace/original.txt` containing the string `RHCSA RHEL 10 Essential Tools`.
2. Create a hard link named `/tmp/lab-workspace/hardlink.txt` pointing to `/tmp/lab-workspace/original.txt`.
3. Inspect the inode numbers and link counts of both files using `ls -l` and `ls -i`.
4. Append text to `/tmp/lab-workspace/hardlink.txt` and verify that `/tmp/lab-workspace/original.txt` reflects the change.
5. Delete `/tmp/lab-workspace/original.txt` and verify that the content remains accessible via `/tmp/lab-workspace/hardlink.txt`.

### Task 3: Symbolic Link Creation & Broken Link Behavior
1. Create a directory `/tmp/lab-workspace/data`.
2. Create a symbolic (soft) link named `/tmp/lab-workspace/data-link` that points to `/tmp/lab-workspace/data`.
3. Verify the link permissions and target path using `ls -l`.
4. Remove the target directory `/tmp/lab-workspace/data` and observe the state of `/tmp/lab-workspace/data-link` (broken link behavior).

---

## 🔍 Verification & Self-Test

Run these commands to verify your work:

```bash
# 1. Verify hard link persistence and inode inspection
ls -i /tmp/lab-workspace/hardlink.txt

# 2. Verify symbolic link target
ls -l /tmp/lab-workspace/data-link
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Directory Creation & File Manipulation
```bash
# 1. Create nested directory structure
mkdir -p /tmp/lab-workspace/logs/app /tmp/lab-workspace/backups

# 2. Create empty file
touch /tmp/lab-workspace/logs/app/server.log

# 3. Copy file
cp /tmp/lab-workspace/logs/app/server.log /tmp/lab-workspace/backups/server.log.bak

# 4. Move/Rename file
mv /tmp/lab-workspace/backups/server.log.bak /tmp/lab-workspace/backups/server.log.old
```
Task 2 Solutions: Hardlink Creation & Inode Inspection
```
# 1. Create base file with content
echo "RHCSA RHEL 10 Essential Tools" > /tmp/lab-workspace/original.txt

# 2. Create hard link
ln /tmp/lab-workspace/original.txt /tmp/lab-workspace/hardlink.txt

# 3. Inspect inodes and link count (link count should be 2)
ls -li /tmp/lab-workspace/*.txt

# 4. Modify via hard link and verify
echo "Appended line" >> /tmp/lab-workspace/hardlink.txt
cat /tmp/lab-workspace/original.txt

# 5. Remove original and verify link survival
rm /tmp/lab-workspace/original.txt
cat /tmp/lab-workspace/hardlink.txt
ls -li /tmp/lab-workspace/hardlink.txt  # Link count drops back to 1
```
Task 3 Solutions: Symbolic Link Creation
```bash
# 1. Create target directory
mkdir /tmp/lab-workspace/data

# 2. Create soft link
ln -s /tmp/lab-workspace/data /tmp/lab-workspace/data-link

# 3. Verify soft link
ls -l /tmp/lab-workspace/data-link

# 4. Remove target directory and observe broken symlink
rmdir /tmp/lab-workspace/data
ls -l /tmp/lab-workspace/data-link  # Target highlighted red/broken in terminal
```
