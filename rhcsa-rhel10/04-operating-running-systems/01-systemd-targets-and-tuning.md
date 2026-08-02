# Lab 04.1: Systemd Targets, Boot Modes & System Tuning with tuned on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/04-operating-running-systems/01-systemd-targets-and-tuning.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Query and configure default systemd boot targets (`multi-user.target`, `graphical.target`).
2. Isolate runtime targets dynamically without rebooting the operating system.
3. Manage the `tuned` system tuning daemon lifecycle and service state.
4. Analyse performance recommendations and switch active `tuned` profiles using `tuned-adm`.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Administrative access via `sudo` or the `root` account.

---

## 🛠️ Scenario

You are commissioning a new RHEL 10 database host that was installed with a graphical desktop environment by default. To conserve system RAM and CPU overhead, you must permanently configure the default boot target to headless CLI mode (`multi-user.target`) and isolate the running state immediately. Additionally, you must evaluate system workload profiles using `tuned-adm` and apply a performance-optimised profile for server operations.

---

## 📝 Lab Tasks

### Task 1: Systemd Boot Target Management
1. Display the currently configured default boot target using `systemctl`.
2. List all currently active systemd target units on the system.
3. Change the default boot target permanently to `multi-user.target`.
4. Verify that the symlink at `/etc/systemd/system/default.target` points to `/usr/lib/systemd/system/multi-user.target`.
5. Isolate the system to `multi-user.target` without rebooting the server.

### Task 2: System Tuning Daemon (`tuned`) Lifecycle
1. Verify that the `tuned` service is installed, enabled, and currently running.
2. If `tuned` is stopped or disabled, start and enable it using `systemctl`.
3. Query the `tuned-adm` utility to determine the profile recommended by Red Hat for your current hardware/hypervisor setup.

### Task 3: Profile Analysis & Activation
1. List all available `tuned` profiles and identify which profile is currently active.
2. Change the active tuning profile to `throughput-performance`.
3. Verify that the new profile is active and check the active profile details.
4. Confirm that the tuning profile selection persists across daemon reloads by restarting the `tuned` service.

---

## 🔍 Verification & Self-Test

Run these commands to verify target and tuning configurations:

```bash
# 1. Verify default systemd target
systemctl get-default

# 2. Confirm active tuned profile
tuned-adm active
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Target Management
```bash
# 1. Query current default boot target
systemctl get-default

# 2. List active target units
systemctl list-units --type=target

# 3. Set default boot target to multi-user
sudo systemctl set-default multi-user.target

# 4. Inspect symlink destination
ls -l /etc/systemd/system/default.target

# 5. Isolate runtime target without rebooting
sudo systemctl isolate multi-user.target
```
Task 2 Solutions: Tuned Daemon Lifecycle
```bash
# 1. Check tuned service status
systemctl status tuned

# 2. Enable and start tuned if inactive
sudo systemctl enable --now tuned

# 3. Ask tuned to recommend a profile based on hardware detection
tuned-adm recommend
```
Task 3 Solutions: Profile Analysis & Activation
```bash
# 1. List available profiles and active state
tuned-adm list

# 2. Switch active profile to throughput-performance
sudo tuned-adm profile throughput-performance

# 3. Verify active profile setting
tuned-adm active

# 4. Restart tuned daemon and re-verify persistence
sudo systemctl restart tuned
tuned-adm active
```
