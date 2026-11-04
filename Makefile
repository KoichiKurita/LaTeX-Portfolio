# ==========================
# LaTeX Portfolio Makefile
# ビルド設定は .latexmkrc に集約
# ==========================

SRC    := src/main.tex
STY    := src/portfolio.sty
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

.PHONY: all build watch checksum clean lint lint-tex check

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
check: lint build

lint: lint-tex

# LaTeX の静的解析
# -n24: \section 直後の改行＋\label を「余分な空白」と誤検知するため無効化
lint-tex:
	chktex -q -n24 $(SRC) $(STY)

clean:
	latexmk -C $(SRC)
	rm -rf $(OUTDIR)
