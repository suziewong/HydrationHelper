#!/usr/bin/env python3
"""
测试喝水提醒应用的通知功能
"""

import subprocess
import time

print("=" * 60)
print("喝水提醒 - 通知调试工具")
print("=" * 60)

# 检查应用是否在通知设置中
print("\n1️⃣ 检查应用是否在通知列表中...")
result = subprocess.run(
    [
        "osascript",
        "-e",
        'tell application "System Events" to get name of every process whose background only is false',
    ],
    capture_output=True,
    text=True,
)

if "喝水提醒" in result.stdout:
    print("✓ 应用正在运行")
else:
    print("✗ 应用未运行")
    print("  正在启动应用...")
    subprocess.Popen(["/Applications/喝水提醒.app/Contents/MacOS/喝水提醒"])
    time.sleep(2)

# 测试应用发送通知
print("\n2️⃣ 测试应用通知功能...")
script = """
tell application "喝水提醒" to activate
delay 1
tell application "System Events"
    tell process "喝水提醒"
        click menu bar item "💧" of menu bar 1
        delay 0.5
    end tell
end tell
"""

print("提示：请在应用中点击'开始'按钮启动定时器")
print("定时器倒计时结束后应该会收到通知")
print("\n⚠️ 如果还是没有通知，请检查：")
print("   1. 系统设置 > 通知与专注模式 > 喝水提醒")
print("   2. 确保'允许通知'已开启")
print("   3. 确保'提醒样式'设置为'横幅'或'提醒'")

# 查看最近的系统日志
print("\n3️⃣ 查看最近的系统日志...")
print("运行以下命令查看应用日志：")
print(
    "  log show --predicate 'processImagePath contains \"喝水提醒\"' --last 5m --style compact"
)
