# Lab 05.1: Disk Partitioning, File Systems & Swap Configuration on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/05-local-storage-and-lvm/01-disk-partitioning-filesystems-and-swap.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Inspect block devices and create GPT partition tables using `fdisk` or `gdisk`.
2. Format block partitions with XFS and Ext4 file systems using `mkfs`.
3. Locate unique block device identifiers (UUIDs) using `blkid` and `lsblk`.
4. Configure persistent file system mounts in `/etc/fstab` using UUIDs.
5. Provision, format, activate, and persistently mount dedicated swap partitions.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine with an unformatted secondary block device (e.g. `/dev/vdb` or `/dev/sdb`, referenced as `<device_name>`).
* Administrative access via `sudo` or the `root` account.

---

## 🛠️ Scenario

You are attaching a secondary storage drive to a RHEL 10 server to handle growing database and swap memory requirements. You must initialise a GPT partition table on block device `<device_name>`, create a primary partition formatted as XFS mounted persistently at `/mnt/data`, and configure a 2 GiB swap partition to expand system virtual memory capacity.

---

## 📝 Lab Tasks

### Task 1: Disk Inspection & Partition Creation
1. Identify all available block storage devices and existing partition layouts on the system using `lsblk`.
2. Target the unformatted secondary disk `<device_name>` and create a new GPT partition table using `fdisk` or `gdisk`.
3. Create two partitions on `<device_name>`:
   * **Partition 1 (`<device_name>1`):** Size of `4 GiB`, primary partition type (Linux filesystem).
   * **Partition 2 (`<device_name>2`):** Size of `2 GiB`, partition type set to Linux swap.
4. Save the partition table changes and force the kernel to re-read the partition table using `partprobe`.

### Task 2: File System Formatting & Persistent Mounting
1. Format Partition 1 (`<device_name>1`) with the default RHEL 10 `xfs` file system.
2. Create a mount point directory at `/mnt/data`.
3. Retrieve the unique UUID of `<device_name>1` using `blkid`.
4. Add an entry to `/etc/fstab` to persistently mount `<device_name>1` to `/mnt/data` using its `UUID`, specifying default mount options (`defaults`), file system type `xfs`, and dump/pass values `0 0`.
5. Test the `/etc/fstab` entry by running `mount -a` and verify that the file system is successfully mounted.

### Task 3: Swap Space Formatting, Activation & Persistence
1. Format Partition 2 (`<device_name>2`) as a swap device using `mkswap`.
2. Retrieve the UUID of the newly created swap partition using `blkid`.
3. Add a persistent entry for the swap partition to `/etc/fstab` using its `UUID`, with mount point `none`, type `swap`, options `defaults`, and dump/pass values `0 0`.
4. Activate all configured swap devices using `swapon -a`.
5. Verify that the new swap space is active using `swapon --show` or `free -h`.

---

## 🔍 Verification & Self-Test

Run these commands to verify partition, file system, and swap state:

```bash
# 1. Verify block layout and mount points
lsblk -f /dev/<device_name>

# 2. Confirm active file system mounts
findmnt /mnt/data

# 3. Verify active swap space details
swapon --show
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Disk Inspection & Partitioning
```bash
# 1. Identify storage devices (replace <device_name> with your disk, e.g. vdb or sdb)
lsblk

# 2. Launch fdisk on target block device
sudo fdisk /dev/<device_name>

# Inside the interactive fdisk prompt:
#  a. Type 'g' to create a new empty GPT partition table.
#  b. Type 'n' to add a new partition.
#     - Partition number: 1 (Press Enter for default)
#     - First sector: Press Enter for default
#     - Last sector: +4G
#  c. Type 'n' to add a second partition.
#     - Partition number: 2 (Press Enter for default)
#     - First sector: Press Enter for default
#     - Last sector: +2G
#  d. Type 't' then select partition 2, type '19' (Linux swap).
#  e. Type 'w' to write changes and exit.

# 3. Notify kernel of partition table updates
sudo partprobe /dev/<device_name>
```
Task 2 Solutions: File System Formatting & Persistent Mounting
```bash
# 1. Format partition 1 with XFS
sudo mkfs.xfs /dev/<device_name>1

# 2. Create mount directory
sudo mkdir -p /mnt/data

# 3. Get UUID for partition 1
FS_UUID=$(sudo blkid -s UUID -o value /dev/<device_name>1)
echo "Partition 1 UUID: ${FS_UUID}"

# 4. Append persistent mount record to /etc/fstab
sudo cat << EOF | sudo tee -a /etc/fstab
UUID=${FS_UUID} /mnt/data xfs defaults 0 0
EOF

# 5. Test persistent mount configuration
sudo mount -a
findmnt /mnt/data
```
Task 3 Solutions: Swap Space Formatting & Activation
```bash
# 1. Format partition 2 as swap
sudo mkswap /dev/<device_name>2

# 2. Get UUID for swap partition
SWAP_UUID=$(sudo blkid -s UUID -o value /dev/<device_name>2)
echo "Swap Partition UUID: ${SWAP_UUID}"

# 3. Append persistent swap record to /etc/fstab
sudo cat << EOF | sudo tee -a /etc/fstab
UUID=${SWAP_UUID} none swap defaults 0 0
EOF

# 4. Activate swap space
sudo swapon -a

# 5. Verify active swap allocation
swapon --show
free -h
```
