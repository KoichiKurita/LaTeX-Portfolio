# ==========================
# LaTeX Portfolio Makefile
# ==========================

LATEXMK=latexmk
SRC=src/main.tex
OUTDIR=output
PDF=$(OUTDIR)/main.pdf

# Default target
all: build

# --------------------------
# Build PDF
# --------------------------
build:
	@echo "=== Building LaTeX document ==="
	@mkdir -p $(OUTDIR)
	$(LATEXMK) -lualatex \
	-interaction=nonstopmode \
	-file-line-error \
	-outdir=$(OUTDIR) \
	$(SRC)
	@echo "=== Build complete ==="
	@echo "Output: $(PDF)"

# --------------------------
# Watch mode (auto build)
# --------------------------
watch:
	@mkdir -p $(OUTDIR)
	$(LATEXMK) -pvc -lualatex \
	-interaction=nonstopmode \
	-file-line-error \
	-outdir=$(OUTDIR) \
	$(SRC)

# --------------------------
# Clean generated files
# --------------------------
clean:
	@echo "=== Cleaning output directory ==="
	$(LATEXMK) -C
	rm -rf $(OUTDIR)/*
	rm -f src/*.aux src/*.log src/*.toc
	@echo "=== Clean complete ==="

.PHONY: all build watch clean
