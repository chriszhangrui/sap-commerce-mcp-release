# ==============================================================================
# SAP-Commerce-MCP Automated Installer (Windows x64)
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "      🚀 安装 SAP-Commerce-MCP 独立可执行程序 (Windows x64)" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SourceBin = Join-Path $ScriptDir "bin\sap-commerce-mcp.exe"

# 检查源文件，若无则检查同级目录下的 windows 二进制
if (-not (Test-Path $SourceBin)) {
    $AltBin = Join-Path $ScriptDir "sap-commerce-mcp-windows-x64.exe"
    if (Test-Path $AltBin) {
        $SourceBin = $AltBin
    } else {
        Write-Host "❌ 错误: 未找到 sap-commerce-mcp.exe 文件！请确保文件存在于 bin\ 目录或当前目录。" -ForegroundColor Red
        Exit 1
    }
}

# 目标安装路径 %USERPROFILE%\bin
$TargetDir = Join-Path $env:USERPROFILE "bin"
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
$TargetBin = Join-Path $TargetDir "sap-commerce-mcp.exe"

Write-Host "📦 正在复制程序到: $TargetBin..." -ForegroundColor Yellow
Copy-Item -Path $SourceBin -Destination $TargetBin -Force

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
