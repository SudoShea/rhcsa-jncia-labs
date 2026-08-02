# Lab 04.4: Emergency Boot, Root Password Reset (rd.break) & GRUB2 on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `04-operating-running-systems/04-emergency-boot-and-root-password-reset.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Interrupt the GRUB2 bootloader prompt during early system initialisation.
2. Append kernel runtime parameters (`rd.break`) to enter the initramfs emergency debug shell.
3. Remount the root filesystem (`/sysroot`) read-write and perform an emergency `root` account password reset.
4. Enforce mandatory SELinux filesystem relabelling (`/.autorelabel`) to preserve security context integrity.
5. Modify persistent GRUB2 default boot parameters in `/etc/default/grub` and rebuild GRUB2 bootloader configurations.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine with access to the virtual serial or graphical console.
* Direct console boot access.

---

## 🛠️ Scenario

You have been handed an enterprise RHEL 10 server where the previous administrator left without documenting the `root` user password. Standard SSH and local login attempts fail. You must access the machine via the local console, interrupt the GRUB2 boot sequence, break into the early RAM disk environment, reset the `root` password safely while maintaining SELinux labelling rules, and reboot into the operational system. Additionally, you must update default GRUB2 boot options to display verbose kernel messages during boot.

---

## 📝 Lab Tasks

### Task 1: Interrupting Boot & Entering Emergency Mode (`rd.break`)
1. Reboot the virtual machine and access the local console interface.
2. At the GRUB2 bootloader menu screen, press the **`e`** key to edit the active kernel boot entry.
3. Locate the kernel command line starting with `linux` (or `linux16`/`linuxefi`).
4. Append `rd.break` to the end of the line (separated by a space).
5. Press **`Ctrl+x`** (or **`F10`**) to boot the system with the modified kernel parameters. You will land in the Emergency `switch_root` prompt (`:/#`).

### Task 2: Remounting File Systems & Password Reset
1. Verify that `/sysroot` is currently mounted read-only (`ro`) using `mount | grep sysroot`.
2. Remount `/sysroot` with read-write permissions (`rw`):
```bash
mount -o remount,rw /sysroot
```
3. Change the root directory context to `/sysroot` using `chroot`:
```bash
chroot /sysroot
```
4. Reset the `root` password to a new value using the `passwd` command:
```bash
passwd
```
5. Create an empty SELinux relabel flag file at the filesystem root:
```bash
touch /.autorelabel
```
6. Exit the `chroot` jail (`exit`) and exit the initramfs shell (`exit`) to resume system boot. Wait for SELinux relabelling to complete and boot into multi-user mode.

### Task 3: GRUB2 Bootloader Configuration
1. Log in as `root` using the newly configured password.
2. Inspect persistent GRUB2 defaults in `/etc/default/grub`.
3. Modify the `GRUB_CMDLINE_LINUX` parameter inside `/etc/default/grub` to remove `quiet` and `rhgb` to enable verbose systemd boot logging.
4. Regenerate the persistent GRUB2 configuration file using `grub2-mkconfig -o /boot/grub2/grub.cfg`.

---

## 🔍 Verification & Self-Test
Run these commands after logging in to verify password functionality and GRUB2 settings:
```bash
# 1. Confirm successful root login and SELinux status
whoami
sestatus

# 2. Verify updated GRUB configuration parameters
grep "GRUB_CMDLINE_LINUX" /etc/default/grub
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 & 2 Solutions: Emergency Password Reset Commands
```bash
# Executed within the initramfs rd.break shell (:/# prompt):

# 1. Remount target system root read-write
mount -o remount,rw /sysroot

# 2. Enter chroot environment
chroot /sysroot

# 3. Reset root password
passwd

# 4. Trigger mandatory SELinux relabelling on next boot
touch /.autorelabel

# 5. Exit chroot jail and resume boot process
exit
exit
```
Task 3 Solutions: Persistent GRUB2 Customisation
```bash
# Executed as root on the restored operating system:

# 1. Inspect current default GRUB settings
cat /etc/default/grub

# 2. Modify GRUB_CMDLINE_LINUX parameter
sudo sed -i 's/quiet rhgb//' /etc/default/grub

# 3. Regenerate GRUB2 configuration file
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# 4. Confirm default kernel parameters updated
grep -i "linux" /boot/loader/entries/*
```
