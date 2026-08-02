# Lab 05.4: NFS Share Persistent Mounting & Automated autofs on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `05-local-storage-and-lvm/04-nfs-mounts-and-autofs.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Discover remote Network File System (NFS) exports using `showmount`.
2. Mount remote NFS shares manually and persistently via `/etc/fstab` with mandatory network dependency options (`_netdev`).
3. Deploy and configure the `autofs` service for dynamic, on-demand file system automounting.
4. Author direct and indirect `autofs` map configuration files to automate network storage mounts.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine with network reachability to an NFS storage server (`<nfs_server_ip>`).
* Administrative access via `sudo` or the `root` account.

---

## 🛠️ Scenario

Your team is connecting a RHEL 10 server to central NAS storage (`<nfs_server_ip>`). You must discover remote exports, mount a public dataset persistently at `/mnt/nfs_data`, and configure `autofs` to dynamically mount individual team directories on-demand under `/mnt/shares/work` whenever users navigate into the target mount path.

---

## 📝 Lab Tasks

### Task 1: Remote NFS Discovery & Manual Mounting
1. Install the `nfs-utils` package using DNF.
2. Discover available remote NFS exports from target server `<nfs_server_ip>` using `showmount -e <nfs_server_ip>`.
3. Create a local mount point directory at `/mnt/nfs_data`.
4. Mount the remote NFS export `<nfs_server_ip>:/exports/data` manually to `/mnt/nfs_data` specifying `nfs` file system type.
5. Verify active mount status and write access using `findmnt /mnt/nfs_data`.

### Task 2: Persistent NFS Mount Configuration in `/etc/fstab`
1. Unmount the manual share using `umount /mnt/nfs_data`.
2. Append a persistent entry to `/etc/fstab` to mount `<nfs_server_ip>:/exports/data` to `/mnt/nfs_data`.
3. Include standard mount options: `defaults,_netdev` (where `_netdev` delays mounting until network services are active during system boot).
4. Test the configuration by executing `mount -a` and verifying mount state with `df -h /mnt/nfs_data`.

### Task 3: Automated On-Demand Storage with `autofs`
1. Install the `autofs` package and ensure the `autofs` service is enabled and running using `systemctl`.
2. Configure a direct automount map for `/mnt/direct_share`:
   * Create a master map drop-in file `/etc/auto.master.d/direct.autofs` containing:
     ```
     /-  /etc/auto.direct
     ```
   * Create map file `/etc/auto.direct` containing:
     ```
     /mnt/direct_share  -rw,sync  <nfs_server_ip>:/exports/direct
     ```
3. Configure an indirect automount map under `/mnt/shares`:
   * Create a master map drop-in file `/etc/auto.master.d/indirect.autofs` containing:
     ```
     /mnt/shares  /etc/auto.indirect  --timeout=300
     ```
   * Create map file `/etc/auto.indirect` containing:
     ```
     work  -rw,sync  <nfs_server_ip>:/exports/work
     ```
4. Reload the `autofs` daemon (`systemctl reload autofs`).
5. Verify automount behaviour by triggering directory traversal (`cd /mnt/shares/work` or `ls /mnt/direct_share`) and confirming dynamic filesystem binding via `findmnt`.

---

## 🔍 Verification & Self-Test

Run these commands to verify active NFS mounts and automount maps:

```bash
# 1. Verify persistent fstab NFS mount
findmnt /mnt/nfs_data

# 2. Test autofs dynamic mount trigger
ls -la /mnt/shares/work
findmnt /mnt/shares/work
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Discovery & Manual Mounting
```bash
# 1. Install NFS client tools
sudo dnf install -y nfs-utils

# 2. Discover exports on remote server
showmount -e <nfs_server_ip>

# 3. Create mount point
sudo mkdir -p /mnt/nfs_data

# 4. Mount remote share manually
sudo mount -t nfs <nfs_server_ip>:/exports/data /mnt/nfs_data

# 5. Verify mount
findmnt /mnt/nfs_data
```
Task 2 Solutions: Persistent /etc/fstab Mounting
```bash
# 1. Unmount manual mount
sudo umount /mnt/nfs_data

# 2. Add persistent entry to /etc/fstab
sudo cat << EOF | sudo tee -a /etc/fstab
<nfs_server_ip>:/exports/data /mnt/nfs_data nfs defaults,_netdev 0 0
EOF

# 3. Test fstab execution
sudo mount -a
df -h /mnt/nfs_data
```
Task 3 Solutions: Autofs Configuration
```bash
# 1. Install autofs
sudo dnf install -y autofs
sudo systemctl enable --now autofs

# 2. Configure Direct Automount Map
sudo cat << 'EOF' | sudo tee /etc/auto.master.d/direct.autofs
/-  /etc/auto.direct
EOF

sudo cat << EOF | sudo tee /etc/auto.direct
/mnt/direct_share -rw,sync <nfs_server_ip>:/exports/direct
EOF

# 3. Configure Indirect Automount Map
sudo cat << 'EOF' | sudo tee /etc/auto.master.d/indirect.autofs
/mnt/shares /etc/auto.indirect --timeout=300
EOF

sudo cat << EOF | sudo tee /etc/auto.indirect
work -rw,sync <nfs_server_ip>:/exports/work
EOF

# 4. Reload autofs service
sudo systemctl reload autofs

# 5. Trigger automount and verify
ls -la /mnt/direct_share
ls -la /mnt/shares/work
findmnt | grep nfs
```
