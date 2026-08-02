# Lab 01.3: Archiving & Compression Utilities on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/01-essential-tools/03-archiving-and-compression.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Create, list, and extract uncompressed `tar` archives.
2. Build compressed archives using `gzip` (`.tar.gz`), `bzip2` (`.tar.bz2`), and `xz` (`.tar.xz`).
3. Extract archive contents to specific target directories without altering original path structures.
4. Compare compression ratios and performance across compression algorithms.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Standard user account access with `sudo` privileges.

---

## 🛠️ Scenario

You are tasked with backing up system configuration directories (`/etc`) and log directories (`/var/log`) for offline storage. You must create compressed archives using various compression formats, verify archive integrity, and test targeted restorations into isolation directories.

---

## 📝 Lab Tasks

### Task 1: `gzip` & `tar` Archive Creation
1. Create an uncompressed tar archive named `/tmp/etc-backup.tar` containing the contents of `/etc/sysconfig`.
2. List the contents of `/tmp/etc-backup.tar` without extracting it.
3. Create a `gzip`-compressed archive named `/tmp/etc-backup.tar.gz` containing `/etc/sysconfig`.

### Task 2: Multi-Format Compression (`bzip2` & `xz`)
1. Create a `bzip2`-compressed archive named `/tmp/log-backup.tar.bz2` containing `/var/log`.
2. Create an `xz`-compressed archive named `/tmp/log-backup.tar.xz` containing `/var/log`.
3. Compare the file sizes of the generated archives in `/tmp` using `ls -lh`.

### Task 3: Selective & Targeted Archive Extraction
1. Create an extraction target directory named `/tmp/restore-test`.
2. Extract `/tmp/etc-backup.tar.gz` into `/tmp/restore-test` using the `-C` target option.
3. Verify that the files were correctly restored into `/tmp/restore-test/etc/sysconfig`.

---

## 🔍 Verification & Self-Test

Run these commands to verify archive integrity:

```bash
# 1. Test xz archive integrity
tar -tvf /tmp/log-backup.tar.xz | head -n 5

# 2. Check extracted directory contents
ls -l /tmp/restore-test/etc/sysconfig
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Archive Creation
```bash
# 1. Create uncompressed tar archive (c = create, f = file)
tar -cf /tmp/etc-backup.tar /etc/sysconfig

# 2. List archive contents (t = list)
tar -tf /tmp/etc-backup.tar

# 3. Create gzip compressed archive (z = gzip)
tar -czf /tmp/etc-backup.tar.gz /etc/sysconfig
```
Task 2 Solutions: Multiformat Compression
```bash
# 1. Create bzip2 compressed archive (j = bzip2)
sudo tar -cjf /tmp/log-backup.tar.bz2 /var/log

# 2. Create xz compressed archive (J = xz)
sudo tar -cJf /tmp/log-backup.tar.xz /var/log

# 3. Compare archive sizes
ls -lh /tmp/*.tar*
```
Task 3 Solutions: Archive Extraction
```bash
# 1. Create target directory
mkdir -p /tmp/restore-test

# 2. Extract archive into target directory (x = extract, C = directory)
tar -xzf /tmp/etc-backup.tar.gz -C /tmp/restore-test

# 3. Verify extracted path structure
ls -la /tmp/restore-test/etc/sysconfig
```
