function Remove-TempASPNETFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$Days,

        [string]$FolderPath = "$env:SystemRoot\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\root",

        [switch]$DryRun
    )

    process {
        if (Test-Path $FolderPath) {
            Get-ChildItem $FolderPath | Remove-OldItem -Days $Days -DryRun:$DryRun
        }
    }
}