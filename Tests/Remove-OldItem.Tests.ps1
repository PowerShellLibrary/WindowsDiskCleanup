Import-Module .\WindowsDiskCleanup\WindowsDiskCleanup.psm1 -Force

Describe 'Remove-OldItem.Tests' {
    BeforeAll {
        $path = "$PSScriptRoot\test.txt"
    }

    BeforeEach {
        $file = New-Item -Path $path -ItemType File -Force
        $file.CreationTimeUtc = (Get-Date).AddDays(-10)
    }

    AfterEach {
        if (Test-Path $path) {
            Remove-Item -Path $path -Force
        }
    }

    It 'should remove old file by Path (parameter)' {
        Remove-OldItem -Path $file.FullName -Days 5 -DryRun:$false
        Test-Path $path | Should -Be $false
    }

    It 'should remove old file by Path (pipeline)' {
        $file.FullName | Remove-OldItem -Days 5 -DryRun:$false
        Test-Path $path | Should -Be $false
    }

    It 'should remove old file by File (parameter)' {
        Remove-OldItem -File $file -Days 5 -DryRun:$false
        Test-Path $path | Should -Be $false
    }

    It 'should remove old file by File (pipeline)' {
        $file | Remove-OldItem -Days 5 -DryRun:$false
        Test-Path $path | Should -Be $false
    }

    It 'should not remove files in dry run mode' {
        Remove-OldItem -File $file -Days 5 -DryRun:$true
        Test-Path $path | Should -Be $true
    }

    It 'should not remove files that are not old enough' {
        $file.CreationTimeUtc = (Get-Date).AddDays(-3)
        Remove-OldItem -File $file -Days 5 -DryRun:$false
        Test-Path $path | Should -Be $true
    }
}

Context 'Remove-CrashDump Tests' {
    BeforeAll {
        $LOCALAPPDATA = "$PSScriptRoot\LocalAppData"
        $env:LOCALAPPDATA = $LOCALAPPDATA
        $crashDumpPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'CrashDumps')
        $testDumpFilePath = [System.IO.Path]::Combine($crashDumpPath, 'test.dmp')

        if (-not (Test-Path $crashDumpPath)) {
            New-Item -Path $crashDumpPath -ItemType Directory -Force | Out-Null
        }
    }

    BeforeEach {
        $file = New-Item -Path $testDumpFilePath -ItemType File -Force
        $file.CreationTimeUtc = (Get-Date).AddDays(-10)
    }

    AfterEach {
        if (Test-Path $testDumpFilePath) {
            Remove-Item -Path $testDumpFilePath -Force
        }
    }

    AfterAll {
        if (Test-Path $LOCALAPPDATA) {
            Remove-Item -Path $LOCALAPPDATA -Recurse -Force
        }
    }

    It 'should remove crash dump files older than specified days' {
        Remove-CrashDump -Days 5 -DryRun:$false
        Test-Path $testDumpFilePath | Should -Be $false
    }

    It 'should not remove crash dump files in dry run mode' {
        Remove-CrashDump -Days 5 -DryRun:$true
        Test-Path $testDumpFilePath | Should -Be $true
    }

    It 'should do nothing if crash dump path does not exist' {
        Remove-Item -Path $crashDumpPath -Recurse -Force
        { Remove-CrashDump -Days 5 -DryRun:$false } | Should -Not -Throw
    }
}