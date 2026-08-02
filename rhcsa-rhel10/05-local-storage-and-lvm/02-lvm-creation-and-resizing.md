# Lab 05.2: Logical Volume Manager (LVM) Creation & Dynamic Resizing on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/05-local-storage-and-lvm/02-lvm-creation-and-resizing.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Initialise storage devices as LVM Physical Volumes (PVs) using `pvcreate`.
2. Group physical storage into Volume Groups (VGs) using `vgcreate` and extend existing VGs using `vgextend`.
3. Provision flexible Logical Volumes (LVs) using `lvcreate`.
4. Dynamically extend LVs and grow underlying XFS and Ext4 file systems online using `lvextend` with `-r` (`--resizefs`).
5. Query LVM components using `pvs`, `vgs`, `lvs`, `pvdisplay`, `vgdisplay`, and `lvdisplay`.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine with an available block storage device or unused partitions (e.g. `/dev/<device_name>1` and `/dev/<device_name>2`).
* Administrative access via `sudo` or the `root` account.

---

## 🛠️ Scenario

Your database host requires flexible storage that can scale on demand without interrupting application uptime. You are tasked with initialising physical storage partitions, aggregating them into a volume group named `vg_database`, provisioning an initial 2 GiB logical volume named `lv_data`, and mounting it persistently at `/mnt/database`. Later, as application traffic increases, you must extend the volume group and grow the logical volume online to double its original storage capacity.

---

## 📝 Lab Tasks

### Task 1: Physical Volume & Volume Group Initialisation
1. Inspect available block partitions and verify their current LVM metadata state using `pvs`.
2. Initialise two unformatted partitions (e.g. `/dev/<device_name>1` and `/dev/<device_name>2`) as LVM Physical Volumes using `pvcreate`.
3. Create a new Volume Group named `vg_database` using only the first physical volume (`/dev/<device_name>1`).
4. Display the physical extents (PE) size and total free space available in `vg_database` using `vgdisplay`.

### Task 2: Logical Volume Provisioning & Persistent Mounting
1. Create a Logical Volume named `lv_data` with a fixed size of `2 GiB` inside the `vg_database` volume group.
2. Format the newly created logical volume (`/dev/vg_database/lv_data`) with the default `xfs` file system.
3. Create a mount point directory at `/mnt/database`.
4. Obtain the UUID of `/dev/vg_database/lv_data` using `blkid` and configure a persistent entry in `/etc/fstab`.
5. Mount the file system using `mount -a` and verify the mounted capacity using `df -h /mnt/database`.

### Task 3: Volume Group Extension & Online File System Expansion
1. Extend the capacity of `vg_database` by adding the second physical volume (`/dev/<device_name>2`) using `vgextend`.
2. Verify that the free capacity in `vg_database` has increased using `vgs`.
3. Extend the size of `lv_data` by an additional `2 GiB` (or consume 100% of the remaining free extents) and automatically resize the underlying XFS file system online in a single command using `lvextend -r`.
4. Confirm that `/mnt/database` reflects the new expanded storage capacity without unmounting the file system.

---

## 🔍 Verification & Self-Test

Run these commands to verify your LVM storage hierarchy and active mounts:

```bash
# 1. Verify physical volume allocations
pvs

# 2. Check volume group free space and total size
vgs vg_database

# 3. Confirm expanded logical volume and mounted file system size
lvs vg_database/lv_data
df -h /mnt/database
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: PV and VG Initialisation
```bash
# 1. Inspect existing physical volumes
sudo pvs

# 2. Initialise block partitions as Physical Volumes
sudo pvcreate /dev/<device_name>1 /dev/<device_name>2

# 3. Create Volume Group using the first PV
sudo vgcreate vg_database /dev/<device_name>1

# 4. Display detailed VG information
sudo vgdisplay vg_database
```
Task 2 Solutions: LV Provisioning & Mounting
```bash
# 1. Create a 2 GiB Logical Volume
sudo lvcreate -L 2G -n lv_data vg_database

# 2. Format the logical volume with XFS
sudo mkfs.xfs /dev/vg_database/lv_data

# 3. Create mount point directory
sudo mkdir -p /mnt/database

# 4. Retrieve UUID for the logical volume
LV_UUID=$(sudo blkid -s UUID -o value /dev/vg_database/lv_data)
echo "LV UUID: ${LV_UUID}"

# 5. Add persistent mount record to /etc/fstab
sudo cat << EOF | sudo tee -a /etc/fstab
UUID=${LV_UUID} /mnt/database xfs defaults 0 0
EOF

# 6. Mount file system and verify
sudo mount -a
df -h /mnt/database
```
Task 3 Solutions: VG Extension & Online Resizing
```bash
# 1. Add second physical volume to the volume group
sudo vgextend vg_database /dev/<device_name>2

# 2. Check updated VG capacity
sudo vgs vg_database

# 3. Extend logical volume by 2 GiB and resize file system online (-r)
sudo lvextend -r -L +2G /dev/vg_database/lv_data

# Note: To allocate all remaining free space instead, use:
# sudo lvextend -r -l +100%FREE /dev/vg_database/lv_data

# 4. Confirm online expansion of mounted file system
df -h /mnt/database
sudo lvs vg_database/lv_data
```
