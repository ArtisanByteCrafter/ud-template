[cmdletBinding()]
Param(
    [Parameter()]
    [Switch]
    $Test,

    [Parameter()]
    [Switch]
    $Build,

    [Parameter()]
    [Switch]
    $Deploy
)

# Initialize paths
$innvocationPath = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PSModuleRoot = Split-Path -Parent $innvocationPath
$TestPath = Join-Path $PSModuleRoot "Tests"
$DeployFolder = Join-Path $env:Build_ArtifactStagingDirectory UDTemplate

#Do stuff based on passed args
Switch ($true) {

    $Test {

        If (-not (Get-Module Pester)) {
            Install-Module -Name Pester -SkipPublisherCheck -Force
        }

        $invokePesterSplat = @{
            Script       = $TestPath
            OutputFile   = "$($env:Build_ArtifactStagingDirectory)\UDTemplate.Results.xml"
            OutputFormat = 'NUnitXml'
        }
        Invoke-Pester @invokePesterSplat


        Get-ChildItem $env:Build_ArtifactStagingDirectory
    }

    $Build {

        # Copy module folder to build folder
        $copyItemSplat = @{
            Path = (Join-Path $PSModuleRoot UDTemplate)
            Destination = 'C:\Temp'
            Recurse = $true
            Container = $true
        }
        Copy-Item @copyItemSplat

        Write-Output "Module copied and imported from $DeployFolder"

        #Verify we can load the module and see cmdlets
        Import-Module (Join-Path $DeployFolder UDTemplate.psd1)
        Get-Command -Module UDTemplate 

    }

    $Deploy {

        Try {

            $deploySplat = @{
                Path        = (Resolve-Path -Path $DeployFolder)
                NuGetApiKey = $env:NuGetApiKey
                ErrorAction = 'Stop'
            }

            # Publish-Module @deploySplat -WhatIf
        }
        Catch {
            throw $_
        }
    }

    default {

        Write-Output "Please Provide one of the following switches: -Test, -Build, -Deploy"
    }

}