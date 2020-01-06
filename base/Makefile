BASE_IMGS=alpine[3.11.2] alpine[3.10.3] debian[bullseye-slim] debian[buster-slim] golang[1.13.5-alpine] golang[1.13.5-buster]
APPLICATION?=base
FRIENDLY?=Docker Base Image
DESCRIPTION?=This is the description of the base image, enjoy!
VENDOR?=Chad Grant
BUILD_NUMBER?=1.0.0
BUILD_GROUP?=sample-group
BUILD_BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
BUILD_HASH?=$(shell git rev-parse HEAD)
BUILD_DATE?=$(shell date -u +%s)
REPO_URL?=https://github.com/chadgrant/docker-tools/base
REGISTRY?=docker.io
BASE_REPOSITORY?=chadgrant/base
BUILD_USER?=$(USER)
ifdef BUILD_HASH
	BUILD_USER?=$(shell git --no-pager show -s --format='%ae' $(BUILD_HASH))
endif

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

common_args += --build-arg REGISTRY="${REGISTRY}"
common_args += --build-arg BASE_REPOSITORY="${BASE_REPOSITORY}"

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:

docker-build: $(addprefix docker-build-,$(BASE_IMGS))
docker-push: $(addprefix docker-push-,$(BASE_IMGS))
docker-stop: $(addprefix docker-stop-,$(BASE_IMGS))
docker-rm: $(addprefix docker-rm-,$(BASE_IMGS))

docker-clean: $(addprefix docker-clean-,$(BASE_IMGS))
	-docker system prune -f --volumes

docker-build-%:
	docker build ${common_args} --build-arg IMG="$(subst ],,$(subst [,:,$*))" \
		-t ${REGISTRY}/chadgrant/base:$(subst ],,$(subst [,-,$*)) .

docker-push-%: docker-build-%
	docker push ${REGISTRY}/chadgrant/base:$(subst ],,$(subst [,-,$*))

docker-stop-%:
	-docker container stop `docker container ls -q --filter ancestor=$*`

docker-rm-%: docker-stop_%
	-docker container rm `docker container ls -aq --filter ancestor=$*`

docker-clean-%: docker-rm_%
	-docker rmi `docker images --format '{{.Repository}}:{{.Tag}}' | grep "$*"` -f