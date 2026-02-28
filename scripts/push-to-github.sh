#!/bin/bash

# 推送到GitHub的简化脚本

echo "=== 推送代码到GitHub ==="
echo

# 检查参数
if [ $# -eq 0 ]; then
    echo "用法: ./scripts/push-to-github.sh <your-github-username>"
    echo "例如: ./scripts/push-to-github.sh qihao"
    exit 1
fi

USERNAME=$1
REPO_NAME="chrome-extension-fetch-proxy"
REMOTE_URL="https://github.com/$USERNAME/$REPO_NAME.git"

echo "用户名: $USERNAME"
echo "仓库URL: $REMOTE_URL"
echo

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi

# 检查Git状态
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ 当前目录不是Git仓库"
    exit 1
fi

echo "🔍 检查是否有未提交的更改..."
if ! git diff-index --quiet HEAD --; then
    echo "📝 提交未跟踪的文件..."
    git add .
    git commit -m "Update: Sync with GitHub"
fi

echo "🔗 配置远程仓库..."
git remote remove origin 2>/dev/null
git remote add origin $REMOTE_URL

echo "🚀 推送代码到GitHub..."
git push -u origin master

if [ $? -eq 0 ]; then
    echo
    echo "🎉 推送成功！"
    echo "仓库地址: https://github.com/$USERNAME/$REPO_NAME"
    echo
    echo "下一步："
    echo "1. 访问上面的仓库地址确认代码已上传"
    echo "2. 创建第一个 Release (tag: v1.0.0)"
    echo "3. 在 Release 描述中说明这是初始版本"
else
    echo
    echo "❌ 推送失败"
    echo "可能的原因："
    echo "1. 用户名不正确"
    echo "2. 网络连接问题"
    echo "3. GitHub账户权限问题"
    echo
    echo "请检查后重试"
fi