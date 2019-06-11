Import-Module (Join-Path $PSScriptRoot "*.psm1")

. (Join-Path $PSScriptRoot "themes\*.ps1")

$MyDashboard = New-UDDashboard -Title "Sample Dashboard" -Theme $SampleTheme -Content {
    New-UDCard -Title "Sample Dashboard Card"
}
Start-UDDashboard -Port 10000 -Dashboard $MyDashboard -Name 'Sample Dashboard'
