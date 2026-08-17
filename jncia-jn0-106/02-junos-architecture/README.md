# 02. Junos OS Architecture (JN0-106)

## 📌 Domain Overview
This domain covers the internal architecture of Junos OS: the clear physical and logical separation between the **Control Plane** (Routing Engine - RE) and the **Forwarding Plane** (Packet Forwarding Engine - PFE), the modular software process structure built on FreeBSD, and the mechanics of **Transit Traffic** vs **Exception Traffic**.

---

## 🎯 Exam Objectives Covered
- **Junos OS Software Architecture:** Single OS design, modular software daemons running on a FreeBSD UNIX kernel.
- **Control Plane vs Forwarding Plane:** Separation of management/routing tasks from line-rate hardware packet forwarding.
- **Routing Engine (RE):** Brain of the system; runs software daemons (`rpd`, `mgd`, `dcd`), handles CLI/SSH, builds routing tables (`inet.0`).
- **Packet Forwarding Engine (PFE):** ASIC/PFE hardware engine; holds the forwarding table, processes transit traffic at wire speed.
- **Transit Traffic Processing:** Packets passing through the router from ingress to egress interface without targeting the router itself.
- **Exception Traffic Processing:** Packets targeting the router directly (SSH, ICMP, routing updates) or requiring special handling (IP options, TTL expiry).

---

## 🛠️ Module 02 Guides & Exercises

1. 📄 [**Lab 01: Inspecting Control vs Forwarding Plane Architecture**](labs/lab-01-control-vs-forwarding-plane.md)
   * Inspect active Junos system processes (`rpd`, `mgd`), verify PFE hardware states, and analyse transit vs exception traffic paths.

---

## ⚡ Quick Reference Cheatsheet

### Control Plane (RE) vs Forwarding Plane (PFE)
| Component | Routing Engine (RE) | Packet Forwarding Engine (PFE) |
| :--- | :--- | :--- |
| **Primary Role** | Control & Management Plane | Data Plane / Forwarding |
| **Hardware** | General-purpose x86 CPU & RAM | Specialized ASICs / Network Processors |
| **Tables Held** | **Routing Table (`inet.0`)** (All learned routes) | **Forwarding Table** (Active paths only) |
| **Core Functions** | Runs routing protocols, processes CLI commands, handles system logging, builds active state. | Wire-speed packet switching, firewall filter lookup, CoS queuing, packet counting. |
| **Failure Impact** | RE restart does NOT stop active packet forwarding if Graceful Routing Engine Switchover (GRES) / NSF is active. | Hardware failure stops physical packet transmission on bound interfaces. |

### Core Junos Daemons
| Daemon Name | Full Name | Function |
| :--- | :--- | :--- |
| **`rpd`** | Routing Protocol Daemon | Manages BGP, OSPF, RIP, IS-IS, static routes, and routing table updates. |
| **`mgd`** | Management Daemon | Handles CLI commands, user permissions, configuration commits, and XML API. |
| **`dcd`** | Device Control Daemon | Manages physical/logical interface state configurations. |
| **`chassisd`** | Chassis Daemon | Monitors fans, power supplies, line card status, and system thermals. |
| **`kernel`** | FreeBSD Kernel | Interfaces between RE software daemons and internal communication links. |
