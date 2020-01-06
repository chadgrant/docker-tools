ARG GO_IMG 
FROM $GO_IMG as go

RUN install-deps git curl tar bzip2 make jq

ENV GOPATH="/go" PATH="/usr/local/go/bin:/go/bin:$PATH"

RUN go get github.com/gojp/goreportcard \
           github.com/gojp/goreportcard/cmd/goreportcard-cli && \
    cd $GOPATH/src/github.com/gojp/goreportcard && \
    make install && \
    cd $GOPATH/src/github.com/gojp/goreportcard/cmd/goreportcard-cli && \
    go install

#COPY entrypoint.sh /entrypoint.sh

#ENTRYPOINT [ "go" ]
CMD ["go","test","-v","./..."]