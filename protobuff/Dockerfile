ARG PROTOBUFF_VERSION
ARG RUNTIME_IMG
FROM $RUNTIME_IMG
ARG PROTOBUFF_VERSION

RUN install-deps autoconf automake libtool curl make g++ unzip

RUN curl -L https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUFF_VERSION}/protobuf-all-${PROTOBUFF_VERSION}.tar.gz \
    --output protobuf-all-${PROTOBUFF_VERSION}.tar.gz && \
    tar zxf protobuf-all-${PROTOBUFF_VERSION}.tar.gz && \
	rm protobuf-all-${PROTOBUFF_VERSION}.tar.gz && \
	cd protobuf-${PROTOBUFF_VERSION} && \
		./configure && \
		make && \
		make install && \
		ldconfig && \
	    cd .. && \
        rm -rf protobuf-${PROTOBUFF_VERSION}

RUN	go get -u -v \
	github.com/gogo/protobuf/proto \
	github.com/gogo/protobuf/gogoproto \
	github.com/golang/protobuf/protoc-gen-go \
	github.com/gogo/protobuf/protoc-gen-gogo \
	github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
	github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
	github.com/mwitkow/go-proto-validators/protoc-gen-govalidators && \
	env GO111MODULE=on go get -u -v goa.design/goa/v3/...@v3 && \
	goa version

ENTRYPOINT ["protoc"]