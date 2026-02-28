# GitHub 手动发布指南

## 当前状态

✅ **本地准备已完成**
- Git 仓库已初始化
- 所有文件已提交
- 版本：v1.0.0
- 分支：master

## 手动发布步骤

### 第一步：在 GitHub 上创建仓库

1. 访问 [GitHub 新建仓库页面](https://github.com/new)
2. 填写以下信息：
   - **Repository name**: `chrome-extension-fetch-proxy`
   - **Description**: `A Chrome extension fetch proxy library for handling cross-origin requests through background scripts`
   - **Visibility**: Public（推荐）
   - **不要**勾选 "Initialize this repository with a README"
   - **不要**添加 `.gitignore` 或 `license`（我们已经有这些文件）

3. 点击 "Create repository"

### 第二步：获取仓库URL

创建完成后，你会看到类似这样的页面，复制 HTTPS URL：
```
https://github.com/YOUR_USERNAME/chrome-extension-fetch-proxy.git
```

### 第三步：关联远程仓库

在终端中执行以下命令（将 YOUR_USERNAME 替换为你的实际用户名）：

```bash
cd /Users/qihao/Documents/workspace/emt/chrome-extension-fetch-proxy

# 添加远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/chrome-extension-fetch-proxy.git

# 推送代码
git push -u origin master
```

### 第四步：创建 Release

1. 访问你的仓库 releases 页面：
   `https://github.com/YOUR_USERNAME/chrome-extension-fetch-proxy/releases/new`

2. 填写发布信息：
   - **Tag version**: `v1.0.0`
   - **Release title**: `v1.0.0 - Initial Release`
   - **Description** 使用以下模板：

```
## What's Changed

🚀 **Initial Release v1.0.0**

### Features
- Core fetch proxy functionality for Chrome extensions
- Support for content script to background script communication
- Cross-origin request handling through background scripts
- Multiple build formats (UMD, CommonJS, ES Module)
- TypeScript type definitions
- Comprehensive error handling and timeout control

### Installation
```bash
npm install chrome-extension-fetch-proxy
```

### Usage
```javascript
import ChromeExtensionFetchProxy from 'chrome-extension-fetch-proxy';

const fetchProxy = new ChromeExtensionFetchProxy({
  debug: true,
  timeout: 10000
});

const response = await fetchProxy.sendFetchRequestToBackground(
  'https://api.example.com/data',
  { method: 'GET' }
);
```

### Documentation
- [Main README](https://github.com/YOUR_USERNAME/chrome-extension-fetch-proxy/blob/master/README.md)
- [Usage Guide](https://github.com/YOUR_USERNAME/chrome-extension-fetch-proxy/blob/master/USAGE_GUIDE.md)
- [API Documentation](https://github.com/YOUR_USERNAME/chrome-extension-fetch-proxy/blob/master/src/index.d.ts)

### Links
- [npm Package](https://www.npmjs.com/package/chrome-extension-fetch-proxy)
- [Report Issues](https://github.com/YOUR_USERNAME/chrome-extension-fetch-proxy/issues)

---

Published with ❤️ using automated release script
```

3. 点击 "Publish release"

## 验证发布

发布完成后，你可以通过以下链接验证：

- 仓库主页：`https://github.com/YOUR_USERNAME/chrome-extension-fetch-proxy`
- README 显示：应该能看到完整的文档
- 代码浏览：所有源码应该可见
- Release 页面：应该显示 v1.0.0

## 后续维护

### 推送更新
```bash
# 添加更改
git add .

# 提交更改
git commit -m "fix: some bug fix"

# 推送到GitHub
git push origin master
```

### 创建新版本
```bash
# 更新版本号
npm version patch  # 或 minor/major

# 推送标签和代码
git push origin master --tags
```

## 常见问题

### Q: 推送时提示权限错误
A: 确保使用了正确的用户名，或者配置 GitHub SSH 密钥

### Q: 如何修改仓库设置
A: 在仓库页面点击 "Settings" 进行修改

### Q: 如何添加协作者
A: 在仓库 Settings → Collaborators 中添加

---
🎉 **发布完成后，记得回来告诉我，我可以帮你做进一步的配置！**
```