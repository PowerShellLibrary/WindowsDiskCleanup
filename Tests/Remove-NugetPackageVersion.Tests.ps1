Import-Module .\WindowsDiskCleanup\WindowsDiskCleanup.psm1 -Force

Describe 'Remove-NugetPackageVersion.Tests' {
    BeforeAll {
        $nugetRoot = Join-Path -Path $PSScriptRoot -ChildPath 'Nuget'
        $packageName = 'sitecore.cms.core.content'
        $otherPackageName = 'sitecore.cms.feature.navigation'
        $packagePath = Join-Path -Path $nugetRoot -ChildPath $packageName
        $otherPackagePath = Join-Path -Path $nugetRoot -ChildPath $otherPackageName

        if (-not (Test-Path $packagePath)) {
            New-Item -Path $packagePath -ItemType Directory -Force | Out-Null
        }

        if (-not (Test-Path $otherPackagePath)) {
            New-Item -Path $otherPackagePath -ItemType Directory -Force | Out-Null
        }
    }

    BeforeEach {
        $packageVersions = @{
            $packagePath = @('18.0.1580', '18.0.1581', '18.0.1582')
            $otherPackagePath = @('2.0.0', '2.0.1', '2.0.2')
        }

        foreach ($currentPackagePath in $packageVersions.Keys) {
            foreach ($version in $packageVersions[$currentPackagePath]) {
                $folder = New-Item -Path (Join-Path -Path $currentPackagePath -ChildPath $version) -ItemType Directory -Force
                $folder.CreationTimeUtc = (Get-Date).AddDays(-10)
            }
        }
    }

    AfterEach {
        if (Test-Path $nugetRoot) {
            Get-ChildItem -Path $nugetRoot -Directory | ForEach-Object {
                Get-ChildItem -Path $_.FullName -Directory | Remove-Item -Force -Recurse
            }
        }
    }

    AfterAll {
        if (Test-Path $nugetRoot) {
            Remove-Item -Path $nugetRoot -Recurse -Force
        }
    }

    It 'should remove old package versions but keep latest version' {
        Remove-NugetPackageVersion -NugetFolder $nugetRoot -PackageName $packageName -Days 5 -DryRun:$false

        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1580') | Should -Be $false
        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1581') | Should -Be $false
        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1582') | Should -Be $true
    }

    It 'should not remove package versions in dry run mode' {
        Remove-NugetPackageVersion -NugetFolder $nugetRoot -PackageName $packageName -Days 5 -DryRun:$true

        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1580') | Should -Be $true
        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1581') | Should -Be $true
        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1582') | Should -Be $true
    }

    It 'should do nothing if package path does not exist' {
        Remove-Item -Path $packagePath -Recurse -Force

        { Remove-NugetPackageVersion -NugetFolder $nugetRoot -PackageName $packageName -Days 5 -DryRun:$false } | Should -Not -Throw
    }

    It 'should process all matching packages when wildcard package name is provided' {
        Remove-NugetPackageVersion -NugetFolder $nugetRoot -PackageName 'sitecore.cms.*' -Days 5 -DryRun:$false

        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1582') | Should -Be $true
        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1581') | Should -Be $false
        Test-Path (Join-Path -Path $otherPackagePath -ChildPath '2.0.2') | Should -Be $true
        Test-Path (Join-Path -Path $otherPackagePath -ChildPath '2.0.1') | Should -Be $false
    }

    It 'should process all packages when package name is omitted' {
        Remove-NugetPackageVersion -NugetFolder $nugetRoot -Days 5 -DryRun:$false

        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1582') | Should -Be $true
        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1580') | Should -Be $false
        Test-Path (Join-Path -Path $otherPackagePath -ChildPath '2.0.2') | Should -Be $true
        Test-Path (Join-Path -Path $otherPackagePath -ChildPath '2.0.0') | Should -Be $false
    }

    It 'should keep the only available version even if it is older than days threshold' {
        Get-ChildItem -Path $packagePath -Directory | Where-Object { $_.Name -ne '18.0.1582' } | Remove-Item -Recurse -Force

        Remove-NugetPackageVersion -NugetFolder $nugetRoot -PackageName $packageName -Days 5 -DryRun:$false

        Test-Path (Join-Path -Path $packagePath -ChildPath '18.0.1582') | Should -Be $true
    }
}
