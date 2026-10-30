# 赛博小镇 - AI NPC对话系统

基于 [HelloAgents](https://github.com/datawhalechina/hello-agents) 框架的 AI 小镇模拟游戏，展示多智能体系统在游戏中的应用。

> 本项目源自《Hello-Agents》教材第 15 章配套案例（`code/chapter15/Helloagents-AI-Town`），
> 在原版基础上补充了本机部署所需的启动脚本、依赖修正与部署文档。
> 原项目采用 **CC BY-NC-SA 4.0** 许可，本仓库沿用该许可。

## 🎮 功能特性

- ✅ 3 个 AI NPC（张三、李四、王五），各有独立人设与说话风格
- ✅ 智能对话系统（自然语言，无预设选项）
- ✅ 记忆系统（短期工作记忆 + 长期情景记忆，Qdrant 向量库）
- ✅ 好感度系统（5 个等级，随对话演化）
- ✅ NPC 自主行为（闲逛、工作、喝咖啡）
- ✅ 完整的对话日志与好感度变更记录

## 🛠️ 技术栈

| 层 | 技术 |
|---|---|
| 游戏引擎 | Godot 4.5 |
| 后端 | FastAPI + Python 3.10+ |
| 智能体 | HelloAgents 0.2.9（每个 NPC = 一个 SimpleAgent） |
| 向量库 | Qdrant 1.20 |
| LLM | 任意 OpenAI 兼容服务（DeepSeek / ModelScope / Ollama / vLLM） |

## 🚀 快速开始

### 1. 安装依赖

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate            # Windows
pip install -r requirements.txt
pip install -r requirements.local.txt
```

### 2. 配置 LLM

```bash
copy .env.example .env
notepad .env
```

填入你的服务地址与密钥。支持三种写法，具体见 [.env.example](backend/.env.example)：

```ini
# DeepSeek
LLM_MODEL_ID=deepseek-chat
LLM_API_KEY=sk-xxx
LLM_BASE_URL=https://api.deepseek.com/v1

# 本地 Ollama（无需外网）
LLM_MODEL_ID=qwen2.5vl:7b
LLM_API_KEY=ollama
LLM_BASE_URL=http://127.0.0.1:11434/v1
OLLAMA_HOST=http://127.0.0.1:11434/v1   # 必须带 http:// 前缀
```

### 3. 启动

```bash
# 终端 1：后端（需先启动 Qdrant 与 Ollama）
cd backend
python -m uvicorn main:app --host 127.0.0.1 --port 8000

# 终端 2：游戏
godot --path helloagents-ai-town
```

Windows 下也可直接双击仓库自带的脚本：

- `启动后端.bat` —— 自动检查并拉起 Qdrant、Ollama，再启动 FastAPI
- `启动小镇.bat` —— 打开 Godot 游戏窗口

### 4. 操作

| 按键 | 功能 |
|---|---|
| `W A S D` | 移动角色 |
| `E` | 与附近 NPC 交互 |
| `Enter` | 发送消息 |
| `ESC` | 关闭对话框 |

后端 API 文档：<http://127.0.0.1:8000/docs>

## 📋 主要接口

| 方法 | 路径 | 说明 |
|---|---|---|
| POST | `/chat` | 与指定 NPC 对话 |
| GET | `/npcs` | NPC 列表 |
| GET | `/npcs/status` | NPC 当前自主行为对话 |
| GET | `/npcs/{name}/memories` | 查看记忆 |
| GET | `/affinities` | 查看所有好感度 |

## 📚 文档

- [本地部署说明](本地部署说明.md) —— 完整安装步骤、配置项、已知问题与修复记录
- [安装配置指南](SETUP_GUIDE.md) —— 原版教程
- [对话日志系统](DIALOGUE_LOG_GUIDE.md)
- [好感度系统](AFFINITY_SYSTEM_GUIDE.md)
- [记忆系统](MEMORY_SYSTEM_GUIDE.md)

## ⚠️ 本仓库相对原版的改动

1. `helloagents-ai-town/project.godot` 的主场景由失效 UID 改为路径 `res://scenes/main.tscn`
2. 新增 `backend/requirements.local.txt`：补齐 `hello-agents` 导入时必需的重依赖，并锁定 `qdrant-client==1.12.1`
3. 新增 `启动后端.bat` / `启动小镇.bat`，统一处理 `PYTHONUTF8`、`OLLAMA_HOST` 等环境变量
4. 新增 `本地部署说明.md`，记录踩坑与验证方法

## 📄 许可证

CC BY-NC-SA 4.0 —— 与原项目一致。转载或修改请保留署名并以相同方式共享，且不得用于商业用途。

原项目：<https://github.com/datawhalechina/hello-agents>