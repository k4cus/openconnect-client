FROM alpine:edge
LABEL maintainer='Kacper Nowak <kadzbi@gmail.com>'

# BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
# COMMIT_SHA="$(git rev-parse HEAD 2>/dev/null || echo 'null')"
ARG BUILD_DATE COMMIT_SHA

# https://github.com/opencontainers/image-spec/blob/master/spec.md
LABEL org.opencontainers.image.title='openconnect' \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.description='AnyConnect-compatible client to route host traffic based on https://github.com/aw1cks/openconnect' \
      org.opencontainers.image.documentation='https://github.com/k4cus/openconnect-client/blob/master/README.md' \
      org.opencontainers.image.version='2.0' \
      org.opencontainers.image.source='https://github.com/k4cus/openconnect-client' \
      org.opencontainers.image.revision="${COMMIT_SHA}"

RUN apk add --no-cache openconnect dnsmasq iptables

WORKDIR /vpn
COPY ./entrypoint.sh .

HEALTHCHECK --start-period=15s --retries=1 \
  CMD pgrep openconnect || exit 1; pgrep dnsmasq || exit 1

ENTRYPOINT ["/vpn/entrypoint.sh"]
