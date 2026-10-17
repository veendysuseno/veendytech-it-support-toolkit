# Basic IT Support Troubleshooting Guide

## Internet or network issue
1. Confirm the user is connected to Wi-Fi or Ethernet.
2. Run `Network-Diagnostics.ps1` and review the IP address, gateway, and DNS results.
3. If no valid address is assigned, investigate DHCP, cable, switch, or access point.
4. If the gateway test fails, inspect local connectivity and gateway availability.
5. If IP connectivity works but DNS resolution fails, investigate configured DNS servers.
6. Remember: firewalls may block ICMP ping.

## Slow computer
1. Review Task Manager for CPU, memory, and disk pressure.
2. Run `System-Information.ps1` and `Generate-Report.ps1`.
3. Check whether the system drive has low free space.
4. Review startup applications and pending updates using approved procedures.
5. Do not remove user files or system files without authorization.

## Printer issue
1. Check power, paper, toner/ink, cable, and network.
2. Confirm the intended printer is selected.
3. Run `Printer-Check.ps1` and inspect the queue details.
4. Do not cancel print jobs or restart the Print Spooler without authorization.

## Windows integrity concern
1. Record symptoms and recent changes.
2. Run `Repair-Check.ps1` to generate a read-only report.
3. Before any actual repair, obtain authorization, review the impact, and ensure backups/recovery options are available.
