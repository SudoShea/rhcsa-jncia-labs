# Lab 04.5: Process Control, Signals & Priority Scheduling on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `04-operating-running-systems/05-process-control-signals-and-priority.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Audit running processes, CPU/memory consumption, and process hierarchies using `ps`, `pgrep`, `pstree`, and `top`.
2. Terminate rogue or unresponsive processes gracefully and forcefully using `kill`, `pkill`, and `killall`.
3. Launch background processes with custom execution niceness priorities using `nice`.
4. Alter the scheduling priority of active running processes dynamically using `renice`.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Standard user account access with `sudo` administrative privileges.

---

## 🛠️ Scenario

A user application on a RHEL 10 application node is consuming excessive CPU resources, degrading system responsiveness. You must identify high-resource process trees, terminate rogue background jobs, launch a resource-intensive background audit task with reduced CPU priority (higher nice value), and dynamically deprioritise an existing active process to ensure real-time user services remain responsive.

---

## 📝 Lab Tasks

### Task 1: Process Auditing & Identification
1. List all running processes on the system in full detail using `ps aux` and `ps -ef`.
2. Display process IDs (PIDs), user owners, parent PIDs (PPID), and nice values (`ni`) using customised output formatting:
```bash
ps -eo pid,ppid,user,ni,%cpu,%mem,comm
```
3. Locate all processes owned by user `nobody` using `pgrep -u nobody -l`.
4. Launch an interactive `top` session, sort active processes by CPU usage (`P`), and identify the top resource consumer.

### Task 2: Process Termination & Signal Management
1. Launch three dummy background sleep processes as a standard user:
```bash
sleep 3000 &
sleep 3000 &
sleep 3000 &
```
2. Identify the Process IDs (PIDs) of the newly spawned `sleep` background jobs using `pgrep sleep`.
3. Send a standard graceful termination signal (`SIGTERM` / `15`) to the first `sleep` PID using `kill`.
4. Send an uncatchable forceful kill signal (`SIGKILL` / `9`) to the second `sleep` PID using `kill -9`.
5. Terminate all remaining `sleep` processes matching the executable name simultaneously using `pkill` or `killall`.

### Task 3: Priority Scheduling with nice and renice
1. Launch a background SHA512 compute task using `nice` with a reduced priority (nice value `+15`):
```bash
nice -n 15 sha512sum /dev/zero > /dev/null &
```
2. Verify that the newly created `sha512sum` process reflects a `nice` value of `15` using `ps -o pid,ni,comm -C sha512sum`.
3. Launch a second `sha512sum` process with default niceness (`0`):
```bash
sha512sum /dev/zero > /dev/null &
```
4. Dynamically modify the niceness of the second running `sha512sum` process to `19` (lowest possible execution priority) using `renice`.
5. Clean up all running background `sha512sum` jobs using `pkill -9 sha512sum`.

---

## 🔍 Verification & Self-Test

Run these commands to verify process priorities and signal delivery:
```bash
# 1. Query nice levels of specific running executables
ps -eo pid,ni,args | grep sha512sum

# 2. Confirm process cleanup
pgrep sleep sha512sum || echo "All test processes terminated successfully."
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Process Inspection
```bash
# 1. Full process listings
ps aux
ps -ef

# 2. Customised attribute formatting (includes Niceness column 'ni')
ps -eo pid,ppid,user,ni,%cpu,%mem,comm

# 3. Search processes by owner
pgrep -u nobody -l
```
Task 2 Solutions: Signals & Termination
```bash
# 1. Spawn background processes
sleep 3000 &
sleep 3000 &
sleep 3000 &

# 2. Locate PIDs
pgrep -l sleep

# 3. Graceful termination (SIGTERM = 15)
PID_1=$(pgrep sleep | head -n 1)
kill -15 "${PID_1}"

# 4. Forceful termination (SIGKILL = 9)
PID_2=$(pgrep sleep | head -n 1)
kill -9 "${PID_2}"

# 5. Terminate remaining processes by process name
pkill -9 sleep
```
Task 3 Solutions: Priority Scheduling
```bash
# 1. Launch job with custom nice value (+15)
nice -n 15 sha512sum /dev/zero > /dev/null &

# 2. Verify nice value allocation
ps -eo pid,ni,comm -C sha512sum

# 3. Launch job with default nice value (0)
sha512sum /dev/zero > /dev/null &

# 4. Dynamically adjust niceness of active PID to 19
TARGET_PID=$(pgrep -n sha512sum)
renice -n 19 -p "${TARGET_PID}"

# 5. Confirm updated niceness
ps -o pid,ni,comm -p "${TARGET_PID}"

# 6. Clean up compute jobs
pkill -9 sha512sum
```
