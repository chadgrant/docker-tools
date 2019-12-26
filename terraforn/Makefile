TERRAFORM_VERSION?=0.11.11
GO_VERSION?=1.13.5
TAG?=chadgrant/terraform

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:

docker-build:
	docker build -t ${TAG}:${TERRAFORM_VERSION} \
	--build-arg GO_VERSION=${GO_VERSION} \
	--build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} .

docker-push:
	docker push ${TAG}:${TERRAFORM_VERSION}

docker-run:
	docker run -it \
		-v $(shell pwd)/terraform/:/terraform \
		${TAG}:${TERRAFORM_VERSION}

docker-stop:
	-docker container stop `docker container ls -q --filter ancestor=${TAG}`

docker-rm: docker-stop
	-docker container rm `docker container ls -aq --filter ancestor=${TAG}`

docker-clean: docker-rm
	-docker rmi `docker images --format '{{.Repository}}:{{.Tag}}' | grep "${TAG}"` -f
	-docker rmi `docker images -qf dangling=true`