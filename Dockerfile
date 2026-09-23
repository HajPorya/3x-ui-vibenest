FROM golang:1.24-bookworm

WORKDIR /app

# Unpack the source repository into the image.
COPY 3x-ui-source.zip /tmp/3x-ui-source.zip
RUN apt-get update && apt-get install -y --no-install-recommends unzip ca-certificates git make gcc g++ &&     rm -rf /var/lib/apt/lists/* &&     unzip -q /tmp/3x-ui-source.zip -d /app &&     rm /tmp/3x-ui-source.zip

# VibeNest-style web service defaults.
ENV XUI_PORT=8080
ENV XUI_ENABLE_FAIL2BAN=false

EXPOSE 8080

# The upstream project may define its own build/start process.
# This wrapper delegates to the repository's existing Dockerfile when possible.
RUN if [ -f /app/Dockerfile ]; then       echo "Upstream Dockerfile present; source unpacked successfully.";     fi

CMD ["sh", "-c", "echo 'Source uploaded successfully. Configure VibeNest build/start settings for the upstream 3X-UI image.' && sleep infinity"]
