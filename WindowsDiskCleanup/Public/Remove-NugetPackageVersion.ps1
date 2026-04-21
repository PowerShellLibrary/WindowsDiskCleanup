function Remove-NugetPackageVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$Days,

        [string[]]$PackageName = @('*'),

        [string]$NugetFolder = 'C:\nuget',

        [switch]$DryRun
    )

    process {
        if (-not (Test-Path $NugetFolder)) {
            return
        }

        $packagePatterns = @($PackageName | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
        if ($packagePatterns.Count -eq 0) {
            $packagePatterns = @('*')
        }

        $packageDirectories = @()
        foreach ($pattern in $packagePatterns) {
            $packageDirectories += Get-ChildItem -Path $NugetFolder -Directory -Filter $pattern -ErrorAction SilentlyContinue
        }

        $packageDirectories = @($packageDirectories | Sort-Object -Property FullName -Unique)
        if ($packageDirectories.Count -eq 0) {
            return
        }

        foreach ($packageDirectory in $packageDirectories) {
            $versionDirectories = @(Get-ChildItem -Path $packageDirectory.FullName -Directory)
            if ($versionDirectories.Count -le 1) {
                continue
            }

            $parsedVersions = @()
            foreach ($directory in $versionDirectories) {
                try {
                    $parsedVersions += [PSCustomObject]@{
                        Directory = $directory
                        Version   = [Version]$directory.Name
                    }
                }
                catch {
                    # Ignore folders that are not valid [Version] names.
                }
            }

            if ($parsedVersions.Count -gt 0) {
                $latestDirectory = ($parsedVersions | Sort-Object -Property Version -Descending | Select-Object -First 1).Directory
            }
            else {
                $latestDirectory = $versionDirectories | Sort-Object -Property Name -Descending | Select-Object -First 1
            }

            $directoriesToEvaluate = $versionDirectories | Where-Object { $_.FullName -ne $latestDirectory.FullName }
            $directoriesToEvaluate | Remove-OldItem -Days $Days -DryRun:$DryRun
        }
    }
}