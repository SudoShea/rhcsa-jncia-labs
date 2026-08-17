# 06. Routing Fundamentals (JN0-106)

## 📌 Domain Overview
This domain covers the core concepts of traffic forwarding within Junos OS: the separation of the control and forwarding planes, default routing tables, route preference rules, static and floating backup routes, blackhole routes (`discard`/`reject`), dynamic routing protocol selection, and user-defined routing instances.

---

## 🎯 Exam Objectives Covered
- **Traffic Forwarding Concepts:** How Junos evaluates packets and determines next-hop forwarding decisions.
- **Routing vs Forwarding Tables:** Distinguishing the Routing Table (`inet.0` on the Routing Engine) from the Forwarding Table (kernel/Packet Forwarding Engine).
- **Default Routing Tables:** Purpose of `inet.0` (IPv4), `inet6.0` (IPv6), `inet.3` (MPLS path selection), and `inet.1` (Multicast).
- **Route Preference (Administrative Distance):** Active route selection based on default Junos preference values.
- **Static Routing:** Default routes (`0.0.0.0/0`), qualified next-hops (floating static routes), `discard` and `reject` target options.
- **Dynamic Routing Use Cases:** Use cases and trade-offs for RIP, OSPF, IS-IS, and BGP.
- **Routing Instances:** Purpose of the default `master` instance and user-created `virtual-router` instances.

---

## 🛠️ Labs in This Module

1. 📄 [**Lab 01: Routing Tables, Active Route Selection & Preference**](labs/lab-01-routing-tables-and-preference.md)
   * Inspect `inet.0`, compare RE routing tables against PFE forwarding tables, and test route preference overrides.
2. 📄 [**Lab 02: Static Routes, Qualified Next-Hops & Blackhole Routing**](labs/lab-02-static-and-aggregate-routes.md)
   * Configure static IPv4/IPv6 routes, implement floating backup routes with qualified next-hops, and set up `discard`/`reject` safety routes.
3. 📄 [**Lab 03: Virtual-Router Instances & Table Isolation**](labs/lab-03-routing-instances.md)
   * Create isolated routing instances (`virtual-router`), assign interfaces, and inspect custom instance routing tables.

---

## 📁 Configuration Snippets
- ⚙️ [`configs/vsrx-1-routing-baseline.set`](configs/vsrx-1-routing-baseline.set): Baseline routing setup for `vSRX-1`.
- ⚙️ [`configs/vsrx-2-routing-baseline.set`](configs/vsrx-2-routing-baseline.set): Baseline routing setup for `vSRX-2`.

---

## ⚡ Quick Reference Cheatsheet

### Junos Default Route Preferences (Exam Critical)
| Protocol / Route Type | Default Preference | Notes |
| :--- | :--- | :--- |
| **Directly Connected (`Direct`)** | `0` | Lowest preference (most preferred). |
| **Local Host (`Local`)** | `0` | Interface local IP address. |
| **Static Route (`Static`)** | `5` | User-defined static entry. |
| **OSPF Internal** | `10` | OSPF intra-area and inter-area routes. |
| **IS-IS Level 1 Internal** | `15` | Intermediate System to Intermediate System L1. |
| **IS-IS Level 2 Internal** | `18` | Intermediate System to Intermediate System L2. |
| **RIP** | `100` | Distance-vector protocol. |
| **OSPF External** | `150` | OSPF routes redistributed from external sources. |
| **BGP (Internal & External)** | `170` | Border Gateway Protocol (iBGP & eBGP). |

### Core System Routing Tables
| Table Name | Address Family / Purpose |
| :--- | :--- |
| **`inet.0`** | Primary IPv4 unicast routing table. |
| **`inet6.0`** | Primary IPv6 unicast routing table. |
| **`inet.3`** | MPLS path information table for BGP resolution. |
| **`inet.1`** | Multicast forwarding cache table. |

### Essential CLI Verification Commands
```junos
# Inspect primary IPv4 routing table
show route

# View routing table entry details including active status (*)
show route 10.0.0.0/30 detail

# Inspect Packet Forwarding Engine (PFE) forwarding table
show route forwarding-table destination 10.0.0.0/30

# View specific routing instance table
show route table CUSTOM-VR.inet.0
```
