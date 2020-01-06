ARG BUILDER_IMG
ARG RUNTIME_IMG
ARG DHALL_VERSION
ARG DHALL_JSON_VERSION

FROM $BUILDER_IMG AS builder
ARG DHALL_VERSION
ARG DHALL_JSON_VERSION

RUN apk add --update --no-cache --clean-protected bzip2 tar curl && \
	mkdir -p /tmp/dhall && cd /tmp/dhall && \
	curl -sL https://github.com/dhall-lang/dhall-haskell/releases/download/${DHALL_VERSION}/dhall-${DHALL_VERSION}-x86_64-linux.tar.bz2 \
	--output dhall.tar.bz2 && \
	bzip2 -dc dhall.tar.bz2 | tar xf - && rm dhall.tar.bz2 && \
    curl -sL https://github.com/dhall-lang/dhall-haskell/releases/download/${DHALL_VERSION}/dhall-json-${DHALL_JSON_VERSION}-x86_64-linux.tar.bz2 \
    --output dhall-json.tar.bz2 && \
	bzip2 -dc dhall-json.tar.bz2 | tar xf - && rm dhall-json.tar.bz2 && \
	cp ./bin/*dhall* /usr/local/bin && \
	rm -rf /tmp/dhall

FROM $RUNTIME_IMG
COPY --from=builder /usr/local/bin/*dhall* /usr/local/bin/
ENTRYPOINT ["dhall-to-json"]