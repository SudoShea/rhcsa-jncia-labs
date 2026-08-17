# Changelog

All notable changes to the `rhcsa-jncia-labs` project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] - 2026-08-17

### Added
- **JNCIA-Junos (JN0-106) Complete Curriculum:**
  - **`01-networking-fundamentals`:** Subnetting exercises, decimal-to-binary conversions, IPv6 compression rules, Layer 2/3 packet traversal logic, and longest match routing lookup evaluation.
  - **`02-junos-architecture`:** Control plane (RE) vs forwarding plane (PFE) separation, modular FreeBSD daemons (`rpd`, `mgd`, `dcd`), and transit vs exception traffic mechanics.
  - **`03-user-interfaces`:** Operational vs configuration CLI modes, output pipe filters (`match`, `except`, `count`, `display set`), candidate staging, commit/rollback operations, baseline `.set` configs, and `save`/`load` file management.
  - **`04-configuration-basics`:** Day 0 initialisation, root authentication, built-in and custom RBAC login classes, IPv4/IPv6 interface properties, syslog, NTP, traceoptions debugging, and reusable configuration groups (`apply-groups`).
  - **`05-system-maintenance`:** System health monitoring, storage partition cleanup (`request system storage cleanup`), software upgrade syntax, graceful power control, and console root password recovery.
  - **`06-routing-fundamentals`:** `inet.0` routing table evaluation, default route preferences, IPv4/IPv6 static routes, floating static routes via qualified next-hops, `discard`/`reject` targets, and `virtual-router` routing instances.
  - **`07-firewall-filters`:** Import/export routing policies, prefix-lists, `route-filter` match types, stateless firewall filter terms, action modifiers (`count`, `log`), `lo0.0` Routing Engine protection, and Unicast RPF (uRPF).

### Fixed
- **Directory Hierarchy & Lab Naming:**
  - Moved `lab-01-control-vs-forwarding-plane.md` into `02-junos-architecture/labs/`.
  - Renamed duplicate `lab-01-interfaces-and-system-services.md` to `lab-02-interfaces-and-system-services.md` inside `04-configuration-basics/labs/`.

### Changed
- **Root Documentation:** Updated root `README.md` to reflect the completed domain objectives across all 7 JNCIA-Junos modules.

---

## [1.0.0] - 2026-08-03

### Added
- **RHCSA (EX200) RHEL 10 Complete Curriculum:**
  - **`01-essential-tools`:** Hands-on labs covering file navigation, hard and soft links, I/O redirection, regular expressions (`grep`/`sed`), `tar` compression (`gzip`, `bzip2`, `xz`), SSH remote transfers (`scp`, `rsync`), and system documentation (`man`, `info`, `/usr/share/doc`).
  - **`02-software-management`:** Lab guides for Flatpaks, DNF package operations, custom local `.repo` file authoring, DNF history rollbacks, package versionlocking, single-shot `at` task scheduling, and static IPv6 configuration via `nmcli`.
  - **`03-shell-scripting`:** Interactive scripting labs demonstrating variables, positional arguments (`$1`, `$2`), conditionals (`if`, `test`), file/numeric test operators, and looping constructs (`for`, `while`).
  - **`04-operating-running-systems`:** Guides for systemd boot targets, `tuned-adm` performance profiles, persistent `journalctl` storage, cron jobs, systemd timer units, GRUB2 bootloader customisation, emergency boot recovery with `rd.break`, and process management (`ps`, `top`, signals, `nice`, `renice`).
  - **`05-local-storage-and-lvm`:** Comprehensive storage labs covering GPT disk partitioning, swap allocation, LVM volume group creation and online expansion, Stratis managed storage, persistent `/etc/fstab` mounts with `_netdev`, and direct/indirect `autofs` automounting.
  - **`06-users-and-security`:** User and group lifecycle administration, password aging policies (`chage`), umask configuration, POSIX ACLs, `/etc/sudoers.d/` privilege delegation, and SELinux enforcement (modes, file contexts, port labelling, and booleans).
  - **`07-systemd-and-automation`:** Custom systemd unit file authoring, `firewalld` rich rules and service filtering, static IPv4 network configuration, and OpenSSH daemon hardening via `/etc/ssh/sshd_config.d/`.
  - **`08-podman-containers`:** Rootless Podman configuration, subuid/subgid mappings, session lingering, container registry search paths, runtime port publishing, SELinux volume relabelling (`:Z`), and automated systemd Quadlet (`.container`) service deployment.
  - **`09-mock-exam`:** Full-length, 3-hour practice mock exam synthesizing all 7 EX200 domain competencies into an end-to-end deployment scenario.

- **Infrastructure & Automation:**
  - Added Ansible VM management playbook (`playbooks/manage-lab-vms.yml`) along with inventory templates (`inventory.ini`, `inventory.local.ini`).
  - Added repository version bump utility script (`scripts/bump_version.py`).
  - Staged scaffolding directories for upcoming JNCIA-Junos track (`jncia-jn0-106/`) and topology definitions (`topologies/gns3/`, `topologies/containerlab/`).
