# ==========================
# LaTeX Portfolio Makefile
# ビルド設定は .latexmkrc に集約
# ==========================

SRC    := src/main.tex
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

.PHONY: all build watch clean checksum

all: build

build:
	latexmk $(SRC)

watch:
	latexmk -pvc -view=none $(SRC)

checksum: build
	sha256sum $(PDF)

clean:
	latexmk -C $(SRC)
	rm -rf $(OUTDIR)
