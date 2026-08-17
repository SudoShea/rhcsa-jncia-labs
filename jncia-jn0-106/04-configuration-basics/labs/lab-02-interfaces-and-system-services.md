# Lab 02: Interfaces, System Services & Traceoptions

## Objective
Configure physical and logical interfaces for IPv4 and IPv6, setup the loopback adapter (`lo0`), configure system syslog endpoints, NTP servers, debug using `traceoptions`, and configure commit archival.

## Topology
- **Device:** `vSRX-1`
- **Interfaces:** `ge-0/0/0` (LAN/Management), `ge-0/0/1` (WAN/P2P link), `lo0` (Loopback)
---
## Task 1: Physical & Logical Interface Configuration
In Junos, physical interfaces contain one or more **logical units** (`unit`), and each unit contains address families (`family inet`, `family inet6`).
1. Configure `ge-0/0/0` for local subnet access (IPv4 & IPv6):
```junos
set interfaces ge-0/0/0 unit 0 description "LAN Segment"
set interfaces ge-0/0/0 unit 0 family inet address 192.168.1.1/24
set interfaces ge-0/0/0 unit 0 family inet6 address 2001:db8:1::1/64
```
2. Configure `ge-0/0/1` as a Point-to-Point WAN link:
```junos
set interfaces ge-0/0/1 unit 0 description "P2P Link to vSRX-2"
set interfaces ge-0/0/1 unit 0 family inet address 10.0.0.1/30
```
3. Configure the Primary Loopback Interface (`lo0`):
```junos
set interfaces lo0 unit 0 description "Router ID Loopback"
set interfaces lo0 unit 0 family inet address 1.1.1.1/32
```
4. Commit the interface changes:
```junos
commit
```
---
## Task 2: System Logging (Syslog) & NTP Setup
1. Configure time zone and NTP server preferences:
```junos
set system time-zone UTC
set system ntp server 192.168.1.254 prefer
```
2. Configure Syslog to output logs to a file and a remote log server:
```junos
# Local log file for authorization events
set system syslog file auth-events change-service any

# Remote Syslog server for overall system messages
set system syslog host 192.168.1.50 any notice
```
---
## Task 3: Debugging with Traceoptions
`traceoptions` provides fine-grained protocol/service logging for operational troubleshooting.
1. Enable tracing for interface state changes:
```junos
set interfaces ge-0/0/0 traceoptions file int-debug.log
set interfaces ge-0/0/0 traceoptions file size 1m
set interfaces ge-0/0/0 traceoptions flag parse
set interfaces ge-0/0/0 traceoptions flag config-internal
commit
```
2. Monitor the trace log file live in operational mode:
```junos
run monitor file int-debug.log
```
*(Press* `CTRL+C` *to stop monitoring).*
---
## Task 4: Automated Configuration Archival
Junos can automatically transfer the active configuration to an external FTP/SFTP/HTTP server every time a `commit` is executed.
1. Configure automatic transfer on commit:
```junos
set system archival configuration transfer-on-commit
set system archival configuration archive-sites "scp://backup-user@192.168.1.50/var/backups/vsrx1/" password "Juniper123!"
commit
```
---
## Verification Commands
```junos
# View interface summary table
show interfaces terse

# Check operational interface details
show interfaces ge-0/0/0

# Verify NTP synchronization status
show ntp status

# View custom log contents
show log auth-events
```
