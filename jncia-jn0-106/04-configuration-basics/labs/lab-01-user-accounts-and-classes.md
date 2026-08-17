# Lab 01: User Accounts, Login Classes & RBAC Permissions

## Objective
Configure local user accounts on `vSRX-1`, assign built-in Junos login classes, build a custom Role-Based Access Control (RBAC) login class using specific match permissions, and verify user privilege boundaries.

## Topology
- **Device:** `vSRX-1`

---

## Task 1: Built-In Login Classes & User Creation
Junos provides four built-in login classes: `super-user`, `read-only`, `operator`, and `unauthorized`.
1. Access `vSRX-1` and enter configuration mode:
```junos
configure
```
2. Create an Auditor user using the built-in `read-only` class:
```junos
set system login user auditor class read-only
set system login user auditor authentication plain-text-password
```
*When prompted, enter:* `Juniper123!`
3. Create a **NOC Staff** user using the built-in `operator` class:
```junos
set system login user noc-tech class operator
set system login user noc-tech authentication plain-text-password
```
*When prompted, enter:* `Juniper123!`
4. Commit the changes:
```junos
commit
```
---
## Task 2: Create a Custom Login Class with RBAC Permissions
Exam candidates must know how to construct custom classes using `permissions`, `allow-commands`, `allow-configuration`, and `deny-configuration`.
In this task, build a `junior-admin` class that can configure interfaces and system properties, but is explicitly denied from modifying the root password or system security settings.
1. Create the custom class and grant specific permission flag:
```junos
set system login class junior-admin permissions [ configure interface system ]
```
2. Apply explicit deny rules to protect root authentication:
```junos
set system login class junior-admin deny-configuration "system root-authentication"
```
3. Assign a user to the new `junior-admin` class:
```junos
set system login user jsmith class junior-admin
set system login user jsmith authentication plain-text-password
```
*When prompted, enter:* `Juniper123!`
---
## Task 3: Verification & Inspection
1. View all configured user accounts in single-line set format:
```junos
show system login | display set
```
2. Verify active logged-in users on the system:
```junos
run show system users
```
3. Test class restriction logic by attempting to modify root settings under `jsmith`:
    *  Exit configuration mode and log in as `jsmith`.
    *  Enter `configure`.
    *  Attempt to run: `set system root-authentication plain-text-password`
    *  Observe Junos reject the command with a permission error.
---
## Key Exam Takeaways
* **Classes vs. Accounts**: Permissions are defined in Login Classes, not directly on User Accounts.
* `permissions` **array**: Controls access to broad areas (e.g. `routing`, `interface`, `firewall`, `system`).
* `deny-configuration` **regex**: Precedes allow permissions, blocking access to matching configuration stanzas.

