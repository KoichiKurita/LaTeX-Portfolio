# Security Policy

## サポート対象

| バージョン | サポート |
|---|---|
| 最新リリース | ✅ |
| それ以前 | ❌ |

## 脆弱性の報告方法

脆弱性を発見した場合は、**公開の Issue ではなく**、
[Security タブの「Report a vulnerability」](../../security/advisories/new)
から非公開で報告してください。

報告には以下を含めてください。

- 影響を受けるファイル・ワークフロー
- 再現手順
- 想定される影響

通常 7 日以内に初回の返信を行います（個人運営のためベストエフォート）。

## 対象範囲

- GitHub Actions ワークフロー（`.github/workflows/`）
- 開発環境の定義（`.devcontainer/`）
- LaTeX ソースとビルド設定

## セキュリティ方針

- `GITHUB_TOKEN` は既定で読み取り専用とし、必要なジョブにのみ書き込み権限を付与
- サードパーティのアクションはコミット SHA で固定し、Dependabot で更新
- LaTeX のビルドで `--shell-escape`（外部コマンドの実行）は使用しない
- 開発コンテナは root ではなく一般ユーザー（texlive）で実行
