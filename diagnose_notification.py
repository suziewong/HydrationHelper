#!/usr/bin/env python3
"""
检查并修复通知权限问题
"""

import subprocess
import os

print("=" * 60)
print("喝水提醒 - 通知权限诊断")
print("=" * 60)

# 检查应用是否在运行
print("\n1️⃣ 检查应用状态...")
result = subprocess.run(["ps", "aux"], capture_output=True, text=True)
if "喝水提醒" in result.stdout or "HydrationHelper" in result.stdout:
    print("   ✅ 应用正在运行")
else:
    print("   ❌ 应用未运行")
    print("   正在启动...")
    subprocess.Popen(["/Applications/喝水提醒.app/Contents/MacOS/喝水提醒"])

# 尝试检查通知权限（使用 applescript）
print("\n2️⃣ 检查通知权限...")

script = """
tell application "System Events"
    try
        if exists application process "喝水提醒" then
            tell application "喝水提醒" to activate
        end if
    end try
end tell
"""

subprocess.run(["osascript", "-e", script])

# 尝试查看最近的通知
print("\n3️⃣ 查看控制台日志...")
print("运行以下命令查看实时日志：")
print("  streamlog processImagePath == '*喝水提醒*'")
print("")
print("或使用：")
print("  log stream --predicate 'processImagePath contains \"喝水提醒\"' --level info")

# 诊断建议
print("\n" + "=" * 60)
print("诊断结果")
print("=" * 60)
print("\n如果通知不工作，可能的原因：")
print("")
print("1. 应用名称包含中文字符")
print("   - 解决：修改 Bundle ID 和应用名称为英文")
print("")
print("2. 需要显式请求权限")
print("   - 解决：首次启动时系统会弹出权限提示")
print("")
print("3. 应用在访问模式（accessory）下运行")
print("   - 解决：可能需要短暂显示窗口以请求权限")
print("")
print("4. macOS 15.7 的通知系统可能需要更长的初始化时间")
print("   - 解决：等待应用启动几秒后再测试")
print("")
print("建议操作步骤：")
print("1. 打开应用（点击菜单栏 💧 图标）")
print("2. 点击'测试通知'按钮")
print("3. 如果系统弹出权限请求，点击'允许'")
print("4. 如果没有弹出，前往：系统设置 > 通知与专注模式")
print("   查找 'HydrationHelper' 或 'com.example.HydrationHelper'")
print("=" * 60)
