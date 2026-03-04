#!/usr/bin/env python3
import subprocess
import time

print("测试通知权限...")

# 使用 osascript 发送测试通知
script = """
tell application "System Events"
    display notification "测试通知 - 喝水提醒" with title "💧 水分提醒" sound name "Ping"
end tell
"""

try:
    result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
    if result.returncode == 0:
        print("✓ 测试通知已发送")
    else:
        print(f"✗ 通知发送失败: {result.stderr}")
except Exception as e:
    print(f"✗ 错误: {e}")

print("\n检查 macOS 通知设置：")
print("请前往：系统设置 > 通知与专注模式")
print("找到 '喝水提醒' 并确保：")
print("  - 允许通知：开启")
print("  - 提醒样式：横幅")
