Import-Module .\WindowsDiskCleanup\WindowsDiskCleanup.psm1 -Force

Describe 'WindowsDiskCleanup.Tests' {
    Context 'Remove-OldFile Tests' {
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
            Remove-OldFile -Path $file.FullName -Days 5 -DryRun:$false
            Test-Path $path | Should -Be $false
        }

        It 'should remove old file by Path (pipeline)' {
            $file.FullName | Remove-OldFile -Days 5 -DryRun:$false
            Test-Path $path | Should -Be $false
        }

        It 'should remove old file by File (parameter)' {
            Remove-OldFile -File $file -Days 5 -DryRun:$false
            Test-Path $path | Should -Be $false
        }

        It 'should remove old file by File (pipeline)' {
            $file | Remove-OldFile -Days 5 -DryRun:$false
            Test-Path $path | Should -Be $false
        }

        It 'should not remove files in dry run mode' {
            Remove-OldFile -File $file -Days 5 -DryRun:$true
            Test-Path $path | Should -Be $true
        }

        It 'should not remove files that are not old enough' {
            $file.CreationTimeUtc = (Get-Date).AddDays(-3)
            Remove-OldFile -File $file -Days 5 -DryRun:$false
            Test-Path $path | Should -Be $true
        }
    }
}