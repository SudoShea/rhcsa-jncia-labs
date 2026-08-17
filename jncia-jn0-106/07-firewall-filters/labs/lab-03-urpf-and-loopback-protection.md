# Lab 03: Loopback RE Protection & Unicast RPF (uRPF)

## Objective
Protect the Junos Routing Engine (Control Plane) by applying a firewall filter to the loopback interface (`lo0.0`), and implement Unicast Reverse Path Forwarding (uRPF) to drop spoofed IP traffic.

## Topology
- **Device:** `vSRX-1`
- **Interfaces:** `ge-0/0/1` (Edge interface), `lo0.0` (Routing Engine interface)

---

## Task 1: Protecting the Routing Engine via `lo0.0`

In Junos, all traffic destined to the router itself (SSH, SNMP, BGP, OSPF, ICMP) passes through the internal interface to the Routing Engine. Applying an `input` firewall filter to **`lo0.0`** protects the RE from Denial-of-Service (DoS) attacks.

1. Enter configuration mode on `vSRX-1`:
```junos
configure
```
2. Construct an RE protection filter named `PROTECT-RE`:
```junos
# Allow established BGP sessions
set firewall filter PROTECT-RE term ALLOW-BGP from protocol tcp
set firewall filter PROTECT-RE term ALLOW-BGP from port bgp
set firewall filter PROTECT-RE term ALLOW-BGP then accept

# Allow SSH access only from management subnet
set firewall filter PROTECT-RE term ALLOW-MGMT-SSH from source-address 192.168.1.0/24
set firewall filter PROTECT-RE term ALLOW-MGMT-SSH from protocol tcp
set firewall filter PROTECT-RE term ALLOW-MGMT-SSH from destination-port 22
set firewall filter PROTECT-RE term ALLOW-MGMT-SSH then accept

# Rate limit ICMP requests to the RE
set firewall filter PROTECT-RE term LIMIT-ICMP from protocol icmp
set firewall filter PROTECT-RE term LIMIT-ICMP then accept

# Discard and count all other unauthorized traffic to the RE
set firewall filter PROTECT-RE term DEFAULT-DISCARD then count re-dropped-packets
set firewall filter PROTECT-RE term DEFAULT-DISCARD then discard
```
3. Apply the filter to `lo0.0` input:
```junos
set interfaces lo0 unit 0 family inet filter input PROTECT-RE
commit
```
---

## Task 2: Unicast Reverse Path Forwarding (uRPF)

Unicast RPF prevents IP address spoofing by checking if the source address of an incoming packet matches an active route in the routing table pointing back out that same interface.

### uRPF Modes:
* **Strict Mode**: The source IP must exist in the routing table AND the active next-hop must match the interface where the packet arrived.
* **Loose Mode**: The source IP must simply exist in the routing table (regardless of interface).

1. Enable **Strict Mode uRPF** on edge interface `ge-0/0/1.0`:
```junos
set interfaces ge-0/0/1 unit 0 family inet rpf-check
commit
```
2. Enable **Loose Mode uRPF** (optional variant for multi-homed asymmetric environments):
```junos
set interfaces ge-0/0/1 unit 0 family inet rpf-check mode loose
commit
```
---

## Task 3: Verification

1. Verify uRPF configuration status on the interface:
```junos
run show interfaces ge-0/0/1 detail | match "RPF|rpf"
```
2. Monitor dropped packets on the loopback filter:
```junos
run show firewall filter PROTECT-RE
```
---

## Key Exam Takeaways

* `lo0.0` **Filter Scope**: Filtering `lo0.0` protects the Control Plane (RE). It does not filter transit traffic passing through the router.
* `rpf-check`: Configured under `interfaces <name> unit <number> family inet`.
* **Strict uRPF**: Requires matching route and matching ingress interface.
