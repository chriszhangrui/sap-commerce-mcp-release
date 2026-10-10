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
Write-Host "👉 接下来：请将以下配置填入您的 AI 客户端 (Claude / Cursor / Antigravity / Cline)" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan

$EscapedTargetBin = $TargetBin.Replace("\", "\\")

$ConfigJson = @"
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

Write-Host $ConfigJson -ForegroundColor White

Write-Host ""
Write-Host "----------------------------------------------------------------------" -ForegroundColor Cyan
Write-Host "📌 常见客户端配置文件位置：" -ForegroundColor Yellow
Write-Host " • Claude Desktop:  %APPDATA%\Claude\claude_desktop_config.json" -ForegroundColor Green
Write-Host " • Cursor / Cline:  Cursor Settings -> Features -> MCP" -ForegroundColor Green
Write-Host " • 快速自检命令:     & '$TargetBin' --version" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
