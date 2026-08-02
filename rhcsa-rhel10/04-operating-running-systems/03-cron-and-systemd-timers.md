# Lab 04.3: Task Automation with Cron Jobs & Systemd Timers on RHEL 10

**Track:** RHCSA (EX200)  
**Target OS:** Red Hat Enterprise Linux 10  
**Location:** `rhcsa-rhel10/04-operating-running-systems/03-cron-and-systemd-timers.md`  
**Licence:** MIT  

---

## 🎯 Objectives

By the end of this lab, you will be able to:
1. Schedule periodic user and system tasks using `crontab` and `/etc/cron.d/`.
2. Construct custom single-shot `systemd` service units (`.service`) for background execution.
3. Create, enable, and manage `systemd` timer units (`.timer`) using calendar-based schedules (`OnCalendar`).
4. Inspect active timer schedules and historical execution logs using `systemctl list-timers` and `journalctl`.

---

## 📋 Prerequisites

* A running RHEL 10 lab virtual machine.
* Administrative access via `sudo` or the `root` account.

---

## 🛠️ Scenario

You are automating routine system maintenance on a RHEL 10 server. You must configure traditional `cron` jobs for simple, periodic user script executions. Additionally, to improve logging, dependency tracking, and execution flexibility, you must convert a critical system audit script into a native `systemd` service triggered on a daily schedule by a `systemd` timer unit.

---

## 📝 Lab Tasks

### Task 1: User & System-Wide Cron Job Scheduling
1. Log in as a standard user (`<username>`) and create a script at `~/scripts/disk-audit.sh` that appends the output of `df -h /` to `~/disk-usage.log` along with a current timestamp.
2. Grant execution rights (`chmod +x`) to `~/scripts/disk-audit.sh`.
3. Configure a user `crontab` entry using `crontab -e` to run `~/scripts/disk-audit.sh` every 5 minutes (`*/5 * * * *`).
4. Verify the installed user crontab entry using `crontab -l` and confirm that file entries exist under `/var/spool/cron/<username>`.
5. Create a system-wide cron file at `/etc/cron.d/system-cleaner` that runs a temporary file cleanup command (`/usr/bin/find /tmp -type f -mtime +7 -delete`) as user `root` every Sunday at 03:00 AM (`0 3 * * 0`).

### Task 2: Creating a Custom Systemd Service Unit
1. Create an administrative audit script at `/usr/local/bin/system-audit.sh` containing:
```bash
#!/usr/bin/env bash
echo "[AUDIT] System audit executed at $(date)" >> /var/log/system-audit.log
```
2. Grant execution rights (`chmod 755`) to `/usr/local/bin/system-audit.sh`.
3. Create a custom systemd service unit file at `/etc/systemd/system/system-audit.service` with:
    * Service type set to `oneshot`.
    * Execution target set to `/usr/local/bin/system-audit.sh`.
4. Reload the systemd manager configuration (`systemctl daemon-reload`) and manually trigger `system-audit.service` to verify that `/var/log/system-audit.log` is populated.

### Task 3: Creating & Managing a Systemd Timer Unit
1. Create a matching systemd timer unit file at `/etc/systemd/system/system-audit.timer`.
2. Configure the timer to execute the associated service unit daily at 02:30 AM (`OnCalendar=*-*-* 02:30:00`) and run 15 minutes after system boot (`OnBootSec=15min`).
3. Reload systemd configuration, then enable and start `system-audit.timer`.
4. Query all active system timers using `systemctl list-timers` to verify the next scheduled run time and elapsed time since the last run.

---

## 🔍 Verification & Self-Test
Run these commands to verify cron entries and active systemd timers:
```bash
# 1. Verify user crontab schedule
crontab -l

# 2. Inspect custom systemd timer status
systemctl status system-audit.timer

# 3. List active systemd timers with next execution times
systemctl list-timers --all | grep system-audit
```
---

## 💡 Step-by-Step Solution & Reference
Task 1 Solutions: Cron Scheduling
```bash
# 1. Create directory and script file
mkdir -p ~/scripts
cat << 'EOF' > ~/scripts/disk-audit.sh
#!/usr/bin/env bash
echo "=== Disk Audit: $(date) ===" >> ~/disk-usage.log
df -h / >> ~/disk-usage.log
EOF

# 2. Grant execution permissions
chmod +x ~/scripts/disk-audit.sh

# 3. Edit user crontab (appends cron rule automatically)
(crontab -l 2>/dev/null; echo "*/5 * * * * $HOME/scripts/disk-audit.sh") | crontab -

# 4. Confirm user crontab file
crontab -l
sudo ls -l /var/spool/cron/

# 5. Create system-wide cron configuration file
sudo cat << 'EOF' | sudo tee /etc/cron.d/system-cleaner
# /etc/cron.d/system-cleaner
# min hour day month dayofweek user command
0 3 * * 0 root /usr/bin/find /tmp -type f -mtime +7 -delete
EOF

sudo chmod 644 /etc/cron.d/system-cleaner
```
Task 2 Solutions: Custom Systemd Service
```bash
# 1. Create system script
sudo cat << 'EOF' | sudo tee /usr/local/bin/system-audit.sh
#!/usr/bin/env bash
echo "[AUDIT] System audit executed at $(date)" >> /var/log/system-audit.log
EOF

# 2. Set execution bit
sudo chmod 755 /usr/local/bin/system-audit.sh

# 3. Create service unit definition
sudo cat << 'EOF' | sudo tee /etc/systemd/system/system-audit.service
[Unit]
Description=Routine System Audit Task
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/system-audit.sh
EOF

# 4. Reload daemon and test manual execution
sudo systemctl daemon-reload
sudo systemctl start system-audit.service

# 5. Verify log creation
cat /var/log/system-audit.log
```
Task 3 Solutions: Systemd Timer Unit
```bash
# 1. Create timer unit definition
sudo cat << 'EOF' | sudo tee /etc/systemd/system/system-audit.timer
[Unit]
Description=Run System Audit Task Daily

[Timer]
OnBootSec=15min
OnCalendar=*-*-* 02:30:00
Persistent=true
Unit=system-audit.service

[Install]
WantedBy=timers.target
EOF

# 2. Reload daemon, enable and start the timer
sudo systemctl daemon-reload
sudo systemctl enable --now system-audit.timer

# 3. Verify timer state and schedules
systemctl status system-audit.timer
systemctl list-timers --all | grep system-audit
```
