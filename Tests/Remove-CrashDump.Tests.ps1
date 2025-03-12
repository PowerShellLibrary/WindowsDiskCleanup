Import-Module .\WindowsDiskCleanup\WindowsDiskCleanup.psm1 -Force

Describe 'Remove-CrashDump.Tests' {
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