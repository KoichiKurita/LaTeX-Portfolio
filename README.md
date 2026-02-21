# LaTeX Portfolio

高度なLaTeX技術解説書ポートフォリオです。

### 🔗 Review PDF Link
https://KoichiKurita.github.io/LaTeX-Portfolio/

---

## 📂 Project Structure

```bat
latex-portfolio/
├─ src/        # LaTeX source files
│  ├─ main.tex
│  └─ sections/
│     ├─ intro.tex
│     ├─ theory.tex
│     └─ conclusion.tex
├─ images/     # Image assets
│  └─ tcp_udp.png
├─ output/     # Generated files (PDF, aux, log, etc.)
├─ Makefile
└─ .github/workflows/build.yml
```

---

## 🚀 Build (Windows PowerShell)

```powershell
latexmk -lualatex -interaction=nonstopmode -file-line-error -outdir=output src/main.tex
```

---

## 🛠 Makefile Usage

### Build

```powershell
make
```

### Watch (auto build)

```powershell
make watch
```

### Clean

```powershell
make clean
```

---

## 📑 Features

- LuaLaTeX (Japanese supported)
- Automatic index generation (makeindex)
- Graphs with pgfplots
- Multi-file structured document
- Output files isolated in `/output`
- GitHub Actions CI enabled

---

## 🤖 Continuous Integration (GitHub Actions)

- Push to `main` branch triggers automatic PDF build.
- The generated PDF is available in GitHub Actions Artifacts.

---

## 🧠 Requirements

- TeX Live 2025+
- latexmk
- LuaLaTeX

---

## Development Note

This project was developed with the assistance of AI tools (ChatGPT)
for architectural guidance, debugging, and best practices.

All integration, configuration, and final implementation were
performed and validated by the author.

## 📄 License

MIT License
