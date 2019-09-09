$ConfigurationFile = Get-Content (Join-Path $PSScriptRoot dbconfig.json) | ConvertFrom-Json

Try {
    Import-Module (Join-Path $PSScriptRoot $ConfigurationFile.dashboard.rootmodule) -ErrorAction Stop
} Catch {
    Write-Warning "Valid function module not found. Generate one by running $(Join-Path $PSScriptRoot New-UDProject.ps1) -ProjectName 'myProject'"
    break;
}

. (Join-Path $PSScriptRoot "themes\*.ps1")

$PageFolder = Get-ChildItem (Join-Path $PSScriptRoot pages)

$Pages = Foreach ($Page in $PageFolder){
    . $Page.Fullname
}

$Initialization = New-UDEndpointInitialization -Module @(Join-Path $PSScriptRoot $ConfigurationFile.dashboard.rootmodule)

$DashboardParams=@{
    Title = $ConfigurationFile.dashboard.title
    Theme = $SampleTheme
    Pages = $Pages
    EndpointInitialization = $Initialization
}

$MyDashboard = New-UDDashboard @DashboardParams

Start-UDDashboard -Port $ConfigurationFile.dashboard.port -Dashboard $MyDashboard -Name $ConfigurationFile.dashboard.title