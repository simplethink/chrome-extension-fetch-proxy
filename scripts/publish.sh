#!/bin/bash

# Chrome Extension Fetch Proxy 发布脚本

echo "=== Chrome Extension Fetch Proxy 发布脚本 ==="
echo

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi

# 获取当前版本
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo "📦 当前版本: $CURRENT_VERSION"

# 询问新版本号
echo
echo "请选择版本更新类型:"
echo "1) Patch (补丁版本) - $CURRENT_VERSION -> $(npm version --silent patch --no-git-tag-version)"
echo "2) Minor (次版本) - $CURRENT_VERSION -> $(npm version --silent minor --no-git-tag-version)"  
echo "3) Major (主版本) - $CURRENT_VERSION -> $(npm version --silent major --no-git-tag-version)"
echo "4) 自定义版本"
echo

read -p "请选择 (1-4): " choice

case $choice in
    1)
        NEW_VERSION=$(npm version patch --no-git-tag-version)
        ;;
    2)
        NEW_VERSION=$(npm version minor --no-git-tag-version)
        ;;
    3)
        NEW_VERSION=$(npm version major --no-git-tag-version)
        ;;
    4)
        read -p "请输入新版本号 (格式: x.y.z): " CUSTOM_VERSION
        NEW_VERSION=$(npm version $CUSTOM_VERSION --no-git-tag-version)
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo "✅ 版本已更新为: $NEW_VERSION"

# 运行测试
echo
echo "🧪 运行测试..."
npm test
if [ $? -ne 0 ]; then
    echo "❌ 测试失败，发布中止"
    exit 1
fi
echo "✅ 测试通过"

# 构建项目
echo
echo "🔨 构建项目..."
npm run build
if [ $? -ne 0 ]; then
    echo "❌ 构建失败，发布中止"
    exit 1
fi
echo "✅ 构建完成"

# Git 提交
echo
echo "💾 提交到 Git..."
git add .
git commit -m "Release $NEW_VERSION"
git tag "v$NEW_VERSION"

echo "✅ Git 提交完成"

# 发布到 npm
echo
echo "🚀 发布到 npm..."
echo "注意: 如果启用了 2FA，系统会提示输入一次性密码"

npm publish

if [ $? -eq 0 ]; then
    echo
    echo "🎉 发布成功!"
    echo "📦 包名: chrome-extension-fetch-proxy@$NEW_VERSION"
    echo "🔗 访问地址: https://www.npmjs.com/package/chrome-extension-fetch-proxy"
else
    echo
    echo "❌ 发布失败"
    echo "请检查:"
    echo "1. 是否已启用 npm 两步验证"
    echo "2. 是否有发布权限"
    echo "3. 网络连接是否正常"
fi