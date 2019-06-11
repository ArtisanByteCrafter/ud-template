<#
.SYNOPSIS
    Creates the framework for a new dashboard project
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> New-UDProject -ProjectName MyProject 
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
[cmdletbinding()]
param(
    [Parameter(Mandatory)]
    [string]$ProjectName

)

Begin {
$ModuleFileContents = @'
$Functions = Get-ChildItem $PSScriptRoot\src\*.ps1 -Recurse -ErrorAction SilentlyContinue
Foreach($import in $Functions) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error "Failed to import function $($import.fullname)"
    }
}
'@
# dot-source components
$SampleDashboard = @'
Import-Module (Join-Path $PSScriptRoot "*.psm1")

. (Join-Path $PSScriptRoot "themes\*.ps1")

$MyDashboard = New-UDDashboard -Title "Sample Dashboard" -Theme $SampleTheme -Content {
    New-UDCard -Title "Sample Dashboard Card"
}
Start-UDDashboard -Port 10000 -Dashboard $MyDashboard -Name 'Sample Dashboard'
'@

$SampleTheme = @'
$SampleTheme = New-UDTheme -Name 'SampleTheme' -Definition @{
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

}
Process {
    Foreach ($folder in "assets","pages","src","themes") {
        New-Item -Path (Join-Path $PSScriptRoot $Folder) -ItemType Directory > $null
    }
    


    Set-Content -Path ("{0}\{1}.psm1" -f $PSScriptRoot,$ProjectName) -Value $ModuleFileContents

    $ModuleManifestSplat = @{
        Path = ("{0}\{1}.psd1" -f $PSScriptRoot,$ProjectName)
        RootModule = "$ProjectName.psm1"
    }
    New-ModuleManifest @ModuleManifestSplat

    Set-Content -Path ("{0}\dashboard.ps1" -f $PSScriptRoot) -Value $SampleDashboard
    Set-Content -Path ("{0}\themes\SampleTheme.ps1" -f $PSScriptRoot) -Value $SampleTheme
}
End {

    [PSCustomObject]@{
        'Name' = $ProjectName
        'ModuleFile' = ("{0}\{1}.psd1" -f $PSScriptRoot,$ProjectName)
    }
}
    
