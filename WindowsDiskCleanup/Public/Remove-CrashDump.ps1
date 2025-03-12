function Remove-CrashDump {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$Days,

        [switch]$DryRun
    )

    process {
        $crashDumpPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'CrashDumps')
        if (Test-Path $crashDumpPath) {
            Get-ChildItem $crashDumpPath -Filter "*.dmp" | Remove-OldItem -Days $Days -DryRun:$DryRun
        }
    }
}