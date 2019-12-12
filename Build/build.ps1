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

    }

    $Deploy {

        Try {

            $deploySplat = @{
                Path        = (Resolve-Path -Path "$($env:Build_ArtifactStagingDirectory)\UDTemplate")
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