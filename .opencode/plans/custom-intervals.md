# 自定义时间间隔功能实现计划

## 概述
将固定的 45/60/90 分钟间隔改为可自定义输入的时间间隔，支持 1-480 分钟范围内的任意值。

## 修改文件

### 1. ContentView.swift
**位置**: /Users/zhengyangfei3/code/HydrationHelper/HydrationHelper/ContentView.swift

**修改内容**:
- 将 `Picker` 替换为 `TextField` 用于输入任意分钟数
- 添加快捷按钮（1、5、15、30、60 分钟）
- 添加验证逻辑，限制范围 1-480 分钟

**具体修改**:
1. 替换 `intervalSettingsView` 中的 Picker 为 TextField + 快捷按钮
2. 添加 `validateAndSetInterval()` 方法验证输入值
3. 添加 `QuickIntervalButton` 组件用于快捷选择

### 2. TimerManager.swift
**位置**: /Users/zhengyangfei3/code/HydrationHelper/HydrationHelper/TimerManager.swift

**修改内容**:
- 修改 `setInterval(minutes:)` 方法，添加范围验证（1-480 分钟）
- 更新注释说明支持任意分钟数

## 预期结果
用户可以通过以下方式设置提醒间隔：
1. 在文本框中直接输入 1-480 之间的任意数字
2. 点击快捷按钮快速设置常用值（1、5、15、30、60 分钟）

## 测试步骤
1. 打开应用，检查是否可以输入自定义分钟数
2. 测试输入小于 1 的值，应自动变为 1
3. 测试输入大于 480 的值，应自动变为 480
4. 测试点击快捷按钮是否能正确设置间隔
5. 验证计时器是否按新设置的时间运行
