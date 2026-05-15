#!/bin/bash

# Flutter iOS Framework 构建和签名脚本
# 用途：将Flutter项目打包成可嵌入其他iOS应用的framework

set -e

# 配置
IDENTITY="Apple Distribution: guanghui fan (Z3FKF6BF5P)"
OUTPUT_DIR="./build/frameworks"
RELEASE_DIR="$OUTPUT_DIR/Release"

echo "=========================================="
echo "Flutter iOS Framework 构建和签名工具"
echo "=========================================="
echo ""

# 1. 清理旧的构建
echo "📦 步骤 1/4: 清理旧的构建..."
flutter clean
rm -rf "$OUTPUT_DIR"
echo "✓ 清理完成"
echo ""

# 2. 构建 Framework
echo "🔨 步骤 2/4: 构建 iOS Framework..."
flutter build ios-framework \
    --no-debug \
    --no-profile \
    --release \
    --output="$OUTPUT_DIR"

if [ $? -ne 0 ]; then
    echo "✗ 构建失败"
    exit 1
fi
echo "✓ 构建完成"
echo ""

# 3. 签名所有 Frameworks
echo "🔐 步骤 3/4: 签名 Frameworks..."
SIGNED_COUNT=0
FAILED_COUNT=0

for framework in "$RELEASE_DIR"/*.xcframework; do
    if [ -d "$framework" ]; then
        FRAMEWORK_NAME=$(basename "$framework")
        echo "  正在签名: $FRAMEWORK_NAME"
        
        if codesign --sign "$IDENTITY" --force --deep --timestamp "$framework" 2>/dev/null; then
            echo "  ✓ $FRAMEWORK_NAME 签名成功"
            ((SIGNED_COUNT++))
        else
            echo "  ✗ $FRAMEWORK_NAME 签名失败"
            ((FAILED_COUNT++))
        fi
    fi
done

echo ""
echo "签名统计: $SIGNED_COUNT 成功, $FAILED_COUNT 失败"
echo ""

# 4. 验证签名
echo "🔍 步骤 4/4: 验证签名..."
VERIFY_SUCCESS=0
VERIFY_FAILED=0

for framework in "$RELEASE_DIR"/*.xcframework; do
    if [ -d "$framework" ]; then
        FRAMEWORK_NAME=$(basename "$framework")
        if codesign --verify --deep --strict "$framework" 2>/dev/null; then
            ((VERIFY_SUCCESS++))
        else
            echo "  ✗ $FRAMEWORK_NAME 验证失败"
            ((VERIFY_FAILED++))
        fi
    fi
done

echo "验证统计: $VERIFY_SUCCESS 成功, $VERIFY_FAILED 失败"
echo ""

# 5. 生成摘要
echo "=========================================="
echo "📊 构建摘要"
echo "=========================================="
echo "输出目录: $RELEASE_DIR"
echo "总大小: $(du -sh "$RELEASE_DIR" | cut -f1)"
echo ""
echo "包含的 Frameworks:"
ls -1 "$RELEASE_DIR"/*.xcframework 2>/dev/null | while read framework; do
    echo "  - $(basename "$framework")"
done
echo ""

if [ $FAILED_COUNT -eq 0 ] && [ $VERIFY_FAILED -eq 0 ]; then
    echo "✅ 所有操作成功完成！"
    echo ""
    echo "📖 查看集成指南: $OUTPUT_DIR/INTEGRATION_GUIDE.md"
    exit 0
else
    echo "⚠️  部分操作失败，请检查错误信息"
    exit 1
fi
