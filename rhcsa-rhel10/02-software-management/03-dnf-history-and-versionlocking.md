# Lab 02.3: DNF Transaction History, Rollbacks & Version Locking on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/02-software-management/03-dnf-history-and-versionlocking.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Inspect, search, and analyze DNF transaction history logs.
2. Undo and rollback specific package installation and upgrade operations.
3. Install and configure the DNF versionlock plugin (`python3-dnf-plugin-versionlock`).
4. Lock package versions to prevent unintended system updates during routine maintenance.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Administrative access via `sudo` or the `root` account.

---

## 🛠️ Scenario

A software update accidentally installed an incompatible package version on your system. You must inspect DNF transaction logs to identify the exact change, undo the installation, and place a version lock on critical system packages to prevent future automatic updates from altering production binaries.

---

## 📝 Lab Tasks

### Task 1: Inspecting DNF Transaction History
1. View the complete list of past DNF transactions using `dnf history`.
2. Install the package `nmap` using DNF.
3. Query detailed information about the transaction ID associated with the `nmap` installation using `dnf history info <transaction_id>`.

### Task 2: Transaction Reversal & Rollbacks
1. Undo the `nmap` installation transaction using `dnf history undo <transaction_id>`.
2. Verify that `nmap` was removed from the system.
3. Install `tcpdump` and `bind-utils` in two separate DNF transactions.
4. Perform a rollback to the transaction state prior to installing `tcpdump` using `dnf history rollback <transaction_id>`.

### Task 3: Package Version Locking
1. Install the `python3-dnf-plugin-versionlock` package.
2. Place a version lock on the currently installed `bash` package so it cannot be updated or removed.
3. Verify active version locks using `dnf versionlock list`.
4. Attempt to update or reinstall `bash` and observe the blocking behavior.
5. Clear the version lock for `bash`.

---

## 🔍 Verification & Self-Test

Run these commands to verify versionlock state:

```bash
# 1. View active version locks
sudo dnf versionlock list

# 2. Check recent transaction history
sudo dnf history list | head -n 5
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: History Inspection
```bash
# 1. List past DNF transactions
sudo dnf history

# 2. Install test package
sudo dnf install -y nmap

# 3. Inspect latest transaction details (replace <id> with actual transaction number)
sudo dnf history info $(sudo dnf history list | awk 'NR==3 {print $1}')
```
Task 2 Solutions: Transaction Reversal
```bash
# 1. Undo the nmap installation
sudo dnf history undo last -y

# 2. Confirm package removal
which nmap

# 3. Install packages in separate steps
sudo dnf install -y tcpdump
sudo dnf install -y bind-utils

# 4. View transaction list to find ID before tcpdump
sudo dnf history

# 5. Rollback to target transaction ID (replace <target_id> accordingly)
sudo dnf history rollback <target_id> -y
```
Task 3 Solutions: Version Locking
```bash
# 1. Install versionlock plugin
sudo dnf install -y python3-dnf-plugin-versionlock

# 2. Lock current bash version
sudo dnf versionlock add bash

# 3. List locked packages
sudo dnf versionlock list

# 4. Test lock enforcement (should report no packages marked for update)
sudo dnf update bash

# 5. Clear version locks
sudo dnf versionlock clear
```
