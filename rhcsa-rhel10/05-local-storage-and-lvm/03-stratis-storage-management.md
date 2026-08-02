# Lab 05.3: Stratis Local Storage Management on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/05-local-storage-and-lvm/03-stratis-storage-management.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Install and manage the Stratis daemon (`stratisd`) and management CLI (`stratis-cli`).
2. Create, inspect, and expand Stratis storage pools using block devices.
3. Provision thin-provisioned Stratis file systems within storage pools.
4. Configure persistent mounts in `/etc/fstab` with mandatory `systemd` service dependencies (`x-systemd.requires=stratisd.service`).
5. Create and manage point-in-time Stratis file system snapshots for recovery.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine with two unformatted block storage devices or partitions (e.g. `/dev/<device_name1>` and `/dev/<device_name2>`).
* Administrative access via `sudo` or the `root` account.

---

## 🛠️ Scenario

You are modernising local storage management on a RHEL 10 workstation server. You must deploy Stratis to simplify thin-provisioning and storage pooling. You are required to create a initial storage pool using `/dev/<device_name1>`, provision a thin file system for data storage, configure a persistent mount point at `/mnt/stratis-app`, expand the pool dynamically using `/dev/<device_name2>`, and create a point-in-time snapshot before performing maintenance.

---

## 📝 Lab Tasks

### Task 1: Daemon Installation & Storage Pool Creation
1. Install the `stratisd` service and `stratis-cli` package using DNF.
2. Enable and start the `stratisd` daemon using `systemctl`.
3. Initialise a new Stratis pool named `pool_app` using the primary block device `/dev/<device_name1>`.
4. Inspect the newly created pool, verifying total capacity, used space, and associated block devices using `stratis pool list` and `stratis blockdev list`.

### Task 2: File System Provisioning & Persistent Mounting
1. Create a Stratis file system named `fs_finance` inside the `pool_app` storage pool.
2. Inspect the file system details using `stratis filesystem list`.
3. Create a mount point directory at `/mnt/stratis-app`.
4. Retrieve the file system UUID using `blkid` or `stratis filesystem list`.
5. Add a persistent entry to `/etc/fstab` to mount `fs_finance` at `/mnt/stratis-app`. Ensure you specify the `xfs` file system type and append the `x-systemd.requires=stratisd.service` mount option to delay mounting until `stratisd` starts during boot.
6. Test mount execution using `mount -a` and verify the active mount point.

### Task 3: Pool Expansion & Snapshot Management
1. Dynamically expand `pool_app` by adding the secondary block device `/dev/<device_name2>` using `stratis pool add-data`.
2. Confirm that the total storage pool capacity has increased.
3. Create a point-in-time snapshot of `fs_finance` named `fs_finance_snap` inside `pool_app`.
4. Create a mount directory at `/mnt/stratis-snap` and manually mount the snapshot to verify data accessibility.

---

## 🔍 Verification & Self-Test

Run these commands to verify your Stratis daemon, pool, and file system states:

```bash
# 1. Verify stratisd service health
systemctl is-active stratisd

# 2. Display pool and block device allocations
stratis pool list
stratis blockdev list

# 3. Confirm active file systems and snapshots
stratis filesystem list
findmnt /mnt/stratis-app
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Installation & Pool Creation
```bash
# 1. Install Stratis management tools
sudo dnf install -y stratisd stratis-cli

# 2. Enable and start daemon
sudo systemctl enable --now stratisd

# 3. Create storage pool
sudo stratis pool create pool_app /dev/<device_name1>

# 4. List active pools and block devices
sudo stratis pool list
sudo stratis blockdev list
```
Task 2 Solutions: File System & Persistent Mounting
```bash
# 1. Create Stratis file system
sudo stratis filesystem create pool_app fs_finance

# 2. Inspect created file system
sudo stratis filesystem list

# 3. Create target mount directory
sudo mkdir -p /mnt/stratis-app

# 4. Extract UUID for the new Stratis file system
FS_UUID=$(sudo stratis filesystem list pool_app | awk '/fs_finance/ {print $3}')
echo "Stratis FS UUID: ${FS_UUID}"

# 5. Add persistent entry to /etc/fstab with systemd dependency
sudo cat << EOF | sudo tee -a /etc/fstab
UUID=${FS_UUID} /mnt/stratis-app xfs defaults,x-systemd.requires=stratisd.service 0 0
EOF

# 6. Test fstab mounting
sudo mount -a
findmnt /mnt/stratis-app
```
Task 3 Solutions: Pool Expansion & Snapshots
```bash
# 1. Add additional block device to pool
sudo stratis pool add-data pool_app /dev/<device_name2>

# 2. Verify increased pool size
sudo stratis pool list

# 3. Create point-in-time snapshot
sudo stratis filesystem snapshot pool_app fs_finance fs_finance_snap

# 4. Verify snapshot listing
sudo stratis filesystem list pool_app

# 5. Mount snapshot for verification
sudo mkdir -p /mnt/stratis-snap
sudo mount /stratis/pool_app/fs_finance_snap /mnt/stratis-snap
ls -la /mnt/stratis-snap
```
