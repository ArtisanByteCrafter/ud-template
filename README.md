# ud-template
A scaffolded Template for UniversalDashboard Projects

## To create a new project:

```powershell
PS> Import-Module ud-template.psd1

PS> New-UDProject -ProjectName 'MyApp' -Destination C:\Temp -SetAsCurrentLocation

C:\Temp> .\dashboard.ps1
```

## v1:

**This script does the following:**

* sets a module for the project that automatically sources .ps1 files in the `src` folder

* Sources each theme defined in `/themes` as a usable theme in `New-UDDashboard -Theme $myTheme`. A theme is included as an example and is enabled by default.

* Initializes and sources all functions defined by the root module, which in turn sources all functions in /src. This means any *.ps1 files in /src automatically are availabe in all runspaces.

* Creates a page for each page.ps1 found in /pages. A home page is included by default.


