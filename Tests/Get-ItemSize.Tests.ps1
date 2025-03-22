Import-Module .\WindowsDiskCleanup\WindowsDiskCleanup.psm1 -Force

Describe 'Get-ItemSize.Tests' {
    BeforeAll {
        $testFolder = "$PSScriptRoot\TestFolder"
        $nestedFolder = "$testFolder\Nested"
        $testFile1 = "$testFolder\File1.txt"
        $testFile2 = "$nestedFolder\File2.txt"
    }

    BeforeEach {
        if (-not (Test-Path $testFolder)) {
            New-Item -Path $testFolder -ItemType Directory -Force | Out-Null
        }
        if (-not (Test-Path $nestedFolder)) {
            New-Item -Path $nestedFolder -ItemType Directory -Force | Out-Null
        }
        Set-Content -Path $testFile1 -Value ('A' * 1024) -NoNewline # 1 KB
        Set-Content -Path $testFile2 -Value ('B' * 2048) -NoNewline # 2 KB
    }

    AfterEach {
        if (Test-Path $testFolder) {
            Remove-Item -Path $testFolder -Recurse -Force
        }
    }

    It 'should calculate the correct size of a folder with files' {
        $result = Get-ItemSize -Path $testFolder
        $result | Should -Be 3072 # 1 KB + 2 KB
    }

    It 'should return 0 for an empty folder' {
        Remove-Item -Path $testFile1, $testFile2 -Force
        $result = Get-ItemSize -Path $testFolder
        $result | Should -Be 0
    }

    It 'should calculate the correct size for nested folders' {
        $result = Get-ItemSize -Path $testFolder
        $result | Should -Be 3072 # 1 KB + 2 KB
    }

    It "shouldn't throw an error for an invalid path" {
        $result = Get-ItemSize -Path "$PSScriptRoot\InvalidPath"
        $result | Should -Be 0
    }

    It 'should calculate the correct size of a single file' {
        $fileInfo = Get-Item -Path $testFile1
        $result = Get-ItemSize -File $fileInfo
        $result | Should -Be 1024 # 1 KB
    }

    It 'should return 0 for a non-existent file' {
        $fileInfo = [System.IO.FileInfo]::new("$PSScriptRoot\NonExistentFile.txt")
        $result = Get-ItemSize -File $fileInfo
        $result | Should -Be 0
    }
}