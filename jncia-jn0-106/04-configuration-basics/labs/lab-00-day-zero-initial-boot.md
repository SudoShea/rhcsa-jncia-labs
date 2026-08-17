# Lab 00: Day 0 Initialisation & Factory Default State

## Objective
Log into a factory-fresh Junos vSRX instance from the initial console prompt, set the mandatory root password, configure a hostname, perform the initial commit, and create a rescue configuration.

## Prerequisites
- Freshly booted vSRX instance in GNS3 connected via serial/text console.
---
## Step 1: Initial Login & Transition to Junos CLI
When a fresh Junos device boots, it presents the FreeBSD login prompt with the system name set to `Amnesiac`:
```text
Amnesiac (ttyd0)

login:
```
1. Log in as root (no password required on factory defaults).
2. You will be placed directly into the FreeBSD shell prompt (`root@:~ #`):
```junos
root@:~ #
```
3. Launch the Junos Operational CLI mode:
```junos
cli
```
4. You are now at the operational mode prompt (`>`):
```junos
root>
```
---
## Step 2: Set Mandatory Root Password & Hostname
Junos enforces strict password complexity out of the box. Your password must contain a mix of uppercase letters, lowercase letters, numbers, and symbols (e.g., `Juniper123!`).
1. Enter configuration mode:
```junos
configure
```
*Prompt changes to: `root#`*

2. Set the root authentication password:
```junos
set system root-authentication plain-text-password
```
*When prompted, enter a strong password meeting Junos requirements (e.g. `Juniper123!`)*
3. Set the system host-name:
```junos
set system host-name vSRX-1
```
4. Commit the initial configuration:
```junos
commit
```
*Prompt updates to reflect new host-name `root@vSRX-1`*
---
## Step 3: Create a Rescue Configuration
A **rescue configuration** is a known-good baseline saved to non-volatile storage that can be recalled if a future commit breaks remote access or corrupts configuration files.
1. Create the rescue configuration snapshot while in configuration mode:
```junos
run request system configuration rescue save
```
2. Exit to Operational Mode:
```junos
exit
```
*Prompt updates to: `root@vSRX-1>`*

3. Verify that the rescue file was saved on disk:
```junos
show system configuration rescue
```
---
# Verification & Summary
| **Command** | **Context/Mode** | **Result** |
| --- | --- | --- |
| `cli` | FreeBSD Shell (`root@:~ #`) | Enters Junos Operational Mode (`root>`). |
| `configure` | Operational Mode (`root>`) | Enters Junos Configuration Mode (`root#`). |
| `set system root-authentication plain-text-password` | Configuration Mode (`root#`) | Mandatory setting required before `commit` is permitted. |
| `set system host-name vSRX-1` | Configuration Mode (`root@vSRX-1#`) | Sets system host-name. |
| `run request system configuration rescue save` | Configuration Mode (`root@vSRX-1#`) | Saves baseline rescue configuration to disk. |
| `show system configuration rescue` | Operational Mode (`root@vSRX-1>`) | Displays the active rescue configuration buffer. |
