ARG BUILDER_IMAGE=docker.io/library/golang:1.19-alpine
ARG RUNTIME_IMAGE=docker.io/library/alpine:3
ARG VERSION=v2.1.1
ARG BIN=switchbot
ARG APP=switchbot

FROM ${BUILDER_IMAGE} AS builder

# Arguments go here so that the previous steps can be cached if no external
#  sources have changed.
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG BIN
ARG APP

RUN set -eux \
    && apk --no-cache add --virtual build-dependencies unzip curl git tzdata make
RUN cp /usr/share/zoneinfo/Japan /etc/localtime

RUN go install github.com/yasuoza/switchbot-ble-go/v2/cmd/switchbot@${VERSION}

# Build binary and make sure there is at least an empty key file.
#  This is useful for GCP App Engine custom runtime builds, because
#  you cannot use multiline variables in their app.yaml, so you have to
#  build the key into the container and then tell it where it is
#  by setting OAUTH2_PROXY_JWT_KEY_FILE=/etc/ssl/private/jwt_signing_key.pem
#  in app.yaml instead.
# Set the cross compilation arguments based on the TARGETPLATFORM which is
#  automatically set by the docker engine.
#RUN case ${TARGETPLATFORM} in \
#         "linux/amd64")  echo ${TARGETPLATFORM} ;; \
#         "linux/arm64" | "linux/arm64/v8")  echo ${TARGETPLATFORM}  ;; \
#    esac

FROM ${RUNTIME_IMAGE}

LABEL maintainer="CTY <admin@ctyavalon.com>"

ARG BIN
ENV BIN=${BIN}
ARG APP
ENV APP=${APP}

RUN set -eux \
    && apk --no-cache add --virtual build-dependencies unzip curl git tzdata
RUN cp /usr/share/zoneinfo/Japan /etc/localtime

COPY --from=builder /go/bin/${BIN} /usr/local/bin/${APP}

# UID/GID 65532 is also known as nonroot user in distroless image
#USER 65532:65532

CMD /usr/local/bin/${APP} "scan"
