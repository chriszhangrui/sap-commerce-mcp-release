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

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# 自动定位匹配架构的二进制文件
SOURCE_BIN=""
if [ -f "$SCRIPT_DIR/bin/sap-commerce-mcp-macos-$ARCH" ]; then
  SOURCE_BIN="$SCRIPT_DIR/bin/sap-commerce-mcp-macos-$ARCH"
elif [ -f "$SCRIPT_DIR/sap-commerce-mcp-macos-$ARCH" ]; then
  SOURCE_BIN="$SCRIPT_DIR/sap-commerce-mcp-macos-$ARCH"
elif [ -f "$SCRIPT_DIR/bin/sap-commerce-mcp" ]; then
  SOURCE_BIN="$SCRIPT_DIR/bin/sap-commerce-mcp"
fi

if [ -z "$SOURCE_BIN" ] || [ ! -f "$SOURCE_BIN" ]; then
  echo -e "${RED}❌ 错误: 未找到适用于 macOS ($ARCH) 的独立执行文件！${NC}"
  echo -e "请确认 $SCRIPT_DIR/bin/ 目录下存在 sap-commerce-mcp 或 sap-commerce-mcp-macos-$ARCH。"
  exit 1
fi

# 2. 目标安装路径选择
TARGET_DIR="$HOME/bin"
mkdir -p "$TARGET_DIR"
TARGET_BIN="$TARGET_DIR/sap-commerce-mcp"

echo -e "📦 正在复制程序到: ${YELLOW}$TARGET_BIN${NC}..."
cp -f "$SOURCE_BIN" "$TARGET_BIN"

# 3. 赋权与清除 macOS Gatekeeper 隔离属性
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
