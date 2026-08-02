# Lab 01.2: I/O Redirection, Pipelines & Pattern Matching on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/01-essential-tools/02-io-redirection-grep-regex.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Redirect standard input, standard output, and standard error streams.
2. Construct multi-stage shell pipelines using `|` and `tee`.
3. Filter text streams using regular expressions with `grep`.
4. Separate error output from valid stdout data in administrative operations.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Standard user account access with `sudo` privileges.

---

## 🛠️ Scenario

You are inspecting system logs and user directory structures. You need to extract specific error events, analyze user shell assignments, and save filtered diagnostic outputs to log files while discarding noise.

---

## 📝 Lab Tasks

### Task 1: Standard Output, Append & Error Redirection
1. Redirect the output of `uname -a` to overwrite a file named `/tmp/sysinfo.txt`.
2. Append the current system uptime (`uptime`) to `/tmp/sysinfo.txt`.
3. Run `ls /root /nonexistent_dir` in a single command, redirecting standard output to `/tmp/valid.log` and standard error to `/tmp/error.log`.
4. Run `ls /root /nonexistent_dir` again, redirecting both standard output and standard error into a single file named `/tmp/combined.log`.
5. Run `find /etc -name "*.conf"` and redirect all permission error messages (`Permission denied`) to `/dev/null`.

### Task 2: Pipelines & `tee` Processing
1. List all active processes using `ps aux`, pipe the output to `sort` by CPU usage, and display only the top 5 CPU-consuming processes.
2. Read `/etc/passwd`, extract lines containing `/bin/bash`, count the total number of matching users using `wc -l`, and simultaneously output the result to stdout and write it to `/tmp/bash_user_count.txt` using `tee`.

### Task 3: Pattern Matching with `grep` & Regular Expressions
1. Search `/etc/ssh/sshd_config` for lines that start with `PermitRootLogin` (ignoring leading whitespace if present).
2. Recursively search `/var/log` for the word `FAILED` or `failed` case-insensitively, displaying line numbers for matches.
3. Extract all non-comment, non-empty lines from `/etc/rsyslog.conf` and display them on screen.

---

## 🔍 Verification & Self-Test

Run these commands to verify your output:

```bash
# 1. Check combined log contents
cat /tmp/combined.log

# 2. Verify tee output file
cat /tmp/bash_user_count.txt
```
---

## 💡 Step-by-Step Solution & Reference
Step 1 Solutions: Standard Output, Append & Error Redirection
```bash
# 1. Overwrite stdout
uname -a > /tmp/sysinfo.txt

# 2. Append stdout
uptime >> /tmp/sysinfo.txt

# 3. Separate stdout (1) and stderr (2)
sudo ls /root /nonexistent_dir > /tmp/valid.log 2> /tmp/error.log

# 4. Merge stdout and stderr
sudo ls /root /nonexistent_dir &> /tmp/combined.log

# 5. Suppress error output
find /etc -name "*.conf" 2> /dev/null
```
Task 2 Solutions: Pipelines & 'tee'
```bash
# 1. Pipeline with sort and head (column 3 is %CPU)
ps aux --sort=-%cpu | head -n 6

# 2. Pipeline using tee
grep "/bin/bash" /etc/passwd | wc -l | tee /tmp/bash_user_count.txt
```
Task 3 Solutions: Pattern Matching 
```bash
# 1. Match start of line anchors with grep
grep -E "^\s*PermitRootLogin" /etc/ssh/sshd_config

# 2. Recursive, case-insensitive grep with line numbers
sudo grep -rn -i "failed" /var/log/

# 3. Exclude comment lines (#) and blank lines
grep -v -E "^#|^$" /etc/rsyslog.conf
```
