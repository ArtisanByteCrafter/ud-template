$Public  = Get-ChildItem $PSScriptRoot\UDTemplate\public\*.ps1 -Recurse -ErrorAction SilentlyContinue

Foreach($import in $Public) {
    . $import.fullname
}