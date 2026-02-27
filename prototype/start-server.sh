#!/bin/bash

# 陌恋 App 原型服务器启动脚本

echo "🚀 启动陌恋 App 原型服务器..."
echo ""
echo "📱 可用页面："
echo "   - http://localhost:8000/index.html (主应用界面)"
echo "   - http://localhost:8000/publish.html (发布动态)"
echo "   - http://localhost:8000/note-edit.html (编辑笔记)"
echo ""
echo "💡 提示：在浏览器中打开开发者工具，切换到移动设备模式以获得最佳体验"
echo "   推荐设备：iPhone 15 Pro (393 x 852)"
echo ""
echo "⏹️  按 Ctrl+C 停止服务器"
echo ""

# 启动 Python HTTP 服务器
python3 -m http.server 8000
