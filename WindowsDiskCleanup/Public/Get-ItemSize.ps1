function Get-ItemSize {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "File")]
        [System.IO.FileSystemInfo]$File,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "Path")]
        [string]$Path,

        [ValidateSet("GB", "MB", "KB", "Bytes")]
        [string]$Unit = "Bytes"
    )

    process {
        $size = 0

        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            if (-Not (Test-Path -Path $Path)) {
                return 0
            }

            $size = (Get-ChildItem -Recurse -File $Path | Measure-Object -Property Length -Sum).Sum
            if ($null -eq $size) {
                return 0
            }
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'File') {
            if (-Not (Test-Path -Path $File.FullName)) {
                return 0
            }

            $size = $File.Length
        }

        switch ($Unit) {
            "GB" { return [math]::Round($size / 1GB, 2) }
            "MB" { return [math]::Round($size / 1MB, 2) }
            "KB" { return [math]::Round($size / 1KB, 2) }
            "Bytes" { return $size }
        }
    }
}