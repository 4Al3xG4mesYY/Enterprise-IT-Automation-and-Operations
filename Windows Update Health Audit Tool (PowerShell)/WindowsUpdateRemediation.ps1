# Stop Windows Update and related services
Stop-Service -Name wuauserv -Force
Stop-Service -Name cryptSvc -Force
Stop-Service -Name bits -Force
Stop-Service -Name msiserver -Force

# Rename SoftwareDistribution and catroot2 to clear cache
if (Test-Path "C:\Windows\SoftwareDistribution") {
    Rename-Item -Path "C:\Windows\SoftwareDistribution"
                -NewName "SoftwareDistribution.old"
                -Force
}
if (Test-Path "C:\Windows\SoftwareDistribution") {
    Rename-Item -Path "C:\Windows\catroot2" 
                -NewName "catroot2.old"
                -Force
}

# Restart services
Start-Service -Name wuauserv
Start-Service -Name cryptSvc
Start-Service -Name bits
Start-Service -Name msiserver


$reboot = Read-Host "Restart now? (Y/N)"
if ($reboot -eq "Y") {
    Restart-Computer
}
Write-Host "Windows Update reset completed."
Read-Host "Press any key to exit"
