# Build from a reviewed, immutable upstream commit rather than a stale source ZIP.
ARG UPSTREAM_REF=efb6c6d5796c427cb547fecc4f2a607c36ae7009

FROM --platform=$BUILDPLATFORM alpine:3.22 AS source
ARG UPSTREAM_REF
RUN apk add --no-cache ca-certificates git \
    && mkdir -p /src \
    && git -C /src init \
    && git -C /src remote add origin https://github.com/MHSanaei/3x-ui.git \
    && git -C /src fetch --depth=1 origin "${UPSTREAM_REF}" \
    && git -C /src checkout --detach FETCH_HEAD \
    && test "$(git -C /src rev-parse HEAD)" = "${UPSTREAM_REF}" \
    && rm -rf /src/.git

# The current upstream frontend declares Node >=26 and npm >=11.
FROM --platform=$BUILDPLATFORM node:26-alpine AS frontend
WORKDIR /src
COPY --from=source /src/ ./
WORKDIR /src/frontend
RUN node --version && npm --version && npm ci --engine-strict
COPY --from=source /src/internal/web/translation /src/internal/web/translation
RUN npm run build

FROM golang:1.27-alpine AS builder
WORKDIR /app
ARG TARGETARCH
ARG TARGETVARIANT
RUN apk --no-cache add build-base gcc curl unzip
COPY --from=source /src/ ./
COPY --from=frontend /src/internal/web/dist ./internal/web/dist
RUN chmod +x DockerInit.sh DockerEntrypoint.sh x-ui.sh
ENV CGO_ENABLED=1
ENV CGO_CFLAGS="-D_LARGEFILE64_SOURCE"
RUN go version && go build -ldflags "-w -s" -o build/x-ui main.go
RUN sh ./DockerInit.sh "$TARGETARCH" "$TARGETVARIANT"

FROM alpine:3.22
ARG UPSTREAM_REF
LABEL org.opencontainers.image.source="https://github.com/MHSanaei/3x-ui" \
      org.opencontainers.image.revision="${UPSTREAM_REF}"
ENV TZ=Asia/Tehran
WORKDIR /app
RUN apk add --no-cache ca-certificates tzdata fail2ban bash curl openssl
COPY --from=builder /app/build/ /app/
COPY --from=builder /app/DockerEntrypoint.sh /app/
COPY --from=builder /app/x-ui.sh /usr/bin/x-ui
COPY --from=builder /app/internal/web/translation /app/internal/web/translation
COPY vibenest-entrypoint.sh /app/
RUN rm -f /etc/fail2ban/jail.d/alpine-ssh.conf \
    && cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local \
    && sed -i "s/^\\[ssh\\]$/&\\nenabled = false/" /etc/fail2ban/jail.local \
    && sed -i "s/^\\[sshd\\]$/&\\nenabled = false/" /etc/fail2ban/jail.local \
    && sed -i "s/#allowipv6 = auto/allowipv6 = auto/g" /etc/fail2ban/fail2ban.conf
RUN chmod +x /app/DockerEntrypoint.sh /app/x-ui /usr/bin/x-ui /app/vibenest-entrypoint.sh

# VibeNest supplies PORT; the wrapper maps it to upstream's XUI_PORT.
ENV PORT=8080 \
    XUI_IN_DOCKER=true \
    XUI_MAIN_FOLDER=/app \
    XUI_ENABLE_FAIL2BAN=false \
    XUI_DB_TYPE="" \
    XUI_DB_DSN=""

EXPOSE 8080
VOLUME ["/etc/x-ui"]
HEALTHCHECK --interval=30s --timeout=5s --start-period=90s --retries=3 \
    CMD ["bash", "-ec", "exec 3<>/dev/tcp/127.0.0.1/${XUI_PORT:-${PORT:-8080}}"]
ENTRYPOINT ["/app/vibenest-entrypoint.sh"]
CMD ["./x-ui"]
