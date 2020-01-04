GO_IMGS=1.13.5-alpine 1.13.5-buster

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:

docker-build: $(addprefix docker-build-,$(GO_IMGS))
docker-push: $(addprefix docker-push-,$(GO_IMGS))
docker-stop: $(addprefix docker-stop-,$(GO_IMGS))
docker-rm: $(addprefix docker-rm-,$(GO_IMGS))
docker-clean: $(addprefix docker-clean-,$(GO_IMGS))
	-docker rmi `docker images -qf dangling=true`

docker-build-%:
	docker build -t chadgrant/golang-testing:$* \
	--build-arg GO_IMG=golang:$* .

docker-push-%: docker-build_%
	docker push chadgrant/golang-testing\:$*

docker-stop-%:
	-docker container stop `docker container ls -q --filter ancestor=$*`

docker-rm-%: docker-stop_%
	-docker container rm `docker container ls -aq --filter ancestor=$*`

docker-clean-%: docker-rm_%
	-docker rmi `docker images --format '{{.Repository}}:{{.Tag}}' | grep "$*"` -f