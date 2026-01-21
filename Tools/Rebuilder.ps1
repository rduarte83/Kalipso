# =============================
# REQUIRE ADMIN
# =============================
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Host "Requesting administrative privileges..."
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# =============================
# LOCK TO SCRIPT DIRECTORY
# =============================
$Root = Split-Path -Parent $PSCommandPath
Set-Location $Root

Write-Host "Running as Administrator"
Write-Host "Root locked to:"
Write-Host $Root
Write-Host ""

# =============================
# DELETE Source.del IF EXISTS
# =============================
$SourceDelPath = Join-Path $Root "Source.del"
if (Test-Path $SourceDelPath) {
    Write-Host "Deleting Source.del..."
    Remove-Item -Path $SourceDelPath -Force
    Write-Host "Deleted Source.del"
    Write-Host ""
} else {
    Write-Host "Source.del not found, skipping."
    Write-Host ""
}

# =============================
# GET ALL DIRECTORIES (deepest first)
# =============================
$Folders = Get-ChildItem -Path $Root -Directory -Recurse |
           Sort-Object FullName -Descending

foreach ($Folder in $Folders) {

    Write-Host "Processing: $($Folder.FullName)"

    $Temp = Join-Path $Folder.FullName ".__temp__"

    # create temp folder
    New-Item -ItemType Directory -Path $Temp -Force | Out-Null

    # copy contents to temp (exclude temp itself)
    Get-ChildItem -Path $Folder.FullName -Force |
        Where-Object { $_.Name -ne '.__temp__' } |
        Copy-Item -Destination $Temp -Recurse -Force

    # remove contents ONLY (keep folder & ACLs)
    Get-ChildItem -Path $Folder.FullName -Force |
        Where-Object { $_.Name -ne '.__temp__' } |
        Remove-Item -Recurse -Force

    # restore contents
    Get-ChildItem -Path $Temp -Force |
        Copy-Item -Destination $Folder.FullName -Recurse -Force

    # cleanup
    Remove-Item -Path $Temp -Recurse -Force

    Write-Host "Done"
    Write-Host ""
}

Write-Host "All folders processed recursively."
Pause
