<#
.SYNOPSIS
    Creates the framework for a new dashboard project
.DESCRIPTION
    Creates a module for the project that imports all *.ps1 located in the /src folder.
.EXAMPLE
    PS C:\> New-UDProject -ProjectName myProject 
    Creates a new project called myProject. The dashboard will use this for it's title,
    but this is configurable in dbconfig.json
.INPUTS
    Inputs (if any)
.OUTPUTS
    PSCustomObject of the dashboard module name and location
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
$Source = Get-ChildItem $PSScriptRoot\src\*.ps1 -Recurse -ErrorAction SilentlyContinue

Foreach($import in $Source) {
     . $import.fullname
}
'@

$Configuration = Get-Content (Join-Path $PSScriptRoot dbconfig.json) | ConvertFrom-Json

}
Process {

    $Configuration.dashboard.title = $ProjectName
    $Configuration.dashboard.rootmodule = "$ProjectName.psm1"
    $Configuration | ConvertTo-Json -Depth 99 | Set-Content -Path (Join-Path $PSScriptRoot dbconfig.json)

    Foreach ($folder in 'src','assets') {
        $NewItemSplat = @{
            ItemType = 'Directory'
            Path = (Join-Path $PSScriptRoot $folder)
            ErrorAction = 'SilentlyContinue'
        }
        New-Item @NewItemSplat > $null
    } 

    Set-Content -Path ("{0}\{1}.psm1" -f $PSScriptRoot,$ProjectName) -Value $ModuleFileContents

    $ModuleManifestSplat = @{
        Path = ("{0}\{1}.psd1" -f $PSScriptRoot,$ProjectName)
        RootModule = "$ProjectName.psm1"
    }
    New-ModuleManifest @ModuleManifestSplat

}
End {

    [PSCustomObject]@{
        'Name' = $ProjectName
        'RootModule' = (Join-Path $PSScriptRoot $Configuration.dashboard.rootmodule )
        'ConfigFile' = (Join-Path $PSScriptRoot dbconfig.json)
    }
}
    
