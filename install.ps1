# ==============================================================================
# SAP-Commerce-MCP Automated Installer (Windows x64)
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "      🚀 安装 SAP-Commerce-MCP 独立可执行程序 (Windows x64)" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan

# 目标安装路径 %USERPROFILE%\bin
$TargetDir = Join-Path $env:USERPROFILE "bin"
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
$TargetBin = Join-Path $TargetDir "sap-commerce-mcp.exe"

# 从 GitHub Release 下载最新 Windows x64 二进制（latest 自动指向最新版本）
$DownloadUrl = "https://github.com/chriszhangrui/sap-commerce-mcp-release/releases/latest/download/sap-commerce-mcp-windows-x64.exe"
Write-Host "⬇️  正在从 GitHub Release 下载最新二进制..." -ForegroundColor Yellow
Write-Host "    $DownloadUrl" -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $TargetBin -UseBasicParsing
} catch {
    Write-Host "❌ 下载失败。请检查网络，或手动从 Releases 页面下载 sap-commerce-mcp-windows-x64.exe。" -ForegroundColor Red
    Write-Host "    https://github.com/chriszhangrui/sap-commerce-mcp-release/releases/latest" -ForegroundColor Yellow
    Exit 1
}

# 解除 Windows SmartScreen / Web 下载标记
try {
    Unblock-File -Path $TargetBin -ErrorAction SilentlyContinue
} catch {}

# 添加到用户环境变量 PATH（如果尚未包含）
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$TargetDir*") {
    Write-Host "🔧 正在将 $TargetDir 添加到当前用户的 PATH 环境变量..." -ForegroundColor Cyan
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$TargetDir", "User")
}

Write-Host "✅ 安装成功！`n" -ForegroundColor Green

# 打印配置模板
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "👉 接下来：请根据您的使用场景配置 AI 客户端" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "💡 本程序支持两种运行模式：本地 stdio 管道模式 或 独立常驻 HTTP/SSE 微服务模式。`n" -ForegroundColor Yellow

Write-Host "🔹 【模式一：本地 stdio 进程管道（推荐桌面端使用）】" -ForegroundColor Green
Write-Host "无论您使用 Claude Desktop、Cursor、Antigravity 还是 VS Code Cline，" -ForegroundColor Gray
Write-Host "只需将以下 JSON 块加入您的 mcpServers 配置项中（客户端将按需自动拉起进程）：`n" -ForegroundColor Gray

$EscapedTargetBin = $TargetBin.Replace("\", "\\")

$ConfigJsonStdio = @"
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "command": "$EscapedTargetBin",
      "env": {
        "SAP_COMMERCE_URL": "https://localhost:9002",
        "SAP_COMMERCE_USER": "admin",
        "SAP_COMMERCE_KEY": "nimda"
      }
    }
  }
}
"@

Write-Host $ConfigJsonStdio -ForegroundColor White

Write-Host ""
Write-Host "----------------------------------------------------------------------" -ForegroundColor Cyan
Write-Host "🔹 【模式二：独立常驻 HTTP / SSE 微服务（推荐远程/容器/团队共享）】" -ForegroundColor Green
Write-Host "如果您希望将 MCP 作为独立的常驻后台微服务运行（例如供远程团队或 Web AI 调用）：`n" -ForegroundColor Gray
Write-Host " 1. PowerShell 启动服务（默认监听 8080 端口）：" -ForegroundColor Cyan
Write-Host '    $env:SAP_COMMERCE_URL="https://localhost:9002"' -ForegroundColor Yellow
Write-Host '    $env:SAP_COMMERCE_USER="admin"' -ForegroundColor Yellow
Write-Host '    $env:SAP_COMMERCE_KEY="nimda"' -ForegroundColor Yellow
Write-Host "    & '$TargetBin' --transport streamable-http --port 8080" -ForegroundColor Yellow
Write-Host ""
Write-Host "    • MCP 端点:     http://<IP>:8080/mcp (若用 --transport sse 则为 /sse)" -ForegroundColor Gray
Write-Host "    • 健康检查:     http://<IP>:8080/health`n" -ForegroundColor Gray
Write-Host " 2. AI 客户端配置 (通过 URL 直连，无需配置本地命令与密码)：" -ForegroundColor Cyan

$ConfigJsonHttp = @"
{
  "mcpServers": {
    "sap-commerce-mcp": {
      "url": "http://localhost:8080/mcp"
    }
  }
}
"@

Write-Host $ConfigJsonHttp -ForegroundColor White

Write-Host ""
Write-Host "----------------------------------------------------------------------" -ForegroundColor Cyan
Write-Host "📌 常见客户端配置文件位置：" -ForegroundColor Yellow
Write-Host " • Claude Desktop:  %APPDATA%\Claude\claude_desktop_config.json" -ForegroundColor Green
Write-Host " • Cursor / Cline:  Cursor Settings -> Features -> MCP" -ForegroundColor Green
Write-Host " • 快速自检命令:     & '$TargetBin' --version" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
