# Lab 02: Storage Maintenance, Software Upgrades & System Power Control

## Objective
Perform storage partition maintenance, practise software installation command syntax, and execute controlled system reboots and power-off operations on a Junos device.
## Topology
- **Device:** `vSRX-1`
---
## Task 1: System Storage Partition Cleanup
Junos devices store log archives, crash dumps, and old software packages on `/var`. Running out of space on `/var` can prevent configuration commits or software upgrades.
1. Inspect active storage utilisation:
```junos
show system storage
```
2. Perform a dry-run storage cleanup to view files safe for removal:
```junos
request system storage cleanup dry-run
```
3. Execute storage cleanup to purge temporary log archives and old software packages:
```junos
request system storage cleanup
```
---
## Task 2: Junos OS Software Upgrade Procedure
Updating Junos OS is a core operational duty. On JNCIA-JN0-106, candidates must know the proper syntax and options for `request system software add`.
1. **Standard Upgrade Command Syntax:**
```junos
request system software add /var/tmp/junos-install-vsrx-x86-64-21.3R1.9.tgz reboot
```
2. **Key Installation Flags to Know for the Exam:**
    * `no-copy`: Prevents copying the installation package to the package directory before installation (saves space on systems with small flash drives).
    * `unlink`: Removes the installation package file automatically after successful installation.
    * `reboot`: Reboots the device automatically once package installation finishes.
    * `validate`: Checks package compatibility against the running candidate configuration prior to installation.
3. **Verifying Software Package Status:**
```junos
show version
show system software detail
```
---
## Task 3: Controlled Reboots & System Shutdowns
Never turn off a Junos device by abruptly pulling power; doing so can corrupt the underlying FreeBSD filesystem and SQLite database.
1. **Immediate Reboot:**
```junos
request system reboot
```
2. **Scheduled Delayed Reboot with Broadcast Message:**
Schedule a reboot in 15 minutes and send a warning message to all logged-in CLI users:
```junos
request system reboot in 15 message "System upgrading to Junos 21.3 - Save your work!"
```
3. **Cancel Pending Reboot:**
```junos
request system reboot cancel
```
4. **Graceful System Power-Off:**
To safely power down hardware prior to physical maintenance or moving power cables:
```junos
request system power-off
```
---
## Summary Checklist
* `request system storage cleanup`: Safely cleans temporary files on `/var`.
* `request system software add`: Command used for OS upgrades.
* `request system power-off`: Halts the OS cleanly before physical power disconnection.
