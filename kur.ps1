# ============================================================
#  AI Yazilim Sirketi - Kurulum / Setup
#  Kullanim: sag tik > "Run with PowerShell"  veya  .\kur.ps1
# ============================================================

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

function Ok($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  [!]    $m" -ForegroundColor Yellow }
function Err($m)  { Write-Host "  [HATA] $m" -ForegroundColor Red }

Write-Host ""
Write-Host "  AI Yazilim Sirketi - Kurulum" -ForegroundColor Cyan
Write-Host "  =============================" -ForegroundColor Cyan
Write-Host ""

# --- 1. Claude Code kontrolu -------------------------------
$claude = Get-Command claude -ErrorAction SilentlyContinue
if ($claude) {
    Ok "Claude Code bulundu: $($claude.Source)"
} else {
    $local = "$env:USERPROFILE\.local\bin\claude.exe"
    if (Test-Path $local) {
        Warn "Claude Code kurulu ama PATH'te yok: $local"
        Write-Host "         Duzeltme (yeni terminal gerekir):"
        Write-Host "         [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path','User') + ';' + \"$env:USERPROFILE\.local\bin\", 'User')"
    } else {
        Err "Claude Code bulunamadi."
        Write-Host "         Kurulum: https://claude.com/download"
        Write-Host ""
    }
}

# --- 2. Ajan dosyalari -------------------------------------
$agents = @(Get-ChildItem "$root\.claude\agents\*.md" -ErrorAction SilentlyContinue)
if ($agents.Count -eq 20) {
    Ok "20 ajan dosyasi hazir"
} elseif ($agents.Count -gt 0) {
    Warn "$($agents.Count) ajan dosyasi bulundu (20 bekleniyordu)"
} else {
    Err ".claude\agents\ bos - paket eksik indirilmis olabilir"
}

# --- 3. Arsiv ----------------------------------------------
$arsivOk = $true
foreach ($k in @('skills','rules','mcp','plugins','dev')) {
    $p = "$root\arsiv\$k"
    if (Test-Path $p) {
        if ($k -eq 'dev') {
            # dev/ servisleri klasor degil katalog kaydi olarak tutar
            $cat = "$p\_catalog.json"
            $n = 0
            if (Test-Path $cat) {
                $json = ConvertFrom-Json (Get-Content $cat -Raw)
                $n = $json.Length
            }
            Ok "arsiv/dev : $n ucretsiz servis"
        } else {
            $n = @(Get-ChildItem $p -Directory -ErrorAction SilentlyContinue).Count
            Ok "arsiv/$k : $n kayit"
        }
    } else {
        Warn "arsiv/$k yok"
        $arsivOk = $false
    }
}
if (-not $arsivOk) {
    Write-Host ""
    Warn "Arsiv eksik. Indirmek icin:  .\arsiv-indir.ps1"
}

# --- 4. Hafiza klasorleri ----------------------------------
$created = 0
foreach ($d in @('00-brief','10-bilgi','20-plan','30-gorevler','40-urun')) {
    $p = "$root\hafiza\$d"
    if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null; $created++ }
}
if ($created -gt 0) { Ok "hafiza/ olusturuldu ($created klasor)" } else { Ok "hafiza/ hazir" }

# --- 5. Bitis ----------------------------------------------
Write-Host ""
Write-Host "  Kurulum tamam." -ForegroundColor Cyan
Write-Host ""
Write-Host "  Baslatmak icin bu klasorde:" -ForegroundColor White
Write-Host ""
Write-Host "      claude" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Sonra CEO'ya gorevini soyle. Ornek:" -ForegroundColor White
Write-Host '      "Kullanicilarin not tutup etiketleyebildigi bir web uygulamasi istiyorum."' -ForegroundColor Gray
Write-Host ""
Write-Host "  NOT: Fable 5 modeli 30 gunluk veri saklama gerektirir." -ForegroundColor DarkGray
Write-Host "       Hesabin sifir-veri-saklama (ZDR) ayarindaysa 4 rol calismaz;" -ForegroundColor DarkGray
Write-Host "       .claude/agents icinde 'model: fable' satirlarini 'model: opus' yap." -ForegroundColor DarkGray
Write-Host ""
