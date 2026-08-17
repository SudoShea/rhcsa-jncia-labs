# Lab 02: Static Routes, Qualified Next-Hops & Blackhole Routing

## Objective
Configure static IPv4 and IPv6 routes, implement floating backup static routes using qualified next-hops, and configure `discard` and `reject` safety routes.

## Topology
- **Primary Path:** `ge-0/0/1` (`10.0.0.1/30` -> `10.0.0.2`)
- **Backup Path:** `ge-0/0/2` (`172.16.0.1/30` -> `172.16.0.2`)

---

## Task 1: Static IPv4 & IPv6 Route Configuration

1. Log into `vSRX-1` and enter configuration mode:
```junos
configure
```
2. Configure a default IPv4 static route pointing to `10.0.0.2`:
```junos
set routing-options static route 0.0.0.0/0 next-hop 10.0.0.2
```
3. Configure a default IPv6 static route pointing to `2001:db8:10::2`:
```junos
set routing-options rib inet6.0 static route ::/0 next-hop 2001:db8:10::2
```
4. Commit and verify active paths:
```junos
commit
run show route 0.0.0.0/0
run show route rib inet6.0 ::/0
```
---

## Task 2: Floating Static Routes using Qualified Next-Hops

A **qualified next-hop** allows you to assign a unique preference to a specific next-hop within a single static route entry, creating a floating backup path.
1. Configure a primary static route to `192.168.10.0/24` via `10.0.0.2`, with a backup qualified next-hop via `172.16.0.2` assigned a higher preference (`50`):
```junos
set routing-options static route 192.168.10.0/24 next-hop 10.0.0.2
set routing-options static route 192.168.10.0/24 qualified-next-hop 172.16.0.2 preference 50
commit
```
2. Verify active route selection in `inet.0`:
```junos
run show route 192.168.10.0/24
```
*Only* `10.0.0.2` *(Preference 5) will be marked active (*`*`*).* `172.16.0.2` *(Preference 50) stays inactive in reserve.*
---

## Task 3: Discard vs Reject Static Routes (Blackhole Targets)

Junos supports two special next-hop targets for dropping unroutable traffic or preventing routing loops:
| Target | Behaviour | ICMP Response |
| --- | --- | --- |
| `discard` | Silently drops matching packets. | None (stealth drop). |
| `reject` | Drops matching packets and notifies sender | Sends ICMP Unreachable message back to source. |

1. Configure a `discard` static route for an internal summary block:
```junos
set routing-options static route 10.100.0.0/16 discard
```
2. Configure a `reject` static route for unauthorized subnets:
```junos
set routing-options static route 10.200.0.0/16 reject
commit
```
3. Verify route properties:
```junos
run show route 10.100.0.0/16
run show route 10.200.0.0/16
```
---

## Key Exam Takeaways

* `rib inet6.0`: IPv6 static routes must be configured under the `rib inet6.0` stanza.
* **Qualified Next-Hops**: Used to construct floating static backup paths without creating duplicate route statements.
* `discard` **vs** `reject`: `discard` drops silently; `reject` drops and sends an ICMP destination unreachable reply.
