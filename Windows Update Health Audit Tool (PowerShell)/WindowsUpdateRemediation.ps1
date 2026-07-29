# Stop Windows Update and related services
$steps = 4
$current = 0
$current++
Write-Progress -Activity "Windows Update Remediation" `
               -Status "Remediation Starting" `
               -PercentComplete (($current / $steps) * 100)
$LogFile = ".\WindowsUpdateRepair.log"
Start-Transcript -Path $LogFile
Write-Output "============================= Windows Update Remediation Tool =============================="
Write-Output "Process of stopping services started..."
try{
    if (Get-Service wuauserv | Where-Object {$_.Status -eq "Stopped"}) {
    Write-Host "Windows Update service already stopped. Skipping."
    }
    else {
        Stop-Service wuauserv -Force
    }
} catch {
    Write-Warning "Failed to stop Windows Update Service."
}
try{
    if (Get-Service cryptSvc | Where-Object {$_.Status -eq "Stopped"}) {
    Write-Host "Cryptographic Services already stopped. Skipping."
    }
    else {
        Stop-Service cryptSvc -Force
    }
} catch {
    Write-Warning "Failed to stop Cryptographic Services."
}
try{
    if (Get-Service bits | Where-Object {$_.Status -eq "Stopped"}) {
    Write-Host "Cryptographic Services already stopped. Skipping."
    }
    else {
        Stop-Service bits -Force
    }
} catch {
    Write-Warning "Failed to stop Background Intelligence Transfer Service."
}
try{
    if (Get-Service msiserver | Where-Object {$_.Status -eq "Stopped"}) {
    Write-Host "Cryptographic Services already stopped. Skipping."
    }
    else {
        Stop-Service msiserver -Force
    }
} catch {
    Write-Warning "Failed to stop Windows Installer Service."
}
$current++
Write-Progress -Activity "Windows Update Remediation" -Status "Stopping Services" `
               -PercentComplete (($current / $steps) * 100)
Write-Output "Stopping services has completed."

# Rename SoftwareDistribution and catroot2 to clear cache
Write-Output "Process of renaming folders and clearing cache..."
if (Test-Path "C:\Windows\SoftwareDistribution") {
    Rename-Item -Path "C:\Windows\SoftwareDistribution" `
                -NewName "SoftwareDistribution.old" `
                -Force
}
if (Test-Path "C:\Windows\catroot2") {
    Rename-Item -Path "C:\Windows\System32\catroot2" `
                -NewName "catroot2.old" `
                -Force
}
$current++
Write-Progress -Activity "Windows Update Remediation" `
               -Status "Clearing Update Cache" `
               -PercentComplete (($current / $steps) * 100)
Write-Output "Process of renaming folders and clearing cache has completed."

# Restart services
Write-Output "Process of starting services started..."
try{
    Start-Service -Name wuauserv
} catch {
    Write-Warning "Failed to start Windows Update Service."
}
try{
    Start-Service -Name cryptSvc 
} catch {
    Write-Warning "Failed to start Cryptographic Services."
}
try{
    Start-Service -Name bits
} catch {
    Write-Warning "Failed to start Background Intelligence Transfer Service."
}
try{
    Start-Service -Name msiserver
} catch {
    Write-Warning "Failed to start Windows Installer Service."
}
$current++
Write-Progress -Activity "Windows Update Remediation" `
               -Status "Starting services" `
               -PercentComplete (($current / $steps) * 100)
Write-Output "Process of starting services ended..."

$reboot = Read-Host "Restart now? (Y/N)"
if ($reboot -eq "Y") {
    Restart-Computer
}
Write-Progress -Activity "Windows Update Remediation" -Completed
Write-Host "Windows Update reset completed." -ForegroundColor Green
Read-Host "Press any key to exit"
Stop-Transcript
