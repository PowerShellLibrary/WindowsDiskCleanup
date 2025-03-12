Import-Module .\WindowsDiskCleanup\WindowsDiskCleanup.psm1 -Force

Describe 'Get-DiskSpace.Tests' {
    BeforeAll {
        Mock -CommandName Get-PSDrive -ModuleName WindowsDiskCleanup -MockWith {
            return @{
                Name = 'C'
                Used = 50GB
                Free = 100GB
            }
        }
    }

    It 'should return free space in GB by default' {
        $result = Get-DiskSpace
        $result | Should -Be 100
    }

    It 'should return total space in GB' {
        $result = Get-DiskSpace -Name 'C' -SpaceType 'Total' -Unit 'GB'
        $result | Should -Be 150
    }

    It 'should return used space in GB' {
        $result = Get-DiskSpace -Name 'C' -SpaceType 'Used' -Unit 'GB'
        $result | Should -Be 50
    }

    It 'should return free space in MB' {
        $result = Get-DiskSpace -Name 'C' -SpaceType 'Free' -Unit 'MB'
        $result | Should -Be (100 * 1024)
    }

    It 'should return total space in MB' {
        $result = Get-DiskSpace -Name 'C' -SpaceType 'Total' -Unit 'MB'
        $result | Should -Be (150 * 1024)
    }

    It 'should return used space in MB' {
        $result = Get-DiskSpace -Name 'C' -SpaceType 'Used' -Unit 'MB'
        $result | Should -Be (50 * 1024)
    }

    It 'should return free space in KB' {
        $result = Get-DiskSpace -Name 'C' -SpaceType 'Free' -Unit 'KB'
        $result | Should -Be (100 * 1024 * 1024)
    }

    It 'should return total space in KB' {
        $result = Get-DiskSpace -Name 'C' -SpaceType 'Total' -Unit 'KB'
        $result | Should -Be (150 * 1024 * 1024)
    }

    It 'should return used space in KB' {
        $result = Get-DiskSpace -Name 'C' -SpaceType 'Used' -Unit 'KB'
        $result | Should -Be (50 * 1024 * 1024)
    }
}