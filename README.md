# Sanaei 3X-UI — VibeNest

This repository packages Sanaei 3X-UI source in `3x-ui-source.zip` and builds it with Docker for deployment on VibeNest.

## Deploy

1. Fork this repository.
2. Import/select your fork in VibeNest and deploy using the included Dockerfile.
3. Configure the platform to route web traffic to container port **8080** (the image sets `XUI_PORT=8080`).
4. If the platform supports persistent storage, mount it at **`/etc/x-ui`**. This is required to preserve the panel database/settings across redeploys.
5. After the first launch, check the service logs for the panel's startup information and use the generated/configured credentials. Change default credentials immediately if applicable.

## Container configuration

- Panel port: `8080` (via `XUI_PORT`)
- Persistent data path: `/etc/x-ui`
- `XUI_ENABLE_FAIL2BAN=false`: disabled by default because managed app platforms commonly do not provide the required network capabilities.
- SQLite is the default unless database environment variables are configured.

**Important:** A persistent volume is essential. A container restart without persistent storage can lose the panel database and settings. VibeNest routing and volume options may vary by account/platform configuration; verify these settings before deploying.

## Files

- `Dockerfile` — multi-stage frontend and Go build, then runtime image
- `3x-ui-source.zip` — source archive used by the Docker build

## Upstream

Sanaei 3X-UI: https://github.com/MHSanaei/3x-ui
