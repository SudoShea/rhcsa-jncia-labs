# Lab 02: Longest Match Routing & Layer 2/3 Packet Traversal

## Objective
Analyse how routers make forward-path decisions using the **Longest Match Rule** and trace Layer 2 MAC header rewrites vs Layer 3 IP header preservation across network hops.

---

## Scenario 1: Longest Match Routing Decisions

Assume a router's active routing table (`inet.0`) contains the following routes:

- **Route A:** `0.0.0.0/0` via `10.0.0.1`
- **Route B:** `172.16.0.0/16` via `10.0.0.2`
- **Route C:** `172.16.10.0/24` via `10.0.0.3`
- **Route D:** `172.16.10.128/25` via `10.0.0.4`

### Destination Lookup Evaluation:

| Target Destination IP | Matching Routes | Selected Route (Longest Prefix) | Next-Hop IP |
| :--- | :--- | :--- | :--- |
| **`172.16.10.130`** | Route A (`/0`), B (`/16`), C (`/24`), D (`/25`) | **Route D (`/25`)** | `10.0.0.4` |
| **`172.16.10.50`** | Route A (`/0`), B (`/16`), C (`/24`) | **Route C (`/24`)** | `10.0.0.3` |
| **`172.16.20.1`** | Route A (`/0`), B (`/16`) | **Route B (`/16`)** | `10.0.0.2` |
| **`8.8.8.8`** | Route A (`/0`) | **Route A (`/0`)** | `10.0.0.1` |

> **Key Rule:** The router **always** selects the matching route with the longest prefix mask (most specific prefix length), regardless of administrative route preference or protocol type.

---

## Scenario 2: Layer 2 vs Layer 3 Header Traversal

```text
[ Host A ] ─── (ge-0/0/0) [ Router 1 ] (ge-0/0/1) ─── [ Router 2 ]
192.168.1.10               192.168.1.1    10.0.0.1             10.0.0.2
MAC: AA:AA                 MAC: R1-A      MAC: R1-B            MAC: R2-B
```
When Host A (`192.168.1.10`) sends a packet to Host B behind Router 2:
1. **Source & Destination IP Addresses**:
    * **Source IP**: `192.168.1.10` (Unchanged end-to-end)
    * **Destination IP**: `10.0.0.2` (Unchanged end-to-end)
2. **Layer 2 MAC Addresses (Rewritten at every hop)**:
    * **Hop 1 (Host A -> Router 1)**: Src MAC = `AA:AA`, Dst MAC = `R1-A` (Resolved via ARP).
    * **Hop 2 (Router 1 -> Router 2)**: Src MAC = `R1-B`, Dst MAC = `R2-B`.
3. **TTL (Time to Live)**: Decremented by `1` at each router hop. If TTL reaches `0`, the router drops the packet and sends an ICMP Time Exceeded message back to the source.
