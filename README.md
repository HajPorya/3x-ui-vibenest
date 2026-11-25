# Sanaei 3X-UI — VibeNest

This repository builds the official [Sanaei 3X-UI](https://github.com/MHSanaei/3x-ui) source as a Docker image with deployment defaults for VibeNest.

## Upstream source and build versions

- Upstream source is pinned to commit [`efb6c6d5796c427cb547fecc4f2a607c36ae7009`](https://github.com/MHSanaei/3x-ui/commit/efb6c6d5796c427cb547fecc4f2a607c36ae7009) so builds are reproducible and do not silently follow a moving branch.
- Frontend: Node 26 / npm 11 or newer, enforced with `npm ci --engine-strict`.
- Backend: Go 1.27 toolchain.
- Runtime: Alpine 3.22.
- CI builds `linux/amd64` and `linux/arm64`. Other architectures are not currently covered by this repository's CI.

To upgrade 3X-UI, review the upstream changes first, then change the `UPSTREAM_REF` default near the top of the Dockerfile to the full 40-character commit SHA and push the change. Do not use a floating `main` reference for a production build.

## Deploy on VibeNest

1. Import this repository and deploy it using its Dockerfile.
2. The default web port is **8080**. The image sets `PORT=8080`; the VibeNest entrypoint maps `PORT` to upstream's `XUI_PORT`. If VibeNest injects a different `PORT`, the panel follows it. An explicitly configured `XUI_PORT` takes precedence.
3. If VibeNest asks for a target/container port, use the same value as `PORT` (8080 by default).
4. In 3X-UI Panel Settings, leave **Web listen** empty (all interfaces) or set it to `0.0.0.0`. Do not bind it to `127.0.0.1`.
5. Attach persistent storage at **`/etc/x-ui` before the first launch**.
6. Use VibeNest's HTTPS URL for public access and keep secrets in its encrypted environment-variable settings, not in Git.

The Docker health check verifies that the configured TCP listener is accepting connections. VibeNest's public URL check is still needed to verify external routing and TLS.

## Storage and database

- **Required persistent path:** `/etc/x-ui`. The default SQLite database is `/etc/x-ui/x-ui.db`; panel settings are stored in the database too. Without persistent storage, a container replacement can lose the database and panel configuration.
- **VibeNest managed PostgreSQL:** when `DATABASE_URL` is present and `XUI_DB_DSN` is not set, the entrypoint maps it to `XUI_DB_DSN` and selects PostgreSQL unless `XUI_DB_TYPE` was explicitly set. You can also configure `XUI_DB_TYPE=postgres` and `XUI_DB_DSN` directly. Keep the database URL in VibeNest's encrypted environment settings.
- **Certificate persistence (optional):** if you use 3X-UI's own ACME/certificate management instead of VibeNest TLS, persist `/root/cert` and `/root/.acme.sh` as well. The upstream entrypoint re-registers the ACME renewal job from the latter path.

SQLite remains the default when no PostgreSQL DSN is supplied. Back up the persistent volume or database regularly.

## Runtime and security notes

- `XUI_ENABLE_FAIL2BAN=false` by default because Fail2ban needs network capabilities such as `NET_ADMIN` / `NET_RAW`, which managed app platforms may not grant. With it disabled, Fail2ban-based IP-limit bans are not enforced.
- The container runs the upstream entrypoint as root because the upstream image includes Xray and optional Fail2ban operations that may require elevated privileges. Do not expose extra container capabilities unless you intentionally enable and need those features.
- The panel generates or retains its own login credentials. Read the first-start logs, use a strong unique password, and enable two-factor authentication after login.
- Do not commit passwords, database URLs, API tokens, certificates, private keys, or user databases.

## Files

- `Dockerfile` — pinned upstream multi-stage build, runtime port bridge, persistent volume, and TCP health check.
- `vibenest-entrypoint.sh` — maps VibeNest's `PORT` and `DATABASE_URL` conventions to upstream 3X-UI environment variables.
- `.github/workflows/docker-build.yml` — no-push multi-architecture build validation.

## References

- [VibeNest deployment platform](https://vibenest.net/)
- [Sanaei 3X-UI upstream](https://github.com/MHSanaei/3x-ui)
- [Upstream environment-variable reference](https://docs.sanaei.dev/docs/reference/env-vars)
- [Upstream panel settings](https://docs.sanaei.dev/docs/config/panel/)
- [Upstream database guide](https://docs.sanaei.dev/docs/reference/database)
