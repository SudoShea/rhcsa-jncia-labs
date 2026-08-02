# Lab 02.2: Local DNF Repository Creation & Repo Configuration on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/02-software-management/02-creating-local-repositories.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Create local package directory structures and populate them with RPM packages.
2. Generate repository metadata using `createrepo_c`.
3. Author custom `.repo` files in `/etc/yum.repos.d/` using `file:///` URIs.
4. Manage repository options including `enabled`, `gpgcheck`, `gpgkey`, and priority settings.
5. Mount ISO images persistent across reboots via `/etc/fstab` as local package repositories.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Administrative access via `sudo` or the `root` account.
* A mounted or downloaded RHEL 10 ISO image / RPM package pool.

---

## 🛠️ Scenario

Your team is deploying RHEL 10 servers in an air-gapped environment without external internet access. You are tasked with staging local RPM packages under `/var/custom-repo`, creating valid repository metadata, configuring system-wide `.repo` definitions, and mounting an ISO image as a fallback local package repository.

---

## 📝 Lab Tasks

### Task 1: Staging Packages & Generating Metadata
1. Create a directory named `/var/custom-repo`.
2. Download or copy at least two RPM packages into `/var/custom-repo` (e.g., download packages using `dnf download --destdir=/var/custom-repo zsh wget`).
3. Install `createrepo_c` if not present, and generate repository metadata for `/var/custom-repo`.
4. Verify that the `repodata/` directory was created containing `repomd.xml`.

### Task 2: Creating a Custom Repository File
1. Create a repository configuration file at `/etc/yum.repos.d/custom-local.repo`.
2. Configure the repository with the ID `[custom-local]`, descriptive name `Custom Local Repository`, base URL pointing to `file:///var/custom-repo`, enabled status (`enabled=1`), and disabled GPG checking (`gpgcheck=0`).
3. Clean the DNF cache and verify that `custom-local` appears in `dnf repolist`.
4. Install a package specifically targeting the `custom-local` repository.

### Task 3: ISO Mounting & Persistent Local Repo
1. Create a mount point directory at `/mnt/rhel10-iso`.
2. Mount an available RHEL 10 installation ISO to `/mnt/rhel10-iso` loopback.
3. Configure `/etc/fstab` to ensure the ISO automatically mounts to `/mnt/rhel10-iso` on system boot.
4. Create `/etc/yum.repos.d/rhel10-media.repo` configuring repository entries for the `BaseOS` and `AppStream` directories within the mounted ISO.

---

## 🔍 Verification & Self-Test

Run these commands to verify repository validity:

```bash
# 1. Verify custom repodata files
ls -la /var/custom-repo/repodata/

# 2. Check enabled repositories
sudo dnf repolist

# 3. Test ISO fstab entry
sudo mount -a
ls -la /mnt/rhel10-iso
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Staging & Metadata
```bash
# 1. Create target directory
sudo mkdir -p /var/custom-repo

# 2. Download sample RPM packages without installing
sudo dnf download --destdir=/var/custom-repo zsh wget

# 3. Install createrepo_c and generate metadata
sudo dnf install -y createrepo_c
sudo createrepo_c /var/custom-repo

# 4. Verify repodata structure
ls -la /var/custom-repo/repodata/
```
Task 2 Solutions: Custom `.repo` File
```bash
# 1. Create repo configuration file
sudo cat << 'EOF' | sudo tee /etc/yum.repos.d/custom-local.repo
[custom-local]
name=Custom Local Repository
baseurl=file:///var/custom-repo
enabled=1
gpgcheck=0
EOF

# 2. Clean cache and list repos
sudo dnf clean all
sudo dnf repolist

# 3. Test installation from custom repo
sudo dnf install --disablerepo="*" --enablerepo="custom-local" zsh -y
```
Task 3 Solutions: ISO Mount & Media Repo
```bash
# 1. Create mount directory
sudo mkdir -p /mnt/rhel10-iso

# 2. Mount ISO image (replace <iso_filename> with target ISO path)
sudo mount -o loop /var/lib/libvirt/images/<iso_filename>.iso /mnt/rhel10-iso

# 3. Add persistent entry to /etc/fstab
echo "/var/lib/libvirt/images/<iso_filename>.iso /mnt/rhel10-iso iso9660 loop,ro 0 0" | sudo tee -a /etc/fstab

# 4. Create repo file for ISO BaseOS and AppStream
sudo cat << 'EOF' | sudo tee /etc/yum.repos.d/rhel10-media.repo
[media-baseos]
name=RHEL 10 Media BaseOS
baseurl=file:///mnt/rhel10-iso/BaseOS
enabled=1
gpgcheck=0

[media-appstream]
name=RHEL 10 Media AppStream
baseurl=file:///mnt/rhel10-iso/AppStream
enabled=1
gpgcheck=0
EOF

# 5. Verify repository recognition
sudo dnf repolist
```
