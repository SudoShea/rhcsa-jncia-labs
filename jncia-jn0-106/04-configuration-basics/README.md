# 04. Configuration Basics (JN0-106)

## 📌 Domain Overview
This domain covers the core administration tasks required to manage a Junos device day-to-day. You will master initial setup, local user account administration, RBAC login classes, logical and physical interface configurations, system log (syslog) parameters, NTP, traceoptions debugging, configuration archival, and re-usable configuration groups.

---

## 🎯 Exam Objectives Covered
- **Factory-Default State & Day 0 Setup:** Amnesiac boot state, root password enforcement, rescue configurations.
- **User Accounts & Authentication:** Setting up local accounts, plain-text passwords, SSH key references.
- **Login Classes (RBAC):** Built-in classes (`super-user`, `read-only`, `operator`, `unauthorized`) and custom class permissions (`permissions`, `allow-commands`, `deny-configuration`).
- **Interface Types & Properties:** Interface naming (`ge-`, `xe-`, `lo0`, `fxp0`), logical units (`unit 0`), protocol families (`family inet`, `family inet6`).
- **System Services:** Syslog facilities/severities, NTP, SNMP basics.
- **Logging & Tracing:** Configuring `traceoptions` for operational debugging.
- **Configuration Archival:** Auto-backing up candidate/active configurations on commit.
- **Configuration Groups:** Reusable templates using `groups` and `apply-groups`.

---

## 🛠️ Labs in This Module

1. 📄 [**Lab 00: Day 0 Initialisation & Factory Default State**](labs/lab-00-day-zero-initial-boot.md)
   * Initial amnesiac boot, setting root password, hostname, and creating the baseline rescue configuration.
2. 📄 [**Lab 01: User Accounts, Login Classes & RBAC Permissions**](labs/lab-01-user-accounts-and-classes.md)
   * Create local accounts, explore built-in login classes, and construct a custom restricted admin class.
3. 📄 [**Lab 02: Interfaces, System Services & Traceoptions**](labs/lab-02-interfaces-and-system-services.md)
   * Configure physical/logical interfaces (IPv4/IPv6), loopback adapters, syslog targets, NTP, traceoptions, and auto-archival.
4. 📄 [**Lab 03: Reusable Configuration Groups**](labs/lab-03-configuration-groups.md)
   * Construct configuration templates using `groups`, apply them globally/locally, and inspect inheritances with `| display inheritance`.

---

## 📁 Configuration Snippets
- ⚙️ [`configs/vsrx-1-module-04-complete.set`](configs/vsrx-1-module-04-complete.set): Combined `.set` commands containing all Module 04 user, interface, and service configurations.

---

## ⚡ Quick Reference Cheatsheet

### Built-in Login Classes
| Class | Operational Access | Configuration Access | Use Case |
| :--- | :--- | :--- | :--- |
| **`super-user`** | Full | Full | Root/Senior Admin equivalent. |
| **`read-only`** | Full (`show`) | None | Auditors, monitoring tools. |
| **`operator`** | Limited (`ping`, `traceroute`, `clear`) | None | First-level NOC support staff. |
| **`unauthorized`** | None | None | Temporarily suspended accounts. |

### Interface Naming Conventions
- **`ge-0/0/0`**: **G**igabit **E**thernet | Slot **0** | Flexible PIC Concentrator (FPC) **0** | Port **0**
- **`xe-1/0/2`**: 10-Gigabit Ethernet | Slot **1** | FPC **0** | Port **2**
- **`lo0.0`**: Loopback Interface | Unit **0** (Always logical unit 0 for main loopback)
- **`fxp0`**: Out-of-Band Management Interface

### Essential CLI Operations
```junos
# User & Class Creation
set system login class net-sec permissions [ configure firewall ]
set system login user sec-admin class net-sec authentication plain-text-password

# Interface IP Assignment
set interfaces ge-0/0/0 unit 0 family inet address 192.168.1.1/24
set interfaces ge-0/0/0 unit 0 family inet6 address 2001:db8::1/64

# Syslog & NTP
set system syslog host 192.168.1.50 any change-service
set system ntp server 192.168.1.254 prefer

# Configuration Groups
set groups BASE-SYSTEM system time-zone UTC
set apply-groups BASE-SYSTEM
show | display inheritance
```
