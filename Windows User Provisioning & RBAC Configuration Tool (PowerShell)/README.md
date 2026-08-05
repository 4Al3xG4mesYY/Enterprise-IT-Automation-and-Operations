## Windows User Provisioning & RBAC Configuration Tool
### Overview
This PowerShell tool automates common post-imaging configuration tasks for Windows systems by creating a temporary local user account, assigning role-based access control (RBAC) permissions, and validating account configuration.
The script was inspired by real-world enterprise deployment workflows where temporary support accounts are created to assist with system provisioning, troubleshooting, and remote access requirements.

### Features
* Create a temporary local user account
* Password confirmation validation
* Detect existing accounts before creation
* Assign RBAC permissions
*   Administrators
*   Power Users
*   Remote Desktop Users
* Administrative privilege validation
* Progress tracking using `Write-Progress`
* Color-coded output
* User and group membership validation
* Error handling and reporting

### Skills Demonstrated
* Windows Administration
* Local User Management
* Group Management
* Remote Desktop Configuration
* Administrative Permissions
* PowerShell Automation
* User Provisioning
* Error Handling
* Input Validation
* Progress Indicators
* Conditional Logic

### Identity and Access Management (IAM)
* Role-Based Access Control (RBAC)
* User Validation
* Privilege Assignment

### Workflow
![WorkFlow of the script](/Windows%20User%20Provisioning%20%26%20RBAC%20Configuration%20Tool%20(PowerShell)/docs/workflow.drawio.png)
### Example Output
#### Duplicate User
![Duplicated User](/Windows%20User%20Provisioning%20%26%20RBAC%20Configuration%20Tool%20(PowerShell)/docs/duplicated_user.png)

#### Successful Creation


### Future Improvements
* Custom username input
* User removal option
* CSV logging
* Automatic password generation
* Domain account support
* Account expiration options
* Remote device provisioning support

### Technologies Used
* PowerShell
* Windows Local Users and Groups
* Windows Security Groups
* RBAC Concepts
* Windows Remote Desktop Services
