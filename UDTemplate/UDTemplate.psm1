$Public  = Get-ChildItem $PSScriptRoot\public\*.ps1 -Recurse -ErrorAction SilentlyContinue

Foreach($import in $Public) {
    . $import.fullname
}