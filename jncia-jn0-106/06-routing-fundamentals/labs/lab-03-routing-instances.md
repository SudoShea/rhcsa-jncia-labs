# Lab 03: Virtual-Router Instances & Table Isolation

## Objective
Create a custom `virtual-router` routing instance to isolate traffic, assign interfaces to the instance, manage independent routing tables, and test inter-instance isolation.

## Topology
- **Default Master Instance (`default`):** Interface `ge-0/0/0`
- **Custom Instance (`CUSTOM-VR`):** Interface `ge-0/0/1`

---

## Task 1: Understanding Junos Routing Instances

By default, all interfaces and routes belong to the global `master` routing instance (`inet.0`). Junos supports creating private, isolated routing instances for multi-tenancy or logical separation.

### Core Instance Types Tested on JN0-106:
* **`master`**: Default global routing instance created by Junos.
* **`virtual-router`**: Functional equivalent of a VRF without MPLS/VPN requirements. Maintains independent routing and forwarding tables (`<name>.inet.0`).
* **`forwarding`**: Used for filter-based forwarding (FBF).

---

## Task 2: Creating a `virtual-router` Instance

1. Log into `vSRX-1` and enter configuration mode:
```junos
configure
```
2. Create the routing instance named `CUSTOM-VR`:
```junos
set routing-instances CUSTOM-VR instance-type virtual-router
```
3. Bind interface `ge-0/0/1.0` to the new instance:
```junos
set routing-instances CUSTOM-VR interface ge-0/0/1.0
```
4. Configure a static default route inside `CUSTOM-VR`:
```junos
set routing-instances CUSTOM-VR routing-options static route 0.0.0.0/0 next-hop 10.0.0.2
commit
```
---

## Task 3: Verifying Instance Isolation & Routing Tables

1. View all active routing instances on the system:
```junos
run show routing-instances
```
2. Inspect the global routing table (`inet.0`):
```junos
run show route table inet.0
```
*Notice* `ge-0/0/1.0` *and the static route* `0.0.0.0/0` *are no longer in* `inet.0`.
3. Inspect the custom instance routing table (`CUSTOM-VR.inet.0`):
```junos
run show route table CUSTOM-VR.inet.0
```
4. Execute ping tests originating specifically from inside the `CUSTOM-VR` instance:
```junos
run ping 10.0.0.2 routing-instance CUSTOM-VR
```
---

## Key Exam Takeaways

* `virtual-router`: Creates a completely separate routing table independent of `inet.0`.
* **Interface Ownership**: An interface can belong to only one routing instance at a time.
* **Instance Execution**: Diagnostic commands (`ping`, `traceroute`) require the `routing-instance <name>` flag when testing targets bound to custom instances.
