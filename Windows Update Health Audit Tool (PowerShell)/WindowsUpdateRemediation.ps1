# Stop Windows Update and related services
$steps = 4
$current = 0
$current++
Write-Progress -Activity "Windows Update Remediation" `
               -Status "Remediation Starting" `
               -PercentComplete (($current / $steps) * 100)
Start-Sleep 2

$LogFile = ".\WindowsUpdateRepair.log"
Start-Transcript -Path $LogFile
Write-Host "============================="  -ForegroundColor Cyan
Write-Host "Windows Update Remediation Tool" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "Process of stopping services started..." -ForegroundColor Cyan
try{
    if (Get-Service wuauserv | Where-Object {$_.Status -eq "Stopped"}) {
    Write-Host "Windows Update service already stopped. Skipping." -ForegroundColor Yellow
    }
    else {
        Stop-Service wuauserv -Force
    }
} catch {
    Write-Host "[FAIL] Failed to stop Windows Update Service." -ForegroundColor Red
}
try{
    if (Get-Service cryptSvc | Where-Object {$_.Status -eq "Stopped"}) {
    Write-Host "Cryptographic Services already stopped. Skipping." -ForegroundColor Yellow
    }
    else {
        Stop-Service cryptSvc -Force
    }
} catch {
    Write-Host "[FAIL] Failed to stop Cryptographic Services." -ForegroundColor Red
}
try{
    if (Get-Service bits | Where-Object {$_.Status -eq "Stopped"}) {
    Write-Host "Background Intelligence Transfer Service already stopped. Skipping." -ForegroundColor Yellow
    }
    else {
        Stop-Service bits -Force
    }
} catch {
    Write-Host "[FAIL] Failed to stop Background Intelligence Transfer Service."-ForegroundColor Red
}
try{
    if (Get-Service msiserver | Where-Object {$_.Status -eq "Stopped"}) {
    Write-Host "Windows Installer Service already stopped. Skipping."-ForegroundColor Yellow
    }
    else {
        Stop-Service msiserver -Force
    }
} catch {
    Write-Host "[FAIL] Failed to stop Windows Installer Service." -ForegroundColor Red
}
$current++
Write-Progress -Activity "Windows Update Remediation" -Status "Stopping Services" `
               -PercentComplete (($current / $steps) * 100)
Write-Host "[PASS] Services stopped successfully." -ForegroundColor Green
Start-sleep 2

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
Start-Sleep 2
Write-Host "[PASS] Windows Update cache cleared." -ForegroundColor Green

# Restart services
Write-Host "Process of starting services started..." -ForegroundColor Cyan
try{
    Start-Service -Name wuauserv
} catch {
    Write-Host "[FAIL] Failed to start Windows Update Service." -ForegroundColor Red
}
try{
    Start-Service -Name cryptSvc 
} catch {
    Write-Host "[FAIL] Failed to start Cryptographic Services." -ForegroundColor Red
}
try{
    Start-Service -Name bits
} catch {
    Write-Host "[FAIL] Failed to start Background Intelligence Transfer Service." -ForegroundColor Red
}
try{
    Start-Service -Name msiserver
} catch {
    Write-Host "[FAIL] Failed to start Windows Installer Service." -ForegroundColor Red
}
$current++
Write-Progress -Activity "Windows Update Remediation" `
               -Status "Starting services" `
               -PercentComplete (($current / $steps) * 100)
Write-Host "[PASS] Services restarted successfully." -ForegroundColor Green
Start-Sleep 2

$reboot = Read-Host "Restart now? (Y/N)"
if ($reboot -eq "Y") {
    Restart-Computer
}
Write-Progress -Activity "Windows Update Remediation" -Status "Completed" -PercentComplete 100
Start-Sleep 2
Write-Progress -Activity "Windows Update Remediation" -Completed
$current = 0

Write-Host "[PASS] Windows Update reset completed." -ForegroundColor Green
Read-Host "Press any key to exit"
Stop-Transcript
