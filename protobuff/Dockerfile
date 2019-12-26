FROM golang:1.13.5-buster
ARG PROTOBUFF_VERSION="3.6.1"

RUN	go get \
	github.com/gogo/protobuf/proto \
	github.com/gogo/protobuf/gogoproto \
	github.com/gogo/protobuf/protoc-gen-gogo \
	github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
	github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
	github.com/mwitkow/go-proto-validators/protoc-gen-govalidators

RUN apt-get update && \
    apt-get install -y autoconf automake libtool curl make g++ unzip && \
    rm -rf /var/lib/apt/lists/*

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

ENTRYPOINT ["protoc"]