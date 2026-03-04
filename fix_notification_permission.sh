#!/bin/bash

echo "=========================================="
echo "喝水提醒 - 通知权限修复脚本"
echo "=========================================="
echo ""

# 1. 停止应用
echo "1️⃣ 停止应用..."
killall "喝水提醒" 2>/dev/null || echo "   应用未运行"

# 2. 修复 Info.plist 文件
echo "2️⃣ 修复 Info.plist 文件..."

# 备份原始 Info.plist
cp /Applications/喝水提醒.app/Contents/Info.plist /Applications/喝水提醒.app/Contents/Info.plist.bak

# 添加 NSUserNotificationUsageDescription 键
/usr/libexec/PlistBuddy -c "Add :NSUserNotificationUsageDescription string '喝水提醒需要发送通知来提醒您定期喝水，保持身体水分充足。'" /Applications/喝水提醒.app/Contents/Info.plist

if [ $? -eq 0 ]; then
    echo "   ✅ 已成功添加通知权限描述"
else
    echo "   ❌ 添加通知权限描述失败"
    exit 1
fi

# 3. 重启应用
echo ""
echo "3️⃣ 启动应用..."
/Applications/喝水提醒.app/Contents/MacOS/喝水提醒 &

sleep 3

echo ""
echo "=========================================="
echo "修复完成！"
echo "=========================================="
echo ""
echo "现在请执行以下操作："
echo "1. 点击菜单栏右上角的 💧 图标"
echo "2. 点击 '测试通知' 按钮"
echo "3. 检查系统设置 > 通知与专注模式 > 喝水提醒"
echo "   确保 '允许通知' 已开启，'提醒样式' 设置为 '横幅'"
echo ""
echo "=========================================="
