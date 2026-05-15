#!/bin/bash

IDENTITY="Apple Distribution: guanghui fan (Z3FKF6BF5P)"
FRAMEWORKS_DIR="./build/frameworks/Release"

echo "开始签名frameworks..."

for framework in "$FRAMEWORKS_DIR"/*.xcframework; do
    if [ -d "$framework" ]; then
        echo "正在签名: $(basename "$framework")"
        codesign --sign "$IDENTITY" --force --deep --timestamp "$framework"
        if [ $? -eq 0 ]; then
            echo "✓ $(basename "$framework") 签名成功"
        else
            echo "✗ $(basename "$framework") 签名失败"
        fi
    fi
done

echo ""
echo "验证签名..."
for framework in "$FRAMEWORKS_DIR"/*.xcframework; do
    if [ -d "$framework" ]; then
        echo "验证: $(basename "$framework")"
        codesign --verify --deep --strict --verbose=2 "$framework"
    fi
done

echo ""
echo "签名完成！"
