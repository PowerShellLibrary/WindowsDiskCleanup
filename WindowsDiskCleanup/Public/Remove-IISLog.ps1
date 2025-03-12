function Remove-IISLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$Days,

        [string]$LogFilesFolder = "$env:SystemDrive\inetpub\logs\LogFiles",

        [switch]$DryRun
    )

    process {
        if (Test-Path $LogFilesFolder) {
            Get-ChildItem $LogFilesFolder -Recurse -Filter *.log | Remove-OldItem -Days $Days -DryRun:$DryRun
        }
    }
}