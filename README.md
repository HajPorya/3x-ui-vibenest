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

---

# راهنمای فارسی

## معرفی پروژه

این پروژه نسخه آماده استقرار **Sanaei 3X-UI** برای استفاده روی VibeNest است.

3X-UI یک پنل تحت وب برای مدیریت Xray است و این پروژه به‌گونه‌ای آماده شده که از طریق GitHub به VibeNest متصل شده و داخل یک Docker Container اجرا شود.

## امکانات

- پنل تحت وب 3X-UI
- مدیریت Xray
- استقرار با Docker
- اتصال مستقیم GitHub به VibeNest
- امکان استفاده از فضای ذخیره‌سازی دائمی
- مناسب برای استقرار به‌صورت سرویس وب در VibeNest
- پورت پنل: `8080`

## ساختار استقرار

```text
GitHub
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

## راه‌اندازی در VibeNest

### 1. آماده‌سازی GitHub

فایل‌های اصلی پروژه باید در ریشه Repository قرار داشته باشند:

```text
Dockerfile
3x-ui-source.zip
README.md
```

فایل `Dockerfile` باید در ریشه Repository باشد.

### 2. اتصال به VibeNest

در VibeNest یک پروژه جدید ایجاد کنید و Repository گیت‌هاب را انتخاب کنید.

تنظیمات پیشنهادی:

```text
Source: GitHub
Branch: main
Build: Dockerfile
```

VibeNest سپس Image مربوط به Docker را Build می‌کند.

### 3. تنظیم پورت

پورت پنل وب:

```text
8080
```

در صورتی که VibeNest پورت سرویس را درخواست کرد، مقدار زیر را وارد کنید:

```text
8080
```

### 4. ذخیره‌سازی دائمی

اطلاعات و تنظیمات 3X-UI در مسیر زیر قرار می‌گیرند:

```text
/etc/x-ui
```

برای استفاده دائمی، بهتر است این مسیر به یک Persistent Volume متصل شود تا اطلاعات پنل، دیتابیس و تنظیمات هنگام Redeploy از بین نروند.

## راه‌اندازی اولیه

بعد از اینکه وضعیت Deployment در VibeNest به **LIVE** تغییر کرد، آدرس عمومی پروژه را باز کنید.

سپس تنظیمات اولیه پنل را انجام دهید و برای حساب Administrator یک نام کاربری و رمز عبور قوی انتخاب کنید.

**رمز عبور، Private Key، UUID و اطلاعات حساس کاربران را داخل GitHub قرار ندهید.**

## تنظیم Inboundهای Xray

3X-UI امکان مدیریت Inboundهای Xray را فراهم می‌کند.

بسته به Protocol و تنظیماتی که انتخاب می‌کنید، ممکن است به پورت‌های TCP یا UDP عمومی نیاز داشته باشید.

**توجه:** پورت `8080` مربوط به پنل وب 3X-UI است و به این معنی نیست که تمام پورت‌های TCP/UDP موردنیاز Xray به‌صورت خودکار در VibeNest قابل دسترسی هستند.

قبل از استفاده، بررسی کنید که محیط میزبانی VibeNest پورت‌های موردنیاز کانفیگ شما را پشتیبانی می‌کند.

## به‌روزرسانی پروژه

برای به‌روزرسانی:

1. فایل‌ها یا تنظیمات Docker را در GitHub تغییر دهید.
2. تغییرات را Commit و Push کنید.
3. در VibeNest یک Deployment جدید اجرا کنید.
4. منتظر Build شدن Docker Image بمانید.
5. وضعیت Health Check و Live شدن سرویس را بررسی کنید.

در صورت امکان مسیر `/etc/x-ui` را روی Persistent Storage نگه دارید.

## نکات امنیتی

- برای Administrator رمز عبور قوی انتخاب کنید.
- رمز عبور و Private Key را در GitHub قرار ندهید.
- اطلاعات حساس کاربران و Client Configurationها را عمومی نکنید.
- برای پنل از HTTPS استفاده کنید.
- 3X-UI و Xray را به‌روز نگه دارید.
- در صورت امکان دسترسی به پنل مدیریت را محدود کنید.
- قبل از تغییرات مهم از `/etc/x-ui` نسخه پشتیبان تهیه کنید.
- قوانین و محدودیت‌های شبکه VibeNest را درباره پورت‌های عمومی بررسی کنید.

## ساختار پروژه

```text
.
├── Dockerfile
├── 3x-ui-source.zip
└── README.md
```

## محیط اجرا

```text
Docker
Go
Node.js
Alpine Linux
Xray
3X-UI
```

پورت پنل:

```text
8080
```

مسیر اطلاعات دائمی:

```text
/etc/x-ui
```

---

# English Guide

## Deploy on VibeNest

### 1. GitHub Repository

The repository should contain:

```text
Dockerfile
3x-ui-source.zip
README.md
```

The `Dockerfile` must be located in the root of the repository.

### 2. Connect GitHub to VibeNest

In VibeNest, create a new project and select the GitHub repository.

Recommended settings:

```text
Source: GitHub
Branch: main
Build: Dockerfile
```

VibeNest will build the Docker image from the repository.

### 3. Application Port

The 3X-UI web panel uses:

```text
8080
```

If VibeNest asks for the application/service port, enter `8080`.

### 4. Persistent Storage

3X-UI stores its application data under:

```text
/etc/x-ui
```

For production use, configure persistent storage/volume for `/etc/x-ui` so the panel database and configuration survive redeployments.

## First Setup

After the deployment becomes **LIVE**, open the public URL provided by VibeNest.

Complete the initial panel configuration and use a strong administrator username and password.

Do not publish administrator credentials, private keys, UUIDs, or client configurations in this GitHub repository.

## Xray Inbounds

3X-UI can manage Xray inbound configurations.

Depending on the selected protocol and configuration, the required TCP/UDP ports must be publicly reachable.

**Important:** VibeNest's web-service port `8080` is the panel's web port. It does not automatically mean that arbitrary Xray TCP/UDP inbound ports are publicly exposed.

Verify that the hosting environment supports the public TCP/UDP ports required by your configuration.

## Updating the Deployment

1. Update the source or Docker configuration in GitHub.
2. Commit and push the changes.
3. Trigger a new deployment in VibeNest.
4. Wait for the Docker image to build.
5. Confirm that the application passes the health check.

Keep `/etc/x-ui` on persistent storage when possible.

# Disclaimer

This repository provides a Docker/VibeNest deployment setup for 3X-UI.

Users are responsible for complying with applicable laws, regulations, terms of service, and network policies.
