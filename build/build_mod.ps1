# Build the Simplified Chinese patch mod for Warrior Cats: Clans of the Forest.
#
# Output: <OutDir>/pakchunk0-Windows_P.pak + .utoc + .ucas  (install into <game>/Wrc/Content/Paks/)
#
# Requirements:
#   - UnrealPak.exe from Unreal Engine 5.7/5.8  (pass -UnrealPak "<path>")
#   - retoc.exe (https://github.com/trumank/retoc/releases)  (pass -Retoc "<path>")
#
# Usage (from repo root):
#   powershell -ExecutionPolicy Bypass -File build\build_mod.ps1 `
#       -UnrealPak "C:\Program Files\Epic Games\UE_5.8\Engine\Binaries\Win64\UnrealPak.exe" `
#       -Retoc ".\tools\retoc\retoc.exe" `
#       -OutDir ".\dist"
param(
    [Parameter(Mandatory = $true)][string]$UnrealPak,
    [Parameter(Mandatory = $true)][string]$Retoc,
    [string]$OutDir = ".\dist",
    [switch]$Compress
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$work = Join-Path $repo 'build\tmp'
$stage = Join-Path $work 'stage'
$modName = 'pakchunk0-Windows_P'
if (-not [System.IO.Path]::IsPathRooted($OutDir)) { $OutDir = Join-Path $repo $OutDir }
$OutDir = [System.IO.Path]::GetFullPath($OutDir)

foreach ($tool in @($UnrealPak, $Retoc)) {
    if (-not (Test-Path $tool)) { throw "tool not found: $tool" }
}

# ---- staging: virtual paths ----
Remove-Item -Recurse -Force $stage -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force (Join-Path $stage 'Wrc\Content\Gameplay\Strings\NonAsset') | Out-Null
Copy-Item (Join-Path $repo 'assets\strings\Strings_EN.zh.csv') (Join-Path $stage 'Wrc\Content\Gameplay\Strings\NonAsset\Strings_EN.csv')
Copy-Item -Path (Join-Path $repo 'assets\fonts\Wrc\*') -Destination (Join-Path $stage 'Wrc') -Recurse -Force
Copy-Item (Join-Path $repo 'assets\marker\WRC-CN-ModMarker.txt') (Join-Path $stage 'WRC-CN-ModMarker.txt')

# ---- response file ----
$virtuals = New-Object System.Collections.Generic.List[string]
$virtuals.Add('Wrc/Content/Gameplay/Strings/NonAsset/Strings_EN.csv')
$virtuals.Add('WRC-CN-ModMarker.txt')
Get-ChildItem (Join-Path $stage 'Wrc\Content\Art\UXD\Fonts') -Recurse -File -Filter '*.ufont' | ForEach-Object {
    $rel = $_.FullName.Substring($stage.Length).TrimStart('\').Replace('\', '/')
    $virtuals.Add($rel)
}
$resp = Join-Path $work 'response.txt'
$lines = foreach ($v in $virtuals) { '"{0}" "../../../{1}"' -f (Join-Path $stage $v.Replace('/', '\')), $v }
[System.IO.File]::WriteAllText($resp, (($lines -join "`r`n") + "`r`n"), (New-Object System.Text.UTF8Encoding($false)))

# ---- legacy patch pak ----
New-Item -ItemType Directory -Force $work | Out-Null
$legacyPak = Join-Path $work "$modName.pak"
Remove-Item $legacyPak -ErrorAction SilentlyContinue
$pakArgs = @($legacyPak, "-Create=$resp")
if ($Compress) { $pakArgs += '-Compress' }
& $UnrealPak @pakArgs | Out-Null
if (-not (Test-Path $legacyPak)) { throw 'UnrealPak failed to create patch pak' }

# ---- IoStore container (required by the game: pak only mounts when matching .utoc exists) ----
& $Retoc to-zen $legacyPak (Join-Path $work "$modName.utoc") --version UE5_7 | Out-Null

# ---- output ----
New-Item -ItemType Directory -Force $OutDir | Out-Null
foreach ($ext in 'pak', 'utoc', 'ucas') {
    $src = Join-Path $work "$modName.$ext"
    if (-not (Test-Path $src)) { throw "missing build output: $src" }
    Copy-Item $src $OutDir -Force
}
Write-Host '--- validation ---'
& $UnrealPak (Join-Path $OutDir "$modName.pak") -List | Select-String 'mount point|files \(' | ForEach-Object { Write-Host $_.Line }
& $Retoc info (Join-Path $OutDir "$modName.utoc") | Select-String 'version|chunks|compression' | ForEach-Object { Write-Host $_.Line }
& $Retoc verify (Join-Path $OutDir "$modName.utoc")
Write-Host "Done. Files in: $OutDir"