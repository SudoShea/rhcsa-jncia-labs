# Lab 03: Reusable Configuration Groups

## Objective
Create reusable configuration templates using Junos **Configuration Groups** (`groups`), apply them globally or to specific hierarchies using `apply-groups`, and inspect inherited configuration statements.

## Topology
- **Device:** `vSRX-1`
---
## Task 1: Create a System Baseline Configuration Group
Configuration groups allow you to define common stanzas (like domain names, NTP, syslog, or interface options) once, and inherit them across the device.
1. Enter configuration mode:
```junos
configure
```
---
## Task 2: Apply Configuration Groups
A group does not take effect until it is referenced via an `apply-groups` statement.
1. Apply `GLOBAL-BASELINE` at the top level of the configuration:
```junos
set apply-groups GLOBAL-BASELINE
```
2. Apply `ETH-INTERFACES` specifically under the interfaces stanza:
```junos
set interfaces apply-groups ETH-INTERFACES
```
3. Commit the candidate configuration:
```junos
commit
```
---
## Task 3: Inspecting Group Inheritance
When running standard `show` commands, Junos hides group-inherited statements to keep output concise. You must use `| display inheritance` to view merged inherited settings.
1. Run standard show on interfaces:
```junos
show interfaces ge-0/0/0
```
*Notice the MTU setting from the group is not explicitly printed.*
2. Run show with inheritance display enabled:
```junos
show interfaces ge-0/0/0 | display inheritance
```
*Notice lines inherited from the group are displayed along with an annotation indicating the originating group name: ## 'GLOBAL-BASELINE' inherited from group.*
---
## Key Exam Takeaways
* `groups <name>`: Defines the template stanza.
* `apply-groups <name>`: Activates the template at the current hierarchy or root.
* `| display inheritance`: Displays the active configuration merged with all applied group statements.
* **Direct config overrides group config**: Explicitly defined statements always take precedence over group-inherited values.
