$Functions = Get-ChildItem $PSScriptRoot\src\*.ps1 -Recurse -ErrorAction SilentlyContinue
Foreach($import in $Functions) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error "Failed to import function $($import.fullname)"
    }
}
