# ==========================
# LaTeX Portfolio Makefile
# ビルド設定は .latexmkrc に集約
# ==========================

SRC    := src/main.tex
OUTDIR := output
PDF    := $(OUTDIR)/main.pdf

.PHONY: all build watch clean

all: build

build:
	latexmk $(SRC)

watch:
	latexmk -pvc -view=none $(SRC)

clean:
	latexmk -C $(SRC)
	rm -rf $(OUTDIR)
