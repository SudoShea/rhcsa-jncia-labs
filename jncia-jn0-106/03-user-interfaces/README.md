# 03. User Interfaces (JN0-106)

## 📌 Domain Overview
This module covers the operational and configuration mechanics of the Junos user interface, focusing on CLI navigation, configuration staging, commit/rollback operations, configuration file management, built-in help systems, and J-Web fundamentals.

---

## 🎯 Exam Objectives Covered
- **CLI Functionality & Modes:** Operational mode vs. Configuration mode.
- **CLI Navigation:** Navigating hierarchical levels (`edit`, `up`, `top`, `exit`).
- **CLI Help:** `?`, `help topic`, and `help reference`.
- **Output Filtering:** Modifiers (`match`, `except`, `count`, `display set`, `display xml`).
- **Active vs. Candidate Configuration:** Staging changes, `show | compare`, `commit check`.
- **Rollback Mechanics:** `rollback 0`, `rollback 1..50`, `commit confirmed`.
- **Managing Configuration Files:** `save` and `load` options (`merge`, `override`, `replace`, `set`).
- **J-Web Fundamentals:** Core features and web management service activation.

---

## 🛠️ Prerequisites & Labs

> **Prerequisite:** Before starting the labs in this module, ensure your vSRX instance has completed **Day 0 Initialisation** (root password and hostname set). Refer to:
> 📄 [`../04-configuration-basics/labs/lab-00-day-zero-initial-boot.md`](../04-configuration-basics/labs/lab-00-day-zero-initial-boot.md)

### Module 03 Labs
1. 📄 [**Lab 01: CLI Navigation, Display Modifiers & Commit Mechanics**](labs/lab-01-cli-navigation.md)
   * Practise transitioning between modes, hierarchical navigation, output modifiers, staging candidate changes, and `rollback` operations.
2. 📄 [**Lab 02: Configuration File Management & CLI Help Systems**](labs/lab-02-config-management-and-help.md)
   * Practise built-in `help` lookups, saving configuration files to disk, loading staged changes via `load set` / `load override`, and enabling J-Web.

---

## 📁 Configuration Snippets
- ⚙️ [`configs/vsrx-1-base.set`](configs/vsrx-1-base.set): Baseline `set`-style configuration for `vSRX-1`.
- ⚙️ [`configs/sample-load-test.set`](configs/sample-load-test.set): Staged payload file for testing `load set` and `load merge` operations.

---

## ⚡ Quick Reference Cheatsheet

### CLI Navigation & Modes
| Action | Command | Mode |
| :--- | :--- | :--- |
| Enter CLI from Shell | `cli` | FreeBSD Shell (`%` / `#`) |
| Enter Config Mode | `configure` | Operational (`>`) |
| Move down a hierarchy | `edit <stanza>` | Configuration (`#`) |
| Move up one level | `up` | Configuration (`#`) |
| Return to root hierarchy | `top` | Configuration (`#`) |
| Exit to operational | `exit` | Configuration (`#`) |

### Pipe Output Filters
| Modifier | Purpose |
| :--- | :--- |
| `\| match <text>` | Displays only lines matching `<text>`. |
| `\| except <text>` | Excludes lines matching `<text>`. |
| `\| display set` | Converts hierarchical stanzas into single-line executable `set` commands. |
| `\| count` | Counts output lines returned by the command. |
| `\| display xml` | Outputs the XML schema representations of operational data. |

### Configuration Staging & Rollback
| Command | Action |
| :--- | :--- |
| `show \| compare` | Displays diff between Candidate and Active configurations. |
| `commit check` | Validates syntax without applying candidate changes. |
| `rollback 0` | Discards uncommitted candidate changes in memory. |
| `rollback 1` | Reverts candidate buffer to the previous committed state. |
| `commit confirmed <min>` | Commits changes with an automatic rollback timer for safety. |
| `save <file>` | Exports current configuration hierarchy to local disk. |
| `load merge <file>` | Combines file statements with current candidate configuration. |
| `load override <file>` | Replaces candidate configuration completely with file contents. |
| `load set terminal` | Accepts raw `set` commands directly pasted into the terminal session. |
