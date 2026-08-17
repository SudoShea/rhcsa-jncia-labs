# 05. Operational Monitoring and Maintenance (JN0-106)

## 📌 Domain Overview
This domain covers essential day-two operational tasks on Junos OS devices: health monitoring, hardware/system status inspection, diagnostic network tools, system storage maintenance, software upgrades, controlled reboots/shutdowns, and the critical **root password recovery procedure**.
---
## 🎯 Exam Objectives Covered
- **Show Commands:** Inspecting system state, processes, storage, and hardware (`show chassis`, `show system`, `show interfaces`).
- **Monitor Commands:** Real-time interface bandwidth, traffic statistics, and active log tracking (`monitor interface`, `monitor file`).
- **Interface Error Tracking:** Identifying link flaps, collision/framing errors, queue drops, and carrier transitions.
- **Diagnostic Tools:** Advanced `ping`, `traceroute`, `telnet`, and `ssh` execution with source interface and routing instance flags.
- **Storage Maintenance:** Storage partition cleanup and dry-run storage optimization (`request system storage cleanup`).
- **Software Upgrades & Installation:** Junos package management (`request system software add`).
- **System Power Operations:** Graceful rebooting and powering off devices with timing parameters (`request system reboot`, `request system power-off`).
- **Root Password Recovery:** Interrupting the boot sequence, entering single-user mode, executing `recovery`, and setting a new root credential.
---
## 🛠️ Labs in This Module
1. 📄 [**Lab 01: Operational Monitoring, Diagnostics & Interface Errors**](labs/lab-01-operational-monitoring-and-diagnostics.md)
   * Practise system health checks, real-time interface monitoring, error statistic analysis, and advanced `ping`/`traceroute` syntax.
2. 📄 [**Lab 02: Storage Maintenance, Software Upgrades & System Power Control**](labs/lab-02-software-upgrades-and-system-shutdown.md)
   * Clean up system storage partitions, verify software installation syntax, and schedule timed reboots/shutdowns.
3. 📄 [**Lab 03: Root Password Recovery Procedure**](labs/lab-03-root-password-recovery.md)
   * Perform a complete hands-on root password recovery using the FreeBSD bootloader and Junos `recovery` mode.
---
## 📁 Configuration Snippets
- ⚙️ [`configs/vsrx-1-maintenance-baseline.set`](configs/vsrx-1-maintenance-baseline.set): Operational test baseline with diagnostic loopbacks and log targets.
---
## ⚡ Quick Reference Cheatsheet
### Key Operational Commands
| Action | Command | Purpose |
| :--- | :--- | :--- |
| Hardware Status | `show chassis hardware` | Displays serial numbers, line cards, and SFPs. |
| Process Utilization | `show system processes extensive` | Displays active CPU/RAM usage per process (like `top`). |
| Storage Utilization | `show system storage` | Checks mounted filesystems and partition usage (`/var`, `/var/tmp`). |
| Real-time Interface Monitoring | `monitor interface ge-0/0/0` | Live full-screen traffic counter & rate display. |
| Live Log Streaming | `monitor file <filename>` | Streams file updates in real time (like `tail -f`). |
| Storage Cleanup | `request system storage cleanup` | Removes unused software packages and temporary log archives. |
### Network Diagnostics Syntax
```junos
# Ping with specific count, size, and source IP
ping 10.0.0.2 count 5 size 1000 do-not-fragment source 192.168.1.1

# Traceroute with custom TTL and source address
traceroute 8.8.8.8 source 192.168.1.1 ttl 15

# SSH to remote host specifying user and source interface
ssh user@10.0.0.2 source 192.168.1.1
```
### Power & Upgrade Operations
```junos
# Scheduled Reboot with warning message
request system reboot in 10 message "Scheduled Junos Upgrade"

# Cancel pending reboot
request system reboot cancel

# Power off immediately
request system power-off
```
