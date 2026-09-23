# 3X-UI — VibeNest Deployment

A VibeNest-ready deployment of **Sanaei 3X-UI**, a web-based management panel for Xray.

This repository is prepared to run 3X-UI inside a Docker container on VibeNest using GitHub-based deployment.

## Features

- Web-based 3X-UI management panel
- Xray management
- Docker-based deployment
- GitHub → VibeNest deployment
- Persistent application data
- VibeNest-compatible web service configuration
- Panel exposed through port `8080`

## Deployment Architecture

```text
GitHub Repository
       │
       ▼
    VibeNest
       │
       ▼
 Docker Container
       │
       ├── 3X-UI
       ├── Xray
       └── Web Panel
```

# Deploy on VibeNest

## 1. GitHub Repository

The repository should contain:

```text
Dockerfile
3x-ui-source.zip
README.md
```

The `Dockerfile` must be located in the root of the repository.

## 2. Connect GitHub to VibeNest

In VibeNest, create a new project and select the GitHub repository.

Recommended settings:

```text
Source: GitHub
Branch: main
Build: Dockerfile
```

VibeNest will build the Docker image from the repository.

## 3. Application Port

The 3X-UI web panel uses:

```text
8080
```

If VibeNest asks for the application/service port, enter `8080`.

## 4. Persistent Storage

3X-UI stores its application data under:

```text
/etc/x-ui
```

For production use, configure persistent storage/volume for `/etc/x-ui` so the panel database and configuration survive redeployments.

# First Setup

After the deployment becomes **LIVE**, open the public URL provided by VibeNest.

Complete the initial panel configuration and use a strong administrator username and password.

Do not publish administrator credentials, private keys, UUIDs, or client configurations in this GitHub repository.

# Xray Inbounds

3X-UI can manage Xray inbound configurations.

Depending on the selected protocol and configuration, the required TCP/UDP ports must be publicly reachable.

**Important:** VibeNest's web-service port `8080` is the panel's web port. It does not automatically mean that arbitrary Xray TCP/UDP inbound ports are publicly exposed.

Verify that the hosting environment supports the public TCP/UDP ports required by your configuration.

# Updating the Deployment

1. Update the source or Docker configuration in GitHub.
2. Commit and push the changes.
3. Trigger a new deployment in VibeNest.
4. Wait for the Docker image to build.
5. Confirm that the application passes the health check.

Keep `/etc/x-ui` on persistent storage when possible.

# Security Recommendations

- Use a strong administrator password.
- Never commit passwords or private keys to GitHub.
- Do not publish client configurations containing sensitive credentials.
- Use HTTPS for the management panel.
- Keep 3X-UI and Xray updated.
- Restrict access to the management panel when possible.
- Back up `/etc/x-ui` before major updates.
- Check the hosting provider's network and port policies before creating public inbounds.

# Project Structure

```text
.
├── Dockerfile
├── 3x-ui-source.zip
└── README.md
```

# Environment

```text
Docker
Go
Node.js
Alpine Linux
Xray
3X-UI
```

Panel service port:

```text
8080
```

Persistent data:

```text
/etc/x-ui
```

# Disclaimer

This repository provides a Docker/VibeNest deployment setup for 3X-UI.

Users are responsible for complying with applicable laws, regulations, terms of service, and network policies.
