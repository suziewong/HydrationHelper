#!/bin/bash

echo "=========================================="
echo "喝水提醒 - 通知权限手动设置助手"
echo "=========================================="
echo ""

# 1. 停止应用
echo "1️⃣ 停止应用..."
killall "喝水提醒" 2>/dev/null || echo "   应用未运行"

# 2. 清除标志
echo "2️⃣ 清除权限标志..."
defaults delete com.example.HydrationHelper notificationPermissionRequested 2>/dev/null && echo "   ✅ 已清除" || echo "   无需清除"

# 3. 显示信息
echo ""
echo "3️⃣ 启动应用..."
/Applications/喝水提醒.app/Contents/MacOS/喝水提醒 &

sleep 3

echo ""
echo "=========================================="
echo "现在请执行以下操作："
echo "=========================================="
echo ""
echo "方法A: 查看菜单栏"
echo "  1. 点击菜单栏右上角的 💧 图标"
echo "  2. 点击 '测试通知' 按钮"
echo "  3. 如果系统弹出权限请求，点击'允许'"
echo ""
echo "方法B: 手动设置通知权限"
echo "  1. 打开 系统设置 > 通知与专注模式"
echo "  2. 在搜索框输入: HydrationHelper"
echo "  3. 找到后点击进入"
echo "  4. 开启 '允许通知'"
echo "  5. 设置 '提醒样式' 为 '横幅'"
echo "  6. 开启 '声音'"
echo ""
echo "方法C: 从终端查看应用日志"
echo "  运行: /Applications/喝水提醒.app/Contents/MacOS/喝水提醒"
echo "  观察终端输出是否有错误信息"
echo ""
echo "=========================================="
echo ""
echo "按 Ctrl+C 退出..."
echo ""

# 保持运行
wait