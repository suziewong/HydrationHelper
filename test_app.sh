#!/bin/bash

echo "=========================================="
echo "喝水提醒 - 通知测试脚本"
echo "=========================================="
echo ""

# Stop any existing instance
echo "1️⃣ 停止现有应用..."
killall "喝水提醒" 2>/dev/null || echo "   (应用未运行)"
sleep 1

# Launch app
echo "2️⃣ 启动应用..."
/Applications/喝水提醒.app/Contents/MacOS/喝水提醒 > /tmp/hydration_app.log 2>&1 &
APP_PID=$!

sleep 3

# Show if app is running
if ps -p $APP_PID > /dev/null; then
    echo "   ✅ 应用已启动 (PID: $APP_PID)"
else
    echo "   ❌ 应用启动失败"
    exit 1
fi

echo ""
echo "3️⃣ 查看应用日志..."
if [ -f /tmp/hydration_app.log ]; then
    cat /tmp/hydration_app.log
else
    echo "   (暂无日志)"
fi

echo ""
echo "4️⃣ 检查通知权限..."
# Check if app has notification permissions using tccutil
python3 << 'EOF'
import subprocess
import time

script = '''
tell application "System Events"
    tell process "System Events"
        set frontmost to true
    end tell
end tell
display dialog "请在弹出的系统提示中点击'允许'以启用通知。" buttons {"确定"} default button 1
'''

try:
    result = subprocess.run(['osascript', '-e', script], capture_output=True, text=True)
except:
    pass
EOF

echo ""
echo "=========================================="
echo "现在请执行以下操作："
echo "=========================================="
echo ""
echo "1. 点击菜单栏右上角的 💧 图标"
echo "2. 点击 '测试通知' 按钮"
echo ""
echo "应该会看到："
echo "  - 弹窗请求通知权限（第一次）→ 点击'允许'"
echo "  - 系统通知横幅显示"
echo ""
echo "如果没有看到："
echo "  - 打开终端查看实时日志："
echo "    tail -f /tmp/hydration_app.log"
echo ""
echo "  - 检查系统通知设置："
echo "    系统设置 > 通知与专注模式 > HydrationHelper"
echo ""
echo "按 Ctrl+C 停止监控"
echo "=========================================="

# Monitor logs
tail -f /tmp/hydration_app.log