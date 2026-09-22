# STIG Remediation - WN11-00-000125

## Overview

This project demonstrates automated remediation of a Windows 11 Security Technical Implementation Guide (STIG) finding using PowerShell.

The script identifies whether Microsoft Copilot is installed and performs remediation according to Windows 11 STIG WN11-00-000125 requirements.

This project is part of a larger Windows STIG Compliance Framework focused on compliance validation, remediation, and verification of security controls.

## STIG Information

Rule ID: SV-268317

STIG ID: WN11-00-000125

Severity: CAT II

Requirement:

Microsoft Copilot must be disabled for Windows 11.

## Security Risk

Copilot may communicate externally and retrieve data or components.

Disabling the feature reduces the possibility of sensitive information leaving enterprise environments and minimizes uncontrolled feature updates.

## Remediation Workflow
1. Check for installed Copilot package
2. Determine compliance status
3. Remove the package if present
4. Verify successful removal
5. Report compliance status

Example Outputs:

========= Copilot Tool Removal ==========

Detected Copilot Package...

Proceed Copilot Package Removal...

Copilot Successfully Removed!

Copilot Removal Completed!

## Skills Demonstrated
- PowerShell
- Windows Administration
- Compliance Validation
- Security Hardening
- Remediation Workflows
- Verification Procedures
- STIG Implementation

## Lessons Learned
- Security compliance requires both identification and remediation.
- Verification is necessary after remediation actions.
- PowerShell can automate repetitive compliance checks.
- STIG controls can be translated into repeatable operational workflows.
