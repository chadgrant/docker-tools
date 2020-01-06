APPLICATION?=golang_testing
FRIENDLY?=Tools for testing, linting and benchmarking golang
DESCRIPTION?=Tools for testing, linting and benchmarking golang
VENDOR?=Chad Grant
BUILD_NUMBER?=1.0.0
BUILD_GROUP?=sample-group
BUILD_BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
BUILD_HASH?=$(shell git rev-parse HEAD)
BUILD_DATE?=$(shell date -u +%s)
REPO_URL?=https://github.com/chadgrant/docker-tools/golang-testing
REGISTRY?=docker.io
BUILD_USER?=$(USER)
ifdef BUILD_HASH
	BUILD_USER?=$(shell git --no-pager show -s --format='%ae' $(BUILD_HASH))
endif

GO_IMGS=golang-1.13.5-alpine golang-1.13.5-buster
TAG?=chadgrant/golang-testing

## http://label-schema.org/rc1/
common_args += --label org.label-schema.schema-version="1.0"
common_args += --label org.label-schema.version="${BUILD_NUMBER}"
common_args += --label org.label-schema.name="${FRIENDLY}"
common_args += --label org.label-schema.description="${DESCRIPTION}"
common_args += --label org.label-schema.application-name="${APPLICATION}"
common_args += --label org.label-schema.build-group="${BUILD_GROUP}"
common_args += --label org.label-schema.build-user="${BUILD_USER}"
common_args += --label org.label-schema.build-date=${BUILD_DATE}
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

docker-build: $(addprefix docker-build-,$(GO_IMGS))
docker-push: $(addprefix docker-push-,$(GO_IMGS))

docker-build-%:
	docker build ${common_args} --build-arg GO_IMG="${REGISTRY}/chadgrant/base:$*" \
		-t ${REGISTRY}/${TAG}:$(subst golang-,,$*) .

docker-push-%: docker-build-%
	docker push ${REGISTRY}/${TAG}:$(subst golang-,,$*) 

docker-clean:
	-docker rmi `docker images --format '{{.Repository}}:{{.Tag}}' | grep "${TAG}"` -f
	-docker rmi `docker images -qf dangling=true`
