# Lab 02: Configuration File Management (Save/Load) & CLI Help Systems

## Objective
Master the built-in Junos CLI context-sensitive help systems, export/save candidate configurations to local files, practise loading configurations using various `load` options, and review J-Web service activation.

## Topology
- **Device:** `vSRX-1` (GNS3 Instance)
---
## Task 1: Context-Sensitive Help & Auto-Completion
Junos provides extensive built-in documentation directly inside the CLI without requiring internet access.
1. **Auto-Completion & Question Mark (`?`):**
   * Press `?` at any point in operational or configuration mode to see available commands or options.
   * Type `show int` and press `<Tab>` or `<Space>` to complete the command string.

2. **Using `help topic` (Usage & Concepts):**
   * View conceptual information and usage guidelines for a feature:
```junos
help topic interface ge
```

3. **Using `help reference` (Syntax Reference):**
   * View exact CLI configuration hierarchy syntax and allowed statement ranges:
```junos
help reference system host-name
```
---
## Task 2: Saving Configurations to Files
You can export the entire configuration or specific sub-trees to local disk files in either standard stanza format or executable set format.
1. Enter configuration mode:
```junos
configure
```
2. Save the active configuration in standard hierarchical stanza format:
```junos
save /var/tmp/vSRX-1-backup.conf
```
3. Save the configuration strictly as flat `set` commands:
```junos
save /var/tmp/vSRX-1-backup.set display set
```
4. Save only a specific sub-hierarchy (e.g., system settings):
```junos
edit system
save /var/tmp/system-only.conf
top
```
---
## Task 3: Loading Configurations (`load` Options)
The `load` command is a major JNCIA exam topic. It modifies the candidate configuration in memory using external files or staged text snippets.
| `load` Option | Behaviour/Exam Impact |
| --- | --- |
| `load mergre` | Combines new settings with the candidate configuration. Overwrites conflicting statements, leaves non-conflicting statements intact. |
| `load override` | Completely wipes the candidate configuration and replaces it entirely with the loaded file. |
| `load replace` | Replaces specific tagged blocks or existing statements while preserving the rest of the configuration. |
| `load set` | Loads raw single-line `set` commands typed directly or read from a `.set` file. |

### Practice Loading Options
1. Test `load set`:
Stage a bath configuration directly from set commands:
```junos
load set terminal
```
*Paste the following lines into the terminal, then paste `ctrl+D`*:
```junos
set system location "Data Centre 1, Rack 04"
set system login announcement "AUTHORIZED ACCESS ONLY"
```
2. Verify staged changes:
```junos
show | compare
```
3. Test `load override`:
Discard current candidate changes and load your saved baseline file:
```junos
load override /var/tmp/vSRX-1-backup.conf
```
*Junos confirms*: `load complete`
4. Verify and Commit:
```junos
show | compare
commit
```
---
## Task 4: J-Web Web Interface Management
J-Web is the HTTP/HTTPS web GUI for Junos devices. While most enterprise engineers use the CLI, J-Web core concepts are tested on the JNCIA blueprint.
1. Enabling J-Web Service:
To turn on J-Web management over HTTP or HTTPS on `vSRX-1`:
```junos
set system services web-management http interface ge-0/0/0.0
# Or for HTTPS:
set system services web-management https system-generated-certificate
commit
```
2. Key J-Web Capabilities to Know for the Exam:
    * **Dashboard**: Real-time monitoring of CPU, memory, storage, and active alarms.
    * **Configuration**: Point-and-click modification of interfaces, routing, and security zones.
    * **Point-in-Time Commit**: Supports commit, rollback, and candidate diff viewing visually.
---
## Verification & Summary
* `save <file>`: Exports configuration hierarchy to disk. Append `display set` for set format.
* `load merge`: Combines loaded config with existing candidate config.
* `load override`: Replaces candidate config completely (acts like a full restore).
* `load set`: Accepts set-style command syntax from file or terminal.
