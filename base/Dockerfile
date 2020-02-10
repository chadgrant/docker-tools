ARG IMG
ARG DEFAULT_IMAGE=base
#https://github.com/docker-library/official-images#architectures-other-than-amd64

FROM $IMG as base
ARG IMG_ARCH=amd64

# Include various scripts (entrypoint.sh, healthcheck.sh, fix-perms)
COPY bin/ /usr/bin/

ENV DEBIAN_FRONTEND=noninteractive

RUN install-deps ca-certificates curl rsync

RUN curl -sSL https://github.com/vishnubob/wait-for-it/raw/master/wait-for-it.sh >/usr/bin/wait-for-it.sh \
    && chmod 755 /usr/bin/wait-for-it.sh

# Install gosu
ARG GOSU_VER=1.10
RUN curl -sSL "https://github.com/tianon/gosu/releases/download/${GOSU_VER}/gosu-${IMG_ARCH}" >/usr/bin/gosu \
    && chmod 755 /usr/bin/gosu \
    && gosu nobody true

#HEALTHCHECK CMD /usr/bin/healthcheck.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/bin/sh"]

# build a specific image when target is not specified
FROM $DEFAULT_IMAGE as release