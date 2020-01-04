ARG GO_IMG 
FROM $GO_IMG as go

RUN if type "apk" > /dev/null; then apk add --update git curl tar bzip2 make jq && rm /var/cache/apk/*; fi && \
    if type "apt-get" > /dev/null; then apt-get update && apt-get install -y git curl tar bzip2 make jq && rm -rf /var/lib/apt/lists/*; fi

ENV GOPATH="/go" PATH="/usr/local/go/bin:/go/bin:$PATH"

RUN go get github.com/gojp/goreportcard \
           github.com/gojp/goreportcard/cmd/goreportcard-cli && \
    cd $GOPATH/src/github.com/gojp/goreportcard && \
    make install && \
    cd $GOPATH/src/github.com/gojp/goreportcard/cmd/goreportcard-cli && \
    go install

#COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "go" ]
CMD ["test","-v","./..."]