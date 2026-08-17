# Lab 01: Routing Tables, Active Route Selection & Preference

## Objective
Inspect the Junos Routing Table (`inet.0`), compare Routing Engine (RE) routes with Packet Forwarding Engine (PFE) entries, and demonstrate how Junos selects active routes (`*`) based on route preference.

## Topology
```text
[ vSRX-1 ] (ge-0/0/1: 10.0.0.1/30) <===> (ge-0/0/1: 10.0.0.2/30) [ vSRX-2 ]
  lo0.0: 1.1.1.1/32                                              lo0.0: 2.2.2.2/32
```
---

## Task 1: Inspecting `inet.0` and Active Route Selection

Junos maintains all learned routes in the Routing Table (`inet.0`). When multiple routes exist to the same destination, Junos selects one active route based on the lowest preference value.
1. Access `vSRX-1` and view the IPv4 unicast routing table:
```junos
show route
```
2. Inspect the output for direct and local interface routes:
    * `Direct` (Preference `0`): Directly connected subnets on configured interfaces.
    * `Local` (Preference `0`): Local host interface IP addresses.
    * `*` (Asterisk): Indicates the active route chosen for traffic forwarding.
3. Display exact route protocol details for the inter-router subnet:
```junos
show route 10.0.0.0/30 detail
```
*Verify the output lists preference values, protocol type, and next-hop status.*
---

## Task 2: Routing Table (RE) vs Forwarding Table (PFE)

The **Routing Table** lives on the Control Plane (Routing Engine) and holds all known paths. The **Forwarding Table** lives on the Data Plane (PFE) and holds only active forwarding paths.
1. Inspect the active route for `vSRX-2`'s interface in the Routing Engine table:
```junos
show route 10.0.0.2
```
2. Inspect the exact entry programmed into the Packet Forwarding Engine hardware:
```junos
show route forwarding-table destination 10.0.0.2
```
*Notice how the PFE table lists specific egress interfaces (*`ge-0/0/1.0`*) and next-hop MAC/interface actions.*

---

## Task 3: Route Preference Manipulation

1. Configure a static route on `vSRX-1` to reach `vSRX-2`'s loopback (`2.2.2.2/32`):
```junos
configure
set routing-options static route 2.2.2.2/32 next-hop 10.0.0.2
commit
```
2. Verify the static route is active (`*`) with a default preference of `5`:
```junos
run show route 2.2.2.2/32
```
3. Override the default static route preference to `200` (making it less preferred than BGP or RIP):
```junos
set routing-options static route 2.2.2.2/32 metric 10 preference 200
commit
```
4. Verify the updated preference in `inet.0`:
```junos
run show route 2.2.2.2/32 detail | match preference
```
---

## Key Exam Takeaways

* **Lowest Preference Wins**: Junos prefers the route with the numerically lowest preference value.
* **Tie-Breaker Hierarchy**: If preferences match, Junos evaluates metric (cost), interface index, and next-hop IP.
* **PFE Synchronization**: Only active routes marked with an asterisk (`*`) in `inet.0` are pushed to the forwarding table.
