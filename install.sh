#!/usr/bin/env bash
set -e

# ==============================================================================
# SAP-Commerce-MCP Automated Installer (macOS Apple Silicon)
# ==============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================================${NC}"
echo -e "${GREEN}      🚀 安装 SAP-Commerce-MCP 独立可执行程序 (macOS)${NC}"
echo -e "${BLUE}======================================================================${NC}"

# 1. 操作系统与 CPU 架构检查
OS="$(uname -s)"
ARCH="$(uname -m)"
if [ "$OS" != "Darwin" ]; then
  echo -e "${RED}❌ 错误: 本安装脚本仅支持 macOS (Darwin)。当前检测到: $OS${NC}"
  echo -e "${YELLOW}👉 Windows 用户请在 PowerShell 中直接运行: .\\install.ps1${NC}"
  exit 1
fi

echo -e "🔍 检测到系统架构: ${YELLOW}macOS ($ARCH)${NC}"

# 仅支持 Apple Silicon (arm64)。Intel (x86_64) 暂无预编译二进制。
if [ "$ARCH" != "arm64" ]; then
  echo -e "${RED}❌ 错误: 当前仅提供 Apple Silicon (arm64) 预编译二进制，未提供 Intel (x86_64) 版本。${NC}"
  echo -e "${YELLOW}👉 检测到架构: $ARCH。请在 Apple Silicon (M1/M2/M3/M4) Mac 上安装。${NC}"
  exit 1
fi

# 2. 目标安装路径
TARGET_DIR="$HOME/bin"
mkdir -p "$TARGET_DIR"
TARGET_BIN="$TARGET_DIR/sap-commerce-mcp"

# 3. 从 GitHub Release 下载最新 arm64 二进制（latest 自动指向最新版本）
DOWNLOAD_URL="https://github.com/chriszhangrui/sap-commerce-mcp-release/releases/latest/download/sap-commerce-mcp-macos-arm64"
echo -e "⬇️  正在从 GitHub Release 下载最新二进制..."
echo -e "    ${YELLOW}$DOWNLOAD_URL${NC}"
if ! curl -fL --progress-bar -o "$TARGET_BIN" "$DOWNLOAD_URL"; then
  echo -e "${RED}❌ 下载失败。请检查网络，或手动从 Releases 页面下载 sap-commerce-mcp-macos-arm64。${NC}"
  echo -e "    https://github.com/chriszhangrui/sap-commerce-mcp-release/releases/latest"
  exit 1
fi

# 4. 赋权与清除 macOS Gatekeeper 隔离属性
echo -e "🛡️  配置系统执行权限并清除下载隔离标记 (quarantine)..."
chmod +x "$TARGET_BIN"
xattr -d com.apple.quarantine "$TARGET_BIN" 2>/dev/null || true
echo -e "✍️  正在执行本地签名以通过 macOS 内存完整性保护..."
codesign --force --deep --sign - "$TARGET_BIN" 2>/dev/null || true

echo -e "${GREEN}✅ 安装成功！${NC}\n"

# 4. 打印配置模板
echo -e "${BLUE}======================================================================${NC}"
echo -e "${GREEN}👉 接下来：请将以下配置填入您的 AI 客户端${NC}"
echo -e "${BLUE}======================================================================${NC}"
echo -e "无论您使用 ${YELLOW}Claude Desktop${NC}、${YELLOW}Cursor${NC}、${YELLOW}Antigravity${NC} 还是 ${YELLOW}VS Code Cline${NC}，"
echo -e "只需将以下 JSON 块加入您的 ${YELLOW}mcpServers${NC} 配置项中：\n"

cat << EOF
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "command": "$TARGET_BIN",
      "env": {
        "SAP_COMMERCE_URL": "https://localhost:9002",
        "SAP_COMMERCE_USER": "admin",
        "SAP_COMMERCE_KEY": "nimda"
      }
    }
  }
}
EOF

echo ""
echo -e "${BLUE}----------------------------------------------------------------------${NC}"
echo -e "📌 ${YELLOW}常见客户端配置文件位置：${NC}"
echo -e " • Claude Desktop:  ${GREEN}~/Library/Application Support/Claude/claude_desktop_config.json${NC}"
echo -e " • Cursor / Cline:  ${GREEN}Cursor Settings -> Features -> MCP${NC}"
echo -e " • 快速自检命令:     ${GREEN}$TARGET_BIN --version${NC} (或直接回车启动测试)"
echo -e "${BLUE}======================================================================${NC}"
