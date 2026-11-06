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
│  ├─ sections/
│  │  ├─ intro.tex
│  │  ├─ theory.tex
│  │  └─ conclusion.tex
|  └─ figures/
├─ data/
├─ output/     # Generated files (PDF, aux, log, etc.)
├─ Makefile
└─ .github/workflows/ci.yml
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
| `make diff` | 比較元（既定は `origin/develop`）との差分を色分けした PDF を生成 |

### PDF/A の検証（Docker が使える環境：WSL など）
```bash
./scripts/check-pdfa.sh output/main.pdf 2b
```

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
- jlreq による日本語組版（JLReq / JIS X 4051 準拠）
- 共通設定を独自パッケージ `portfolio.sty` に分離
- hyperref / cleveref による相互参照と PDF メタデータ
- biblatex + biber による参考文献管理（IEEE スタイル）
- 品質ゲート `make check`（chktex / textlint / フォント埋め込み検査）を CI で実行
- 図は TikZ / pgfplots で描画（グラフは CSV から生成）、PDF にバージョンとコミットを埋め込み
- PDF/A-2b（長期保存用の国際規格）で出力し、veraPDF で適合を CI 検証

---

## 🤖 CI/CD (GitHub Actions)

| トリガー | 実行内容 |
|---|---|
| Pull Request | build（品質ゲート `make check`・SHA-256 の出力）＋ 差分 PDF（Artifacts の `diff-pdf`） |
| `main` への push | build（マージ後の状態の検証） |
| `v*` タグの push | build → GitHub Release を作成 ＋ GitHub Pages へデプロイ（公開ページ＝最新リリース） |

- ビルドはローカルと同じ Dev Container 内で実行（`devcontainers/ci`）
- TeX Live イメージはダイジェストで固定し、`SOURCE_DATE_EPOCH` により再現可能ビルドを実現
- PDF の SHA-256 を Job Summary に出力（ローカルの `make checksum` と照合可能）
- 1回のビルド成果物を後続ジョブで使い回す構成
- `GITHUB_TOKEN` は既定で `contents: read`、必要なジョブにのみ書き込み権限を付与
- Pages は OIDC による公式デプロイ（`actions/deploy-pages`）
- `build` の成功をマージの必須条件に設定
- サードパーティのアクションはコミット SHA で固定し、Dependabot で週次更新

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
