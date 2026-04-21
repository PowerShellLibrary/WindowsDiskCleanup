param(
    [switch]$DryRun,

    [string[]]$NugetPackages = @(),

    [string]$NugetFolder = 'C:\nuget',

    [int]$NugetDays = 30
)

Import-Module .\WindowsDiskCleanup\WindowsDiskCleanup.psm1 -Force

$global:WDCDryRunTotalBytes = 0
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

$effectiveNugetPackages = @($NugetPackages | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
if ($effectiveNugetPackages.Count -eq 0) {
    $effectiveNugetPackages = @('*')
}

foreach ($packageName in $effectiveNugetPackages) {
    $nugetParams = @{
        PackageName = $packageName
        NugetFolder = $NugetFolder
        Days        = $NugetDays
    }

    if ($DryRun) {
        Write-Host "Executing Remove-NugetPackageVersion in Dry Run mode...[package=$packageName][days>$NugetDays]" -ForegroundColor Cyan
        $nugetParams.DryRun = $true
    }

    Remove-NugetPackageVersion @nugetParams
}

if ($DryRun) {
    $expectedSavingsGB = [math]::Round($global:WDCDryRunTotalBytes / 1GB, 2)
    Write-Host "Expected Disk Space Savings: $expectedSavingsGB GB" -ForegroundColor Yellow
}
else {
    $spaceAfterGB = Get-DiskSpace -SpaceType Free -Unit GB
    $savingsGB = [math]::Round($spaceAfterGB - $spaceBeforeGB, 2)
    Write-Host "Free Space After: $spaceAfterGB GB" -ForegroundColor Green
    Write-Host "Disk Space Freed: $savingsGB GB" -ForegroundColor Yellow
}