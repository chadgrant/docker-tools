PROTOBUFF_VERSION?=3.6.1
RUNTIME_IMG?=golang:1.13.5-buster
TAG?=chadgrant/protobuff

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:

docker-build:
	docker build -t ${TAG}:${PROTOBUFF_VERSION} \
		--build-arg RUNTIME_IMG=${RUNTIME_IMG} \
		--build-arg PROTOBUFF_VERSION=${PROTOBUFF_VERSION} .

docker-push:
	docker push ${TAG}:${PROTOBUFF_VERSION}

docker-run:
	docker run -it \
		-v $(shell pwd)/proto/:/proto \
		${TAG}:${PROTOBUFF_VERSION}

docker-stop:
	-docker container stop `docker container ls -q --filter ancestor=${TAG}`

docker-rm: docker-stop
	-docker container rm `docker container ls -aq --filter ancestor=${TAG}`

docker-clean: docker-rm
	-docker rmi `docker images --format '{{.Repository}}:{{.Tag}}' | grep "${TAG}"` -f
	-docker rmi `docker images -qf dangling=true`