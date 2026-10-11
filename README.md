# SAP Commerce Cloud MCP Server (`SAP-Commerce-MCP`) — Distribution Release

[![Release: v3.1.0](https://img.shields.io/badge/Release-v3.1.0-blue.svg)](https://github.com/chriszhangrui/sap-commerce-mcp-release)
[![macOS Apple Silicon](https://img.shields.io/badge/macOS-Apple%20Silicon%20(arm64)-black.svg?logo=apple)]()
[![Windows](https://img.shields.io/badge/Windows-x64%20(.exe)-0078D6.svg?logo=windows)]()
[![MCP Specification](https://img.shields.io/badge/MCP-2024--11--05-green.svg)](https://modelcontextprotocol.io/)
[![Transports](https://img.shields.io/badge/Transports-stdio%20%7C%20streamable--http%20%7C%20sse-orange.svg)]()
[![SAP Commerce Cloud](https://img.shields.io/badge/SAP%20Commerce%20Cloud-2211%20%7C%20CCv2-008FD3.svg)](https://help.sap.com/docs/SAP_COMMERCE_CLOUD)
[![Build](https://img.shields.io/badge/Build-Native%20Mach--O%20%2F%20PE%20C%20Binary-blue.svg)]()

[English](#-english-guide) | [中文说明](#-中文安装与使用说明)

---

# 📖 English Guide

**SAP-Commerce-MCP** is an enterprise-grade Model Context Protocol (MCP) server that empowers AI assistants (**Claude Desktop, Cursor, Antigravity, VS Code Cline, SAP Joule**, etc.) to directly control, automate, scaffold, and self-heal **SAP Commerce Cloud** environments and **Composable Storefronts (Spartacus)**.

This repository provides pre-compiled, self-contained standalone binary distributions for **macOS (Apple Silicon / arm64)** and **Windows (x64)**. **Zero Python runtime or third-party dependencies required.**

---

## 🌟 Capabilities at a Glance (34+ Built-in Tools)

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
>   over HTTP (`SAP_COMMERCE_URL`); it never reads the Commerce installation directory.

---

<br>

# 🇨🇳 中文安装与使用说明

**SAP-Commerce-MCP** 是一款面向 SAP Commerce Cloud 与 Composable Storefront（Spartacus）的企业级智能体 MCP 服务。

本仓库提供针对 **macOS（Apple Silicon / arm64）** 与 **Windows（x64）** 平台预编译的**独立单文件二进制程序**，内部已集成全部依赖，**无需配置 Python 环境或第三方包，开箱即用**。

---

### 🌟 核心功能特性（v3.1.0）

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
- **服务发现**：`http://<IP>:8080/`

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
