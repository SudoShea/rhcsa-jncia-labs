# Lab 03: Root Password Recovery Procedure

## Objective
Recover full administrative access to a locked Junos device by interrupting the boot sequence, booting into single-user mode, loading the `recovery` process, setting a new root password, and committing changes.

## Prerequisites
- Physical or console serial access to `vSRX-1` in GNS3.
- Access to the device reboot cycle.
---
## Step-by-Step Password Recovery Procedure
```text
[ Reboot Device ] ──> [ Interrupt Loader ] ──> [ Boot Single-User ] ──> [ Run recovery ] ──> [ Set Root Pass & Commit ]
```
---
## Step 1: Reboot and Interrupt the Boot Process
1. Restart the `vSRX-1` instance in GNS3 or issue `request system reboot` from the CLI.
2. Watch the console output carefully as FreeBSD loads.
3. When you see the prompt:
```junos
Hit [Enter] to boot immediately, or any other key for command prompt.
```
4. Press the Spacebar or Esc key immediately to interrupt the boot process.
5. You will land at the FreeBSD boot loader prompt:
```junos
OK 
# Or
loader>
```
---
## Step 2: Boot into Single-User Mode
At the `OK` (or `loader>`) prompt, boot the kernel into single-user mode:
```junos
OK boot -s
```
The bootloader will start Junos in single-user mode. When the boot sequence pauses, it presents a shell prompt asking for a shell location:
```junos    
Enter full pathname of shell or RETURN for /bin/sh:
```
Press Enter to accept the default `/bin/sh` shell. You will arrive at the single-user shell prompt (`#`).

---
## Step 3: Launch the Junos Recovery Script
At the # prompt, launch the automated Junos recovery tool:
```junos
# recovery
```
Junos will start the management process (`mgd`) without loading active database constraints or checking user credentials. You will be placed directly into Junos Operational Mode without a password:
```junos
root>
```
---
## Step 4: Configure New Root Password & Commit
1. Enter configuration mode:
```junos
configure
```
*Notice the prompt shows:* `root#`
2. Define a new compliant root authentication password:
```junos
set system root-authentication plain-text-password
```
*Type your new password twice (e.g.* `Juniper123!`*).*
3. Commit the new configuration:
```junos
commit
```
4. Exit configuration mode and restart the system normally:
```junos
exit
exit
```
5. When prompted by the shell, reboot the system:
```junos
# reboot
```
---
## Key Exam Takeaways
* **Console Access Required**: Password recovery cannot be performed over SSH or Telnet; it requires direct console access.
* **Bootloader Syntax**: The command to enter single-user mode at the `OK` prompt is `boot -s`.
* `recovery` **command**: Executed at the single-user shell prompt (`#`) to enter CLI without password checks.
* **Data Preservation**: The recovery procedure preserves all existing interface, routing, and system configurations—it only resets the root authentication credential.
