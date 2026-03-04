#!/bin/bash

echo "=========================================="
echo "喝水提醒 - 重新安装脚本"
echo "=========================================="
echo ""

# 1. 停止应用
echo "1️⃣ 停止应用..."
killall "喝水提醒" 2>/dev/null || echo "   应用未运行"

# 2. 删除旧应用
echo "2️⃣ 删除旧应用..."
if [ -d "/Applications/喝水提醒.app" ]; then
    echo "   删除 /Applications/喝水提醒.app"
    rm -rf "/Applications/喝水提醒.app"
    if [ $? -eq 0 ]; then
        echo "   ✅ 旧应用已删除"
    else
        echo "   ❌ 删除旧应用失败"
        echo "   请手动删除 /Applications/喝水提醒.app"
    fi
else
    echo "   旧应用不存在"
fi

# 3. 构建应用
echo ""
echo "3️⃣ 构建应用..."
cd "$(dirname "$0")"
xcodebuild -project HydrationHelper.xcodeproj -scheme HydrationHelper -configuration Debug build

if [ $? -eq 0 ]; then
    echo "   ✅ 应用构建成功"
else
    echo "   ❌ 应用构建失败"
    echo "   请检查构建错误信息"
    exit 1
fi

# 4. 安装应用
echo ""
echo "4️⃣ 安装应用..."
BUILD_PATH="/Users/zhengyangfei3/Library/Developer/Xcode/DerivedData/HydrationHelper-*/Build/Products/Debug/喝水提醒.app"

# 查找构建产物
APP_PATH=$(find "$HOME/Library/Developer/Xcode/DerivedData" -name "喝水提醒.app" -type d | grep -E "Build/Products/Debug" | head -1)

if [ -d "$APP_PATH" ]; then
    echo "   找到构建产物: $APP_PATH"
    echo "   复制到 /Applications/"
    cp -R "$APP_PATH" "/Applications/"
    
    if [ $? -eq 0 ]; then
        echo "   ✅ 应用安装成功"
    else
        echo "   ❌ 应用安装失败"
        echo "   请手动复制 $APP_PATH 到 /Applications/"
        exit 1
    fi
else
    echo "   ❌ 找不到构建产物"
    echo "   请检查 Xcode 构建路径"
    exit 1
fi

# 5. 启动应用
echo ""
echo "5️⃣ 启动应用..."
/Applications/喝水提醒.app/Contents/MacOS/喝水提醒 &

sleep 3

echo ""
echo "=========================================="
echo "重新安装完成！"
echo "=========================================="
echo ""
echo "现在请执行以下操作："
echo "1. 点击菜单栏右上角的 💧 图标"
echo "2. 点击 '测试通知' 按钮"
echo "3. 当系统弹出权限请求时，点击 '允许'"
echo "4. 检查系统设置 > 通知与专注模式 > 喝水提醒"
echo "   确保 '允许通知' 已开启，'提醒样式' 设置为 '横幅'"
echo ""
echo "=========================================="
