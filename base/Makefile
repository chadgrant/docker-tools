ALPINE_VERSIONS=3.11.2

APPLICATION?=base
FRIENDLY?=Docker Base Image
DESCRIPTION?=This is the description of the base image, enjoy!
VENDOR?=Chad Grant
BUILD_NUMBER?=1.0.0
BUILD_GROUP?=sample-group
BUILD_BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
BUILD_HASH?=$(shell git rev-parse HEAD)
BUILD_DATE?=$(shell date -u +%s)
REPO_URL="https://github.com/chadgrant/docker-tools/base"
REGISTRY=docker.io
BASE_REPOSITORY=chadgrant/base
BUILD_USER?=$(USER)
ifdef BUILD_HASH
	BUILD_USER=$(shell git --no-pager show -s --format='%ae' $(BUILD_HASH))
endif

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

common_args += --build-arg REGISTRY="${REGISTRY}"
common_args += --build-arg BASE_REPOSITORY="${BASE_REPOSITORY}"

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:

docker-build: $(addprefix docker-build-alpine-,$(ALPINE_VERSIONS))
docker-push: $(addprefix docker-push-alpine-,$(ALPINE_VERSIONS))
docker-stop: $(addprefix docker-stop-alpine-,$(ALPINE_VERSIONS))
docker-rm: $(addprefix docker-rm-alpine-,$(ALPINE_VERSIONS))
docker-clean: $(addprefix docker-clean-alpine-,$(ALPINE_VERSIONS))
	-docker system prune -f --volumes

docker-build-alpine-%:
	DOCKER_BUILDKIT=1 && \
	docker build ${common_args} --build-arg IMG="alpine:$*" -t chadgrant/base:$*-alpine .

docker-push-alpine-%: docker-build-alpine-%
	docker push chadgrant/base:$*-alpine

docker-stop-%:
	-docker container stop `docker container ls -q --filter ancestor=$*`

docker-rm-%: docker-stop_%
	-docker container rm `docker container ls -aq --filter ancestor=$*`

docker-clean-%: docker-rm_%
	-docker rmi `docker images --format '{{.Repository}}:{{.Tag}}' | grep "$*"` -f