#!/bin/bash

# GitHub 发布脚本

echo "=== Chrome Extension Fetch Proxy GitHub 发布脚本 ==="
echo

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi

# 检查Git状态
echo "🔍 检查Git状态..."
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ 当前目录不是Git仓库"
    echo "正在初始化Git仓库..."
    git init
    git add .
    git commit -m "Initial commit: Chrome Extension Fetch Proxy v1.0.0"
fi

# 检查是否有未提交的更改
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  检测到未提交的更改"
    echo "正在提交所有更改..."
    git add .
    git commit -m "Update: Prepare for GitHub release"
fi

echo "✅ Git状态检查完成"

# 获取项目信息
PROJECT_NAME="chrome-extension-fetch-proxy"
CURRENT_VERSION=$(node -p "require('./package.json').version")

echo
echo "📦 项目信息:"
echo "   名称: $PROJECT_NAME"
echo "   版本: $CURRENT_VERSION"

echo
echo "📋 发布前检查清单:"
echo "1. [ ] 已在GitHub上创建仓库"
echo "2. [ ] 仓库名为: $PROJECT_NAME"
echo "3. [ ] 选择了合适的可见性（Public/Private）"
echo "4. [ ] 复制了仓库的HTTPS或SSH URL"

echo
echo "💡 请按以下步骤操作:"

echo
echo "第一步：在GitHub上创建仓库"
echo "================================"
echo "1. 访问 https://github.com/new"
echo "2. Repository name: $PROJECT_NAME"
echo "3. Description: A Chrome extension fetch proxy library for handling cross-origin requests through background scripts"
echo "4. 选择 Public（推荐）或 Private"
echo "5. 不要初始化README、.gitignore或license（我们已经有这些文件）"
echo "6. 点击 'Create repository'"

echo
echo "第二步：获取仓库URL"
echo "==================="
echo "创建完成后，复制仓库的URL:"
echo "- HTTPS: https://github.com/YOUR_USERNAME/$PROJECT_NAME.git"
echo "- SSH: git@github.com:YOUR_USERNAME/$PROJECT_NAME.git"

echo
read -p "请输入你的GitHub用户名: " GITHUB_USERNAME
read -p "请选择URL类型 (1=HTTPS, 2=SSH): " URL_TYPE

if [ "$URL_TYPE" = "1" ]; then
    REPO_URL="https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git"
else
    REPO_URL="git@github.com:$GITHUB_USERNAME/$PROJECT_NAME.git"
fi

echo
echo "第三步：关联并推送代码"
echo "====================="
echo "正在关联远程仓库..."

# 添加远程仓库
git remote add origin $REPO_URL 2>/dev/null || git remote set-url origin $REPO_URL

echo "正在推送代码到GitHub..."
git push -u origin master

if [ $? -eq 0 ]; then
    echo "✅ 代码推送成功！"
    
    echo
    echo "第四步：创建Release"
    echo "=================="
    echo "1. 访问: https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/releases/new"
    echo "2. Tag version: v$CURRENT_VERSION"
    echo "3. Release title: v$CURRENT_VERSION"
    echo "4. 描述内容参考:"
    echo
    cat << EOF
## What's Changed

🚀 **Initial Release v$CURRENT_VERSION**

### Features
- Core fetch proxy functionality for Chrome extensions
- Support for content script to background script communication
- Cross-origin request handling through background scripts
- Multiple build formats (UMD, CommonJS, ES Module)
- TypeScript type definitions
- Comprehensive error handling and timeout control

### Installation
\`\`\`bash
npm install chrome-extension-fetch-proxy
\`\`\`

### Usage
\`\`\`javascript
import ChromeExtensionFetchProxy from 'chrome-extension-fetch-proxy';

const fetchProxy = new ChromeExtensionFetchProxy({
  debug: true,
  timeout: 10000
});

const response = await fetchProxy.sendFetchRequestToBackground(
  'https://api.example.com/data',
  { method: 'GET' }
);
\`\`\`

### Documentation
- [Main README](https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/blob/master/README.md)
- [Usage Guide](https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/blob/master/USAGE_GUIDE.md)
- [API Documentation](https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/blob/master/src/index.d.ts)

### Links
- [npm Package](https://www.npmjs.com/package/chrome-extension-fetch-proxy)
- [Report Issues](https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/issues)

---

Published with ❤️ using automated release script
EOF

    echo
    echo "🎉 发布完成！"
    echo "仓库地址: https://github.com/$GITHUB_USERNAME/$PROJECT_NAME"
    echo "npm包: https://www.npmjs.com/package/chrome-extension-fetch-proxy"
    
else
    echo "❌ 代码推送失败"
    echo "请检查:"
    echo "1. 网络连接"
    echo "2. GitHub用户名是否正确"
    echo "3. SSH密钥配置（如果使用SSH）"
    echo "4. 是否有仓库推送权限"
fi