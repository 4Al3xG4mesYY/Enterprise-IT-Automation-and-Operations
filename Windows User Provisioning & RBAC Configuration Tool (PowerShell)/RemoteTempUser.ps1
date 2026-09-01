# Remote Temp User Tool
# Creates temporary support account and assigns RBAC permissions

$steps = 4
$current = 0
$ProvisioningSuccess = $true
$UserName = "Temp_User"

Write-Host "=============================" -ForegroundColor Cyan
Write-Host "Remote Temp User Tool" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan

# Verify Administrator Privileges
$IsAdmin = (
    [Security.Principal.WindowsPrincipal]`
    [Security.Principal.WindowsIdentity]::GetCurrent()`
).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator
)

if (-not $IsAdmin)
{
    Write-Host "[FAIL] Run PowerShell as Administrator." `
        -ForegroundColor Red
    exit
}

# Password Confirmation
do
{
    $Password1 = Read-Host "Enter password" -AsSecureString
    $Password2 = Read-Host "Confirm password" -AsSecureString

    $Ptr1 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password1)
    $Ptr2 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password2)

    $Plain1 = [Runtime.InteropServices.Marshal]::PtrToStringAuto($Ptr1)
    $Plain2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto($Ptr2)

    if ($Plain1 -ne $Plain2)
    {
        Write-Host "[FAIL] Passwords do not match." `
            -ForegroundColor Red
    }

}
until ($Plain1 -eq $Plain2)

# Create User
$current++
Write-Progress `
    -Activity "Remote Temp User Script" `
    -Status "Creating User Account" `
    -PercentComplete (($current / $steps) * 100)

if (Get-LocalUser -Name $UserName -ErrorAction SilentlyContinue)
{
    Write-Host "[WARNING] $UserName already exists." `
        -ForegroundColor Yellow

    return
}

New-LocalUser `
    -Name $UserName `
    -Password $Password1 `
    -FullName "Temporary Remote User" |
    Out-Null

Write-Host "`n[PASS] User account created." `
    -ForegroundColor Green

# Add RBAC Groups
$current++
Write-Progress `
    -Activity "Remote Temp User Script" `
    -Status "Assigning RBAC Groups" `
    -PercentComplete (($current / $steps) * 100)

$Groups = @(
    "Administrators",
    "Power Users",
    "Remote Desktop Users"
)

foreach ($Group in $Groups)
{
    try
    {
        Add-LocalGroupMember `
            -Group $Group `
            -Member $UserName `
            -ErrorAction Stop

        Write-Host "[PASS] Added to $Group." `
            -ForegroundColor Green
    }
    catch
    {
        $ProvisioningSuccess = $false

        Write-Host "[FAIL] Could not add to $Group." `
            -ForegroundColor Red
    }
}

# Validation
$current++
Write-Progress `
    -Activity "Remote Temp User Script" `
    -Status "Validating Configuration" `
    -PercentComplete (($current / $steps) * 100)

Write-Host "`nUser Created:" -ForegroundColor Cyan
Get-LocalUser $UserName

Write-Host "Assigned Groups:" -ForegroundColor Cyan

Get-LocalGroup |
ForEach-Object {

    if (
        Get-LocalGroupMember $_.Name -ErrorAction SilentlyContinue |
        Where-Object Name -like "*$UserName*"
    )
    {
        Write-Host $_.Name
    }
}

# Completion
$current++
Write-Progress `
    -Activity "Remote Temp User Script" `
    -Status "Completed" `
    -PercentComplete 100

Start-Sleep 2

Write-Progress `
    -Activity "Remote Temp User Script" `
    -Completed

if ($ProvisioningSuccess)
{
    Write-Host "`n[PASS] Temporary user provisioned successfully." `
        -ForegroundColor Green
}
else
{
    Write-Host "`n[WARNING] User created with one or more configuration failures." `
        -ForegroundColor Yellow
}