# ==========================
# LaTeX Portfolio Makefile
# ビルド設定は .latexmkrc に集約
# ==========================

SRC    := src/main.tex
STY    := src/portfolio.sty
TEXT   := src/sections/*.tex
OUTDIR := output
PDF    := $(OUTDIR)/main.pdf

# 引数なしの make で実行するターゲット（定義順に依存しないよう明示）
.DEFAULT_GOAL := build

# 再現可能ビルド：最終コミットの時刻をビルド時刻として使う
# （CI などで環境変数が渡された場合はそちらを優先）
SOURCE_DATE_EPOCH ?= $(shell git log -1 --format=%ct 2>/dev/null)
ifneq ($(SOURCE_DATE_EPOCH),)
export SOURCE_DATE_EPOCH
export FORCE_SOURCE_DATE := 1
endif

.PHONY: all build watch checksum clean lint lint-tex lint-text check-pdf check

all: build

build:
	latexmk $(SRC)

watch:
	latexmk -pvc -view=none $(SRC)

checksum: build
	sha256sum $(PDF)

# --------------------------
# 品質ゲート（CI も make check を実行）
# --------------------------
check: lint check-pdf

lint: lint-tex lint-text

# LaTeX の静的解析
# -n24: \section 直後の改行＋\label を「余分な空白」と誤検知するため無効化
lint-tex:
	chktex -q -n24 $(SRC) $(STY)

# 日本語の文章校正（依存パッケージは package-lock.json で固定）
node_modules: package.json package-lock.json
	npm ci
	@touch $@

lint-text: node_modules
	npx textlint $(TEXT)

# PDF のフォント埋め込みチェック（未埋め込みがあれば失敗）
check-pdf: build
	@echo "=== フォント埋め込みチェック: $(PDF) ==="
	@pdffonts $(PDF)
	@pdffonts $(PDF) | awk 'NR > 2 && $$(NF-4) != "yes" { print "未埋め込みのフォント: " $$1; bad = 1 } END { exit bad }'
	@echo "OK: すべてのフォントが埋め込まれています"
	
clean:
	latexmk -C $(SRC)
	rm -rf $(OUTDIR)
