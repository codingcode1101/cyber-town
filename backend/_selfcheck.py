"""快速自检：LLM 调用 + 记忆管理器"""
import os
import traceback

from dotenv import load_dotenv

load_dotenv(os.path.join(os.path.dirname(__file__), ".env"))

print("LLM_BASE_URL =", os.getenv("LLM_BASE_URL"))
print("OLLAMA_HOST  =", os.getenv("OLLAMA_HOST"))

from hello_agents import HelloAgentsLLM  # noqa: E402

llm = HelloAgentsLLM()
print("provider =", llm.provider, "| base =", llm.base_url, "| model =", llm.model)
try:
    print("invoke ->", llm.invoke([{"role": "user", "content": "用一句话介绍你自己"}]))
except Exception:
    traceback.print_exc()

from hello_agents.memory import MemoryConfig, MemoryManager  # noqa: E402

d = os.path.join(os.path.dirname(__file__), "memory_data", "_probe")
os.makedirs(d, exist_ok=True)
try:
    cfg = MemoryConfig(
        storage_path=d,
        working_memory_capacity=10,
        working_memory_tokens=2000,
        max_capacity=100,
        importance_threshold=0.3,
        decay_factor=0.95,
    )
    mm = MemoryManager(
        config=cfg,
        user_id="probe",
        enable_working=True,
        enable_episodic=True,
        enable_semantic=False,
        enable_perceptual=False,
    )
    print("MemoryManager OK ->", type(mm).__name__)
except Exception:
    traceback.print_exc()