# ud-template
A scaffolded Template for UniversalDashboard Projects

## To create a new project:

Run the included script with a single parameter `New-UDProject.ps1 -ProjectName 'myProject'`

## v1:

**This script does the following:**

[x] sets a module for the project that automatically sources .ps1 files in the `src` folder

[x] Sources each theme defined in `/themes` as a usable theme in `New-UDDashboard -Theme $myTheme`. A theme is included as an example.

[x] creates a `dashboard.ps1` file with a sample dashboard.


