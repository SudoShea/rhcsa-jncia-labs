# Lab 01: Operational Monitoring, Diagnostics & Interface Errors
## Objective
Utilise Junos operational `show` and `monitor` commands to inspect system health, analyze physical/logical interface error statistics, and execute diagnostic network tools with advanced flags.
## Topology
- **Device:** `vSRX-1`
- **Interfaces:** `ge-0/0/0` (LAN), `ge-0/0/1` (WAN link), `lo0.0` (1.1.1.1/32)
---
## Task 1: System Health & Hardware Inspection
1. Log into `vSRX-1` in operational mode (`root@vSRX-1>`).
2. Inspect overall system hardware components, line cards, and serial numbers:
```junos
show chassis hardware
```
3. Check routing engine CPU, memory, and temperature metrics:
```junos
show chassis routing-engine
```
4. Check process resource consumption:
```junos
show system processes extensive
```
*(Press* `q` *to exit the process view).*
5. Check filesystem storage allocation:
```junos
show system storage
```
---
## Task 2: Real-time Monitoring Commands
1. Launch real-time bandwidth monitoring on interface `ge-0/0/0`:
```junos
monitor interface ge-0/0/0
```
*Observe input/output bits per second (bps) and packet rates. Press* `q` *to exit.*
2. Monitor multiple interfaces simultaneously:
```junos
monitor interface traffic
```
3. Stream live entries added to the interactive message log:
```junos
monitor file messages
```
*(Press* `Ctrl+C` *to stop streaming).*
---
## Task 3: Analyzing Interface Statistics & Error Counters
1. Display detailed statistics for interface `ge-0/0/0`:
```junos
show interfaces ge-0/0/0 extensive
```
2. Locate the following critical error fields in the command output:
    * **Input Errors**: Errors detected on incoming frames (CRC, framing, runts).
    * **Output Errors**: Failures when attempting to transmit frames.
    * **Carrier Transitions**: Number of times the physical link state flapped between Up and Down.
    * **Active Alarms / Drops**: Queue drops caused by buffer congestion.
3. Clear interface statistical counters to establish a fresh testing baseline:
```junos
clear interfaces statistics ge-0/0/0
```
---
## Task 4: Advanced Network Diagnostic Tools
1. **Advanced Ping Options**:
Test connectivity using a non-default source address and large payload with the Don't Fragment (DF) bit set:
```junos
ping 10.0.0.2 source 1.1.1.1 count 4 size 1400 do-not-fragment
```
2. **Rapid Ping**:
Send packets without waiting for individual ICMP replies (useful for stress testing):
```junos
ping 10.0.0.2 rapid count 100
```
3. **Advanced Traceroute**:
Trace path specifying a minimum and maximum Time-to-Live (TTL):
```junos
traceroute 10.0.0.2 source 1.1.1.1 ttl 10
```
---
## Key Exam Takeaways
* `show vs monitor`: show displays a static snapshot; `monitor` provides a live updating stream.
* `clear interfaces statistics`: Resets statistical counters without impacting interface operational state.
* `do-not-fragment`: Tests path MTU boundaries when combined with the `size` parameter.
