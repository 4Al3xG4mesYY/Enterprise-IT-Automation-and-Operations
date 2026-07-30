# Check OS Windows version
Write-Output "============================= Windows Health Status Tool =============================="
Write-Output "Checks Windows OS name and OS version"
Get-ComputerInfo -Property OSName, OSVersion

# Windows Update Service
$WUService = Get-Service wuauserv
if ($WUService.Status -eq "Running") {
    Write-Host "[PASS] Windows Update Service Running" -ForegroundColor Green
}
else {
    Write-Warning "[FAIL] Windows Update Service Stopped"
}


# BITS Service
Write-Output "`nChecks Background Intelligence Transfer Service"
if ((Get-Service bits).Status -eq "Running") {
    Write-Host "[PASS] BITS Service Running" -ForegroundColor Green
}
else {
    Write-Warning "[FAIL] BITS Service Stopped"
}

# Disk Space
Write-Output "`nChecks Disk Space"
Get-PSDrive -PSProvider FileSystem | Select-Object Name,
@{Name="Total (GB)";Expression={[math]::Round(($_.Used + $_.Free)/1GB,2)}},
@{Name="Used (GB)";Expression={[math]::round($_.Used/1GB,2)}},
@{Name="Free (GB)";Expression={[math]::round($_.Free/1GB,2)}},
@{Name="Percent Free";Expression={[math]::Round(($_.Free / ($_.Used + $_.Free))*100,2)}}

$Drive = Get-PSDrive -Name C
$PercentFree = [math]::Round(($Drive.Free / ($Drive.Used + $Drive.Free)) * 100,2)

if ($PercentFree -gt 20) {
    Write-Host "[PASS] Disk space above 20%" -ForegroundColor Green
}
else {
    Write-Warning "[WARNING] Disk space below 20%"
}

# Last Installed Patch
$LatestPatch = Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1
$DaysOld = ((Get-Date) - $LatestPatch.InstalledOn).Days

if ($DaysOld -le 30) {
    Write-Host "[PASS] Latest patch installed within 30 days" -ForegroundColor Green
}
else {
    Write-Warning "[WARNING] Latest patch is older than 30 days"
}

# Internet Connectivity
$Connectivity = Test-NetConnection google.com -Port 443
if ($Connectivity.TcpTestSucceeded) {
    Write-Host "[PASS] Internet connectivity verified" -ForegroundColor Green
}
else {
    Write-Warning "[FAIL] Internet connectivity failed"
}

# Pending Reboot
if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired")
{
    Write-Warning "[WARNING] Pending reboot detected"
}
else
{
    Write-Host "[PASS] No reboot required" -ForegroundColor Green
}


