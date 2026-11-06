# LaTeX Portfolio

[![CI](https://github.com/KoichiKurita/LaTeX-Portfolio/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/KoichiKurita/LaTeX-Portfolio/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/KoichiKurita/LaTeX-Portfolio)](https://github.com/KoichiKurita/LaTeX-Portfolio/releases/latest)
[![License: MIT](https://img.shields.io/github/license/KoichiKurita/LaTeX-Portfolio)](LICENSE)

日本語の技術レポート「TCP/IP ネットワーク基礎と通信性能の考察」を題材に、
**LaTeX 文書をソフトウェアと同じ品質基準で開発・検証・配布する仕組み**を構築したポートフォリオです。

## 🔗 成果物

| 種類 | リンク |
|---|---|
| 公開ページ（最新リリースの PDF） | https://koichikurita.github.io/LaTeX-Portfolio/ |
| リリース（バージョンごとの PDF） | https://github.com/KoichiKurita/LaTeX-Portfolio/releases |

PDF の表紙には、バージョンとコミット（例：`v1.6.0（9693a47）`）が印字されます。

---

## ✨ ハイライト

| 観点 | 取り組み |
|---|---|
| **再現性** | Dev Container・ダイジェストで固定した TeX Live・`SOURCE_DATE_EPOCH` により、ローカルと CI で **PDF の SHA-256 が一致** |
| **品質ゲート** | chktex（LaTeX 静的解析）・textlint（日本語校正）・フォント埋め込み検査・veraPDF（規格適合）を `make check` と CI で実行 |
| **規格準拠** | **PDF/A-3b**（長期保存）と **PDF/UA-1**（アクセシビリティ）に適合し、CI で毎回検証 |
| **アクセシビリティ** | Tagged PDF（見出し・段落・表・数式に構造タグ）、図に代替テキストを設定 |
| **セキュリティ** | `GITHUB_TOKEN` の最小権限・OIDC デプロイ・アクションの SHA 固定・Dependabot・非 root コンテナ・Secret scanning |
| **レビュー** | PR ごとに変更箇所を色分けした**差分 PDF**（latexdiff）を自動生成 |
| **運用** | Git Flow 型のブランチ戦略、タグ＝リリース、公開ページ＝最新リリース |

---

## 📄 文書の技術要素（LaTeX）

- **jlreq** による日本語組版（JLReq / JIS X 4051 準拠）、LuaLaTeX
- 共通設定を独自パッケージ **`portfolio.sty`** に分離
- **hyperref / cleveref** による相互参照（「第2節」「表1」「図1」「式(1)」）と PDF メタデータ
- **biblatex + biber** による参考文献管理（IEEE スタイル、RFC 9293 / RFC 768）
- **TikZ** によるシーケンス図、**pgfplotstable** で CSV（`data/latency.csv`）から描くグラフ
- 索引（makeindex）、表紙へのバージョン情報の埋め込み

---

## 📂 ディレクトリ構成

```text
LaTeX-Portfolio/
├─ .devcontainer/          # 開発環境（TeX Live をダイジェストで固定、非 root ユーザー）
├─ .github/
│  ├─ workflows/ci.yml     # CI/CD（ビルド・検証・リリース・Pages）
│  ├─ verapdf/Dockerfile   # veraPDF（規格検証）のイメージを固定
│  ├─ dependabot.yml       # 依存関係の自動更新
│  └─ ISSUE_TEMPLATE/ ・ pull_request_template.md
├─ src/
│  ├─ main.tex             # 文書の入口（\DocumentMetadata・バージョン情報）
│  ├─ portfolio.sty        # 共通設定（パッケージ・相互参照・参考文献）
│  ├─ references.bib       # 参考文献データベース
│  ├─ sections/            # 本文（はじめに・比較と数式モデル・まとめ）
│  └─ figures/             # TikZ の図（シーケンス図・遅延グラフ）
├─ data/latency.csv        # グラフのデータ（モデルによる計算値）
├─ scripts/check-pdf-standard.sh   # PDF/A・PDF/UA の検証（veraPDF）
├─ site/index.html         # 公開ページ
├─ .latexmkrc              # ビルド設定（一元管理）
├─ .textlintrc.json ・ package.json   # 日本語校正（textlint）
├─ Makefile                # ビルド・検査・差分のコマンド
└─ output/                 # 生成物（Git 管理外）
```

---

## 🚀 ビルド

### Dev Container（推奨）

1. Docker Desktop（WSL2）と VS Code（拡張機能：Dev Containers）をインストール
2. リポジトリを開き、`Dev Containers: Reopen in Container` を実行
3. ターミナルで `make` を実行すると、`output/main.pdf` が生成されます

| コマンド | 内容 |
|---|---|
| `make` | PDF をビルド |
| `make check` | 品質ゲート（chktex・textlint・ビルド・フォント埋め込み検査） |
| `make diff` | 比較元（既定は `origin/develop`）との差分を色分けした PDF を生成（例：`make diff DIFF_BASE=v1.5.0`） |
| `make checksum` | PDF の SHA-256 を表示 |
| `make watch` | 変更を監視して自動ビルド |
| `make clean` | 生成物を削除 |

### PDF 規格の検証（Docker が使える環境：WSL など）

```bash
./scripts/check-pdf-standard.sh output/main.pdf 3b    # PDF/A-3b
./scripts/check-pdf-standard.sh output/main.pdf ua1   # PDF/UA-1
```

### 再現可能ビルドの確認

コミット済みの状態で `make checksum` を実行し、同じコミットの CI の Job Summary に表示される SHA-256 と一致することを確認できます。

---

## 🤖 CI/CD（GitHub Actions）

| トリガー | 実行内容 |
|---|---|
| Pull Request | `make check` ＋ PDF/A-3b・PDF/UA-1 の検証 ＋ SHA-256 の出力 ＋ 差分 PDF（Artifacts の `diff-pdf`） |
| `main` への push | 同上の検証（マージ後の状態の確認） |
| `v*` タグの push | 検証 → GitHub Release の作成 ＋ GitHub Pages へのデプロイ |

- ビルドはローカルと同じ Dev Container 内で実行（`devcontainers/ci`）
- 1回のビルド成果物を、Release と Pages の両方で使い回す
- `GITHUB_TOKEN` は既定で `contents: read`、必要なジョブにのみ書き込み権限を付与
- Pages は OIDC による公式デプロイ。タグの push 時のみ実行し、直列化している
- PDF はリリースごとにファイル名を変えて公開（CDN のキャッシュ対策）
- サードパーティのアクション・コンテナイメージはダイジェストで固定し、Dependabot で更新
- `build` の成功をマージの必須条件に設定。ランナーは `ubuntu-24.04` に固定

---

## 🌿 開発フロー

```text
<type>/<issue>-<desc> ──(Squash)──> develop ──(Merge commit)──> main ──(tag v*)──> Release / Pages
```

| ブランチ | 役割 |
|---|---|
| `main` | リリース済みの状態（保護） |
| `develop` | 統合（保護） |
| `feature/` `fix/` `docs/` `ci/` `chore/` | 1 Issue ＝ 1 ブランチ |

- コミットメッセージは [Conventional Commits](https://www.conventionalcommits.org/) に準拠
- Issue は Milestone（Step 単位）で管理し、PR から `Refs #` / `Closes #` で関連付け
- バージョンはセマンティックバージョニング（PDF の内容に影響しない修正はパッチ版）

---

## 🛠 主なトラブルシューティングの記録

| 事象 | 原因 | 対策 |
|---|---|---|
| ローカルと CI で PDF の SHA-256 が不一致（#37） | PR の CI が一時的なマージコミットをビルドしていた | PR ではブランチの先頭コミットをビルド |
| 括弧の不一致があっても品質ゲートを通過（#68） | chktex が一部の警告で終了コード 0 を返す | 警告の出力有無で判定するよう変更 |
| `\DocumentMetadata` でビルドが失敗（#74） | TeX Live 2026 で jlreq の内部命令の定義順の不具合が顕在化 | 該当命令を先に空で定義する回避策 |
| リリース後も Pages の PDF が旧版のまま（#72） | main とタグのデプロイが同一コミットで競合 | タグの push 時のみデプロイ、直列化、ファイル名にバージョン |

詳細は各 Issue / PR を参照してください。

---

## ⚠️ 既知の制約

- jlreq の見出し・目次は、LaTeX のタグ付け機能（tagpdf）に未対応の部分があり、
  ビルド時に構造の警告（`Parent-Child ... not allowed`）が出ます。
  PDF/UA-1 の検証には合格していますが、構造は完全ではありません。
- 数式は MathML ではなく、LaTeX ソースを代替テキストとして使用しています。
- 遅延グラフの値はモデルによる計算値であり、実測値ではありません。

---

## 🧠 必要環境

- Docker Desktop（WSL2 バックエンド）＋ VS Code（Dev Containers）
  - TeX Live 2026・latexmk・Node.js（LTS）・poppler-utils はコンテナに含まれます
- PDF 規格の検証には、ホスト側で Docker が必要です

---

## 📝 Development Note

This project was developed with the assistance of AI tools (ChatGPT, Claude)
for architectural guidance, debugging, and best practices.

All integration, configuration, and final implementation were
performed and validated by the author.

## 🔒 Security / 📄 License

- セキュリティポリシー：[SECURITY.md](SECURITY.md)
- [MIT License](LICENSE)
