# 01. Networking Fundamentals (JN0-106)

## 📌 Domain Overview
This module covers foundational networking concepts essential for the JNCIA-Junos exam, including OSI/TCP-IP layer interactions, Ethernet frames, MAC address resolution (ARP), IPv4/IPv6 address structures, binary math, subnetting/supernetting, longest match routing logic, Class of Service (CoS) fundamentals, and transport protocol distinctions (TCP vs UDP).

---

## 🎯 Exam Objectives Covered
- **Collision & Broadcast Domains:** Distinguishing L2 switch collision domains from L3 router broadcast domains.
- **Router vs Switch Functions:** Frame switching vs packet routing and header rewrites.
- **Ethernet & L2 Addressing:** Ethernet II frame structure, MAC address formatting, and ARP/NDP resolution.
- **IPv4 & IPv6 Addressing:** CIDR notation, subnetting, supernetting (summarisation), and IPv6 address types (Link-Local, Global Unicast, Multicast).
- **Decimal-to-Binary Conversion:** Converting IPv4 octets to binary for mask calculations.
- **Longest Match Routing:** Route selection algorithm based on prefix length.
- **Class of Service (CoS) Basics:** Marking, queuing, scheduling, and traffic shaping fundamentals.
- **Connection-Oriented vs Connectionless Protocols:** TCP 3-way handshake, reliability, and flow control vs UDP low-latency operation.

---

## 🛠️ Module 01 Guides & Exercises

1. 📄 [**Lab 01: Subnetting, VLSM & Binary Conversion Practice**](labs/lab-01-subnetting-and-binary-conversion.md)
   * Practise binary conversions, CIDR block splitting, host range calculations, and IPv6 prefix extraction.
2. 📄 [**Lab 02: Longest Match Routing & Layer 2/3 Packet Traversal**](labs/lab-02-longest-match-and-layer2-layer3.md)
   * Step through packet encapsulation/decapsulation, MAC address table updates, ARP operations, and longest prefix matching decisions.

---

## ⚡ Quick Reference Cheatsheet

### TCP vs UDP Comparison
| Feature | TCP (Connection-Oriented) | UDP (Connectionless) |
| :--- | :--- | :--- |
| **Protocol Number** | `6` | `17` |
| **Establishment** | 3-Way Handshake (`SYN` -> `SYN-ACK` -> `ACK`) | None (best-effort delivery) |
| **Reliability** | Sequence numbers, acknowledgements, retransmissions | No acknowledgements or retransmissions |
| **Flow Control** | Sliding window mechanism | None |
| **Use Cases** | SSH, BGP, HTTP/HTTPS, FTP | DNS, DHCP, NTP, VoIP, Streaming |

### IPv4 Subnet Mask Quick Reference
| CIDR Block | Subnet Mask | Total IPs | Usable Hosts |
| :--- | :--- | :--- | :--- |
| **/24** | `255.255.255.0` | 256 | 254 |
| **/25** | `255.255.255.128` | 128 | 126 |
| **/26** | `255.255.255.192` | 64 | 62 |
| **/27** | `255.255.255.224` | 32 | 30 |
| **/28** | `255.255.255.240` | 16 | 14 |
| **/29** | `255.255.255.248` | 8 | 6 |
| **/30** | `255.255.255.252` | 4 | 2 (Point-to-Point link standard) |
| **/31** | `255.255.255.254` | 2 | 2 (RFC 3021 Point-to-Point links) |
| **/32** | `255.255.255.255` | 1 | 1 (Host / Loopback `lo0.0`) |

### Binary Conversion Reference Table
| Bit Value | Bit 7 | Bit 6 | Bit 5 | Bit 4 | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Decimal Weight** | `128` | `64` | `32` | `16` | `8` | `4` | `2` | `1` |
