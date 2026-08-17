# RHCSA (EX200 on RHEL 10) & JNCIA-Junos (JN0-106) Engineering Labs ⚡

[![Version](https://img.shields.io/github/v/tag/SudoShea/rhcsa-jncia-labs?label=release&color=blue)](https://github.com/SudoShea/rhcsa-jncia-labs/tags)
[![Licence: MIT](https://img.shields.io/badge/Licence-MIT-yellow.svg)](LICENSE)
[![RHEL 10](https://img.shields.io/badge/OS-RHEL%2010-red?logo=redhat)](https://www.redhat.com/)
[![Junos OS](https://img.shields.io/badge/Exam-JN0--106-blue?logo=junipernetworks)](https://www.juniper.net/)

Hands-on laboratories, Ansible automation playbooks, and topology definitions designed for mastering the **Red Hat Certified System Administrator (EX200 on RHEL 10)** and **Juniper Networks Certified Associate Junos (JN0-106)** certification tracks.

---

## 🎯 Exam Objectives & Tracks

### Track 1: RHCSA (EX200) — Red Hat Enterprise Linux 10
* **Essential System Tools:** Shell navigation, I/O redirection, regular expressions, tar archives, SSH file transfer, `/usr/share/doc`.
* **Software & Maintenance:** RPM repositories, DNF package handling, Flatpak configuration, versionlocking, `at` scheduling, static IPv6.
* **Shell Scripting:** Executable shell scripts using conditional execution (`if`, `test`), loops (`for`), and parameter processing (`$1`, `$2`).
* **Operating Running Systems:** Boot targets, `tuned-adm` profiles, persistent `journalctl`, systemd timers, GRUB bootloader, `rd.break` emergency password reset, process control (`nice`/`renice`, signals).
* **Storage & File Systems:** GPT partitioning, swap, LVM creation/expansion, Stratis storage, XFS/ext4/VFAT file systems, UUID mounting, NFS shares & `autofs`.
* **Security & Access Controls:** User accounts, password aging (`chage`), umask, POSIX ACLs, sudoers delegation, SELinux file/port labelling & booleans, `firewalld`.
* **System Automation & Hardening:** Custom systemd services, `nmcli` static networking, SSH daemon hardening (`sshd_config.d`).
* **Containers & Persistence:** Rootless Podman management, subuid mapping, image inspection, volume attachments (`:Z`), and systemd Quadlets.
* **Mock Exam:** A comprehensive 3-hour practice exam covering all domain objectives.

### Track 2: JNCIA-Junos (JN0-106) — Junos OS
* **Networking Fundamentals:** OSI/TCP-IP models, IPv4/IPv6 subnetting, binary conversions, L2 vs L3 traversal, and longest match routing logic.
* **Junos Architecture:** Control Plane (Routing Engine) vs Forwarding Plane (Packet Forwarding Engine), modular FreeBSD daemons, and transit vs exception traffic.
* **CLI Mechanics & User Interfaces:** Operational vs Configuration modes, pipe output filters, candidate configuration staging, `commit check/confirmed`, `rollback`, and file management (`save`/`load`).
* **Configuration Basics:** Day 0 initialisation, root password enforcement, RBAC login classes, user accounts, IPv4/IPv6 interface properties, syslog, NTP, traceoptions, and configuration groups.
* **Operational Maintenance:** System health inspection, error tracking, storage cleanup, software upgrade syntax, graceful power management, and console root password recovery.
* **Routing Fundamentals:** `inet.0` routing table evaluation, route preference, IPv4/IPv6 static routing, floating static routes via qualified next-hops, discard/reject routes, and `virtual-router` instances.
* **Routing Policy & Firewall Filters:** Import/export routing policies, prefix-lists, stateless firewall filters, action modifiers (`count`/`log`), `lo0.0` Routing Engine protection, and Unicast RPF (uRPF).

---

## 🛠️ Repository Structure

```text
rhcsa-jncia-labs/
├── .github/
│   └── workflows/
│       └── lint.yml                 # ShellCheck & Ansible-lint quality gates
├── playbooks/
│   └── manage-lab-vms.yml           # Ansible VM provisioning & environment playbooks
├── rhcsa-rhel10/                    # RHCSA (EX200) Objectives on RHEL 10
│   ├── 01-essential-tools/          # Shell syntax, grep, archives, SSH, documentation
│   ├── 02-software-management/      # RPM repos, DNF management, Flatpaks, at tasks, IPv6
│   ├── 03-shell-scripting/          # Script conditionals, loops, positional arguments
│   ├── 04-operating-running-systems/# Boot targets, tuning profiles, journalctl, emergency boot, process control
│   ├── 05-local-storage-and-lvm/    # GPT partitions, LVM, Stratis, UUID mounting, NFS & autofs
│   ├── 06-users-and-security/       # User management, ACLs, sudoers, SELinux modes/contexts/booleans
│   ├── 07-systemd-and-automation/   # Systemd services, firewalld, static IPv4, SSH hardening
│   ├── 08-podman-containers/        # Rootless containers, volume mounts, systemd Quadlets
│   └── 09-mock-exam/                # Full RHCSA practice exam
├── jncia-jn0-106/                   # JNCIA-Junos (JN0-106) Objectives
│   ├── 01-networking-fundamentals/  # Layer 2/3 headers, IPv4/IPv6 subnetting
│   ├── 02-junos-architecture/       # RE vs PFE, packet handling, transit traffic
│   ├── 03-user-interfaces/          # CLI modes, pipe filters, operational show
│   ├── 04-configuration-basics/     # Candidate config, commit check/confirmed/rollback
│   ├── 05-system-maintenance/       # Factory defaults, rescue config, Junos upgrades
│   ├── 06-routing-fundamentals/     # inet.0, static routes, single-area OSPF
│   └── 07-firewall-filters/         # Stateless terms, match conditions, lo0 policing
├── topologies/                      # Lab Environments
│   ├── gns3/                        # GNS3 project files for vSRX & RHEL 10 nodes
│   └── containerlab/                # Containerlab topology files (cRPD + Linux)
├── scripts/
│   └── bump_version.py              # Repository version management utility
├── .gitignore
├── CHANGELOG.md
├── inventory.ini                    # Ansible inventory definition
├── inventory.local.ini              # Local environment overrides
├── LICENSE
├── README.md
└── VERSION
```
---

## 🚀 Quick Start

### Managing Lab Virtual Machines via Ansible
```bash
git clone https://github.com/SudoShea/rhcsa-jncia-labs.git
cd rhcsa-jncia-labs

ansible-playbook -i inventory.ini playbooks/manage-lab-vms.yml
```
---

# 📄 Licence

Distributed under the MIT Licence. See `LICENSE` for details.
