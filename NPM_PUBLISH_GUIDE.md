# npm 发布完整指南

## 当前状态

✅ **准备工作已完成**
- 项目结构完整
- 代码测试通过
- 构建产物生成
- Git 仓库初始化
- npm 账户登录成功

❌ **发布受阻原因**
npm 要求启用两步验证（2FA）或使用细粒度访问令牌才能发布包。

## 解决方案

### 方案一：启用 npm 两步验证（推荐）

1. **登录 npm 网站**
   - 访问 https://www.npmjs.com
   - 登录你的账户（peter77）

2. **启用 2FA**
   - 进入 Settings → Two-Factor Authentication
   - 选择 "Authenticator App" 方式（更安全）
   - 使用 Google Authenticator、Authy 等应用扫描二维码
   - 保存恢复代码
   - 完成设置

3. **重新发布**
   ```bash
   cd /Users/qihao/Documents/workspace/emt/chrome-extension-fetch-proxy
   npm publish
   ```
   系统会提示输入 2FA 验证码

### 方案二：创建细粒度访问令牌

1. **创建令牌**
   - 登录 npmjs.com
   - 进入 Settings → Access Tokens
   - 点击 "Generate New Token" → "Granular Access Token"
   - 设置令牌名称（如：publish-token）
   - 选择作用域：`chrome-extension-fetch-proxy`
   - 选择权限：勾选 "Publish"
   - 生成令牌并复制

2. **使用令牌发布**
   ```bash
   cd /Users/qihao/Documents/workspace/emt/chrome-extension-fetch-proxy
   npm config set //registry.npmjs.org/:_authToken YOUR_TOKEN_HERE
   npm publish
   ```

## 发布后操作

### 1. 验证发布成功
```bash
# 检查包信息
npm view chrome-extension-fetch-proxy

# 安装测试
mkdir test-install
cd test-install
npm init -y
npm install chrome-extension-fetch-proxy
```

### 2. Git 推送到远程仓库
```bash
# 添加远程仓库（需要先在 GitHub 创建仓库）
git remote add origin https://github.com/qihao/chrome-extension-fetch-proxy.git
git push -u origin master --tags
```

### 3. 创建 GitHub Release
1. 在 GitHub 仓库页面点击 "Releases"
2. 点击 "Draft a new release"
3. 选择刚推送的 tag
4. 填写发布说明
5. 发布

## 未来版本发布

使用我们提供的发布脚本：

```bash
cd /Users/qihao/Documents/workspace/emt/chrome-extension-fetch-proxy
./scripts/publish.sh
```

脚本会自动：
- 询问版本更新类型
- 运行测试
- 构建项目
- Git 提交和打标签
- 发布到 npm

## 常见问题

### Q: 发布时提示 403 Forbidden
A: 确保已启用 2FA 或使用有效的访问令牌

### Q: 包名已被占用
A: 我们检查过，`chrome-extension-fetch-proxy` 目前是可用的

### Q: 如何撤销发布
A: 
```bash
npm unpublish chrome-extension-fetch-proxy@1.0.0
```
注意：24小时后无法撤销

### Q: 如何更新已发布的版本
A: 更新版本号后重新发布：
```bash
npm version patch  # 补丁版本
# 或
npm version minor  # 次版本  
# 或
npm version major  # 主版本
npm publish
```

## 包信息

- **包名**: `chrome-extension-fetch-proxy`
- **当前版本**: `1.0.0`
- **描述**: Chrome 扩展 fetch 代理库
- **关键词**: chrome-extension, fetch, proxy, cross-origin
- **许可证**: MIT
- **作者**: Qihao

## 发布检查清单

- [ ] npm 账户已登录
- [ ] 已启用 2FA 或获得访问令牌
- [ ] 所有测试通过
- [ ] 构建产物生成正确
- [ ] package.json 配置正确
- [ ] README.md 文档完整
- [ ] Git 提交和标签已创建
- [ ] 发布成功验证

---
🎯 **准备好后，请按照上述方案启用 2FA 或获取访问令牌，然后重新运行 `npm publish`**