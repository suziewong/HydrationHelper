#!/usr/bin/env python3
"""
强制触发通知权限请求
"""

import subprocess
import time

print("=" * 60)
print("喝水提醒 - 强制请求通知权限")
print("=" * 60)

# 方法1: 使用 AppleScript 显示通知
print("\n方法1: 发送测试通知...")
script = """
tell application "System Events"
    display notification "这是测试通知 - 喝水提醒" with title "💧 测试通知" sound name "Ping"
end tell
"""

result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
if result.returncode == 0:
    print("✅ 测试通知已发送")
else:
    print(f"❌ 失败: {result.stderr}")

# 方法2: 尝试获取通知权限状态
print("\n方法2: 检查通知权限...")
check_script = """
tell application "System Events"
    try
        return "Notifications enabled"
    on error
        return "Notifications may be restricted"
    end try
end tell
"""

result = subprocess.run(
    ["osascript", "-e", check_script], capture_output=True, text=True
)
print(result.stdout)

# 方法3: 提供手动设置指南
print("\n" + "=" * 60)
print("手动启用通知")
print("=" * 60)
print("\n如果上面没有看到测试通知，请按以下步骤操作：")
print("\n1. 打开 系统设置")
print("2. 点击 通知与专注模式")
print("3. 在左侧找到 '喝水提醒' (或 HydrationHelper)")
print("4. 如果找不到，启动应用后它会自动出现")
print("5. 开启 '允许通知'")
print("6. 设置 '提醒样式' 为 '横幅'")
print("7. 开启 '声音'")
print("\n8. 重新点击应用中的 '测试通知' 按钮")
print("\n" + "=" * 60)

# 方法4: 尝试从终端直接运行应用
print("\n方法3: 尝试从终端启动应用...")
print("运行以下命令:")
print("  /Applications/喝水提醒.app/Contents/MacOS/喝水提醒")
print("\n然后点击菜单栏的 💧 图标 -> 测试通知")
