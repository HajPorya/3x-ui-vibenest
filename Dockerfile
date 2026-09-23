# VibeNest-compatible Docker build for Sanaei 3X-UI
# The source is stored in 3x-ui-source.zip so it can be uploaded from a phone.

# ------------------------------------------------------------
# Stage 0: unpack the source archive
# ------------------------------------------------------------
FROM alpine:3.22 AS source
RUN apk add --no-cache unzip
WORKDIR /src
COPY 3x-ui-source.zip /tmp/3x-ui-source.zip
RUN unzip -q /tmp/3x-ui-source.zip -d /src \
    && rm /tmp/3x-ui-source.zip

# ------------------------------------------------------------
# Stage 1: build frontend
# ------------------------------------------------------------
FROM node:22-alpine AS frontend
WORKDIR /src
COPY --from=source /src/ ./
WORKDIR /src/frontend
RUN npm ci
COPY --from=source /src/internal/web/translation /src/internal/web/translation
RUN npm run build

# ------------------------------------------------------------
# Stage 2: build 3X-UI
# ------------------------------------------------------------
FROM golang:1.27-alpine AS builder
WORKDIR /app
ARG TARGETARCH

RUN apk --no-cache --update add \
    build-base \
    gcc \
    curl \
    unzip

COPY --from=source /src/ ./
COPY --from=frontend /src/internal/web/dist ./internal/web/dist

ENV CGO_ENABLED=1
ENV CGO_CFLAGS="-D_LARGEFILE64_SOURCE"

RUN go build -ldflags "-w -s" -o build/x-ui main.go
RUN ./DockerInit.sh "$TARGETARCH"

# ------------------------------------------------------------
# Stage 3: runtime
# ------------------------------------------------------------
FROM alpine:3.22

ENV TZ=Asia/Tehran
WORKDIR /app

RUN apk add --no-cache --update \
    ca-certificates \
    tzdata \
    fail2ban \
    bash \
    curl \
    openssl

COPY --from=builder /app/build/ /app/
COPY --from=builder /app/DockerEntrypoint.sh /app/
COPY --from=builder /app/x-ui.sh /usr/bin/x-ui
COPY --from=builder /app/internal/web/translation /app/internal/web/translation

RUN rm -f /etc/fail2ban/jail.d/alpine-ssh.conf \
    && cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local \
    && sed -i "s/^\[ssh\]$/&\nenabled = false/" /etc/fail2ban/jail.local \
    && sed -i "s/^\[sshd\]$/&\nenabled = false/" /etc/fail2ban/jail.local \
    && sed -i "s/#allowipv6 = auto/allowipv6 = auto/g" /etc/fail2ban/fail2ban.conf

RUN chmod +x \
    /app/DockerEntrypoint.sh \
    /app/x-ui \
    /usr/bin/x-ui

ENV XUI_IN_DOCKER="true"
ENV XUI_MAIN_FOLDER="/app"
ENV XUI_ENABLE_FAIL2BAN="false"
ENV XUI_PORT="8080"
ENV XUI_DB_TYPE=""
ENV XUI_DB_DSN=""

EXPOSE 8080
VOLUME ["/etc/x-ui"]

ENTRYPOINT ["/app/DockerEntrypoint.sh"]
CMD ["./x-ui"]
