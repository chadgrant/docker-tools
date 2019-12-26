ARG builder_img="alpine:3.10.3"
ARG runtime_img="alpine:3.10.3"

FROM $builder_img AS builder
ARG DHALL_VERSION="1.28.0"
ARG DHALL_JSON_VERSION="1.6.0"

RUN apk add --update bzip2 tar curl && \
	rm -rf /var/cache/apk/* && \
	mkdir -p /tmp/dhall && cd /tmp/dhall && \
	curl -sL https://github.com/dhall-lang/dhall-haskell/releases/download/${DHALL_VERSION}/dhall-${DHALL_VERSION}-x86_64-linux.tar.bz2 \
	--output dhall.tar.bz2 && \
	bzip2 -dc dhall.tar.bz2 | tar xf - && rm dhall.tar.bz2 && \
    curl -sL https://github.com/dhall-lang/dhall-haskell/releases/download/${DHALL_VERSION}/dhall-json-${DHALL_JSON_VERSION}-x86_64-linux.tar.bz2 \
    --output dhall-json.tar.bz2 && \
	bzip2 -dc dhall-json.tar.bz2 | tar xf - && rm dhall-json.tar.bz2 && \
	cp ./bin/*dhall* /usr/local/bin && \
	rm -rf /tmp/dhall

FROM $runtime_img
COPY --from=builder /usr/local/bin/*dhall* /usr/local/bin/
ENTRYPOINT ["dhall-to-json"]