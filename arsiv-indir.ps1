# ============================================================
#  Arsiv indirici - mdskills.ai + free-for.dev
#  Paket arsivsiz geldiyse bunu calistir.
# ============================================================

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$arsiv = Join-Path $root 'arsiv'

Write-Host ""
Write-Host "  Arsiv indiriliyor..." -ForegroundColor Cyan
Write-Host "  Kaynaklar: mdskills.ai  |  github.com/ripienaar/free-for-dev"
Write-Host ""

$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    $nodejs = "C:\Program Files\nodejs\node.exe"
    if (Test-Path $nodejs) {
        $env:Path += ";C:\Program Files\nodejs"
    } else {
        Write-Host "  [HATA] Node.js gerekli: https://nodejs.org" -ForegroundColor Red
        exit 1
    }
}

New-Item -ItemType Directory -Path $arsiv -Force | Out-Null
node (Join-Path $root 'tools\indir.js') $arsiv
