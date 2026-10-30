@echo off
chcp 65001 >nul
title 赛博小镇 - 后端服务 (FastAPI + Ollama)
setlocal

set "ROOT=%~dp0"
set "QDRANT_DIR=D:\sem_workflow\qdrant"
set "OLLAMA_EXE=%LOCALAPPDATA%\Programs\Ollama\ollama.exe"

rem ---------- 环境变量（缺一不可） ----------
rem 中文日志/emoji 输出，避免 GBK 控制台 UnicodeEncodeError
set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"
rem 系统级 OLLAMA_HOST 是 "127.0.0.1:11434"（没有 http:// 前缀），
rem hello-agents 会把它当成 base_url 直接使用，导致 OpenAI client 报 Connection error
set "OLLAMA_HOST=http://127.0.0.1:11434/v1"
rem 沙箱/权限受限环境下的临时目录
set "TMP=D:\sem_workflow\scratch"
set "TEMP=%TMP%"

echo ============================================================
echo  赛博小镇后端启动器
echo ============================================================

echo [1/3] 检查 Qdrant 向量库 (6333) ...
powershell -NoProfile -Command "try { Invoke-WebRequest 'http://127.0.0.1:6333/collections' -TimeoutSec 2 -UseBasicParsing | Out-Null; Write-Host '      已运行' } catch { Write-Host '      启动中...'; Start-Process '%QDRANT_DIR%\qdrant.exe' -WorkingDirectory '%QDRANT_DIR%' -WindowStyle Hidden; Start-Sleep -Seconds 6 }"

echo [2/3] 检查 Ollama (11434) ...
powershell -NoProfile -Command "try { Invoke-WebRequest 'http://127.0.0.1:11434/api/tags' -TimeoutSec 2 -UseBasicParsing | Out-Null; Write-Host '      已运行' } catch { Write-Host '      启动中...'; Start-Process '%OLLAMA_EXE%' -ArgumentList 'serve' -WindowStyle Hidden; Start-Sleep -Seconds 6 }"

echo [3/3] 启动 FastAPI 后端 ...
echo.
echo    API 文档: http://127.0.0.1:8000/docs
echo    关闭此窗口即停止后端
echo.

cd /d "%ROOT%backend"
".venv\Scripts\python.exe" -m uvicorn main:app --host 127.0.0.1 --port 8000 --log-level info

echo.
echo 后端已停止。
pause