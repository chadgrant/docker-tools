ARG TERRAFORM_VERSION
ARG AWS_CLI_VERSION
ARG DHALL_VERSION
ARG DHALL_JSON_VERSION
ARG GO_VERSION
ARG BUILDER_IMG
ARG RUNTIME_IMG

FROM $BUILDER_IMG AS builder
ARG TERRAFORM_VERSION
ARG AWS_CLI_VERSION 
ARG GO_VERSION 
ARG DHALL_VERSION 
ARG DHALL_JSON_VERSION
ENV TERRAFORM_VERSION=${TERRAFORM_VERSION} \
    AWS_CLI_VERSION=${AWS_CLI_VERSION} GO_VERSION=${GO_VERSION} \
    DHALL_VERSION=${DHALL_VERSION} DHALL_JSON_VERSION=${DHALL_JSON_VERSION} \
    GOPATH="/go" PATH="/usr/local/go/bin:/go/bin:$PATH"
    
RUN apk add --update git bash python py-pip groff less openssh nano mailcap jq alpine-sdk curl tar bzip2 && \
    pip install --upgrade awscli==${AWS_CLI_VERSION} s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/* && \
    mkdir -p /go/bin /usr/local/go/bin && \
    mkdir -p /tmp/dhall && cd /tmp/dhall && \
    curl -sL https://github.com/dhall-lang/dhall-haskell/releases/download/${DHALL_VERSION}/dhall-${DHALL_VERSION}-x86_64-linux.tar.bz2 \
    --output dhall.tar.bz2 && \
    bzip2 -dc dhall.tar.bz2 | tar xf - && rm dhall.tar.bz2 && \
    curl -sL https://github.com/dhall-lang/dhall-haskell/releases/download/${DHALL_VERSION}/dhall-json-${DHALL_JSON_VERSION}-x86_64-linux.tar.bz2 \
    --output dhall-json.tar.bz2 && \
    bzip2 -dc dhall-json.tar.bz2 | tar xf - && rm dhall-json.tar.bz2 && \
    cp ./bin/*dhall* /usr/local/bin && \
    cd - && \
    rm -rf /tmp/dhall

RUN git clone https://github.com/chadgrant/go.git $GOPATH/src/github.com/chadgrant/go && \
    cd $GOPATH/src/github.com/chadgrant/go/terraform/tfvars && \
    go install

FROM hashicorp/terraform:${TERRAFORM_VERSION} as terraform
FROM golang:${GO_VERSION}-alpine as go

FROM $RUNTIME_IMG
ARG TERRAFORM_VERSION
ARG AWS_CLI_VERSION 
ARG GO_VERSION 
ARG DHALL_VERSION 
ARG DHALL_JSON_VERSION
ENV TERRAFORM_VERSION=${TERRAFORM_VERSION} \
    AWS_CLI_VERSION=${AWS_CLI_VERSION} GO_VERSION=${GO_VERSION} \
    DHALL_VERSION=${DHALL_VERSION} DHALL_JSON_VERSION=${DHALL_JSON_VERSION} \
    GOPATH="/go" PATH="/usr/local/go/bin:/go/bin:$PATH"

RUN apk -v --update add python py-pip groff less openssh nano mailcap jq alpine-sdk curl && \
    pip install --upgrade awscli==${AWS_CLI_VERSION} s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

COPY --from=builder /usr/local/bin/*dhall* /usr/local/bin/
COPY --from=builder /go/bin/* /usr/local/bin/
COPY --from=go /usr/local/go/ /usr/local/go/
COPY --from=terraform /bin/terraform /usr/local/bin/

ADD aws/modules /terraform/modules/aws/
ADD aws/scripts/* /usr/bin/
ADD scripts/* /usr/bin/
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/bin/*backend-config /usr/bin/*-secret /usr/bin/*-file /usr/bin/plan /usr/bin/apply /usr/bin/destroy /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["sh"]