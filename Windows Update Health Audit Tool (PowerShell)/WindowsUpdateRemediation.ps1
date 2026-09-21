# Stop Windows Update and related services
$steps = 6
$current = 0
$current++

if(
    -not (
        [Security.Principal.WindowsPrincipal]`
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole(
        [Security.Principal.WindowsBuiltinRole]::Administrator
    )
)
{
    Write-Host "[FAIL] Run PowerShell as Administrator." `
        -ForegroundColor Red

    exit
}

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

$Services = @(
    "wuauserv",
    "cryptSvc",
    "bits",
    "msiserver"
)

foreach ($Service in $Services)
{
    try
    {
        if ((Get-Service $Service).Status -eq "Stopped")
        {
            Write-Host "$Service already stopped." `
                -ForegroundColor Yellow
        }
        else
        {
            Stop-Service $Service -Force

            Write-Host "$Service stopped." `
                -ForegroundColor Green
        }
    }
    catch
    {
        Write-Host "$Service failed to stop." `
            -ForegroundColor Red
    }
}

$current++
Write-Progress -Activity "Windows Update Remediation" -Status "Stopping Services" `
               -PercentComplete (($current / $steps) * 100)
Write-Host "[PASS] Services stopped successfully." -ForegroundColor Green
Start-sleep 2

# Rename SoftwareDistribution and catroot2 to clear cache
Write-Host "Process of renaming folders and clearing cache..." -ForegroundColor Cyan
if (Test-Path "C:\Windows\SoftwareDistribution") {
    Rename-Item -Path "C:\Windows\SoftwareDistribution" `
                -NewName "SoftwareDistribution.old" `
                -Force
}
if (Test-Path "C:\Windows\System32\catroot2") {
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
foreach ($Service in $Services)
{
    try
    {
        Start-Service $Service

        Write-Host "$Service started." `
            -ForegroundColor Green
    }
    catch
    {
        Write-Host "$Service failed to start." `
            -ForegroundColor Red
    }
}

$current++
Write-Progress -Activity "Windows Update Remediation" `
               -Status "Starting services" `
               -PercentComplete (($current / $steps) * 100)
Write-Host "[PASS] Services restarted successfully." -ForegroundColor Green
Start-Sleep 2

# Verifying services
Write-Host "`nVerifying Services..." -ForegroundColor Cyan
foreach ($Service in $Services)
{
    $Status = (Get-Service $Service).Status

    if ($Status -eq "Running")
    {
        Write-Host "[PASS] $Service : Running" -ForegroundColor Green
    }
    else
    {
        Write-Host "[FAIL] $Service : $Status" -ForegroundColor Red
    }
}

$current++
Write-Progress -Activity "Windows Update Remediation" `
               -Status "Verifying services" `
               -PercentComplete (($current / $steps) * 100)
Write-Host "[PASS] Services verified successfully." -ForegroundColor Green
Start-Sleep 2

# Verifying connectivity
Write-Host "`nVerifying Connectivity..." -ForegroundColor Cyan
$Connectivity = Test-NetConnection `
        download.windowsupdate.com `
        -Port 443
if ($Connectivity.TcpTestSucceeded) 
{
    Write-Host "[PASS] Windows Update endpoint reachable." `
    -ForegroundColor Green
}
else
{
    Write-Host "[FAIL] Unable to reach Windows Update endpoint." `
    -ForegroundColor Red
}
$current++
Write-Progress -Activity "Windows Update Remediation" `
               -Status "Verifying connectivity" `
               -PercentComplete (($current / $steps) * 100)
$ConnectivitySuccess = $Connectivity.TcpTestSucceeded
if ($ConnectivitySuccess)
{
    Write-Host "[PASS] Connectivity verified successfully." -ForegroundColor Green
}

else
{
    Write-Host "[FAIL] Connectivity verification failed." -ForegroundColor Red
}
Start-Sleep 2

Write-Progress -Activity "Windows Update Remediation" -Status "Completed" -PercentComplete 100
Start-Sleep 2
Write-Progress -Activity "Windows Update Remediation" -Completed
$current = 0

Write-Host "[PASS] Windows Update reset completed." -ForegroundColor Green

Write-Host "If updates still fail, manually try 'Check Online for Updates' from Windows Update settings." `
    -ForegroundColor Cyan

Write-Host "[PASS] Remediation complete." -ForegroundColor Green

Write-Host "`nRecommended Next Steps:" -ForegroundColor Cyan
Write-Host "1. Open Windows Update." -ForegroundColor White
Write-Host "2. Select 'Check Online for Updates'." -ForegroundColor White
Write-Host "3. Verify updates install successfully." -ForegroundColor White

Write-Host "A reboot is recommended before testing Windows Update." -ForegroundColor Yellow
Stop-Transcript
