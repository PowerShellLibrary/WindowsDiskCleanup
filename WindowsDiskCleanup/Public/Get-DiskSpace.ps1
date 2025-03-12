function Get-DiskSpace {
    [CmdletBinding()]
    param(
        [char]$Name = "$env:HOMEDRIVE".TrimEnd(':'),

        [ValidateSet("Free", "Total", "Used")]
        [string]$SpaceType = "Free",

        [ValidateSet("GB", "MB", "KB")]
        [string]$Unit = "GB"
    )

    process {
        $drive = Get-PSDrive -Name $Name
        $space = switch ($SpaceType) {
            "Free" { $drive.Free }
            "Total" { $drive.Used + $drive.Free }
            "Used" { $drive.Used }
        }

        switch ($Unit) {
            "GB" { $space / 1GB }
            "MB" { $space / 1MB }
            "KB" { $space / 1KB }
        }
    }
}

Get-DiskSpace -SpaceType Free -Unit GB