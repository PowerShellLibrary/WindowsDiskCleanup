function Remove-DebugDiagLogs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$Days,

        [switch]$DryRun
    )

    process {
        Get-Item "$env:SystemDrive\Program Files\DebugDiag\Logs\DbgSVC_*.txt" | Remove-OldItem -Days $Days -DryRun:$DryRun
    }
}