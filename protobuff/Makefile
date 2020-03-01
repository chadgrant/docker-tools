APPLICATION?=protobuff
FRIENDLY?=Protobuff tools
DESCRIPTION?=Protobuff compiler and tools
VENDOR?=Chad Grant
BUILD_NUMBER?=1.0.0
BUILD_GROUP?=sample-group
BUILD_BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
BUILD_HASH?=$(shell git rev-parse HEAD)
BUILD_DATE?=$(shell date -u +%s)
REPO_URL?=https://github.com/chadgrant/docker-tools/protobuff
REGISTRY?=docker.io
BASE_REPOSITORY?=chadgrant/base
BUILD_USER?=$(USER)
ifdef BUILD_HASH
	BUILD_USER?=$(shell git --no-pager show -s --format='%ae' $(BUILD_HASH))
endif

PROTOBUFF_VERSION?=3.6.1
RUNTIME_IMG?=${REGISTRY}/chadgrant/base:golang-1.14-buster
TAG?=chadgrant/protobuff

## http://label-schema.org/rc1/
common_args += --label org.label-schema.schema-version="1.0"
common_args += --label org.label-schema.version="${BUILD_NUMBER}"
common_args += --label org.label-schema.name="${FRIENDLY}"
common_args += --label org.label-schema.description="${DESCRIPTION}"
common_args += --label org.label-schema.application-name="${APPLICATION}"
common_args += --label org.label-schema.build-group="${BUILD_GROUP}"
common_args += --label org.label-schema.build-user="${BUILD_USER}"
common_args += --label org.label-schema.build-date="${BUILD_DATE}"
common_args += --label org.label-schema.vcs-branch="${BUILD_BRANCH}"
common_args += --label org.label-schema.vcs-ref="${BUILD_HASH}"
common_args += --label org.label-schema.vcs-url="${REPO_URL}"
common_args += --label org.label-schema.url="${REPO_URL}"
common_args += --label org.label-schema.vendor="${VENDOR}"

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:

build:
	docker build ${common_args} -t ${REGISTRY}/${TAG}:${PROTOBUFF_VERSION} \
		--build-arg RUNTIME_IMG=${RUNTIME_IMG} \
		--build-arg PROTOBUFF_VERSION=${PROTOBUFF_VERSION} .

push: build
	docker push ${REGISTRY}/${TAG}:${PROTOBUFF_VERSION}

run:
	docker run -it \
		-v $(shell pwd)/proto/:/proto \
		${TAG}:${PROTOBUFF_VERSION}

stop:
	-docker container stop `docker container ls -q --filter ancestor=${REGISTRY}/${TAG}`

rm: stop
	-docker container rm `docker container ls -aq --filter ancestor=${REGISTRY}/${TAG}`

clean: docker-rm
	-docker rmi `docker images --format '{{.Repository}}:{{.Tag}}' | grep "${TAG}"` -f
	-docker system prune -f --volumes
