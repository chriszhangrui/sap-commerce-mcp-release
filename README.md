# SAP Commerce Cloud MCP Server (`SAP-Commerce-MCP`) — Distribution Release

[![Release: v3.1.0](https://img.shields.io/badge/Release-v3.1.0-blue.svg)](https://github.com/chriszhangrui/sap-commerce-mcp-release)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS%20(Apple%20Silicon)-black.svg?logo=apple)]()
[![MCP Specification](https://img.shields.io/badge/MCP-2024--11--05-green.svg)](https://modelcontextprotocol.io/)
[![Transports](https://img.shields.io/badge/Transports-stdio%20%7C%20streamable--http%20%7C%20sse-orange.svg)]()
[![SAP Commerce Cloud](https://img.shields.io/badge/SAP%20Commerce%20Cloud-2211%20%7C%20CCv2-008FD3.svg)](https://help.sap.com/docs/SAP_COMMERCE_CLOUD)
[![Build](https://img.shields.io/badge/Build-Native%20Mach--O-blue.svg)]()

[English](README.md) | [中文说明](#-中文安装与使用说明)

**SAP-Commerce-MCP** is an enterprise-grade Model Context Protocol (MCP) server that empowers AI assistants (**Claude Desktop, Cursor, Antigravity, VS Code Cline, SAP Joule**, etc.) to directly control, automate, scaffold, and self-heal **SAP Commerce Cloud (Hybris)** environments and **Composable Storefronts (Spartacus)**.

This repository provides pre-compiled, self-contained standalone binary distributions for macOS. **No Python runtime or third-party dependencies required.**

---

## 🌟 Capabilities at a Glance (34+ Built-in Tools)

- 🏗️ **Dual-Mode Greenfield Site Scaffolding (B2B & B2C)**: Automated generation of `BaseSite`, `BaseStore`, `ProductCatalog`, CMS Catalogs, Sync Jobs, and OCC OAuth clients for both B2B e-commerce and B2C brand direct-to-consumer stores.
- 📦 **CCv2 Enterprise Offline Release Packaging**: Automatically build and export complete, CAB-compliant CCv2 deployment bundles (ZIP) containing structured schema migration scripts, automated rollback plans, health verification probes, and enterprise change documentation.
- 🖼️ **Automated Product Media & Image Fetcher**: Discover, download, and bind high-resolution brand product images and media containers directly into Commerce catalogs via automated CDN/asset binding pipelines.
- 🌐 **External Storefront Ingestion & Crawling**: Ingest and structure external storefront catalogs (Shopify, WooCommerce, Magento, etc.) into ready-to-import SAP Commerce data scripts.
- 🩺 **Headless Spartacus Doctor & Auto-Healing**: 14-point deep health check diagnosing CORS whitelists, OCC URL regex mismatches, MyAccount navigation hierarchies, TabContainer child components, and B2B approval slots.
- 🏢 **B2B Organization Governance**: Automated setup and auditing of `B2BUnit` hierarchies, `B2BCostCenter`, `B2BBudget`, and multi-tier approval permissions.
- 🏷️ **Drools Promotion Engine Orchestration**: Code-free creation of spend thresholds, bundle promotions (A+B+C), free gift rules, and instant publishing into Drools rule bases.
- ⚡ **Commerce Platform Kernel Operations**: Transactional data queries, schema-driven data ingestion pipelines, and runtime execution via the Commerce Platform Kernel API.
- 🔍 **Solr Indexing & Platform Ops**: Real-time Solr reindexing, catalog synchronization (Staged to Online), and Region Cache eviction.

---

## 🚀 Running Modes

The compiled standalone binary natively supports **both** local process execution and standalone HTTP network microservice mode:

### Mode 1: Local `stdio` (Default)
Used by desktop AI tools (Claude Desktop, Cursor, Antigravity) communicating via standard input/output.
```bash
# Simply run the binary without arguments
./sap-commerce-mcp
```

### Mode 2: Network HTTP Service (`streamable-http` / `sse`)
Used for remote deployments, containers, team-shared services, or web clients like SAP Joule:
```bash
# Start Streamable HTTP server on port 8080 (MCP endpoint at /mcp)
./sap-commerce-mcp --transport streamable-http --port 8080

# Or using environment variables
MCP_HTTP=true PORT=8080 ./sap-commerce-mcp
```

Endpoints exposed in HTTP mode:
- `http://0.0.0.0:8080/mcp`: MCP Streamable HTTP protocol endpoint (JSON-RPC 2.0 / SSE stream)
- `http://0.0.0.0:8080/health`: Microservice health check (returns `{"name":"sap-commerce-mcp","status":"ok"}`)
- `http://0.0.0.0:8080/`: Service root discovery & endpoint index

---

## 💻 Quick Start for macOS

### Option 1: One-Click Automated Install (Recommended)

Run the following commands in your Terminal:

```bash
git clone https://github.com/chriszhangrui/sap-commerce-mcp-release.git ~/.sap-commerce-mcp-release
cd ~/.sap-commerce-mcp-release && ./install.sh
```

The script will automatically install the binary to `~/bin/sap-commerce-mcp`, grant execution permissions, clear the macOS quarantine attribute, and display the JSON snippet for your AI client.

---

### Option 2: Manual Installation

1. Clone or download this repository.
2. Copy `bin/sap-commerce-mcp` to your preferred directory (e.g. `~/bin/`):
   ```bash
   mkdir -p ~/bin
   cp bin/sap-commerce-mcp ~/bin/
   ```
3. Grant executable permissions and bypass macOS Gatekeeper quarantine:
   ```bash
   chmod +x ~/bin/sap-commerce-mcp
   xattr -d com.apple.quarantine ~/bin/sap-commerce-mcp 2>/dev/null || true
   ```

---

## ⚙️ AI Client Configuration

### 1. Claude Desktop (Local stdio)
Add to your `claude_desktop_config.json`:
* macOS Path: `~/Library/Application Support/Claude/claude_desktop_config.json`

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

### 2. Cursor (Local stdio)
Go to **Cursor Settings** -> **Features** -> **MCP** -> **Add New MCP Server**:
* **Name**: `sap-commerce-mcp`
* **Type**: `command`
* **Command**: `/Users/<YOUR_USERNAME>/bin/sap-commerce-mcp`
* Add Environment Variables:
  * `SAP_COMMERCE_URL`: `https://localhost:9002`
  * `SAP_COMMERCE_USER`: `admin`
  * `SAP_COMMERCE_KEY`: `nimda`

### 3. Remote / HTTP Mode (Joule, Remote Agent, Web Clients)
If you start `sap-commerce-mcp` as an HTTP service:
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

| Variable | Required | Default | Description |
| :--- | :---: | :--- | :--- |
| `SAP_COMMERCE_URL` | **Yes** | `https://localhost:9002` | SAP Commerce Cloud instance endpoint URL |
| `SAP_COMMERCE_USER` | **Yes** | `admin` | Commerce platform administrative username |
| `SAP_COMMERCE_KEY` | **Yes** | `nimda` | Commerce platform administrative credential |
| `SAP_COMMERCE_VERIFY_SSL` | No | `false` | Verify HTTPS SSL certificate (set `false` for local self-signed certs) |
| `MCP_TRANSPORT` | No | `stdio` | Transport protocol: `stdio`, `streamable-http`, or `sse` |
| `MCP_PORT` / `PORT` | No | `8080` | Port to listen on when running in HTTP mode |
| `MCP_HOST` | No | `0.0.0.0` | Host interface to bind when running in HTTP mode |

---

<br>

# 🇨🇳 中文安装与使用说明

**SAP-Commerce-MCP** 是一款面向 SAP Commerce Cloud（Hybris）与 Composable Storefront（Spartacus）的企业级智能体 MCP 服务。

本仓库提供针对 macOS（Apple Silicon）平台预编译的**独立单文件二进制程序**，内部已集成全部依赖，**无需配置 Python 环境或第三方包，开箱即用**。

---

### 🌟 核心功能特性（v3.1.0 新增）

1. **B2B / B2C 双模商城脚手架**：一键生成从底层数据模型、OCC 接口到 CMS 页面组件的全套配置。
2. **CCv2 离线补丁打包器**：全自动导出包含全套版本变更脚本、自动化回滚方案、健康探测探针及 CAB 审计文档的标准 CCv2 独立发布包（ZIP）。
3. **商品真图抓取与媒体绑定引擎**：自动化抓取品牌高清图并自动生成底层的全生命周期媒体资产绑定与映射逻辑。
4. **双传输运行模式**：同时支持本地极速 `stdio` 管道模式与网络微服务 `streamable-http` / `sse` 模式。
5. **Headless Spartacus Doctor 诊断增强**：覆盖 MyAccount 导航树、B2B 审批流槽位与 TabContainer 层级审计。

---

### 快速安装步骤

#### 第一步：克隆仓库并执行安装脚本
打开 Mac 终端执行：
```bash
git clone https://github.com/chriszhangrui/sap-commerce-mcp-release.git ~/.sap-commerce-mcp-release
cd ~/.sap-commerce-mcp-release && ./install.sh
```

#### 第二步：配置到 AI 工具
安装脚本会自动将程序放入 `~/bin/sap-commerce-mcp`，并输出以下 JSON 配置。将其复制并添加到您的 **Claude Desktop**、**Cursor** 或 **Antigravity** 的配置文件中即可：

```json
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "command": "/Users/<您的电脑用户名>/bin/sap-commerce-mcp",
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
# 启动 Streamable HTTP 服务（默认端口 8080）
~/bin/sap-commerce-mcp --transport streamable-http --port 8080

# 或使用环境变量启动
MCP_HTTP=true PORT=8080 ~/bin/sap-commerce-mcp
```

微服务提供以下标准端点：
- **MCP 端点**：`http://<IP>:8080/mcp`
- **健康检查**：`http://<IP>:8080/health`
- **服务发现**：`http://<IP>:8080/`

---

## ❓ 常见问题 (FAQ)

**Q: 启动时提示 `"sap-commerce-mcp" 无法打开，因为无法验证开发者`？**  
A: 这是 macOS 下载外部二进制程序的 Gatekeeper 安全机制。请在终端执行以下命令解除隔离：
```bash
xattr -d com.apple.quarantine ~/bin/sap-commerce-mcp
```

**Q: 本版本支持哪些 SAP Commerce 版本？**  
A: 支持 SAP Commerce Cloud (CCL) 2211、2011 以及 CCv2 云端环境，兼容 Spartacus / Composable Storefront 4.x / 5.x / 6.x / 2211.x。

