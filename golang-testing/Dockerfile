ARG GO_IMG 
FROM $GO_IMG as go

RUN install-deps git curl tar bzip2 make jq nodejs npm

ENV GOPATH="/go" PATH="/usr/local/go/bin:/go/bin:$PATH"

RUN go get github.com/gojp/goreportcard \
           golang.org/x/tools/cmd/goimports \
           github.com/gojp/goreportcard/cmd/goreportcard-cli && \
    cd $GOPATH/src/github.com/gojp/goreportcard && \
    make install && \
    cd $GOPATH/src/github.com/gojp/goreportcard/cmd/goreportcard-cli && \
    go install && \
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
        | sh -s -- -b $(shell go env GOPATH)/bin v1.22.2

RUN npm install -g npm@latest && \
    npm install -g mocha chai expect supertest ajv

#ENTRYPOINT [ "go" ]
CMD ["go","test","-v","./..."]