// Chrome Extension Fetch Proxy 使用示例

// 注意：这个示例只能在真实的Chrome扩展环境中运行
// 因为它依赖chrome.runtime API

const ChromeExtensionFetchProxy = require('./dist/chrome-extension-fetch-proxy.js');

// 1. Content Script 中的使用示例
function contentScriptExample() {
  const fetchProxy = new ChromeExtensionFetchProxy({
    debug: true,
    timeout: 10000
  });

  // 发送请求到background script
  fetchProxy.sendFetchRequestToBackground('https://httpbin.org/get', {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json'
    }
  })
  .then(response => {
    console.log('请求成功:', response);
  })
  .catch(error => {
    console.error('请求失败:', error);
  });
}

// 2. Background Script 中的使用示例
function backgroundScriptExample() {
  const fetchProxy = new ChromeExtensionFetchProxy({
    debug: true
  });

  // 注册消息监听器
  fetchProxy.registerBackgroundListener();
  
  // 或者使用自定义处理函数
  /*
  fetchProxy.registerBackgroundListener((message, sender, sendResponse) => {
    console.log('收到自定义消息:', message);
    // 自定义处理逻辑
    return true;
  });
  */
}

// 3. 测试函数（仅用于演示API结构）
function testApiStructure() {
  const fetchProxy = new ChromeExtensionFetchProxy({
    messageType: 'CUSTOM_FETCH',
    timeout: 5000,
    debug: true
  });

  console.log('Proxy实例创建成功');
  console.log('messageType:', fetchProxy.messageType);
  console.log('timeout:', fetchProxy.timeout);
  console.log('debug:', fetchProxy.debug);
}

// 运行测试
console.log('=== Chrome Extension Fetch Proxy 示例 ===');
testApiStructure();
console.log('\n注意：完整的功能测试需要在真实的Chrome扩展环境中进行');