ARG TERRAFORM_VERSION
ARG GO_VERSION
#ARG github_token

FROM golang:${GO_VERSION}-alpine AS go

FROM hashicorp/terraform:${TERRAFORM_VERSION}
ENV GOPATH="/go"

COPY --from=go /usr/local/go/ /usr/local/go/

RUN apk -v --update add python py-pip groff less openssh nano mailcap jq alpine-sdk curl && \
    pip install --upgrade awscli==1.16.90 s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/* && \
    mkdir -p /go/bin /usr/local/go/bin

#git config --global url."https://${github_token}:x-oauth-basic@github.com/".insteadOf "https://github.com/" && \

RUN export PATH="/usr/local/go/bin:$PATH" && \
    git clone https://github.com/chadgrant/go.git /go/src/github.com/chadgrant/go && \
    cd /go/src/github.com/chadgrant/go/terraform/tfvars && \
    go install

ADD aws/modules /terraform/modules/aws/
ADD aws/scripts/* /usr/bin/
ADD scripts/* /usr/bin/
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /usr/bin/*backend-config /usr/bin/*-secret /usr/bin/*-file /usr/bin/plan /usr/bin/apply /usr/bin/destroy /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["sh"]