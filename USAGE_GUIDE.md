# Chrome Extension Fetch Proxy 使用指南

## 概述

Chrome Extension Fetch Proxy 是一个专门用于 Chrome 扩展中处理跨域请求的库。它通过 background script 代理的方式解决 content script 中的 CORS 限制问题。

## 安装

```bash
npm install chrome-extension-fetch-proxy
```

## 核心概念

在 Chrome 扩展中，由于安全限制，content script 无法直接发起跨域请求。本库通过以下方式解决这个问题：

1. **Content Script**: 发起请求并转发到 background script
2. **Background Script**: 实际执行跨域请求并返回结果
3. **消息通信**: 使用 `chrome.runtime.sendMessage` 进行通信

## 完整使用示例

### 1. Manifest 配置

```json
{
  "manifest_version": 3,
  "name": "My Extension",
  "version": "1.0",
  "permissions": [
    "storage",
    "activeTab"
  ],
  "host_permissions": [
    "https://*/*"
  ],
  "background": {
    "service_worker": "background.js"
  },
  "content_scripts": [{
    "matches": ["<all_urls>"],
    "js": ["content.js"]
  }]
}
```

### 2. Content Script (content.js)

```javascript
import ChromeExtensionFetchProxy from 'chrome-extension-fetch-proxy';

// 初始化代理
const fetchProxy = new ChromeExtensionFetchProxy({
  debug: true,
  timeout: 10000
});

// 使用示例
async function fetchData() {
  try {
    const response = await fetchProxy.sendFetchRequestToBackground(
      'https://api.example.com/data',
      {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your-token'
        }
      }
    );
    
    console.log('请求成功:', response);
    return response;
  } catch (error) {
    console.error('请求失败:', error);
    throw error;
  }
}

// 在需要的地方调用
document.addEventListener('click', async (event) => {
  if (event.target.id === 'fetchButton') {
    const data = await fetchData();
    // 处理返回的数据
  }
});
```

### 3. Background Script (background.js)

```javascript
import ChromeExtensionFetchProxy from 'chrome-extension-fetch-proxy';

// 初始化代理
const fetchProxy = new ChromeExtensionFetchProxy({
  debug: true
});

// 注册消息监听器（使用默认处理逻辑）
fetchProxy.registerBackgroundListener();

// 或者使用自定义处理函数
/*
fetchProxy.registerBackgroundListener((message, sender, sendResponse) => {
  console.log('收到消息:', message);
  
  // 自定义处理逻辑
  if (message.type === 'SANDBOX_FETCH') {
    // 添加额外的请求头
    const customHeaders = {
      ...message.options.headers,
      'X-Custom-Header': 'custom-value'
    };
    
    fetch(message.url, {
      ...message.options,
      headers: customHeaders
    })
    .then(response => response.json())
    .then(data => sendResponse({ data }))
    .catch(error => sendResponse({ error: error.message }));
    
    return true; // 保持消息通道开放
  }
  
  return false;
});
*/
```

## API 详解

### ChromeExtensionFetchProxy 构造函数

```javascript
new ChromeExtensionFetchProxy(options)
```

**参数:**
- `options` (Object): 配置选项
  - `messageType` (string): 消息类型，默认 `'SANDBOX_FETCH'`
  - `timeout` (number): 超时时间（毫秒），默认 `10000`
  - `debug` (boolean): 是否开启调试模式，默认 `false`

### 方法

#### sendFetchRequestToBackground(url, options)

从 content script 发送请求到 background script。

**参数:**
- `url` (string): 请求地址
- `options` (Object): fetch 选项（与原生 fetch 相同）

**返回:** Promise

**示例:**
```javascript
const response = await fetchProxy.sendFetchRequestToBackground(
  'https://api.example.com/users',
  {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ name: 'John' })
  }
);
```

#### createBackgroundMessageHandler(customHandler)

创建 background 消息处理函数。

**参数:**
- `customHandler` (Function): 自定义处理函数（可选）

**返回:** Function

#### registerBackgroundListener(customHandler)

注册 background 消息监听器。

**参数:**
- `customHandler` (Function): 自定义处理函数（可选）

#### unregisterBackgroundListener()

注销 background 消息监听器。

## 响应格式

```javascript
{
  status: 200,           // HTTP 状态码
  headers: {             // 响应头
    'content-type': 'application/json',
    // ... 其他头信息
  },
  data: {                // 响应数据
    // ... 实际数据
  }
}
```

## 错误处理

```javascript
try {
  const response = await fetchProxy.sendFetchRequestToBackground(url, options);
  // 处理成功响应
} catch (error) {
  switch (error.message) {
    case 'Request timeout':
      // 处理超时
      break;
    case 'Chrome runtime API not available':
      // 处理 API 不可用
      break;
    default:
      // 处理其他错误
      break;
  }
}
```

## TypeScript 支持

```typescript
import ChromeExtensionFetchProxy, { FetchOptions, FetchResponse } from 'chrome-extension-fetch-proxy';

const fetchProxy = new ChromeExtensionFetchProxy();

const options: FetchOptions = {
  method: 'GET',
  headers: {
    'Authorization': 'Bearer token'
  }
};

const response: FetchResponse = await fetchProxy.sendFetchRequestToBackground(
  'https://api.example.com/data',
  options
);
```

## 最佳实践

1. **错误处理**: 始终使用 try-catch 包装异步调用
2. **超时设置**: 根据实际需求调整 timeout 值
3. **调试模式**: 开发阶段开启 debug 模式便于排查问题
4. **权限配置**: 确保 manifest.json 中配置了正确的 host_permissions
5. **安全性**: 不要在客户端存储敏感信息如 API 密钥

## 常见问题

### Q: 为什么在普通网页中无法使用？
A: 该库依赖 `chrome.runtime` API，只能在 Chrome 扩展环境中使用。

### Q: 如何处理认证？
A: 可以在 background script 中添加自定义处理逻辑来处理认证头。

### Q: 支持哪些 HTTP 方法？
A: 支持所有标准的 HTTP 方法（GET、POST、PUT、DELETE 等）。

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT