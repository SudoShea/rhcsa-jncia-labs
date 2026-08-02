# Changelog

All notable changes to the `rhcsa-jncia-labs` project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
