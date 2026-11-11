# SAP Commerce Cloud MCP Server (`SAP-Commerce-MCP`) — Distribution Release

[![Latest Release](https://img.shields.io/github/v/release/chriszhangrui/sap-commerce-mcp-release?label=Release&color=blue)](https://github.com/chriszhangrui/sap-commerce-mcp-release/releases/latest)
[![macOS Apple Silicon](https://img.shields.io/badge/macOS-Apple%20Silicon%20(arm64)-black.svg?logo=apple)]()
[![Windows](https://img.shields.io/badge/Windows-x64%20(.exe)-0078D6.svg?logo=windows)]()
[![MCP Specification](https://img.shields.io/badge/MCP-2024--11--05-green.svg)](https://modelcontextprotocol.io/)
[![Transports](https://img.shields.io/badge/Transports-stdio%20%7C%20streamable--http%20%7C%20sse-orange.svg)]()
[![SAP Commerce Cloud](https://img.shields.io/badge/SAP%20Commerce%20Cloud-2211%20%7C%20CCv2-008FD3.svg)](https://help.sap.com/docs/SAP_COMMERCE_CLOUD)
[![Build](https://img.shields.io/badge/Build-Native%20Mach--O%20%2F%20PE%20C%20Binary-blue.svg)]()

[English Guide](#-english-guide) • [Practical Usage & Prompts](#-practical-usage--ai-prompts-how-to-use) | [中文安装说明](#-中文安装与使用说明) • [实战使用方式与提示词](#-实际使用方式与自然语言提示词指南)

---

# 📖 English Guide

**SAP-Commerce-MCP** is an enterprise-grade Model Context Protocol (MCP) server that empowers **SAP Joule (Joule for Work Desktop / Joule Studio)**, **Claude Desktop**, **Cursor**, **Antigravity**, and enterprise AI agents to directly control, automate, scaffold, and self-heal **SAP Commerce Cloud** environments and **Composable Storefronts (Spartacus)**.

This repository provides pre-compiled, self-contained standalone binary distributions for **macOS (Apple Silicon / arm64)** and **Windows (x64)**. **Zero Python runtime or third-party dependencies required.**

> [!TIP]
> **Recommended Companion MCP:** For 0-to-1 brand storefront scaffolding and modern website ingestion (e.g., Anker, Nike, Allbirds), we strongly recommend installing **Playwright MCP** alongside `sap-commerce-mcp`. Playwright gives your AI agent a real browser engine to bypass Cloudflare/DataDome anti-bot challenges and capture high-resolution product images directly from live DOMs. See [Playwright MCP Setup](#-2-recommended-companion-playwright-mcp-anti-bot-bypass--dynamic-spa-ingestion).

---

## 🌟 Capabilities at a Glance (Built-in Enterprise Toolset)

- 🏗️ **Dual-Mode Greenfield Site Scaffolding (B2B & B2C)**: Automated generation of `BaseSite`, `BaseStore`, `ProductCatalog`, CMS Catalogs, Sync Jobs, and OCC OAuth clients for both B2B e-commerce and B2C brand direct-to-consumer stores.
- 📦 **CCv2 Enterprise Offline Release Packaging**: Automatically build and export complete, CAB-compliant CCv2 deployment bundles (ZIP) containing structured schema migration scripts, automated rollback plans, health verification probes, and enterprise change documentation.
- 🖼️ **Automated Product Media & Image Fetcher**: Discover, download, and bind high-resolution brand product images and media containers directly into Commerce catalogs via automated CDN/asset binding pipelines.
- 🌐 **External Storefront Ingestion & Crawling**: Ingest and structure external storefront catalogs (Shopify, WooCommerce, Magento, etc.) into ready-to-import SAP Commerce data scripts.
- 🩺 **Headless Spartacus Doctor & Auto-Healing**: 14-point deep health check diagnosing CORS whitelists, OCC URL regex mismatches, MyAccount navigation hierarchies, TabContainer child components, and B2B approval slots.
- 🏢 **B2B Organization Governance**: Automated setup and auditing of `B2BUnit` hierarchies, `B2BCostCenter`, `B2BBudget`, and multi-tier approval permissions.
- 🏷️ **Promotion Engine Orchestration**: Code-free creation of spend thresholds, bundle promotions (A+B+C), free gift rules, and instant publishing into promotion rule bases.
- ⚡ **Commerce Platform Kernel Operations**: Transactional data queries, schema-driven data ingestion pipelines, and runtime execution via the Commerce Platform Kernel API.
- 🔍 **Solr Indexing & Platform Ops**: Real-time Solr reindexing, catalog synchronization (Staged to Online), and Region Cache eviction.

---

## 🚀 Running Modes

The compiled standalone binary natively supports **both** local process execution and standalone HTTP network microservice mode:

### Mode 1: Local `stdio` (Default)
Used by desktop AI tools (Claude Desktop, Cursor, Antigravity) communicating via standard input/output.
```bash
# macOS
./sap-commerce-mcp

# Windows
.\sap-commerce-mcp.exe
```

### Mode 2: Network HTTP Service (`streamable-http` / `sse`)
Used for remote deployments, containers, team-shared services, or web clients like SAP Joule:
```bash
# macOS
./sap-commerce-mcp --transport streamable-http --port 8080

# Windows
.\sap-commerce-mcp.exe --transport streamable-http --port 8080
```

Endpoints exposed in HTTP mode:
- `http://0.0.0.0:8080/mcp`: MCP Streamable HTTP protocol endpoint (JSON-RPC 2.0 / SSE stream)
- `http://0.0.0.0:8080/health`: Microservice health check (returns `{"name":"sap-commerce-mcp","status":"ok"}`)
- `http://0.0.0.0:8080/`: Service root discovery & endpoint index

---

## 💻 Quick Start

### macOS (Apple Silicon / arm64)

#### Option 1: One-line Installer (recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/chriszhangrui/sap-commerce-mcp-release/main/install.sh | bash
```
The script downloads the latest **Apple Silicon (arm64)** binary from Releases to `~/bin/sap-commerce-mcp`, configures permissions, and outputs the AI client configuration snippet. (Intel/x86_64 Macs are not currently supported — no prebuilt binary.)

#### Option 2: Manual Installation
1. Download `sap-commerce-mcp-macos-arm64` (Apple Silicon, M1-M4) from Releases.
2. Copy it to `~/bin/sap-commerce-mcp`:
   ```bash
   mkdir -p ~/bin
   cp sap-commerce-mcp-macos-* ~/bin/sap-commerce-mcp
   chmod +x ~/bin/sap-commerce-mcp
   xattr -d com.apple.quarantine ~/bin/sap-commerce-mcp 2>/dev/null || true
   codesign --force --deep --sign - ~/bin/sap-commerce-mcp 2>/dev/null || true
   ```

---

### Windows (x64)

#### Option 1: One-line PowerShell Installer (recommended)
Open **PowerShell** and run:
```powershell
irm https://raw.githubusercontent.com/chriszhangrui/sap-commerce-mcp-release/main/install.ps1 | iex
```
The installer downloads the latest `sap-commerce-mcp-windows-x64.exe` from Releases to `%USERPROFILE%\bin`, unblocks it, adds the directory to your user PATH, and outputs the AI client configuration.

#### Option 2: Manual Installation
1. Download `sap-commerce-mcp-windows-x64.exe` from Releases.
2. Place it in `C:\Users\<YOUR_USERNAME>\bin\sap-commerce-mcp.exe`.
3. Right-click the `.exe` -> **Properties** -> Check **Unblock** if downloaded from the web.

---

## ⚙️ AI Client Configuration

### 🤖 1. SAP Joule (Joule for Work Desktop / Joule Studio) — [Primary Focus]

**SAP Joule for Work Desktop** provides the premier enterprise experience for orchestrating SAP Commerce Cloud.

> [!IMPORTANT]
> **Joule for Work Desktop requires HTTP/SSE Mode ONLY:**
> Unlike developer CLI tools that spawn local `stdio` subprocesses, **SAP Joule for Work Desktop connects to MCP servers exclusively via network HTTP endpoints (Streamable HTTP or Server-Sent Events / SSE)**. You cannot use `command/stdio` configs with Joule. The server must be started in HTTP service mode before Joule connects.

#### Step 1: Start `sap-commerce-mcp` in HTTP Service Mode (Port 8080)

Run the standalone binary with `--transport streamable-http --port 8080` (or `--transport sse --port 8080`):

**macOS:**
```bash
export SAP_COMMERCE_URL="https://localhost:9002"
export SAP_COMMERCE_USER="admin"
export SAP_COMMERCE_KEY="nimda"
~/bin/sap-commerce-mcp --transport streamable-http --port 8080
```

**Windows (PowerShell):**
```powershell
$env:SAP_COMMERCE_URL="https://localhost:9002"
$env:SAP_COMMERCE_USER="admin"
$env:SAP_COMMERCE_KEY="nimda"
& "$env:USERPROFILE\bin\sap-commerce-mcp.exe" --transport streamable-http --port 8080
```

> **Microservice Endpoints Exposed:**
> - Streamable HTTP: `http://localhost:8080/mcp`
> - SSE Protocol: `http://localhost:8080/sse`
> - Health Check: `http://localhost:8080/health`

#### Step 2: Configure Joule for Work Desktop

In **Joule for Work Desktop**, navigate to **Settings** -> **MCP Servers** -> **Add MCP Server** (or edit your Joule MCP configuration file):

**Configuration for Joule Desktop:**
```json
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "url": "http://localhost:8080/mcp",
      "transport": "streamable-http"
    }
  }
}
```

*(If your Joule version uses standard SSE, set `"url": "http://localhost:8080/sse"` and `"transport": "sse"`. If adding via the Joule UI, simply enter `http://localhost:8080/mcp` into the Server URL field).*

---

### 🎭 2. Recommended Companion: Playwright MCP (Anti-Bot Bypass & Dynamic SPA Ingestion)

When building storefronts from existing brand websites (e.g., Anker, Nike, Allbirds), we **strongly recommend installing Playwright MCP (`@playwright/mcp`) alongside `sap-commerce-mcp`**.

#### Why You Need Playwright MCP:
1. **🛡️ Bypass Strict Anti-Bot & WAF Protections**: Modern e-commerce sites are protected by Cloudflare Turnstile, DataDome, Akamai Bot Manager, PerimeterX, and AWS WAF. Standard HTTP scrapers (`requests`, `curl`) are blocked with HTTP 403 or interactive CAPTCHAs. Playwright provides a full Chromium browser engine with real TLS fingerprints and human interaction capabilities to bypass these barriers seamlessly.
2. **⚡ Ingest Dynamic Client-Side SPAs (Next.js / React / Nuxt)**: Leading DTC brands use headless frontends where HTML contains empty product shells until hydrated by client-side JavaScript. Playwright waits for full hydration and extracts the live, fully rendered DOM (`outerHTML`).
3. **🎨 Automated Brand Visual Identity Discovery**: The MCP automatically calls Playwright to inspect `window.getComputedStyle()`, discovering brand primary colors (e.g., Anker Cyan, AusPost Red), secondary accents, typography, and logo assets. This ensures the scaffolded Spartacus storefront matches the brand's visual identity pixel-for-pixel.
4. **🖼️ In-Memory Canvas Asset Capture (No Hotlink Blocks)**: Avoids CDN 403 Forbidden errors by capturing product images directly off the rendered browser canvas as Base64 binaries, writing them permanently into Hybris local storage (`sys_master`).
5. **🩺 End-to-End Storefront Verification**: Enables Joule to perform automated acceptance testing on the generated Spartacus frontend: navigating categories, verifying PDP Specs tabs, checking in-stock ATP statuses, and adding items to cart.

#### Quick Playwright MCP Setup:
```bash
# Verify npx is available (comes with Node.js 18+)
npx -y @playwright/mcp@latest --version
```
Add the `"playwright"` server block shown in the configuration snippets above.

---

### 3. Claude Desktop (Local stdio)
Add to your `claude_desktop_config.json`:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "command": "/Users/<YOUR_USERNAME>/bin/sap-commerce-mcp",
      "env": {
        "SAP_COMMERCE_URL": "https://localhost:9002",
        "SAP_COMMERCE_USER": "admin",
        "SAP_COMMERCE_KEY": "nimda"
      }
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    }
  }
}
```

---

### 4. Cursor (Local stdio)
Go to **Cursor Settings** -> **Features** -> **MCP** -> **Add New MCP Server**:
- **Name**: `sap-commerce-mcp`
- **Type**: `command`
- **Command**: `/Users/<YOUR_USERNAME>/bin/sap-commerce-mcp` (or Windows `.exe` path)
- **Environment Variables**:
  - `SAP_COMMERCE_URL`: `https://localhost:9002`
  - `SAP_COMMERCE_USER`: `admin`
  - `SAP_COMMERCE_KEY`: `nimda`

*(Repeat to add `playwright` with command `npx` and args `["-y", "@playwright/mcp@latest"]`)*

---

### 5. Antigravity & Other MCP Clients
Add both servers to your `mcp_settings.json` or workspace settings using the JSON snippets above.

---

## 🔑 Environment Variables Reference

### Required — Commerce connection (set these in your MCP client's `env`)
| Variable | Default | Description |
| :--- | :--- | :--- |
| `SAP_COMMERCE_URL` | `https://localhost:9002` | SAP Commerce Cloud instance endpoint URL |
| `SAP_COMMERCE_USER` | `admin` | Commerce platform administrative username |
| `SAP_COMMERCE_KEY` | `nimda` | Commerce platform administrative credential |

> Legacy aliases `HAC_URL` / `HAC_USER` / `HAC_PASS` are still accepted as a
> fallback if the `SAP_COMMERCE_*` ones are not set.

### Optional — HTTP service mode (only when not using the default local stdio)
| Variable | Default | Description |
| :--- | :--- | :--- |
| `MCP_TRANSPORT` | `stdio` | Transport protocol: `stdio`, `streamable-http`, or `sse` |
| `MCP_PORT` / `PORT` | `8080` | Port to listen on in HTTP mode |
| `MCP_HOST` | `0.0.0.0` | Host interface to bind in HTTP mode |

### Optional — advanced / situational
| Variable | Default | Description |
| :--- | :--- | :--- |
| `SPARTACUS_PROJECT_PATH` | `~/sap-ai-commerce-demo/spartacus-storefront` | Local path to your Spartacus storefront project. **Only needed** if you use the storefront-config / spartacus-doctor tools to edit your local frontend files (`.env-cmdrc`, `providers.ts`, `styles.scss`). Not needed for backend-only use. |
| `HAC_STORAGE_PATH` | (auto) | Path to store the SSO session, for SAP-internal SSO environments. |
| `MCP_SKIP_NET_TIME` | `false` | Set `true` to skip the network time check (offline / air-gapped environments). |

> **Notes on things you do NOT configure at install time:**
> - **Storefront URL** (e.g. `http://localhost:4200`) is a per-call tool argument
>   (`storefront_origin` / `storefront_url`) with a sensible default — not an env var.
> - **CCv2 output directory** is a per-call tool argument (`output_dir`, default under
>   `/tmp`). The CCv2 tools *generate* extension / Java / release-patch files into that
>   directory; you then copy them into your Commerce project repo and raise a PR — the
>   server never deploys into Commerce itself.
> - There is **no "Commerce server install path"** input — the server talks to Commerce
---

## 🎯 Practical Usage & AI Prompts (How to Use)

Once configured in **Claude Desktop**, **Cursor**, or **Antigravity**, you can interact with SAP Commerce Cloud using natural language. The AI agent automatically orchestrates the built-in MCP tools under the hood.

### 🌟 1. Standard 8-Step Greenfield Site Deployment Workflow
When you prompt the AI to build an e-commerce storefront from scratch, it executes the following industrial-grade pipeline:

1. **Site Scaffolding (`commerce_scaffold_greenfield_site`)**: Creates `BaseSite`, `BaseStore`, `ProductCatalog`, `ClassificationSystem`, OAuth clients (`mobile_android`, `spartacus-client`), and standard `DeliveryModes`.
2. **Catalog Ingestion (`commerce_ingest_external_storefront`)**: Crawls external storefronts or extracts catalog data (categories, products, prices, and high-resolution images).
3. **Master Data Import (`commerce_import_data`)**: Safely imports category trees, product attributes, and canonical B2B/B2C `PriceRow` entries into the database.
4. **CMS Content Catalog Scaffolding (`commerce_storefront_cms_suite_scaffold`)**: Builds an isolated brand `ContentCatalog` with Homepage, 4-tier horizontal navigation tree, 3-column footer, and PDP specification tabs.
5. **Media Asset Binding (`commerce_execute_kernel_task`)**: Downloads high-resolution images in-memory and binds them to Spartacus OCC standard 4-format MediaContainers (`zoom`, `product`, `thumbnail`, `cartIcon`).
6. **Catalog Synchronization (`commerce_catalog_sync`)**: Synchronizes `ProductCatalog` and `ContentCatalog` from `Staged` to `Online`.
7. **Solr Facet Reindexing (`commerce_solr_reindex`)**: Runs a full Solr reindexing so products, categories, and facet filters become immediately searchable via OCC.
8. **Storefront Health Check & Auto-Healing (`commerce_spartacus_doctor`)**: Executes a comprehensive 30-point readiness health check (CORS whitelist, OCC regex patterns, OAuth credentials, stock ATP, delivery modes, payment gateways) and auto-heals any detected gaps.

---

### 💬 2. Real-World Prompts & Usage Scenarios

#### Scenario A: Build a Greenfield Storefront from Scratch
> **Prompt**: *"Scaffold a brand new B2B site for brand 'Anker' (site_id: `anker-b2b`) in USD. Ingest products and high-resolution images from `https://www.anker.com`, set up B2B organizational hierarchy, and build the Spartacus Composable Storefront."*
* **What happens**: The agent scaffolds the site, crawls Anker's products and high-res images, binds them into OCC MediaContainers, syncs catalogs, reindexes Solr, and configures the local Spartacus storefront.

#### Scenario B: Headless Storefront Health Check & Auto-Healing
> **Prompt**: *"Run Spartacus Doctor on my site `anker-b2b` with auto-fix enabled. Check why products aren't displaying and whether CORS and OAuth are configured properly."*
* **What happens**: Calls `commerce_spartacus_doctor(site_id="anker-b2b", auto_fix=True)` to audit all 30 points (OCC routes, CORS whitelist, OAuth clients, ATP stock, PriceRows, Solr documents, MediaContainers) and auto-remediates any failed check.

#### Scenario C: External Storefront Ingestion & Image Binding
> **Prompt**: *"Crawl the storefront at `https://www.anker.com`, extract top 15 products with high-resolution gallery images and specifications, and generate ready-to-import ImpEx master data."*
* **What happens**: Calls `commerce_ingest_external_storefront` to extract clean JSON catalog payloads, and `commerce_execute_kernel_task` to register media formats and bind them into products.

#### Scenario D: Enterprise B2B Org, Budgets & Approval Hierarchy
> **Prompt**: *"Set up a multi-tier B2B organization structure for Anker: Root Unit `ANKER_HQ`, Cost Center `CC_ANKER`, $50,000 monthly budget, and approval threshold of $500 for buyers."*
* **What happens**: Calls `commerce_b2b_scaffold_org` to create `B2BUnit`, `B2BCostCenter`, `B2BBudget`, `B2BOrderApprovalPermission`, and demo buyer/approver accounts.

#### Scenario E: Create and Publish Drools Promotions
> **Prompt**: *"Create a spend threshold promotion: 15% discount for orders exceeding $200 in the B2B store, and immediately publish it to the promotion rule base."*
* **What happens**: Calls `commerce_promotion_scaffold` to compile the Drools rule and publishes it to the active promotion group.

#### Scenario F: Enterprise CCv2 Release Packaging
> **Prompt**: *"Generate a CCv2 offline release bundle for release v2026.10, including schema migration scripts, deployment checklists, and automated rollback plans."*
* **What happens**: Calls `commerce_ccv2_export_offline_bundle` to generate a production-ready CAB-compliant ZIP bundle with verification probes.

#### Scenario G: Safe Site Teardown & Clean Lifecycle Deletion
> **Prompt**: *"Safely delete the test site `anker-b2b` and clean up all its orders, carts, B2B hierarchy, and product catalogs without leaving orphan data."*
* **What happens**: First runs `commerce_delete_site(site_id="anker-b2b", confirm=False)` (DRY RUN) to inventory all objects, then with `confirm=True` cascades the teardown of orders, carts, processes, BaseStore, CMSSite, and catalogs.

---

### 🛠️ 3. Core Tool Quick Reference Matrix
| Category | Tool Name | Key Function |
| :--- | :--- | :--- |
| **Site Lifecycle** | `commerce_scaffold_greenfield_site` | 1-click generation of BaseSite, BaseStore, Catalogs, OAuth |
| | `commerce_delete_site` | Safe, complete cascade deletion of site, orders, carts & catalogs |
| | `commerce_site_list` | Lists all BaseSites, active channels (B2B/B2C), and bound stores |
| **Storefront & CMS** | `commerce_storefront_cms_suite_scaffold` | Builds complete isolated brand CMS content catalog (Nav, Footer, Homepage) |
| | `commerce_spartacus_doctor` | 30-point deep headless readiness diagnostic & auto-healing |
| | `commerce_storefront_autofix` | Remediates CORS, OCC URL regex, and OAuth issues |
| | `commerce_storefront_app_config` | Updates local Spartacus frontend project environment and routing |
| **Media & Crawling** | `commerce_ingest_external_storefront` | Ingests external store catalog and generates master ImpEx |
| | `commerce_discover_brand_catalog` | Discovers brand categories, hero banners, and visual assets |
| | `commerce_execute_kernel_task` | High-performance in-memory image download and 4-format container binding |
| **B2B Governance** | `commerce_b2b_scaffold_org` | Creates multi-tier B2B organization, cost centers, budgets & approval rules |
| | `commerce_b2b_org_doctor` | Audits B2B user permissions, approval chains, and cost centers |
| **Promotions** | `commerce_promotion_scaffold` | Scaffolds and compiles Drools promotion rules (threshold, bundle, free gift) |
| | `commerce_promotion_list` | Lists active promotion source rules and statuses |
| **Platform Ops** | `commerce_solr_reindex` | Full or incremental in-process Solr reindexing |
| | `commerce_catalog_sync` | Synchronizes catalog versions (Staged -> Online) |
| | `commerce_cache_clear` | Evicts Hybris Region Cache in memory |
| | `commerce_query` | Executes transactional FlexibleSearch queries against database |
| **CCv2 Release** | `commerce_ccv2_package_release` | Generates CCv2 extension scaffolding and release packaging |
| | `commerce_ccv2_export_offline_bundle` | Exports CAB-compliant offline deployment zip bundles with rollback scripts |

---

<br>

# 🇨🇳 中文安装与使用说明

**SAP-Commerce-MCP** 是一款专为 **SAP Joule（Joule for Work Desktop / 桌面工作台）**、**Claude Desktop**、**Cursor**、**Antigravity** 等企业级智能体打造的 Model Context Protocol (MCP) 服务。赋能 AI 直接操控、自动化交付、一键建站与自愈修复 **SAP Commerce Cloud** 环境与 **Composable Storefront (Spartacus)** 前台。

本仓库提供针对 **macOS（Apple Silicon / arm64）** 与 **Windows（x64）** 平台预编译的**独立单文件二进制程序**，内部已集成全部依赖，**无需配置 Python 环境或第三方包，开箱即用**。

> [!TIP]
> **最佳实践与核心搭档：** 强烈建议将 **Playwright MCP** 与 `sap-commerce-mcp` **同时安装使用**。在面对 Anker、Nike、Allbirds 等现代商业独立站的反爬防护（Cloudflare、DataDome）与 SPA 客户端动态注水时，Playwright 能够提供真实浏览器环境绕过人机挑战，并抓取高清原图供 Commerce 直接入库。详见 [Playwright MCP 协同安装说明](#-2-强烈建议协同安装playwright-mcp反爬穿透与动态渲染核心搭档)。

---

### 🌟 核心功能特性

1. **多平台原生支持**：提供 macOS（Apple Silicon / arm64）及 Windows（x64）原生编译二进制，开箱即用。
2. **B2B / B2C 双模商城脚手架**：一键生成从底层数据模型、OCC 接口到 CMS 页面组件的全套配置。
3. **CCv2 离线补丁打包器**：全自动导出包含全套版本变更脚本、自动化回滚方案、健康探测探针及 CAB 审计文档的标准 CCv2 独立发布包（ZIP）。
4. **商品真图抓取与媒体绑定引擎**：自动化抓取品牌高清图并自动生成底层的全生命周期媒体资产绑定与映射逻辑。
5. **双传输运行模式**：同时支持本地极速 `stdio` 管道模式与网络微服务 `streamable-http` / `sse` 模式。
6. **Headless Spartacus Doctor 诊断增强**：覆盖 MyAccount 导航树、B2B 审批流槽位与 TabContainer 层级审计。

---

### 快速安装步骤

#### macOS (Apple Silicon)
打开终端执行：
```bash
curl -fsSL https://raw.githubusercontent.com/chriszhangrui/sap-commerce-mcp-release/main/install.sh | bash
```

#### Windows (x64)
打开 PowerShell 执行：
```powershell
irm https://raw.githubusercontent.com/chriszhangrui/sap-commerce-mcp-release/main/install.ps1 | iex
```

---

### ⚙️ AI 客户端配置指南

#### 🤖 1. SAP Joule (Joule for Work Desktop / Joule 工作台) —— [官方首选推荐]

**SAP Joule for Work Desktop** 是操控 SAP Commerce Cloud 的官方企业级首选客户端。

> [!IMPORTANT]
> **Joule for Work Desktop 仅支持网络 HTTP/SSE 模式接入：**  
> 与部分开发者 CLI 工具通过本地 `stdio` 子进程直接拉起命令不同，**SAP Joule for Work Desktop 对外连接 MCP 服务仅支持网络 HTTP 协议端点（Streamable HTTP 或 Server-Sent Events / SSE）**。Joule 桌面端中不能配置 `command/stdio` 本地进程命令，必须先将服务以 HTTP 微服务模式启动，再在 Joule 中接入其 URL 端点。

##### 步骤 1：启动 `sap-commerce-mcp` HTTP 微服务（端口 8080）

使用 `--transport streamable-http --port 8080`（或 `--transport sse --port 8080`）启动独立二进制程序：

**macOS:**
```bash
export SAP_COMMERCE_URL="https://localhost:9002"
export SAP_COMMERCE_USER="admin"
export SAP_COMMERCE_KEY="nimda"
~/bin/sap-commerce-mcp --transport streamable-http --port 8080
```

**Windows (PowerShell):**
```powershell
$env:SAP_COMMERCE_URL="https://localhost:9002"
$env:SAP_COMMERCE_USER="admin"
$env:SAP_COMMERCE_KEY="nimda"
& "$env:USERPROFILE\bin\sap-commerce-mcp.exe" --transport streamable-http --port 8080
```

> **微服务暴露的核心端点：**
> - Streamable HTTP 协议端点：`http://localhost:8080/mcp`
> - SSE 协议端点：`http://localhost:8080/sse`
> - 健康检查端点：`http://localhost:8080/health`

##### 步骤 2：在 Joule for Work Desktop 中添加服务连接

在 **Joule for Work Desktop** 中，进入 **Settings**（设置）-> **MCP Servers** -> **Add MCP Server**（添加 MCP 服务），或者直接配置 Joule 的 MCP 配置文件：

**Joule 桌面端配置示例：**
```json
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "url": "http://localhost:8080/mcp",
      "transport": "streamable-http"
    }
  }
}
```

*(若您所使用的 Joule 版本使用标准 SSE，可将 `sap-commerce-mcp` 的 `url` 设为 `http://localhost:8080/sse`，`transport` 设为 `sse`。若在 Joule 图形界面中添加，直接在 Server URL 输入框中填入 `http://localhost:8080/mcp` 即可。)*

---

#### 🎭 2. 强烈建议协同安装：Playwright MCP（反爬穿透与动态渲染核心搭档）

在要求 AI 基于已有真实商业品牌独立站（如 Anker、Nike、Allbirds 等）进行从 0 到 1 快速建站与主数据抓取时，**强烈建议同时配置安装 Playwright MCP (`@playwright/mcp`)**。

##### 为什么必须搭配安装 Playwright MCP？
1. **🛡️ 突破严苛反爬机制与人机验证（WAF / Anti-Bot Bypass）**：现代知名独立站广泛部署了 Cloudflare Turnstile、DataDome、Akamai、PerimeterX 与 AWS WAF。纯静态的 HTTP 脚本（`requests`/`curl`）极易被拦截返回 403 阻断或强制滑块。Playwright 提供真实 Chromium 浏览器内核与人机特征模拟，确保 Joule 能够 100% 顺畅穿透防护。
2. **⚡ 深度解析客户端动态注水 SPA（Next.js / Nuxt / React Hydration）**：大量前沿 DTC 品牌采用前端无头技术栈，初始返回的 HTML 仅包含空壳框架，商品列表与属性由客户端 JavaScript 异步渲染。Playwright 能够等待页面完全 Hydrate（注水完成）后，精准截获包含全部真实参数与规格的实时 DOM（`outerHTML`）。
3. **🎨 自动提取品牌主视觉与计算样式（Brand Visual Identity）**：建站引擎会自动驱动 Playwright 探测目标品牌的真实 Computed Styles（`window.getComputedStyle`），精准提取品牌主色调（如 Anker 极光蓝、AusPost 邮政红）、强调色与全局字体排版，让一键生成的 Spartacus 商城前台在视觉上与品牌官网像素级同步。
4. **🖼️ 内存级 Canvas 高清图捕获（杜绝跨域 403 裂图）**：现代品牌 CDN 开启了防盗链（Hotlink Protection），直接引用外部图片链接会在前台导致 403 裂图（显示相机斜杠占位符）。Playwright 能够在浏览器内部把商品实拍图绘制到 Canvas 转换为 Base64 本地二进制，由 MCP 存入 Commerce 底层媒体中心（`sys_master`），永不裂图。
5. **🩺 前台端到端交互与验收验证（E2E Storefront Verification）**：赋能 Joule 在建站交付后，直接模拟真实买家打开前台（`https://localhost:4201`）、浏览分类列表、展开 PDP 详情页查看 Specs 规格参数、核验在库状态（In Stock）并点击加车，完成全链路质量闭环。

##### 快速检验与就绪命令：
```bash
# 验证 Node.js 环境及 npx 可用性
npx -y @playwright/mcp@latest --version
```

---

#### 3. Claude Desktop (本地 stdio 模式)
在 `claude_desktop_config.json` 中添加上述双服务配置：
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

---

#### 4. Cursor (本地 stdio 模式)
前往 **Cursor Settings** -> **Features** -> **MCP** -> **Add New MCP Server**：
- **Name**: `sap-commerce-mcp`
- **Command**: `/Users/<您的用户名>/bin/sap-commerce-mcp`（或 Windows `.exe` 路径）
- **Environment Variables**:
  - `SAP_COMMERCE_URL`: `https://localhost:9002`
  - `SAP_COMMERCE_USER`: `admin`
  - `SAP_COMMERCE_KEY`: `nimda`
*(建议同理添加 `playwright` 服务)*

---

#### 5. Antigravity & 其他智能体
在工作区或全局的 `mcp_settings.json` 中填入上述包含 `sap-commerce-mcp` 和 `playwright` 的 JSON 块即可。

---

### 🔑 环境变量参考

#### 必填 —— 连接 Commerce（填入 MCP 客户端配置的 `env`）
| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `SAP_COMMERCE_URL` | `https://localhost:9002` | SAP Commerce Cloud 实例地址 |
| `SAP_COMMERCE_USER` | `admin` | Commerce 平台管理员账号 |
| `SAP_COMMERCE_KEY` | `nimda` | Commerce 平台管理员密码 |

#### 可选 —— HTTP 服务模式（仅在不使用默认本地 stdio 时需要）
| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `MCP_TRANSPORT` | `stdio` | 传输协议：`stdio`、`streamable-http` 或 `sse` |
| `MCP_PORT` / `PORT` | `8080` | HTTP 模式监听端口 |
| `MCP_HOST` | `0.0.0.0` | HTTP 模式绑定的网卡地址 |

#### 可选 —— 高级 / 特定场景
| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `SPARTACUS_PROJECT_PATH` | `~/sap-ai-commerce-demo/spartacus-storefront` | 本机 Spartacus 前台工程目录。**仅当**你用前台配置 / spartacus-doctor 工具去修改本地前台文件（`.env-cmdrc`、`providers.ts`、`styles.scss`）时才需要；只操作后端时无需配置。 |
| `HAC_STORAGE_PATH` | （自动） | SSO 会话存储路径，用于 SAP 内网 SSO 环境。 |
| `MCP_SKIP_NET_TIME` | `false` | 设为 `true` 跳过联网校时（离线 / 内网隔离环境）。 |

> **以下几项无需在安装时配置：**
> - **前台地址**（如 `http://localhost:4200`）是工具的调用参数（`storefront_origin` / `storefront_url`），有默认值，不是环境变量。
> - **CCv2 产物输出目录**是工具的调用参数（`output_dir`，默认在 `/tmp` 下）。CCv2 工具只是把生成的 extension / Java / 发布补丁文件**输出到该目录**，再由你拷进 Commerce 项目仓库提 PR —— 服务本身不会部署进 Commerce。
> - **不存在"Commerce 服务器安装路径"这个输入** —— 服务通过 HTTP（`SAP_COMMERCE_URL`）操作 Commerce，不读取 Commerce 的本地安装目录。

---

### 作为独立 HTTP 服务运行

如果您希望将 MCP 作为独立的常驻后台微服务运行（例如供远程团队或 SAP Joule 调用）：

```bash
# macOS
~/bin/sap-commerce-mcp --transport streamable-http --port 8080

# Windows
& "$env:USERPROFILE\bin\sap-commerce-mcp.exe" --transport streamable-http --port 8080
```

微服务提供以下标准端点：
- **MCP 端点**：`http://<IP>:8080/mcp`
- **健康检查**：`http://<IP>:8080/health`
---

## 🎯 实际使用方式与自然语言提示词指南

配置完成后，您可以在 **Claude Desktop**、**Cursor** 或 **Antigravity** 中**直接使用中文自然语言与 AI 助手对话**。智能体将自动识别意图并在后台调度相应的 MCP 工具。

### 🌟 1. 标准 8 步全托管建站流水线（从零到完整上线）
当您要求 AI 搭建一个全新品牌独立站时，AI 将自动执行标准工业级交付流程：
1. **站点脚手架创建 (`commerce_scaffold_greenfield_site`)**：一键生成 BaseSite、BaseStore、ProductCatalog、ClassificationSystem、OAuth 客户端（`mobile_android`, `spartacus-client`）与标准配送方式。
2. **外部商品抓取 (`commerce_ingest_external_storefront`)**：解析外部官网或导入商品主数据（品类、商品、价格行与高清图片）。
3. **主数据导入 (`commerce_import_data`)**：将商品主数据与规范的 B2B/B2C `PriceRow` 价格行安全入库。
4. **独立 CMS 内容套件构建 (`commerce_storefront_cms_suite_scaffold`)**：生成专属品牌 ContentCatalog，搭建首页、四级横向导航树、多列页尾与详情页 Tab。
5. **商品媒体资产绑定 (`commerce_execute_kernel_task`)**：下载原图并自动切分绑定为 Spartacus OCC 标准的 4 种规格容器（`zoom`、`product`、`thumbnail`、`cartIcon`）。
6. **目录版本同步 (`commerce_catalog_sync`)**：将商品目录与内容目录从 `Staged` 全量同步发布至 `Online`。
7. **Solr 分面索引重构 (`commerce_solr_reindex`)**：触发 Solr FULL 全量重新索引，使商品和分类筛选项在前台即时可查。
8. **无头商城深度体检与自愈 (`commerce_spartacus_doctor`)**：执行 30 项就绪度体检（CORS 白名单、OAuth 凭据、库存状态、价格覆盖、结账履约等）并自动修复异常。

---

### 💬 2. 典型业务场景与 Prompt 提问范例

#### 场景 1：从零搭建全新品牌独立站（B2B / B2C）
> **Prompt**：*“帮我从零建一个 Anker B2B 官方商城（站点 ID: `anker-b2b`，默认币种 USD）。从 `https://www.anker.com` 抓取前 15 款商品和高清图片，建立 B2B 组织与审批预算，并自动生成 Spartacus 前台配置。”*
* **执行效果**：AI 自动完成从数据模型、OCC 接口、CMS 页面、高清媒体容器绑定、Solr 索引到本地 Spartacus 前端代码配置的全流程。

#### 场景 2：Spartacus 无头商城体检与一键自愈
> **Prompt**：*“对站点 `anker-b2b` 执行无头商城就绪度深度体检（开启 auto_fix），检查为什么前台看不了商品、图片有没有裂图，并修复可能存在的跨域或 OAuth 问题。”*
* **执行效果**：调用 `commerce_spartacus_doctor` 进行 30 维深度核验，自动补齐缺失的 CORS 配置、生成缺失的 OAuth 客户端，并排查价格与库存链路。

#### 场景 3：外部独立站商品真图抓取与规格入库
> **Prompt**：*“抓取 `https://www.anker.com` 的主要商品和超清无水印图片，生成符合 SAP Commerce 规范的 ImpEx 主数据并绑定到 4 规格媒体容器。”*
* **执行效果**：智能穿透 Next.js `__NEXT_DATA__` 抓取最高清 CDN 原图，内存字节穿透注入 Commerce 媒体存储，解决跨容器/沙盒环境无图痛点。

#### 场景 4：企业级 B2B 组织架构、预算与审批流治理
> **Prompt**：*“为 Anker 搭建多层级 B2B 组织架构：根组织 `ANKER_HQ`，成本中心 `CC_ANKER`，月度预算 $50,000，采购员单笔审批阈值 $500，并生成采购员和审批人测试账号。”*
* **执行效果**：自动配置 `B2BUnit`、`B2BCostCenter`、`B2BBudget` 及审批规则模板，打通 B2B 结账审批链路。

#### 场景 5：Drools 促销引擎规则编排与即时生效
> **Prompt**：*“帮我创建一个满 $200 减 $30 的满减促销规则，绑定到当前 B2B 商城，并立即编译发布到促销规则库。”*
* **执行效果**：调用 `commerce_promotion_scaffold` 编译 Drools 规则并发布到 Promotion Group，实时对购物车生效。

#### 场景 6：CCv2 企业级离线部署包与回滚方案打包
> **Prompt**：*“为版本 v2026.10 导出符合 CCv2 CAB 标准的离线发布包，包含全套数据迁移脚本、回滚方案与健康探针。”*
* **执行效果**：生成标准化 ZIP 压缩包，内含全套发布脚本、回滚策略和验证说明，直接满足企业上线变更评审要求。

#### 场景 7：安全整站下线销毁（全级联清理无残留）
> **Prompt**：*“清理测试站点 `anker-b2b`。先告诉我将会删除哪些数据，确认后再彻底清空，确保把这个站生成的订单和购物车也一起干净删掉。”*
* **执行效果**：首先以 Dry-Run 模式罗列包含 `Order`、`Cart`、`BaseStore`、`CMSSite`、`B2BUnit`、`Catalog` 在内的清单；确认后自底向上优先级联清理订单、流程、购物车，再销毁站点架构，杜绝脏数据。

---

### 🛠️ 3. 核心工具功能全景速查表
| 分类模块 | 工具名称 | 核心能力说明 |
| :--- | :--- | :--- |
| **站点生命周期** | `commerce_scaffold_greenfield_site` | 一键生成 BaseSite、BaseStore、商品目录、OAuth 客户端 |
| | `commerce_delete_site` | 安全全级联删除整站（含订单、购物车、业务流程与目录） |
| | `commerce_site_list` | 罗列实例内所有 BaseSite、渠道类型（B2B/B2C）与绑定配置 |
| **前台与 CMS** | `commerce_storefront_cms_suite_scaffold` | 构建隔离的品牌专属 CMS 内容目录（导航树、页尾、首页与 Tab） |
| | `commerce_spartacus_doctor` | 30 项 Spartacus 无头商城全维深度体检与自动修复 |
| | `commerce_storefront_autofix` | 针对性修复 CORS 跨域、OCC URL 正则与 OAuth 客户端 |
| | `commerce_storefront_app_config` | 更新本地 Spartacus 前端工程环境变量与多站点路由 |
| **媒体与抓取** | `commerce_ingest_external_storefront` | 抓取外部独立站全量商品数据并生成标准化 ImpEx |
| | `commerce_discover_brand_catalog` | 探索外部站点的品类树、主视觉 Banner 与品牌资产 |
| | `commerce_execute_kernel_task` | 高性能内存穿透下载并绑定 4 规格媒体容器（zoom/product/thumb/cartIcon） |
| **B2B 治理** | `commerce_b2b_scaffold_org` | 搭建多层级 B2B 组织、成本中心、预算与审批权限规则 |
| | `commerce_b2b_org_doctor` | 审计 B2B 用户的组织归属、审批链与成本中心额度 |
| **促销引擎** | `commerce_promotion_scaffold` | 可视化生成 Drools 促销规则（满减、搭配套餐、买赠礼品） |
| | `commerce_promotion_list` | 查询并筛选当前激活的促销规则及其优先级 |
| **运维与检索** | `commerce_solr_reindex` | 执行进程内全量或增量 Solr 重新索引 |
| | `commerce_catalog_sync` | 触发商品/内容目录从 Staged 到 Online 的同步发布 |
| | `commerce_cache_clear` | 刷新并清空 Commerce Region Cache 内存缓存 |
| | `commerce_query` | 直接执行事务级 FlexibleSearch 查询获取数据库明细 |
| **CCv2 发版** | `commerce_ccv2_package_release` | 生成符合 CCv2 规范的 Extension 脚手架与发版配置 |
| | `commerce_ccv2_export_offline_bundle` | 导出符合 CAB 规范的离线部署 ZIP 包与自动化回滚脚本 |

---

## ❓ 常见问题 (FAQ)

**Q: macOS 启动时提示 `"sap-commerce-mcp" 无法打开，因为无法验证开发者`？**  
A: 这是 macOS 下载外部二进制程序的 Gatekeeper 安全机制。请在终端执行：
```bash
xattr -d com.apple.quarantine ~/bin/sap-commerce-mcp
codesign --force --deep --sign - ~/bin/sap-commerce-mcp
```

**Q: Windows 提示 SmartScreen 拦截或未知发布者？**  
A: 在 PowerShell 中执行 `Unblock-File -Path "$env:USERPROFILE\bin\sap-commerce-mcp.exe"` 即可解除下载保护。

**Q: 本版本支持哪些 SAP Commerce 版本？**  
A: 支持 SAP Commerce Cloud (CCL) 2211、2011 以及 CCv2 云端环境，兼容 Spartacus / Composable Storefront 4.x / 5.x / 6.x / 2211.x。
