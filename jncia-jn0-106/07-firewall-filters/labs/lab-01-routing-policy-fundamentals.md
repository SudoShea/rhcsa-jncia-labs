# Lab 01: Routing Policy Structure, Evaluation & Match Criteria

## Objective
Construct Junos routing policies, evaluate top-to-bottom term processing rules, utilise prefix-lists and `route-filter` match criteria, and apply export policies to redistribute routes into routing protocols.

## Topology
- **Device:** `vSRX-1`
- **Interfaces:** `ge-0/0/1` (`10.0.0.1/30`), `lo0.0` (`1.1.1.1/32`)

---

## Task 1: Policy Term Structure & Evaluation Rules

Routing policies are evaluated in order:
1. **Term Order:** Terms are processed sequentially from top to bottom.
2. **Match Evaluation:** If a route matches all `from` criteria in a term, the `then` action is executed.
3. **Terminating Actions:** `accept` or `reject` ends evaluation for that route.
4. **Flow-through Actions:** `next term` or `next policy` continues evaluation down the chain.
5. **No Match:** If a route does not match any term, Junos applies the **default policy** for that protocol.

```text
[ Route Candidate ] ──> [ Term 1: Match? ] ──Yes──> [ Action: Accept/Reject ]
                               │ No
                               ▼
                        [ Term 2: Match? ] ──Yes──> [ Action: Accept/Reject ]
                               │ No
                               ▼
                        [ Default Protocol Policy ]
```
---

## Task 2: Build a Redistribution Export Policy

In this task, build an export policy that redistributes static and direct routes into OSPF, while filtering out private management addresses.
1. Access `vSRX-1` and enter configuration mode:
```junos
configure
```
2. Create a prefix-list to define allowed internal prefixes:
```junos
set policy-options prefix-list INTERNAL-NETS 192.168.1.0/24
set policy-options prefix-list INTERNAL-NETS 10.0.0.0/24
```
3. Construct the policy named `EXPORT-TO-OSPF`:
```junos
# Term 1: Accept local interface routes matching the prefix list
set policy-options policy-statement EXPORT-TO-OSPF term PERMIT-INTERNAL from protocol direct
set policy-options policy-statement EXPORT-TO-OSPF term PERMIT-INTERNAL from prefix-list INTERNAL-NETS
set policy-options policy-statement EXPORT-TO-OSPF term PERMIT-INTERNAL then accept

# Term 2: Explicitly reject 172.16.0.0/12 subnets using route-filter orlonger
set policy-options policy-statement EXPORT-TO-OSPF term BLOCK-PRIVATE from route-filter 172.16.0.0/12 orlonger
set policy-options policy-statement EXPORT-TO-OSPF term BLOCK-PRIVATE then reject

# Term 3: Accept all remaining static routes
set policy-options policy-statement EXPORT-TO-OSPF term PERMIT-STATIC from protocol static
set policy-options policy-statement EXPORT-TO-OSPF term PERMIT-STATIC then accept
```
4. Apply the policy as an export policy under OSPF:
```junos
set protocols ospf export EXPORT-TO-OSPF
set protocols ospf area 0.0.0.0 interface ge-0/0/1.0
commit
```
---

## Task 3: Verification & Inspection

1. Inspect the compiled policy structure:
```junos
run show policy EXPORT-TO-OSPF
```
2. Test policy evaluation against a specific target route without altering traffic:
```junos
run test policy EXPORT-TO-OSPF 192.168.1.0/24
run test policy EXPORT-TO-OSPF 172.16.10.1/32
```
---

## Key Exam Takeaways

* **Import vs Export**: `import` controls routes entering `inet.0` from a protocol; `export` controls routes leaving `inet.0` to be advertised by a protocol.
* **Prefix-lists**: Named lists of IP addresses used for fast matching inside policy terms.
* `test policy`: Operational tool to test how a policy evaluates a specific prefix.
