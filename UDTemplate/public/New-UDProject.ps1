Function New-UDProject {
    <#
    .SYNOPSIS
    Creates the folder structure for a new UD project and sets some defaults for a new dashboard.
    .DESCRIPTION
    Creates folder structure, sets a default port, and sets dashboard to import all .ps1 files in /src
    .EXAMPLE
    PS C:\> New-UDProject -ProjectName myProject -Port 8080 -Destination C:\Temp

    Creates a new project called myProject, configures the listening port as 8080, at C:\Temp.
    .PARAMETER ProjectName
    The name of the project. The dashboard will use this value for it's title, but this is configurable in dbconfig.json
    .PARAMETER Destination
    The folder where the dashboard project will be located
    .PARAMETER Port
    The port on which to listen. The default is port 80.
    .PARAMETER SetAsCurrentLocation
    If included, this parameter will change the current working directory to the new project root after creation.
    .INPUTS
    Inputs (if any)
    .OUTPUTS
    PSCustomObject of the dashboard module name and location
    .NOTES
    General notes
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $ProjectName,

        [Parameter(Mandatory)]
        [ValidateScript( {
                If (-not(Test-Path $_)) {
                    Throw "A valid path is required"
                }
                Else { $true }
            }
        )]
        [string] $Destination,

        [ValidateRange(1, 65535)]
        [string] $Port = 80,

        [Switch] $SetAsCurrentLocation

    )
    Begin {
        $TemplateRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
        $ProjectRoot = (Join-Path $Destination $ProjectName)

    }

    Process {
        If (Test-Path $ProjectRoot) {
            Write-Error "Project exists at '$ProjectRoot'. Please choose a different path."
            break;
        }
        
        New-Item -ItemType Directory -Path $ProjectRoot > $null
        

        #Region Create directory structure and files
        $Folders = @(
            'assets'
            'pages'
            'src'
            'themes'
        )
        Foreach ($folder in $Folders) {
            $NewItemSplat = @{
                ItemType    = 'Directory'
                Path        = (Join-Path $ProjectRoot $folder)
                ErrorAction = 'SilentlyContinue'
            }
            New-Item @NewItemSplat > $null
        }

        # Setup config files within the new project root
        
        $FilesToCopy = @(
            'dashboard.ps1'
        )

        Foreach ($File in $FilesToCopy) {
            Get-Content (Join-Path (Join-Path $TemplateRoot UDTemplate ) $File) | 
            Set-Content (Join-Path $ProjectRoot $File)
        }


        $Configuration = @{
            'Dashboard' = @{
                'Port'       = $Port
                'Title'      = $ProjectName
                'RootModule' = "$ProjectName.psm1"
            }
        }

        $Configuration | ConvertTo-Json -Depth 99 | Set-Content -Path (Join-Path $ProjectRoot dbconfig.json)

        # Create the module manifest psd1 for the project
        
        $ModuleManifestSplat = @{
            'Path'       = "{0}.psd1" -f (Join-Path $ProjectRoot $ProjectName)
            'RootModule' = "$ProjectName.psm1"
        }

        New-ModuleManifest @ModuleManifestSplat

        # Create the module psm1 file for the project

        $ModuleFileContents = @'
$Source = Get-ChildItem (Join-Path $PSScriptRoot src) -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue

Foreach ($import in $Source) {
    . $import.fullname
}
'@
        $ModuleFile = "{0}.psm1" -f (Join-Path $ProjectRoot $ProjectName)

        New-Item $ModuleFile > $null

        Set-Content -Path $ModuleFile -Value $ModuleFileContents

        # Create a default empty home page

        $HomePage = @'
New-UDPage -Name "Home" -Icon home -Endpoint { }
'@
        $HomePage | Set-Content (Join-Path (Join-Path $ProjectRoot pages) home.ps1)

        # Create a sample dark theme
        $SampleTheme = @'
$DarkTheme = New-UDTheme -Name 'Dark' -Definition @{
    UDDashboard = @{
        BackgroundColor = "#333333"
        FontColor       = "#FFFFFF"
    }
    UDNavBar    = @{
        BackgroundColor = "#333333"
        FontColor       = "#FFFFFF"
    }
    UDFooter    = @{
        BackgroundColor = "#333333"
        FontColor       = "#FFFFFF"
    }
    UDCard      = @{
        BackgroundColor = "#444444"
        FontColor       = "#FFFFFF"
    }
    UDInput     = @{
        BackgroundColor = "#444444"
        FontColor       = "#FFFFFF"
    }
    UDGrid      = @{
        BackgroundColor = "#444444"
        FontColor       = "#FFFFFF"
    }
    UDChart     = @{
        BackgroundColor = "#444444"
        FontColor       = "#FFFFFF"
    }
    UDMonitor   = @{
        BackgroundColor = "#444444"
        FontColor       = "#FFFFFF"
    }
    UDTable     = @{
        BackgroundColor = "#444444"
        FontColor       = "#FFFFFF"
    }
    '.btn'      = @{
        'color'            = "#ffffff"
        'background-color' = "#a80000"
        
    }
    '.btn:hover'      = @{
        'color'            = "#ffffff"
        'background-color' = "#C70303"
    }
}
'@
        $SampleTheme | Set-Content (Join-Path (Join-Path $ProjectRoot themes) Dark.ps1)

        #EndRegion

        If ($SetAsCurrentLocation) {
            Set-Location $ProjectRoot
        }

        [PSCustomObject]@{
            'Name'               = $ProjectName
            'Root Module'        = $Configuration.dashboard.rootmodule
            'Configuration File' = (Join-Path $ProjectRoot dbconfig.json)
        }
    }
}
