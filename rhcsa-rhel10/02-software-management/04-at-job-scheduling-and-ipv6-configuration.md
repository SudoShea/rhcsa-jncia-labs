# Lab 02.4: One-Off Task Scheduling (at) & Static IPv6 Network Configuration on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `02-software-management/04-at-job-scheduling-and-ipv6-configuration.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Manage the deferred task daemon (`atd`) lifecycle using `systemctl`.
2. Queue deferred single-shot tasks with relative and absolute timestamps using `at`.
3. Query, inspect, and purge pending scheduled jobs using `atq`, `at -c`, and `atrm`.
4. Configure persistent static IPv6 addressing, prefix lengths, and default gateways using `nmcli`.
5. Validate dual-stack IPv4/IPv6 address assignments and routing tables.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine with network interface `<interface_name>` (e.g. `eth0` or `enp1s0`).
* Administrative access via `sudo` or the `root` account.

---

## 🛠️ Scenario

You are performing network and operational maintenance on a RHEL 10 server. The infrastructure team is transitioning to a dual-stack networking model and requires interface `<interface_name>` to be configured with a static IPv6 address (`2001:db8:1::50/64`) and default gateway (`2001:db8:1::1`). Additionally, you must schedule a one-off system diagnostic script to execute automatically 10 minutes in the future using `at` without setting up a recurring cron job.

---

## 📝 Lab Tasks

### Task 1: Deferred Single-Shot Task Scheduling (`at` & `atd`)
1. Verify that the `at` package is installed and ensure the `atd` service is enabled and running (`systemctl enable --now atd`).
2. Queue a single-shot maintenance task to run 10 minutes from now using `at`:
```bash
at now + 10 minutes
```
3. Inside the interactive `at` prompt, enter the following commands, then save and exit by pressing `Ctrl+D`:
```bash
logger "Deferred maintenance task executed successfully."
ip -6 addr show >> /var/log/ipv6-audit.log
```
4. Schedule a second test job set to execute at `23:00` tonight:
```bash
at 23:00
```
add command `echo "Nightly audit" > /tmp/nightly.log` and save.
5. Display all queued jobs using `atq.` Note the job ID numbers.
6. Inspect the full environment and execution script of the second job using at `-c <job_id>`.
7. Remove the second job from the queue using `atrm <job_id>` and verify with `atq`.

### Task 2: Static IPv6 Network Configuration (`nmcli`)
1. Identify the NetworkManager connection profile bound to network interface `<interface_name>` using `nmcli connection show`.
2. Inspect the current IPv6 configuration parameters using `nmcli connection show "<connection_name>" | grep ipv6`.
3. Configure static IPv6 parameters on `<connection_name>`:
    * **IPv6 Address & Prefix**: `2001:db8:1::50/64`
    * **IPv6 Gateway**: `2001:db8:1::1`
    * **IPv6 Method**: `manual`
4. Ensure the profile is configured to connect automatically (`connection.autoconnect yes`).
5. Activate the updated connection profile using `nmcli connection up "<connection_name>"`.

### Task 3: Dual-Stack Verification & Routing Audit
1. Display active IPv6 address allocations on interface `<interface_name>` using `ip -6 addr show dev <interface_name>`.
2. Inspect the active IPv6 routing table using `ip -6 route`.
3. Verify local IPv6 loopback and gateway reachability using `ping -6 ::1` and `ping -6 2001:db8:1::1` (if reachable).

---

## 🔍 Verification & Self-Test

Run these commands to verify task queues and network configurations:
```bash
# 1. Query pending deferred tasks
atq

# 2. Verify static IPv6 address assignment
ip -6 addr show dev <interface_name>

# 3. Verify IPv6 default route
ip -6 route | grep default
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Deferred Task Scheduling
```bash
# 1. Install at package and start daemon
sudo dnf install -y at
sudo systemctl enable --now atd

# 2. Queue relative time job non-interactively
echo "logger 'Deferred maintenance task executed successfully.' && ip -6 addr show >> /var/log/ipv6-audit.log" | at now + 10 minutes

# 3. Queue absolute time job
echo "echo 'Nightly audit' > /tmp/nightly.log" | at 23:00

# 4. List pending jobs
atq

# 5. Inspect job details (replace 2 with target job ID)
at -c 2

# 6. Remove scheduled job
atrm 2
atq
```
Task 2 Solutions: Static IPv6 Configuration
```bash
# 1. Identify connection profile name
nmcli connection show

# 2. Configure static IPv6 parameters via nmcli
sudo nmcli connection modify "<connection_name>" \
  ipv6.addresses "2001:db8:1::50/64" \
  ipv6.gateway "2001:db8:1::1" \
  ipv6.method manual \
  connection.autoconnect yes

# 3. Apply profile changes
sudo nmcli connection up "<connection_name>"
```
Task 3 Solutions: Verification
```bash
# 1. Check assigned IPv6 address
ip -6 addr show dev <interface_name>

# 2. Check IPv6 routes
ip -6 route

# 3. Test IPv6 stack
ping -6 -c 3 ::1
```
