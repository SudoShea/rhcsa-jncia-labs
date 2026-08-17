# Lab 01: Junos CLI Navigation, Display Modifiers & Commit Mechanics

## Objective
Master the Junos CLI operational and configuration modes, pipe output filters, candidate configuration manipulation, and rollback mechanics on a Juniper vSRX instance.

## Topology
- **Device:** `vSRX-1` (GNS3 Instance)
- **Interface:** `ge-0/0/0` (Connected to local test subnet / VPCS)
---
## Task 1: Operational vs Configuration Modes
1. Access the console of `vSRX-1`.
2. Notice the operational mode prompt (`root@vSRX-1>`).
3. Verify basic system status using operational commands:
```junos
show version
show system uptime
```
4. Transition in configuration mode:
```junos
configure
```
5. Observe the prompt change to `root@vSRX-1#`.
6. Return to operational mode without making changes:
```junos
exit
```
---
## Task 2: CLI Navigation & Context Levels
1. Enter configuration mode again:
```junos
configure
```
2. Navigate down into the `system` hierachy:
```junos
edit system
```
*Notice the context header added above the prompt:* `[edit system]`
3. Set a location string from inside the `edit system` context:
```junos
set location "Rack 1, Lab Suite"
```
4. Step back up one level in the hierachy:
```junos
up
```
5. Jump directly back to the root of the configuration hierachy from anywhere:
```junos
top
```
---
## Task 3: Output Pipe Modifiers
Run the following operational commands from `root@vSRX-1>` to practice pipe filtering:
1. Match specific text:
```junos
show interfaces terse | match ge-
```
2. Exclude unwanted text:
```junos
show interface terse | except down
```
3. Display set syntax (essential for backups, automation, and exam questions):
```junos
show configuration system | display set
```
4. Count output lines:
```junos
show route | count
```
5. Display XML schema format:
```junos
show version | display xml
```
---
## Task 4: Candidate Configuration & Rollback Mechanics
1. Enter configuration mode and stage a hostname change in the candidate buffer:
```junos
set system host-name vSRX-Lab-Node
```
2. Inspect the difference between your uncommitted Candidate configuration and the Active running configuration:
```junos
show | compare
```
*Notice the `-` (removed) and `+` (added) line indicators*
3. Perform a syntax validation check without applying changes:
```junos
commit check
```
4. Discard your candidate changes and revert the candidate buffer to match the active configuration:
```junos
rollback 0
```
5. Verify that `show | compare` now outputs nothing.
---
## Task 5: Safety Commits & Commit History
1. Stage a change and commit with an automatic rollback timer (vital for remote management safety):
```junos
set system host-name vSRX-Testing
commit confirmed 2
```
*If you do NOT issue a follow-up `commit` command within 2 minutes, Junos will automatically revert to the previous configuration.*
2. Confirm the commit immediately to make it permanent:
```junos
commit
```
3. View the history log of recent commits (including timestamp, user, and client):
```junos
run show system commit
```
4. Inspect the configuration diff of the previous rollback state (`rollback 1`):
```junos
show | compare rollback 1
```
---
## Verification & Key Exam Takeaways
* **Operational Mode** (`>`): Used for status monitoring, diagnostic tools (`ping`, `traceroute`), and viewing state.
* **Configuration Mode** (`#`): Staging area for candidate configurations; changes take effect only after `commit`.
* `rollback 0`: Clears uncommitted staged changes from the candidate buffer.
* `rollback 1`: Reverts candidate buffer to the state of the previous committed configuration.
* `commit confirmed <minutes>`: Automatically rolls back if not confirmed within the specified window.
* `| display set`: Converts hierarchical stanza syntax into explicit single-line executable commands.
