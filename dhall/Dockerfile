FROM golang:1.14-rc-buster
MAINTAINER chad.grant@me.com
ARG DHALL_VERSION="1.28.0"

RUN apt-get update && \
    apt-get install -y bzip2 unzip && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/dhall-lang/dhall-haskell/releases/download/${DHALL_VERSION}/dhall-${DHALL_VERSION}-x86_64-linux.tar.bz2 \
    --output dhall.tar.bz2 && \
	tar --extract --bzip2 --file dhall.tar.bz2 && \
	rm dhall.tar.bz2 && \
	mv ./bin/dhall /usr/local/bin && \
	rm -rf bin src && \
	ls -la /usr/local/bin/d*

ENTRYPOINT ["dhall"]