@echo off
chcp 65001 >nul
title 赛博小镇 - 游戏客户端 (Godot 4.5)
setlocal

set "ROOT=%~dp0"
set "GODOT_EXE=D:\sem_workflow\godot45\Godot_v4.5-stable_win64.exe"

echo ============================================================
echo  赛博小镇客户端启动器
echo ============================================================

echo [1/2] 检查后端 (8000) ...
powershell -NoProfile -Command "try { Invoke-WebRequest 'http://127.0.0.1:8000/health' -TimeoutSec 2 -UseBasicParsing | Out-Null; Write-Host '      后端正常' } catch { Write-Host '      [警告] 后端未启动，请先运行 启动后端.bat' -ForegroundColor Yellow }"

echo [2/2] 启动 Godot 游戏 ...
echo.
echo    操作: WASD 移动 / E 与 NPC 对话 / Enter 发送 / ESC 关闭对话框
echo.

rem 如果在 DSH 等受限沙箱里运行，Godot 无法写入默认的 %APPDATA%，
rem 会因 "Could not create directory: user://logs" 崩溃。
rem 这种情况把下面一行取消注释即可：
rem set "APPDATA=D:\sem_workflow\godot_data"

start "" "%GODOT_EXE%" --path "%ROOT%helloagents-ai-town"