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

## 🚀 Build

### Dev Container（推奨）

1. Docker Desktop と VS Code（拡張機能：Dev Containers）をインストール
2. リポジトリを開き、`Dev Containers: Reopen in Container` を実行
3. ターミナルで `make` を実行 → `output/main.pdf` が生成されます

| コマンド | 内容 |
|---|---|
| `make` | PDF をビルド |
| `make watch` | 変更を監視して自動ビルド |
| `make clean` | 生成物を削除 |

---

## 🌿 Branch Strategy

```
<type>/<issue>-<desc> ──(Squash)──> develop ──(Merge commit)──> main ──> Pages / Release
```

| ブランチ | 役割 |
|---|---|
| `main` | 公開版（保護） |
| `develop` | 統合（保護） |
| `feature/` `fix/` `docs/` `ci/` `chore/` | 1 Issue = 1 ブランチ |

- コミットメッセージは [Conventional Commits](https://www.conventionalcommits.org/) に準拠
- Issue は Milestone（Step 単位）で管理

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
