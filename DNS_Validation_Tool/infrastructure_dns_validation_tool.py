#!/usr/bin/env python3

"""
Infrastructure DNS Validation Tool

Purpose:
    Validate subnet assets through:
    - ICMP reachability
    - Reverse DNS validation
    - Forward DNS validation
    - DNS consistency checks
"""

import csv
import socket
import subprocess
import platform
from datetime import datetime

# ----------------------------------------------------
# CONFIGURATION
# ----------------------------------------------------

SUBNET = "10.10.10."
START_IP = 0
END_IP = 255

DEBUG = True

OUTPUT_FILE = (
    f"infrastructure_dns_validation_"
    f"{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.csv"
)


# ----------------------------------------------------
# PING FUNCTION
# ----------------------------------------------------


def ping(ip_address):

    system = platform.system().lower()

    if system == "windows":
        cmd = ["ping", "-n", "1", "-w", "1500", ip_address]
    else:
        cmd = ["ping", "-c", "1", "-W", "2", ip_address]

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=5
        )

        return "ttl=" in result.stdout.lower()

    except Exception:
        return False

# ----------------------------------------------------
# REVERSE DNS LOOKUP
# ----------------------------------------------------

def reverse_dns(ip_address):

    try:
        hostname, aliases, addresses = socket.gethostbyaddr(
            ip_address
        )

        print(
            f"DEBUG {ip_address} -> "
            f"hostname={hostname} "
            f"aliases={aliases} "
            f"addresses={addresses}"
        )

        return hostname

    except Exception:
        return ""

# ----------------------------------------------------
# FORWARD DNS LOOKUP
# ----------------------------------------------------
def forward_dns(hostname, expected_ip):
    try:
        resolved_ip = socket.gethostbyname(hostname)
        return (
            resolved_ip == expected_ip,
            resolved_ip
        )

    except:
        return (
            False,
            ""
        )

# ----------------------------------------------------
# TESTING RESULTS
# ----------------------------------------------------
def classify_result(
        active,
        reverse_dns,
        forward_dns
):
    """
    Classifies hosts into operational categories.

    Healthy:
        Reachable with valid forward and reverse DNS.

    Active Host, No DNS Records:
        Reachable but DNS records not present.

    Review:
        Reverse DNS exists but Forward DNS validation failed.

    No Response / No DNS Records:
        Host unreachable and no DNS records located.
    """

    if (
        active == "YES"
        and reverse_dns == "YES"
        and forward_dns == "YES"
    ):
        return "Healthy"

    elif (
        active == "YES"
        and reverse_dns == "NO"
    ):
        return "Active Host, No DNS Records"

    # Reverse DNS record exists
    # Forward validation failed
    # Requires manual review

    elif (
        reverse_dns == "YES"
        and forward_dns == "NO"
    ):
        return "Review"

    elif (
        active == "NO"
        and reverse_dns == "NO"
        and forward_dns == "NO"
    ):
        return "No Response / No DNS Records"

    return "Review"

# ----------------------------------------------------
# MAIN PROCESS
# ----------------------------------------------------
def main():
    results = []

    print("\nStarting DNS Validation Scan...\n")

    for host in range(START_IP, END_IP + 1):

        ip_address = f"{SUBNET}{host}"

        print(f"Checking {ip_address}")

        fqdn = reverse_dns(ip_address)

        is_alive = ping(ip_address)

        forward_ok = False
        forward_ip = ""

        if fqdn:
            forward_ok, forward_ip = forward_dns(
                fqdn,
                ip_address
            )

        print(
            f"{ip_address} | "
            f"Active={'YES' if is_alive else 'NO'} | "
            f"ReverseDNS={'YES' if fqdn else 'NO'} | "
            f"ForwardDNS={'YES' if forward_ok else 'NO'} | "
            f"ForwardIP={forward_ip if forward_ip else 'N/A'} | "
            f"FQDN={fqdn if fqdn else 'N/A'}"
        )

        result = classify_result(
            "YES" if is_alive else "NO",
            "YES" if fqdn else "NO",
            "YES" if forward_ok else "NO"
        )

        results.append({
            "IP_Address": ip_address,
            "Active": "YES" if is_alive else "NO",
            "Reverse_DNS": "YES" if fqdn else "NO",
            "Forward_DNS": "YES" if forward_ok else "NO",
            "Forward_IP": forward_ip if forward_ip else "N/A",
            "FQDN": fqdn if fqdn else "N/A",
            "Result": result
        })

# ----------------------------------------------------
# EXPORT RESULTS
# ----------------------------------------------------

    with open(
        OUTPUT_FILE,
        "w",
        newline="",
        encoding="utf-8"
    ) as csvfile:

        writer = csv.DictWriter(
            csvfile,
            fieldnames=[
                "IP_Address",
                "Active",
                "Reverse_DNS",
                "Forward_DNS",
                "Forward_IP",
                "FQDN",
                "Result"
            ]
        )

        writer.writeheader()
        writer.writerows(results)

    print(f"\nResults written to {OUTPUT_FILE}")


if __name__ == "__main__":
    main()