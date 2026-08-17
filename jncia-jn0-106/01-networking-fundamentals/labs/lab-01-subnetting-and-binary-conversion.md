# Lab 01: Subnetting, VLSM & Binary Conversion Practice

## Objective
Master decimal-to-binary conversion, CIDR subnet mask calculations, Variable Length Subnet Masking (VLSM), and IPv6 prefix reduction required for the JNCIA-Junos exam.

---

## Exercise 1: Decimal-to-Binary Conversion

Convert the following IPv4 octets into 8-bit binary format:

1. **`192`** = `128 + 64` = `11000000`
2. **`168`** = `128 + 32 + 8` = `10101000`
3. **`172`** = `128 + 32 + 8 + 4` = `10101100`
4. **`240`** = `128 + 64 + 32 + 16` = `11110000`
5. **`254`** = `128 + 64 + 32 + 16 + 8 + 4 + 2` = `11111110`

---

## Exercise 2: IPv4 Subnet Breakdown

Given the IP network **`10.10.0.0/22`**, calculate the network parameters:

- **Subnet Mask:** `255.255.252.0`
- **Total Addresses:** `1024` (`2^(32-22) = 2^10`)
- **Usable Host Addresses:** `1022`
- **First Usable IP:** `10.10.0.1`
- **Last Usable IP:** `10.10.3.254`
- **Broadcast Address:** `10.10.3.255`

---

## Exercise 3: VLSM Design Scenario

Assign subnets from the base block **`192.168.1.0/24`** to accommodate the following requirements:

1. **Subnet A (Engineering - 50 Hosts):** Needs `/26` (62 usable IPs).
   * Network ID: `192.168.1.0/26`
   * Usable Range: `192.168.1.1 - 192.168.1.62`
   * Broadcast: `192.168.1.63`

2. **Subnet B (Sales - 25 Hosts):** Needs `/27` (30 usable IPs).
   * Network ID: `192.168.1.64/27`
   * Usable Range: `192.168.1.65 - 192.168.1.94`
   * Broadcast: `192.168.1.95`

3. **Subnet C (Point-to-Point WAN Link):** Needs `/30` (2 usable IPs).
   * Network ID: `192.168.1.96/30`
   * Usable Range: `192.168.1.97 - 192.168.1.98`
   * Broadcast: `192.168.1.99`

---

## Exercise 4: IPv6 Address Compression Rules

Shorten the following IPv6 addresses using standard RFC 5952 zero-compression rules:

1. `2001:0db8:0000:0000:0000:0000:0000:0001` ──> **`2001:db8::1`**
2. `fe80:0000:0000:0000:0204:61ff:fe9d:f153` ──> **`fe80::204:61ff:fe9d:f153`**
3. `2001:0db8:000a:0000:0000:0000:0000:0002` ──> **`2001:db8:a::2`**
