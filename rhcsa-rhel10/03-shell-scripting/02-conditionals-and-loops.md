# Lab 03.2: Shell Scripting Conditionals & Loops on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/03-shell-scripting/02-conditionals-and-loops.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Evaluate file, string, and integer expressions using `test`, `[ ]`, and `[[ ]]`.
2. Construct decision-making execution flows using `if`, `elif`, `else`, and `fi`.
3. Iterate across explicit lists, command outputs, and ranges using `for` loops.
4. Build conditional monitoring polling routines using `while` and `until` loops.
5. Apply loop control directives (`break` and `continue`) to manage execution state.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Standard user account access with `sudo` administrative privileges.

---

## 🛠️ Scenario

You need to deploy a system health and service monitoring utility named `system-health-check.sh` across your server fleet. The script must iterate through a defined list of core system services, evaluate whether each service is active, test storage directory availability, and poll a service status up to a maximum retry limit using a `while` loop before reporting a failure.

---

## 📝 Lab Tasks

### Task 1: File System & Integer Conditional Testing
1. Create a script named `~/scripts/system-health-check.sh`.
2. Implement an `if / else` structure to check if the directory `/var/log/health-checks` exists (`-d`).
3. If the directory does not exist, attempt to create it. If creation fails, output an error message to standard error (`>&2`) and exit with status code `2`.
4. Test if `/etc/fstab` exists and is a readable regular file (`-f` and `-r`). Print a confirmation message if true.

### Task 2: Service Auditing with `for` Loops
1. Define a list of core system services inside the script: `sshd`, `chronyd`, `firewalld`, `systemd-journald`.
2. Use a `for` loop to iterate through each service in the list.
3. Inside the loop, evaluate whether the service is running using `systemctl is-active --quiet <service_name>`.
4. Print a formatted status line for each service:
   * If active: `[ONLINE] <service_name> is running.`
   * If inactive/failed: `[OFFLINE] <service_name> is not running.`

### Task 3: Retry Polling with `while` Loops & Counter Controls
1. Configure a retry polling block to check for the presence of a specific service or PID (e.g., `sshd`).
2. Initialise a counter variable `RETRY_COUNT=0` and a maximum limit `MAX_RETRIES=5`.
3. Construct a `while` loop that continues polling as long as `RETRY_COUNT` is less than (`-lt`) `MAX_RETRIES`.
4. Inside the loop:
   * Test if the service is active. If active, print a success message and break out of the loop using `break`.
   * If inactive, increment `RETRY_COUNT` by 1 (`RETRY_COUNT=$((RETRY_COUNT + 1))`), print a warning message, and sleep for 1 second (`sleep 1`).
5. If the loop completes without the service coming online (`RETRY_COUNT` equals `MAX_RETRIES`), print a critical alert message and exit with status code `3`.

---

## 🔍 Verification & Self-Test

Run these commands to verify script execution and conditional handling:

```bash
# 1. Grant execution rights and run the health check
chmod +x ~/scripts/system-health-check.sh
sudo ~/scripts/system-health-check.sh
echo "Exit code: $?"

# 2. Test failure handling by stopping a non-critical service (e.g., firewalld)
sudo systemctl stop firewalld
sudo ~/scripts/system-health-check.sh
sudo systemctl start firewalld
```
---

## 💡 Step-by-Step Solution & Reference
Complete Script: `~/scripts/system-health-check.sh`
```bash
#!/usr/bin/env bash
# ==============================================================================
# Script      : system-health-check.sh
# Description : Evaluates directory states, service health, and polls services
# Usage       : sudo ./system-health-check.sh
# ==============================================================================

set -u

LOG_DIR="/var/log/health-checks"
SERVICES=("sshd" "chronyd" "firewalld" "systemd-journald")

echo "=================================================="
echo " Starting RHEL 10 System Health Audit"
echo "=================================================="

# ------------------------------------------------------------------------------
# Task 1: Directory and File Conditional Checks
# ------------------------------------------------------------------------------
echo "[INFO] Validating log storage directory..."

if [ ! -d "${LOG_DIR}" ]; then
  echo "[WARNING] Directory ${LOG_DIR} missing. Creating now..."
  if ! mkdir -p "${LOG_DIR}" 2>/dev/null; then
    echo "[ERROR] Failed to create ${LOG_DIR}. Check permissions." >&2
    exit 2
  fi
fi
echo "[OK] Storage directory ${LOG_DIR} is present."

if [ -f "/etc/fstab" ] && [ -r "/etc/fstab" ]; then
  echo "[OK] System file /etc/fstab verified (readable)."
else
  echo "[WARNING] System file /etc/fstab is missing or unreadable."
fi

echo "--------------------------------------------------"

# ------------------------------------------------------------------------------
# Task 2: Service State Audit using a 'for' Loop
# ------------------------------------------------------------------------------
echo "[INFO] Auditing core system service statuses..."

for SERVICE in "${SERVICES[@]}"; do
  if systemctl is-active --quiet "${SERVICE}"; then
    echo "  [ONLINE]  Service '${SERVICE}' is running."
  else
    echo "  [OFFLINE] Service '${SERVICE}' is NOT running."
  fi
done

echo "--------------------------------------------------"

# ------------------------------------------------------------------------------
# Task 3: Service Polling using a 'while' Loop
# ------------------------------------------------------------------------------
TARGET_SERVICE="sshd"
RETRY_COUNT=0
MAX_RETRIES=5

echo "[INFO] Initiating status polling for '${TARGET_SERVICE}'..."

while [ "${RETRY_COUNT}" -lt "${MAX_RETRIES}" ]; do
  if systemctl is-active --quiet "${TARGET_SERVICE}"; then
    echo "[SUCCESS] Service '${TARGET_SERVICE}' responded on attempt$((RETRY_COUNT + 1))."
    break
  else
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "[RETRY ${RETRY_COUNT}/${MAX_RETRIES}] '${TARGET_SERVICE}' inactive. Retrying in 1 second..."
    sleep 1
  fi
done

if [ "${RETRY_COUNT}" -eq "${MAX_RETRIES}" ]; then
  echo "[CRITICAL] Service '${TARGET_SERVICE}' failed to respond after${MAX_RETRIES} attempts." >&2
  exit 3
fi

echo "=================================================="
echo "[COMPLETE] System health audit finished successfully."
exit 0
```
Execution Verification
```bash
# 1. Make executable
chmod +x ~/scripts/system-health-check.sh

# 2. Run with elevated privileges
sudo ~/scripts/system-health-check.sh

# 3. Check exit status
echo "Exit status: $?"
```
