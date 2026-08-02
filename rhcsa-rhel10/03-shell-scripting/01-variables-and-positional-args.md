# Lab 03.1: Shell Scripting Basics, Variables & Positional Arguments on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/03-shell-scripting/01-variables-and-positional-args.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Write executable Bash scripts using standard shebang declarations (`#!/usr/bin/env bash`).
2. Declare and evaluate user-defined variables, environment variables, and command substitutions (`$(...)`).
3. Parse command-line positional parameters (`$0`, `$1`, `$2`, `$#`, `$@`).
4. Control script execution flow using return codes (`$?`) and explicit `exit` statuses.
5. Set appropriate file execution permissions (`chmod +x`) and manage script execution paths.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Standard user account access with `sudo` administrative privileges.

---

## 🛠️ Scenario

As a Red Hat System Administrator, you need to automate routine user auditing across your RHEL 10 infrastructure. You must author a shell script named `user-audit.sh` that accepts a target username and an output log directory as command-line arguments. The script must gather account metadata, record system information, evaluate parameter counts, and exit cleanly with appropriate status codes.

---

## 📝 Lab Tasks

### Task 1: Script Environment & Variable Declaration
1. Create a script directory at `~/scripts` and navigate into it.
2. Create a script file named `user-audit.sh` starting with a standard `bash` shebang line.
3. Inside the script, assign dynamic system facts to variables using command substitution:
   * `HOSTNAME_FACT`: Holds the short hostname (`hostname -s`).
   * `CURRENT_DATE`: Holds the current date formatted as `YYYY-MM-DD` (`date +%F`).
   * `KERNEL_VER`: Holds the current Linux kernel release (`uname -r`).

### Task 2: Positional Argument Processing & Validation
1. Configure the script to accept two positional arguments:
   * `$1`: Target username to audit (e.g., `<username>`).
   * `$2`: Directory path where the audit report will be stored (e.g., `/tmp/audits`).
2. Assign `$1` to `TARGET_USER` and `$2` to `REPORT_DIR`.
3. Add a basic validation check: If the total number of arguments passed (`$#`) is not equal to `2`, print an error message showing usage syntax (`Usage: ./user-audit.sh <username> <output_dir>`) and exit immediately with status code `1`.

### Task 3: Execution, Output Generation & Exit Codes
1. Append commands to the script to create `REPORT_DIR` if it does not already exist.
2. Write a formatted summary to `${REPORT_DIR}/${TARGET_USER}_report.txt` containing:
   * Audit date, hostname, and kernel version.
   * Target user account details extracted from `/etc/passwd`.
   * Group membership information for `TARGET_USER` extracted using `id <username>`.
3. End the script with an explicit `exit 0` return code.
4. Grant executable permissions (`chmod +x user-audit.sh`) and execute the script passing `<username>` and `/tmp/audits` as arguments.
5. Test invalid invocation (running the script with no arguments) to verify that it exits with status code `1` and displays the usage message.

---

## 🔍 Verification & Self-Test

Run these commands to verify script execution and exit statuses:

```bash
# 1. Test script execution with valid arguments
~/scripts/user-audit.sh <username> /tmp/audits
echo "Exit status: $?"  # Must return 0

# 2. Inspect generated report output
cat /tmp/audits/<username>_report.txt

# 3. Test script execution with missing arguments
~/scripts/user-audit.sh
echo "Exit status: $?"  # Must return 1
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 & 2 Solutions: Script Authoring (`~/scripts/user-audit.sh`)
```bash
# 1. Create directory and script file
mkdir -p ~/scripts
cd ~/scripts
touch user-audit.sh
```
Write the following content into `~/scripts/user-audit.sh`:
```bash
#!/usr/bin/env bash
# ==============================================================================
# Script      : user-audit.sh
# Description : Audits a user account and writes system metadata to a log file
# Usage       : ./user-audit.sh <username> <output_dir>
# ==============================================================================

# Task 2: Positional Argument Validation
if [ "$#" -ne 2 ]; then
  echo "[ERROR] Invalid number of arguments." >&2
  echo "Usage: $0 <username> <output_dir>" >&2
  exit 1
fi

# Assign Positional Arguments to Meaningful Variables
TARGET_USER="$1"
REPORT_DIR="$2"

# Task 1: Command Substitution and Fact Variables
HOSTNAME_FACT=$(hostname -s)
CURRENT_DATE=$(date +%F)
KERNEL_VER=$(uname -r)

# Task 3: Directory Creation and Output Generation
mkdir -p "${REPORT_DIR}"
REPORT_FILE="${REPORT_DIR}/${TARGET_USER}_report.txt"

echo "==================================================" > "${REPORT_FILE}"
echo " USER AUDIT REPORT" >> "${REPORT_FILE}"
echo "==================================================" >> "${REPORT_FILE}"
echo "Date           : ${CURRENT_DATE}" >> "${REPORT_FILE}"
echo "Host           : ${HOSTNAME_FACT}" >> "${REPORT_FILE}"
echo "Kernel Version : ${KERNEL_VER}" >> "${REPORT_FILE}"
echo "--------------------------------------------------" >> "${REPORT_FILE}"
echo "Account Details:" >> "${REPORT_FILE}"
grep "^${TARGET_USER}:" /etc/passwd >> "${REPORT_FILE}" 2>&1 || echo "User not found in /etc/passwd" >> "${REPORT_FILE}"
echo "--------------------------------------------------" >> "${REPORT_FILE}"
echo "Group Memberships:" >> "${REPORT_FILE}"
id "${TARGET_USER}" >> "${REPORT_FILE}" 2>&1 || echo "No group info available" >> "${REPORT_FILE}"
echo "==================================================" >> "${REPORT_FILE}"

echo "[SUCCESS] Audit completed for user '${TARGET_USER}'. Report saved to ${REPORT_FILE}"
exit 0
```
Task 3 Solutions: Permissions and Execution
```bash
# 1. Make script executable
chmod +x ~/scripts/user-audit.sh

# 2. Run valid test invocation using sanitised username
~/scripts/user-audit.sh <username> /tmp/audits

# 3. Verify exit code of successful run
echo "Exit code: $?"

# 4. View generated report
cat /tmp/audits/<username>_report.txt

# 5. Test invalid invocation (triggers usage error and exit code 1)
~/scripts/user-audit.sh
echo "Exit code: $?"
```
