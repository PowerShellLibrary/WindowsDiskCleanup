param(
    [switch]$DryRun
)

Import-Module .\WindowsDiskCleanup\WindowsDiskCleanup.psm1 -Force

$spaceBeforeGB = Get-DiskSpace -SpaceType Free -Unit GB
Write-Host "Free Space Before: $spaceBeforeGB GB" -ForegroundColor Green

$removeCommands = @(
    @{ Cmd = "Remove-TempASPNETFile"; Days = 30 },
    @{ Cmd = "Remove-IISLog"; Days = 7 },
    @{ Cmd = "Remove-ChromiumTempData"; Days = 60 },
    @{ Cmd = "Remove-DebugDiagLogs"; Days = 60 }
)

foreach ($command in $removeCommands) {
    if ($DryRun) {
        write-Host "Executing $($command.Cmd) in Dry Run mode...[days>$($command.Days)]" -ForegroundColor Cyan
        & $command.Cmd -Days $command.Days -DryRun
    }
    else {
        & $command.Cmd -Days $command.Days
    }
}

$spaceAfterGB = Get-DiskSpace -SpaceType Free -Unit GB
$savingsGB = [math]::Round($spaceAfterGB - $spaceBeforeGB, 2)

Write-Host "Free Space After: $spaceAfterGB GB" -ForegroundColor Green
Write-Host "Disk Space Freed: $savingsGB GB" -ForegroundColor Yellow