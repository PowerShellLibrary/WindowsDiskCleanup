function Remove-ChromiumTempData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$Days,

        [switch]$DryRun
    )

    process {
        $paths = @("$env:SystemRoot\SystemTemp\scoped_dir*", "$env:SystemRoot\SystemTemp\chrome_url_fetcher_*")
        Get-ChildItem $paths | Remove-OldItem -Days $Days -DryRun:$DryRun
    }
}