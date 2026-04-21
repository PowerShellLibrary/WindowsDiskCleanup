function Remove-DebugDiagLogs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$Days,

        [switch]$DryRun
    )

    process {
        $debugDiagLogsPath = Join-Path -Path $env:SystemDrive -ChildPath 'Program Files\DebugDiag\Logs'
        if (Test-Path $debugDiagLogsPath) {
            Get-ChildItem -Path $debugDiagLogsPath -File -Filter 'DbgSVC*.txt' | Remove-OldItem -Days $Days -DryRun:$DryRun
        }
    }
}