Write-Host ("========= Copilot Tool Removal ==========") -ForegroundColor Cyan
$CopilotPackage = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*Copilot*"}

if($CopilotPackage)
{
    Write-Host ("Detected Copilot Package...") -ForegroundColor Red
    Write-Host ("Proceed Copilot Package Removal...") -ForegroundColor Yellow
    Get-AppxPackage -AllUsers *CoPilot* | Remove-AppxPackage -AllUsers
    
    $Verify = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*Copilot*"}

    if(-not $Verify)
    {
        Write-Host "Copilot Successfully Removed!" -ForegroundColor Green
    }

    else
    {
        Write-Host "Copilot still detected." -ForegroundColor Red
    }
}
else{
    Write-Host ("No Copilot package detected") -ForegroundColor Green
}
Write-Host ("Copilot Removal Completed!") -ForegroundColor Green