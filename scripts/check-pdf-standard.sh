#!/usr/bin/env bash
# ==========================================
# PDF の規格適合検証（veraPDF）：PDF/A・PDF/UA に対応
# 使い方: scripts/check-pdf-standard.sh [PDFファイル] [規格（例: 3b, ua1）]
# Docker が必要（CI のランナー、または WSL などのホストで実行する）
# ==========================================
set -euo pipefail

pdf="${1:-output/main.pdf}"
flavour="${2:-2b}"
dir="$(cd "$(dirname "$pdf")" && pwd)"
name="$(basename "$pdf")"
report="${dir}/verapdf-report-${flavour}.xml"
image="latex-portfolio-verapdf"

# ダイジェストを固定した veraPDF イメージ（Dependabot で更新）
docker build --quiet --tag "$image" "$(dirname "$0")/../.github/verapdf" > /dev/null

# 検証（PDF は読み取り専用でマウント）。結果は XML で保存し、適合しているかを判定する
docker run --rm --volume "${dir}:/data:ro" "$image" --flavour "$flavour" "/data/${name}" \
  > "$report" || true

rules="$(grep -o 'passedRules="[0-9]*" failedRules="[0-9]*"' "$report" || true)"
if grep -q 'isCompliant="true"' "$report"; then
  echo "OK: ${flavour} に適合しています（${rules}）"
else
  echo "NG: ${flavour} に適合していません（${rules}）"
  echo "詳細: ${report}"
  exit 1
fi
