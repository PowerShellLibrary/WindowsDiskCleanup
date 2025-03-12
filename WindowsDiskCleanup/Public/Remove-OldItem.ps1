function Remove-OldItem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "File")]
        [System.IO.FileSystemInfo]$File,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "Path")]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [int]$Days,

        [switch]$DryRun
    )

    begin {
        $now = Get-Date
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $File = Get-Item -Path $Path
        }

        if (($now - $File.CreationTimeUtc).TotalDays -gt $Days) {
            if ($DryRun) {
                Write-Host "[Dry] Removing $($File.FullName)" -ForegroundColor Yellow
            }
            else {
                Remove-Item -Path $File.FullName -Force -Recurse
            }
        }
    }
}