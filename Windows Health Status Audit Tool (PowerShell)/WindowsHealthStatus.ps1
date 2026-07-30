# Check OS Windows version
Write-Output "============================="
Write-Output "Windows Health Status Tool"
Write-Output "============================="
Write-Output "OS Information"
$OSInfo = Get-ComputerInfo
Write-Host "OS Name: $($OSInfo.OSName)"
Write-Host "OS Version: $($OSInfo.OSVersion)"

# Windows Update Service
Write-Host "`nService Status"
Write-Host "--------------"
$WUService = Get-Service wuauserv
Write-Host "Windows Update Status: $($WUService.Status)"
if ($WUService.Status -eq "Running") {
    Write-Host "[PASS] Windows Update Service Running" -ForegroundColor Green
}
else {
    Write-Warning "[FAIL] Windows Update Service Stopped"
}


# BITS Service
$BITS_Service = Get-Service bits
Write-Host "Windows Update Status: $($BITS_Service.Status)"
if ($BITS_Service.Status -eq "Running") {
    Write-Host "[PASS] BITS Service Running" -ForegroundColor Green
}
else {
    Write-Warning "[FAIL] BITS Service Stopped"
}

Write-Host "`nStorage Status"
Write-Host "--------------"
# Disk Space
$DriveInfo = Get-PSDrive -Name C | Select-Object Name,
@{Name="Total (GB)";Expression={[math]::Round(($_.Used + $_.Free)/1GB,2)}},
@{Name="Used (GB)";Expression={[math]::Round($_.Used/1GB,2)}},
@{Name="Free (GB)";Expression={[math]::Round($_.Free/1GB,2)}},
@{Name="Percent Free";Expression={[math]::Round(($_.Free / ($_.Used + $_.Free))*100,2)}}
Write-Host "Drive: $($DriveInfo.Name)"
Write-Host "Total (GB): $($DriveInfo.'Total (GB)')"
Write-Host "Used (GB): $($DriveInfo.'Used (GB)')"
Write-Host "Free (GB): $($DriveInfo.'Free (GB)')"
Write-Host "Percent Free: $($DriveInfo.'Percent Free')%"

if ($PercentFree -gt 20) {
    Write-Host "[PASS] Disk space above 20%" -ForegroundColor Green
}
else {
    Write-Warning "[WARNING] Disk space below 20%"
}

Write-Host "`nPatch Status"
Write-Host "--------------"
# Last Installed Patch
$LatestPatch = Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1
$DaysOld = ((Get-Date) - $LatestPatch.InstalledOn).Days

if ($DaysOld -le 30) {
    Write-Host "[PASS] Latest patch installed within 30 days" -ForegroundColor Green
}
else {
    Write-Warning "[WARNING] Latest patch is older than 30 days"
}
Write-Host "Last Update Installed: $($LatestPatch.InstalledOn)"

Write-Host "`nConnectivity Status"
Write-Host "--------------"
# Internet Connectivity
$Connectivity = Test-NetConnection google.com -Port 443
if ($Connectivity.TcpTestSucceeded) {
    Write-Host "[PASS] Internet connectivity verified" -ForegroundColor Green
}
else {
    Write-Warning "[FAIL] Internet connectivity failed"
}

Write-Host "`nSystem Status"
Write-Host "--------------"
# Pending Reboot
if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired")
{
    Write-Warning "[WARNING] Pending reboot detected"
}
else
{
    Write-Host "[PASS] No reboot required" -ForegroundColor Green
}


