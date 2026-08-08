#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo ""
echo "  AI Yazilim Sirketi - Kurulum / Setup"
echo "  ====================================="
echo ""

if command -v claude >/dev/null 2>&1; then
  echo "  [OK]   Claude Code: $(command -v claude)"
else
  echo "  [HATA] Claude Code bulunamadi -> https://claude.com/download"
fi

n=$(ls .claude/agents/*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "$n" = "20" ]; then echo "  [OK]   20 ajan dosyasi hazir"
else echo "  [!]    $n ajan dosyasi bulundu (20 bekleniyordu)"; fi

missing=0
for k in skills rules mcp plugins dev; do
  if [ -d "arsiv/$k" ]; then
    if [ "$k" = "dev" ]; then
      # dev/ servisleri klasor degil katalog kaydi olarak tutar
      c=$(grep -o '"url"' "arsiv/dev/_catalog.json" 2>/dev/null | wc -l | tr -d ' ')
      echo "  [OK]   arsiv/dev : $c ucretsiz servis"
    else
      c=$(find "arsiv/$k" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')
      echo "  [OK]   arsiv/$k : $c kayit"
    fi
  else
    echo "  [!]    arsiv/$k yok"; missing=1
  fi
done
[ "$missing" = "1" ] && echo "" && echo "  Arsiv eksik. Indirmek icin:  node tools/indir.js arsiv"

mkdir -p hafiza/{00-brief,10-bilgi,20-plan,30-gorevler,40-urun}
echo "  [OK]   hafiza/ hazir"

echo ""
echo "  Kurulum tamam. Baslatmak icin bu klasorde:"
echo ""
echo "      claude"
echo ""
echo "  NOT: Fable 5 modeli 30 gunluk veri saklama gerektirir."
echo "       ZDR hesabindaysan .claude/agents icinde 'model: fable' -> 'model: opus' yap."
echo ""