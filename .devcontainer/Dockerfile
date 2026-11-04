FROM texlive/texlive:latest@sha256:07e8062637249c4f780ca59f42cc2ed592bc2dc1db4320769406aee3f98aa70e

RUN apt-get update \
 && apt-get install -y --no-install-recommends make git openssh-client \
 && rm -rf /var/lib/apt/lists/*
