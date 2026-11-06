FROM texlive/texlive:latest@sha256:07e8062637249c4f780ca59f42cc2ed592bc2dc1db4320769406aee3f98aa70e

# 文書の日付（\today）を日本時間にする
# POSIX 形式の TZ 指定は tzdata（タイムゾーンデータ）が無くても有効
ENV TZ=JST-9

RUN apt-get update \
 && apt-get install -y --no-install-recommends make git openssh-client poppler-utils \
 && rm -rf /var/lib/apt/lists/*

# 作業ユーザー：イメージ既存の texlive（UID 1000 = WSL の一般ユーザーと同じ ID）
# ホームディレクトリ（VS Code Server・フォントキャッシュ・gh の認証情報の保存先）と
# ログインシェルを確実に用意する
RUN mkdir -p /home/texlive \
 && usermod --home /home/texlive --shell /bin/bash texlive \
 && chown texlive:texlive /home/texlive
