ARG TERRAFORM_VERSION
ARG DHALL_VERSION
ARG DHALL_JSON_VERSION
ARG GO_IMG
ARG BUILDER_IMG
ARG RUNTIME_IMG

FROM $BUILDER_IMG AS builder
ARG DHALL_VERSION 
ARG DHALL_JSON_VERSION
    
RUN install-deps git curl tar bzip2 && \
    mkdir /tmp/dhall && cd /tmp/dhall && \
    curl -sL https://github.com/dhall-lang/dhall-haskell/releases/download/${DHALL_VERSION}/dhall-${DHALL_VERSION}-x86_64-linux.tar.bz2 \
    --output dhall.tar.bz2 && \
    bzip2 -dc dhall.tar.bz2 | tar xf - && rm dhall.tar.bz2 && \
    curl -sL https://github.com/dhall-lang/dhall-haskell/releases/download/${DHALL_VERSION}/dhall-json-${DHALL_JSON_VERSION}-x86_64-linux.tar.bz2 \
    --output dhall-json.tar.bz2 && \
    bzip2 -dc dhall-json.tar.bz2 | tar xf - && rm dhall-json.tar.bz2 && \
    cp ./bin/*dhall* /usr/local/bin && \
    cd - && \
    rm -rf /tmp/dhall

FROM hashicorp/terraform:${TERRAFORM_VERSION} as terraform
FROM $GO_IMG as go

COPY go/go.mod go/go.sum /go/src/github.com/chadgrant/docker-tools/go/
RUN cd $GOPATH/src/github.com/chadgrant/docker-tools/go && \
    go mod download

COPY go /go/src/github.com/chadgrant/docker-tools/go
RUN cd $GOPATH/src/github.com/chadgrant/docker-tools/go/tfvars && \
    go install

FROM $RUNTIME_IMG
ENV GOPATH="/go" PATH="/usr/local/go/bin:/go/bin:$PATH"

RUN apk -v --update add python less openssh nano jq curl && \
    curl -sL "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && rm awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm /var/cache/apk/*

COPY --from=builder /usr/local/bin/*dhall* /usr/local/bin/
COPY --from=go /usr/local/go/ /usr/local/go/
COPY --from=go /go/bin/* /go/bin/
COPY --from=terraform /bin/terraform /usr/local/bin/

COPY aws/modules /terraform/modules/aws/
COPY aws/scripts/* /usr/bin/
COPY scripts/* /usr/bin/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/bin/*backend-config /usr/bin/*-secret /usr/bin/*-file /usr/bin/plan /usr/bin/apply /usr/bin/destroy /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["sh"]