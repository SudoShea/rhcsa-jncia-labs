# Lab 01: Inspecting Control vs Forwarding Plane Architecture

## Objective
Utilise Junos CLI commands to inspect active control plane daemons (`rpd`, `mgd`), verify PFE link communication, observe how the RE compiles the forwarding table for the PFE, and analyse exception vs transit traffic flows.

## Topology
- **Device:** `vSRX-1`

---

## Task 1: Inspect Control Plane Software Daemons

1. Log into `vSRX-1` and view active system processes from operational mode:
```junos
show system processes extensive
```
2. Identify key Junos daemons in the process list:
    * `rpd`: Routing Protocol Daemon.
    * `mgd`: User interface and configuration parser daemon.
    * `chassisd`: Chassis component state management daemon.
3. Filter process search to verify `rpd` CPU and memory footprint:
```junos
show system processes extensive | match rpd
```
---

## Task 2: Inspect Routing Engine & PFE Hardware Status

1. Display Routing Engine hardware metrics (CPU, RAM, Uptime, Temperature):
```junos
show chassis routing-engine
```
2. Display Packet Forwarding Engine (PFE) communication link status:
```junos
show chassis fpc
```
3. View PFE traffic statistics and drop counters directly:
```junos
show pfe statistics traffic
```
---

## Task 3: Traffic Flow Analysis (Transit vs Exception)

1. Transit Traffic Flow
Packets traversing through the router (e.g. Host A on `ge-0/0/0` sending data to Host B on `ge-0/0/1`):
```plaintext
[ Ingress Interface ] ──> [ PFE Lookup (Forwarding Table) ] ──> [ Egress Interface ]
```
* **Path**: Handled entirely within the **Data Plane (PFE)** at wire speed.
* **RE Involvement**: None.
2. Exception Traffic Flow
Packets addressed directly to the router (SSH to `192.168.1.1`, OSPF hellos, ICMP echo requests) or requiring CPU intervention (IP options set, TTL=1):
```plaintext
[ Ingress Interface ] ──> [ PFE Inspection ] ──Internal Link──> [ RE Processing (Daemon) ]
```
* **Path**: PFE redirects the packet over the internal internal link (rate-limited) to the **Routing Engine (RE)**.
* **RE Protection**: Internal rate limiters protect the RE CPU from being overwhelmed by flood traffic.

---

## Key Exam Takeaways

* **Control & Data Separation**: Junos keeps routing decision logic (RE) strictly separated from packet forwarding hardware (PFE).
* `inet.0` **vs Forwarding Table**: `inet.0` contains all candidate routes learned by `rpd`; the Forwarding Table contains only the single active path per prefix pushed from the RE to the PFE.
* **Exception Traffic Rate Limiting**: Traffic destined to the RE is subject to built-in rate-limiting to prevent Control Plane DoS conditions.
