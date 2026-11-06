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

# PDF に埋め込むバージョン情報（CI などで環境変数が渡された場合はそちらを優先）
DOC_VERSION ?= $(shell git describe --tags --match 'v*' --dirty --abbrev=7 2>/dev/null || echo dev)
DOC_COMMIT  ?= $(shell git rev-parse --short=7 HEAD 2>/dev/null || echo unknown)
VERSION_TEX := $(OUTDIR)/version.tex

.PHONY: all build watch checksum clean lint lint-tex lint-text check-pdf check FORCE

all: build

build: $(VERSION_TEX)
	latexmk $(SRC)

watch: $(VERSION_TEX)
	latexmk -pvc -view=none $(SRC)

# バージョン情報ファイル：内容が変わったときだけ更新する
# （毎回書き換えると、latexmk が変更ありと判断して不要な再ビルドが起きるため）
$(VERSION_TEX): FORCE
	@mkdir -p $(OUTDIR)
	@printf '\\newcommand{\\docversion}{%s}\n\\newcommand{\\doccommit}{%s}\n' '$(DOC_VERSION)' '$(DOC_COMMIT)' > $@.tmp
	@if cmp -s $@.tmp $@; then rm -f $@.tmp; else mv $@.tmp $@; fi

checksum: build
	sha256sum $(PDF)

# --------------------------
# 品質ゲート（CI も make check を実行）
# --------------------------
check: lint check-pdf

lint: lint-tex lint-text

# LaTeX の静的解析
# -n24: \section 直後の改行＋\label を「余分な空白」と誤検知するため無効化
# chktex は警告の種類によって終了コードが 0 になる（例：括弧の不一致）ため、
# 標準出力に警告が1行でもあれば失敗とする（% chktex で除外した旨のメッセージは標準エラー出力）
lint-tex:
	@out=$$(chktex -q -n24 $(SRC) $(STY)); status=$$?; \
	if [ -n "$$out" ]; then printf '%s\n' "$$out"; echo "chktex: 警告があります"; exit 1; fi; \
	exit $$status

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
