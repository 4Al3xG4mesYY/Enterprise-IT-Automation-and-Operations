# Windows Health Status Audit Tool
## Purpose

Collects and evaluates Windows system health indicators including:
- Operating System Information
- Windows Update Service Status
- BITS Service Status
- Storage Utilization
- Patch Recency
- Internet Connectivity
- Pending Reboot Status

## Skills Demonstrated
- PowerShell
- Windows Administration
- Health Monitoring
- Troubleshooting
- Automation
- Compliance Validation
- System Assessment

## Sample Output
```text
=============================
Windows Health Status Tool
=============================

OS Name: Microsoft Windows 11 Enterprise
OS Version: 10.0.26200

[PASS] Windows Update Service Running
[PASS] BITS Service Running
[PASS] Disk space above 20%
[PASS] Latest patch installed within 30 days
[PASS] Internet connectivity verified
[PASS] No reboot required
```

## Example Output
![Windows_health_status_output](/Windows%20Health%20Status%20Audit%20Tool%20(PowerShell)/docs/windows_health_status_output.png)

## Future Improvements
* Export results to CSV
* Export results to HTML reports
* Additional Windows service checks
* STIG compliance integration
* Multi-system auditing
