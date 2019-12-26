DHALL_VERSION?=1.28.0
DHALL_JSON_VERSION?=1.6.0
BUILDER_IMG?=alpine:3.11.2
RUNTIME_IMG?=alpine:3.11.2
TAG?=chadgrant/dhall

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:

docker-build:
	docker build -t ${TAG}:${DHALL_VERSION} \
	--build-arg DHALL_VERSION=${DHALL_VERSION} \
	--build-arg DHALL_JSON_VERSION=${DHALL_JSON_VERSION} \
	--build-arg BUILDER_IMG=${BUILDER_IMG} \
	--build-arg RUNTIME_IMG=${RUNTIME_IMG} .

docker-push:
	docker push ${TAG}:${DHALL_VERSION}

docker-run:
	docker run --rm -it \
		--workdir /work \
		-v $(shell pwd):/work \
		${TAG}:${DHALL_VERSION} --help

docker-stop:
	-docker container stop `docker container ls -q --filter ancestor=${TAG}`

docker-rm: docker-stop
	-docker container rm `docker container ls -aq --filter ancestor=${TAG}`

docker-clean: docker-rm
	-docker rmi `docker images --format '{{.Repository}}:{{.Tag}}' | grep "${TAG}"` -f
	-docker rmi `docker images -qf dangling=true`