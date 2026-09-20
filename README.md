# SAP Commerce Cloud MCP Server (`SAP-Commerce-MCP`) — Distribution Release

[![Platform: macOS](https://img.shields.io/badge/Platform-macOS%20(Apple%20Silicon)-black.svg?logo=apple)]()
[![MCP Specification](https://img.shields.io/badge/MCP-2024--11--05-green.svg)](https://modelcontextprotocol.io/)
[![SAP Commerce Cloud](https://img.shields.io/badge/SAP%20Commerce%20Cloud-2211%20%7C%20CCv2-008FD3.svg)](https://help.sap.com/docs/SAP_COMMERCE_CLOUD)
[![Build](https://img.shields.io/badge/Build-Native%20Mach--O-blue.svg)]()

[English](README.md) | [中文说明](#-中文安装说明)

**SAP-Commerce-MCP** is an enterprise-grade Model Context Protocol (MCP) server that empowers AI assistants (**Claude Desktop, Cursor, Antigravity, VS Code Cline**, etc.) to directly control, automate, scaffold, and self-heal **SAP Commerce Cloud (Hybris)** environments and **Composable Storefronts (Spartacus)**.

This repository provides pre-compiled, self-contained standalone binary distributions for macOS. **No Python runtime or third-party dependencies required.**

---

## 🌟 Capabilities at a Glance (33 Built-in Tools)

- 🏗️ **Zero-to-One Greenfield Site Scaffolding**: Automated generation of `BaseSite`, `BaseStore`, `ProductCatalog`, CMS Catalogs, Sync Jobs, and OCC OAuth clients in seconds.
- 🌐 **External Storefront Ingestion**: Crawl existing e-commerce storefronts (Shopify, WooCommerce, Magento) and auto-generate ready-to-import Hybris ImpEx scripts.
- 🩺 **Headless Spartacus Doctor & Auto-Healing**: 12-point health check diagnosing CORS whitelist gaps, OCC URL regex mismatches, and automated remediation.
- 🏢 **B2B Organization Governance**: Automated setup and auditing of `B2BUnit` hierarchies, `B2BCostCenter`, `B2BBudget`, and multi-tier approval permissions.
- 🏷️ **Drools Promotion Engine Orchestration**: Code-free creation of spend thresholds, bundle rules (A+B+C), free gifts, and auto-publishing to Drools.
- ⚡ **Direct Hybris Runtime Control**: Safe execution of FlexibleSearch queries, transactional ImpEx imports, and live Groovy scripts.
- 🔍 **Solr Indexing & Platform Ops**: Real-time Solr reindexing, catalog synchronization (Staged to Online), and Region Cache eviction.

---

## 🚀 Quick Start for macOS

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
2. Copy `bin/sap-commerce-mcp` to your preferred directory (e.g. `~/bin/` or `~/Downloads/`):
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

### 1. Claude Desktop
Add the following to your `claude_desktop_config.json`:
* macOS Path: `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "command": "/Users/<YOUR_USERNAME>/bin/sap-commerce-mcp",
      "env": {
        "HAC_BASE_URL": "https://localhost:9002",
        "HAC_USER": "admin",
        "HAC_PASSWORD": "nimda"
      }
    }
  }
}
```

### 2. Cursor
Go to **Cursor Settings** -> **Features** -> **MCP** -> **Add New MCP Server**:
* **Name**: `sap-commerce-mcp`
* **Type**: `command`
* **Command**: `/Users/<YOUR_USERNAME>/bin/sap-commerce-mcp`
* Add Environment Variables:
  * `HAC_BASE_URL`: `https://localhost:9002`
  * `HAC_USER`: `admin`
  * `HAC_PASSWORD`: `nimda`

### 3. Antigravity
Add to your Antigravity MCP settings:
```json
{
  "sap-commerce-mcp": {
    "command": "/Users/<YOUR_USERNAME>/bin/sap-commerce-mcp",
    "env": {
      "HAC_BASE_URL": "https://localhost:9002",
      "HAC_USER": "admin",
      "HAC_PASSWORD": "nimda"
    }
  }
}
```

---

## 🔑 Environment Variables Reference

| Variable | Required | Default | Description |
| :--- | :---: | :--- | :--- |
| `HAC_BASE_URL` | **Yes** | `https://localhost:9002` | Target Hybris Administration Console (HAC) URL |
| `HAC_USER` | **Yes** | `admin` | HAC administrative username |
| `HAC_PASSWORD` | **Yes** | `nimda` | HAC administrative password |
| `HAC_VERIFY_SSL` | No | `false` | Verify HTTPS SSL certificate (set `false` for local self-signed certs) |

---

<br>

# 🇨🇳 中文安装说明

**SAP-Commerce-MCP** 是一款面向 SAP Commerce Cloud（Hybris）与 Composable Storefront（Spartacus）的企业级 MCP（Model Context Protocol）智能体服务。

本仓库提供针对 macOS（Apple Silicon）平台预编译的**独立单文件二进制程序**，内部已集成全部依赖，**无需配置 Python 环境或第三方包，开箱即用**。

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
        "HAC_BASE_URL": "https://localhost:9002",
        "HAC_USER": "admin",
        "HAC_PASSWORD": "nimda"
      }
    }
  }
}
```

---

## ❓ 常见问题 (FAQ)

**Q: 启动时提示 `"sap-commerce-mcp" 无法打开，因为无法验证开发者`？**  
A: 这是 macOS 下载外部二进制程序的 Gatekeeper 安全机制。请在终端执行以下命令解除隔离：
```bash
xattr -d com.apple.quarantine ~/bin/sap-commerce-mcp
```

**Q: 本版本支持哪些 SAP Commerce 版本？**  
A: 支持 SAP Commerce Cloud (CCL) 2211、2011 以及 CCv2 云端环境，兼容 Spartacus / Composable Storefront 4.x / 5.x / 6.x / 2211.x。

**Q: 试用授权与技术支持**  
A: 当前分发版本为 60 天评估试用版（有效期至 2026-11-19）。如需获取永久授权或申请定制支持，请联系作者：
* **Author**: Chris Zhang
* **Email**: `chris.zhang01@sap.com`
