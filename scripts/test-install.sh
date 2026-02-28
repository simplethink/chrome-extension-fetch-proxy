#!/bin/bash

# 发布后测试安装脚本

echo "=== Chrome Extension Fetch Proxy 安装测试 ==="
echo

# 创建临时测试目录
TEST_DIR="/tmp/chrome-extension-fetch-proxy-test"
echo "📁 创建测试目录: $TEST_DIR"

rm -rf $TEST_DIR
mkdir -p $TEST_DIR
cd $TEST_DIR

# 初始化 npm 项目
echo "🔧 初始化测试项目..."
npm init -y > /dev/null

# 安装包
echo "📥 安装 chrome-extension-fetch-proxy..."
npm install chrome-extension-fetch-proxy

# 检查安装结果
if [ -d "node_modules/chrome-extension-fetch-proxy" ]; then
    echo "✅ 包安装成功"
    
    # 检查主要文件是否存在
    FILES_TO_CHECK=(
        "node_modules/chrome-extension-fetch-proxy/package.json"
        "node_modules/chrome-extension-fetch-proxy/dist/chrome-extension-fetch-proxy.js"
        "node_modules/chrome-extension-fetch-proxy/dist/chrome-extension-fetch-proxy.esm.js"
        "node_modules/chrome-extension-fetch-proxy/dist/chrome-extension-fetch-proxy.umd.js"
    )
    
    for file in "${FILES_TO_CHECK[@]}"; do
        if [ -f "$file" ]; then
            echo "✅ $file 存在"
        else
            echo "❌ $file 不存在"
        fi
    done
    
    # 创建测试文件
    echo "📝 创建测试文件..."
    cat > test.js << 'EOF'
const ChromeExtensionFetchProxy = require('chrome-extension-fetch-proxy');

console.log('=== 安装测试 ===');
console.log('ChromeExtensionFetchProxy 类型:', typeof ChromeExtensionFetchProxy);

const proxy = new ChromeExtensionFetchProxy({
    debug: true,
    timeout: 5000
});

console.log('实例创建成功');
console.log('配置:', {
    messageType: proxy.messageType,
    timeout: proxy.timeout,
    debug: proxy.debug
});

console.log('✅ 测试完成');
EOF

    # 运行测试
    echo "🏃 运行测试..."
    node test.js
    
else
    echo "❌ 包安装失败"
fi

# 清理
echo
echo "🧹 清理测试环境..."
cd /
rm -rf $TEST_DIR

echo "🏁 测试完成"