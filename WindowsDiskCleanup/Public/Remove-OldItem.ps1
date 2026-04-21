function Remove-OldItem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "File")]
        [System.IO.FileSystemInfo]$File,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "Path")]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [int]$Days,

        [switch]$DryRun,

        [switch]$SkipSize
    )

    begin {
        $now = Get-Date
        $effectiveSkipSize = $SkipSize -or ($env:WDC_SKIP_SIZE -eq '1')
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $File = Get-Item -Path $Path
        }

        if (($now - $File.CreationTimeUtc).TotalDays -gt $Days) {
            if ($DryRun) {
                if ($effectiveSkipSize) {
                    Write-Host "[Dry] Removing $($File.FullName)" -ForegroundColor Yellow
                }
                else {
                    $sizeBytes = Get-ItemSize -Path $File.FullName
                    $global:WDCDryRunTotalBytes += $sizeBytes
                    $sizeMB = [math]::Round($sizeBytes / 1MB, 2)
                    Write-Host "[Dry] Removing $($File.FullName) [$sizeMB MB]" -ForegroundColor Yellow
                }
            }
            else {
                Remove-Item -Path $File.FullName -Force -Recurse
            }
        }
    }
}