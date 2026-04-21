Import-Module .\WindowsDiskCleanup\WindowsDiskCleanup.psm1 -Force

Describe 'Remove-DebugDiagLogs.Tests' {
    BeforeAll {
        $originalSystemDrive = $env:SystemDrive
        $testSystemDrive = Join-Path -Path $PSScriptRoot -ChildPath 'TestSystemDrive'
        $env:SystemDrive = $testSystemDrive
        $debugDiagLogPath = Join-Path -Path $testSystemDrive -ChildPath 'Program Files\DebugDiag\Logs'

        if (-not (Test-Path $debugDiagLogPath)) {
            New-Item -Path $debugDiagLogPath -ItemType Directory -Force | Out-Null
        }
    }

    BeforeEach {
        $legacyPath = Join-Path -Path $debugDiagLogPath -ChildPath 'DbgSVC_legacy.txt'
        $datedPath = Join-Path -Path $debugDiagLogPath -ChildPath 'DbgSVC_Date__03_21_2025__Time_08_19_41AM__908__Log.txt'

        $legacyFile = New-Item -Path $legacyPath -ItemType File -Force
        $datedFile = New-Item -Path $datedPath -ItemType File -Force

        $legacyFile.CreationTimeUtc = (Get-Date).AddDays(-10)
        $datedFile.CreationTimeUtc = (Get-Date).AddDays(-10)
    }

    AfterEach {
        if (Test-Path $debugDiagLogPath) {
            Get-ChildItem -Path $debugDiagLogPath -File -Filter 'DbgSVC*.txt' | Remove-Item -Force
        }
    }

    AfterAll {
        if (Test-Path $testSystemDrive) {
            Remove-Item -Path $testSystemDrive -Recurse -Force
        }

        if ($null -ne $originalSystemDrive) {
            $env:SystemDrive = $originalSystemDrive
        }
    }

    It 'should remove matching DebugDiag files older than specified days' {
        Remove-DebugDiagLogs -Days 5 -DryRun:$false

        Test-Path (Join-Path -Path $debugDiagLogPath -ChildPath 'DbgSVC_legacy.txt') | Should -Be $false
        Test-Path (Join-Path -Path $debugDiagLogPath -ChildPath 'DbgSVC_Date__03_21_2025__Time_08_19_41AM__908__Log.txt') | Should -Be $false
    }

    It 'should not remove matching DebugDiag files in dry run mode' {
        Remove-DebugDiagLogs -Days 5 -DryRun:$true

        Test-Path (Join-Path -Path $debugDiagLogPath -ChildPath 'DbgSVC_legacy.txt') | Should -Be $true
        Test-Path (Join-Path -Path $debugDiagLogPath -ChildPath 'DbgSVC_Date__03_21_2025__Time_08_19_41AM__908__Log.txt') | Should -Be $true
    }

    It 'should do nothing if DebugDiag log path does not exist' {
        Remove-Item -Path $debugDiagLogPath -Recurse -Force

        { Remove-DebugDiagLogs -Days 5 -DryRun:$false } | Should -Not -Throw
    }
}
