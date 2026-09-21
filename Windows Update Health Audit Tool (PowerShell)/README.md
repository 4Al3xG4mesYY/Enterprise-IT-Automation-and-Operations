### Enterprise Windows Update Troubleshooting & Automation
#### Overview
While working in an enterprise IT environment, I encountered multiple Windows endpoints experiencing update issues, networking problems, and update failures caused by corrupted Windows Update components.
This project demonstrates:

### Troubleshooting methodology
* Root cause analysis
* Windows Update remediation
* PowerShell automation
* Technical documentation

This repository is based on generalized troubleshooting techniques and does not contain any proprietary or confidential information.

### Problem Statement
Several systems required Windows updates but experienced issues such as:
* Outdated Windows versions
* Failed update installations
* Corrupted Windows Update cache
* Network connectivity issues
* Locked desktop environments preventing updates


### Investigation Process
#### Initial Assessment
* Reviewed update status of all endpoints
* Identified outdated systems
* Categorized devices by update readiness

#### Network Troubleshooting
* Validated Ethernet connectivity
* Confirmed network access
* Resolved communication issues affecting updates

### Windows Update Analysis
Investigated update failures and identified:
`0x80080005(CO_E_SERVER_EXEC_FAILURE)`
![Windows_updates_error](/Windows%20Update%20Health%20Audit%20Tool%20(PowerShell)/docs/Windows_Update_Error.png)
_The issue was traced to corrupted Windows Update cache components._

### Remediation Steps
#### Stop Update Services
```
net stop wuauserv
net stop cryptSvc
new stop bits
net stop msiserver
```

#### Reset Windows Update Cache
```
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
```

#### Restart Services
```
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
```
![Windows_Remediation_Commands_part_1](/Windows%20Update%20Health%20Audit%20Tool%20(PowerShell)/docs/Windows_Remediation_Commands_part_1.png)
![Windows_Remediation_Commands_part_2](/Windows%20Update%20Health%20Audit%20Tool%20(PowerShell)/docs/Windows_Remediation_Commands_part_2.png)

### Validation
* Restart system
* Re-run Windows Updates
![Update_Windows_status](/Windows%20Update%20Health%20Audit%20Tool%20(PowerShell)/docs/Update_Windows_status.png)
* Verify successful update installation
![After_Windows_Updates_completed](/Windows%20Update%20Health%20Audit%20Tool%20(PowerShell)/docs/After_Windows_Updates_completed.png)

### Results
* Multiple endpoints successfully updated
* Corrupted update cache issue resolved
* Standard remediation workflow documented
* Future automation opportunities identified

### Additional Findings
During later testing, Windows Update failures (`0x80244022 error`) persisted even after successfully:
* Restarting update services
* Resetting SoftwareDistribution
* Resetting catroot2
* Verifying service availability
* Verifying connectivity to Microsoft update endpoints

Through collaboration with senior technicians, it was determined that manually selecting:
> **Check Online for Updates**

within the Windows Update interface successfully initiated update detection and installation, while the standard "Check" or "Retry" workflow continued to fail.

### Lessons Learned
* Not all update failures originate from corrupted caches.
* Successful remediation requires validation, not just execution.
* Service, cache, and connectivity checks help eliminate common causes.
* Operational workflows may behave differently even when services are healthy.
