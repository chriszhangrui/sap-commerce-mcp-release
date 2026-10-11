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

**SAP-Commerce-MCP** is an enterprise-grade Model Context Protocol (MCP) server that empowers AI assistants (**Claude Desktop, Cursor, Antigravity, VS Code Cline, SAP Joule**, etc.) to directly control, automate, scaffold, and self-heal **SAP Commerce Cloud** environments and **Composable Storefronts (Spartacus)**.

This repository provides pre-compiled, self-contained standalone binary distributions for **macOS (Apple Silicon / arm64)** and **Windows (x64)**. **Zero Python runtime or third-party dependencies required.**

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

### 1. Claude Desktop (Local stdio)
Add to your `claude_desktop_config.json`:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

**macOS Config:**
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
    }
  }
}
```

**Windows Config:**
```json
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "command": "C:\\Users\\<YOUR_USERNAME>\\bin\\sap-commerce-mcp.exe",
      "env": {
        "SAP_COMMERCE_URL": "https://localhost:9002",
        "SAP_COMMERCE_USER": "admin",
        "SAP_COMMERCE_KEY": "nimda"
      }
    }
  }
}
```

### 2. Cursor (Local stdio)
Go to **Cursor Settings** -> **Features** -> **MCP** -> **Add New MCP Server**:
- **Name**: `sap-commerce-mcp`
- **Type**: `command`
- **Command**:
  - macOS: `/Users/<YOUR_USERNAME>/bin/sap-commerce-mcp`
  - Windows: `C:\Users\<YOUR_USERNAME>\bin\sap-commerce-mcp.exe`
- Environment Variables:
  - `SAP_COMMERCE_URL`: `https://localhost:9002`
  - `SAP_COMMERCE_USER`: `admin`
  - `SAP_COMMERCE_KEY`: `nimda`

### 3. Remote / HTTP Mode (Joule, Remote Agent, Web Clients)
```json
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "url": "http://<YOUR_HOST_OR_IP>:8080/mcp",
      "transport": "streamable-http"
    }
  }
}
```

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

**SAP-Commerce-MCP** 是一款面向 SAP Commerce Cloud 与 Composable Storefront（Spartacus）的企业级智能体 MCP 服务。

本仓库提供针对 **macOS（Apple Silicon / arm64）** 与 **Windows（x64）** 平台预编译的**独立单文件二进制程序**，内部已集成全部依赖，**无需配置 Python 环境或第三方包，开箱即用**。

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

### 客户端配置示例

将配置写入您的 **Claude Desktop**、**Cursor** 或 **Antigravity** 中：

#### macOS:
```json
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "command": "/Users/<您的用户名>/bin/sap-commerce-mcp",
      "env": {
        "SAP_COMMERCE_URL": "https://localhost:9002",
        "SAP_COMMERCE_USER": "admin",
        "SAP_COMMERCE_KEY": "nimda"
      }
    }
  }
}
```

#### Windows:
```json
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "command": "C:\\Users\\<您的用户名>\\bin\\sap-commerce-mcp.exe",
      "env": {
        "SAP_COMMERCE_URL": "https://localhost:9002",
        "SAP_COMMERCE_USER": "admin",
        "SAP_COMMERCE_KEY": "nimda"
      }
    }
  }
}
```

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
