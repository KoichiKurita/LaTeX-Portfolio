FROM texlive/texlive:latest

RUN apt-get update \
 && apt-get install -y --no-install-recommends make git openssh-client \
 && rm -rf /var/lib/apt/lists/*
