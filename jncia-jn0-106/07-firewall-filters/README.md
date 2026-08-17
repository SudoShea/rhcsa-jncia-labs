# 07. Routing Policy and Firewall Filters (JN0-106)

## 📌 Domain Overview
This domain covers the mechanisms Junos OS uses to control route propagation and filter data traffic. You will explore routing policies (which control the Routing Table and protocol route advertising) and stateless firewall filters (which inspect and act upon transit or exception traffic at the interface level).

---

## 🎯 Exam Objectives Covered
- **Routing Policy Concepts:** Import and export policies, evaluation order (top-to-bottom, term-by-term), and term action mechanics.
- **Default Routing Policies:** Default import/export actions for BGP, OSPF, RIP, Direct, and Static routes.
- **Policy Match Criteria & Actions:** `from` match parameters (prefix-lists, route-filters, protocol) and `then` actions (`accept`, `reject`, `next term`, `next policy`).
- **Firewall Filter Concepts:** Stateless packet inspection, filter terms, directionality (`input` vs `output`), and the implicit deny at the end of filters.
- **Firewall Actions & Modifiers:** Terminating actions (`accept`, `discard`, `reject`) and non-terminating action modifiers (`count`, `log`, `syslog`).
- **Unicast RPF (uRPF):** Loose vs strict uRPF mechanics for anti-spoofing protection.

---

## 🛠️ Labs in This Module

1. 📄 [**Lab 01: Routing Policy Structure, Evaluation & Match Criteria**](labs/lab-01-routing-policy-fundamentals.md)
   * Construct import/export policy chains, test prefix-list match types, and evaluate policy flow.
2. 📄 [**Lab 02: Stateless Firewall Filters & Action Modifiers**](labs/lab-02-stateless-firewall-filters.md)
   * Build interface firewall filters, configure term match criteria, and track dropped traffic with action counters.
3. 📄 [**Lab 03: Loopback RE Protection & Unicast RPF (uRPF)**](labs/lab-03-urpf-and-loopback-protection.md)
   * Protect the Routing Engine by binding filters to `lo0.0`, and configure strict uRPF validation on ingress interfaces.

---

## 📁 Configuration Snippets
- ⚙️ [`configs/vsrx-1-policy-filter-baseline.set`](configs/vsrx-1-policy-filter-baseline.set): Complete set commands for Module 07 policy and filter configurations.

---

## ⚡ Quick Reference Cheatsheet

### Default Junos Routing Policies (Exam Critical)
| Protocol | Default Import Action | Default Export Action |
| :--- | :--- | :--- |
| **BGP** | Accept all BGP routes. | Export all active BGP routes. |
| **OSPF** | Accept all OSPF routes into `inet.0`. | Reject everything (must use explicit export policy to redistribute). |
| **RIP** | Accept all RIP routes. | Reject everything (must use explicit export policy to redistribute). |
| **Direct / Static** | N/A (Locally generated). | Reject everything (not advertised unless explicitly exported). |

### Match Types for `route-filter`
| Match Type | Rule Description | Example: `10.0.0.0/16` |
| :--- | :--- | :--- |
| **`exact`** | Matches only the specified prefix and length. | `10.0.0.0/16` only |
| **`longer`** | Matches any prefix within the block with a longer netmask length. | `10.0.1.0/24`, `10.0.1.4/30` |
| **`orlonger`** | Matches the exact prefix OR any longer netmask length within it. | `10.0.0.0/16`, `10.0.1.0/24` |
| **`upto /prefix-length`** | Matches prefixes within the block up to a maximum netmask length. | `10.0.0.0/16 upto /20` |

### Key Policy vs Filter Differences
| Feature | Routing Policies | Firewall Filters |
| :--- | :--- | :--- |
| **Target Data** | Control Plane (Routes / Network prefixes) | Data/Control Plane (Individual IP Packets) |
| **State Processing** | Evaluates route attributes in memory | Stateless (inspects packet headers line-by-line) |
| **Default Action if Unmatched** | Fall back to protocol default policy | **Implicit Deny** (Silently discards unmatched packets) |
| **Application Point** | Applied under `protocols` or `routing-options` | Applied to interfaces (`input` or `output`) |
