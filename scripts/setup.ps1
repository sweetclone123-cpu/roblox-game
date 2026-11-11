$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$toolDir = Join-Path $repoRoot '.tools'
$rojoExe = Join-Path $toolDir 'rojo.exe'
$version = '7.7.1'
New-Item -ItemType Directory -Force -Path $toolDir, (Join-Path $repoRoot 'build') | Out-Null

if (-not (Test-Path -LiteralPath $rojoExe)) {
    $architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
    $target = if ($architecture -eq 'Arm64') { 'aarch64' } else { 'x86_64' }
    $zipPath = Join-Path $toolDir "rojo-$version.zip"
    $downloadUrl = "https://github.com/rojo-rbx/rojo/releases/download/v$version/rojo-$version-windows-$target.zip"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing
    Expand-Archive -LiteralPath $zipPath -DestinationPath $toolDir -Force
}

$reportedVersion = & $rojoExe --version
if ($LASTEXITCODE -ne 0 -or $reportedVersion -ne "Rojo $version") {
    throw "Expected Rojo $version; received: $reportedVersion"
}
& $rojoExe plugin install
if ($LASTEXITCODE -ne 0) { throw 'Rojo plugin installation failed.' }
Push-Location -LiteralPath $repoRoot
try {
    & $rojoExe sourcemap default.project.json --output sourcemap.json
    if ($LASTEXITCODE -ne 0) { throw 'Sourcemap generation failed.' }
} finally {
    Pop-Location
}
Write-Host 'Ready. Open this folder in VS Code. Run task: Rojo: Serve.'
Write-Host 'In Roblox Studio: Plugins > Rojo > Connect (localhost:34872).'
