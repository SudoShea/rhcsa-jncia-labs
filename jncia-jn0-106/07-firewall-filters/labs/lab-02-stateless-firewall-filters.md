# Lab 02: Stateless Firewall Filters & Action Modifiers

## Objective
Build stateless firewall filters, configure multi-criteria terms, apply non-terminating action modifiers (`count`, `log`), apply filters to interfaces, and verify the implicit deny behaviour.

## Topology
- **Device:** `vSRX-1`
- **Interface:** `ge-0/0/0` (LAN segment: `192.168.1.1/24`)

---

## Task 1: Stateless Firewall Filter Architecture

Junos firewall filters operate statelessly at the Packet Forwarding Engine (PFE) level. Every packet is inspected independently against defined terms.

### Critical Rule: Implicit Deny
> Unlike routing policies (which fall back to protocol defaults), **firewall filters end with an implicit deny all**. If a packet does not match any explicit term in a filter, it is **silently discarded**.

---

## Task 2: Construct a Stateless Interface Filter

In this task, configure a filter to:
1. Allow ICMP traffic and count the matching packets.
2. Allow SSH management traffic (`tcp/22`) and log attempts.
3. Explicitly reject all HTTP (`tcp/80`) traffic with an ICMP response.
4. Allow all other corporate subnet traffic to prevent hitting the implicit deny.

1. Log into `vSRX-1` and enter configuration mode:
```junos
configure
```
2. Define the firewall filter named `PROTECT-INBOUND`:
```junos
# Term 1: Permit ICMP and count packets
set firewall filter PROTECT-INBOUND term ALLOW-ICMP from protocol icmp
set firewall filter PROTECT-INBOUND term ALLOW-ICMP then count icmp-counter
set firewall filter PROTECT-INBOUND term ALLOW-ICMP then accept

# Term 2: Permit SSH and log header info
set firewall filter PROTECT-INBOUND term ALLOW-SSH from protocol tcp
set firewall filter PROTECT-INBOUND term ALLOW-SSH from destination-port 22
set firewall filter PROTECT-INBOUND term ALLOW-SSH then log
set firewall filter PROTECT-INBOUND term ALLOW-SSH then accept

# Term 3: Reject HTTP traffic with ICMP unreachable
set firewall filter PROTECT-INBOUND term REJECT-HTTP from protocol tcp
set firewall filter PROTECT-INBOUND term REJECT-HTTP from destination-port 80
set firewall filter PROTECT-INBOUND term REJECT-HTTP then count http-rejected-counter
set firewall filter PROTECT-INBOUND term REJECT-HTTP then reject

# Term 4: Explicitly permit remaining local subnet traffic (overriding implicit deny)
set firewall filter PROTECT-INBOUND term ALLOW-LAN from source-address 192.168.1.0/24
set firewall filter PROTECT-INBOUND term ALLOW-LAN then accept
```
3. Apply the filter to the ingress (`input`) direction of interface `ge-0/0/0.0`:
```junos
set interfaces ge-0/0/0 unit 0 family inet filter input PROTECT-INBOUND
commit
```
---

## Task 3: Verification & Action Counters

1. Display interface filter binding status:
```junos
run show interfaces ge-0/0/0 detail | match filter
```
2. Send ping traffic from an attached host to increment the `icmp-counter`.
3. Inspect real-time filter action counters:
```junos
run show firewall filter PROTECT-INBOUND
```
4. View logged packet headers captured by the `log` modifier:
```junos
run show firewall log
```
---

## Key Exam Takeaways

* **Terminating Actions**: `accept`, `discard` (silent drop), `reject` (drop with ICMP reply).
* **Non-Terminating Modifiers**: `count`, `log`, `syslog` execute their action and then continue processing terminating actions within the same term.
* **Implicit Deny**: Always ensure a final `accept` term exists if you do not want un-matched traffic silently dropped.
