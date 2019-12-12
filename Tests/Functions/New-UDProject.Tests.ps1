$root = Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) UDTemplate

Get-Module -ListAvailable -Name 'UDTemplate' | Remove-Module -Force
Import-Module (Join-Path $Root UDTemplate.psd1) -ErrorAction Stop

Describe 'New-UDProject Unit Tests' -Tags 'Unit' {

    Context 'Folder Structure' {

        It 'It should create a folder at -Destingation specified' {
            $TestProject = "TestProject"
            New-UDProject -ProjectName $TestProject -Destination $TestDrive
            (Test-Path (Join-Path $TestDrive $TestProject)) | Should Be $True
        }

        It 'It should throw if the destination exists' {
            New-Item (Join-Path $TestDrive Exists) -ItemType Directory
            { New-UDProject -ProjectName 'Exists' -Destination $TestDrive -ErrorAction Stop } | Should Throw

        }

        It 'It should be able to import the new project dashboard module' {
            $ModuleImport = "ModuleImport"
            New-UDProject -ProjectName $ModuleImport -Destination $TestDrive
            Import-Module (Join-Path (Join-Path $TestDrive $ModuleImport) "$ModuleImport.psd1")
            { Get-Module -ListAvailable -Name $ModuleImport } | Should -HaveCount 1
        }
    }
}