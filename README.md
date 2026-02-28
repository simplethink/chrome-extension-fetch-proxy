# Chrome Extension Fetch Proxy

[![npm version](https://badge.fury.io/js/chrome-extension-fetch-proxy.svg)](https://badge.fury.io/js/chrome-extension-fetch-proxy)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A lightweight library for handling cross-origin fetch requests in Chrome extensions through background script communication.

## Features

- 🔄 Seamless cross-origin request handling
- 🛡️ Built-in timeout and error handling
- 🔧 Flexible configuration options
- 📦 Multiple build formats (UMD, CommonJS, ES Modules)
- 📝 TypeScript support with full type definitions
- 🎯 Zero dependencies
- 🔍 Debug mode for development

## Installation

```bash
npm install chrome-extension-fetch-proxy
```

## Quick Start

### 1. Content Script Usage

```javascript
import ChromeExtensionFetchProxy from 'chrome-extension-fetch-proxy';

// Initialize the proxy
const fetchProxy = new ChromeExtensionFetchProxy({
  debug: true, // Enable debug logging
  timeout: 10000 // 10 second timeout
});

// Send request to background script
try {
  const response = await fetchProxy.sendFetchRequestToBackground(
    'https://api.example.com/data',
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ key: 'value' })
    }
  );
  
  console.log('Response:', response);
} catch (error) {
  console.error('Request failed:', error);
}
```

### 2. Background Script Setup

```javascript
import ChromeExtensionFetchProxy from 'chrome-extension-fetch-proxy';

// Initialize the proxy
const fetchProxy = new ChromeExtensionFetchProxy({
  debug: true
});

// Register message listener (uses default handler)
fetchProxy.registerBackgroundListener();

// Or use custom handler
fetchProxy.registerBackgroundListener((message, sender, sendResponse) => {
  // Custom processing logic
  console.log('Custom handler received:', message);
  
  // Your custom fetch logic here
  fetch(message.url, message.options)
    .then(response => response.json())
    .then(data => sendResponse({ data }))
    .catch(error => sendResponse({ error: error.message }));
    
  return true; // Keep message channel open
});
```

## API Reference

### ChromeExtensionFetchProxy

#### Constructor

```javascript
new ChromeExtensionFetchProxy(options)
```

**Options:**
- `messageType` (string): Message type for communication (default: `'SANDBOX_FETCH'`)
- `timeout` (number): Request timeout in milliseconds (default: `10000`)
- `debug` (boolean): Enable debug logging (default: `false`)

#### Methods

##### sendFetchRequestToBackground(url, options)

Send a fetch request from content script to background script.

**Parameters:**
- `url` (string): Request URL
- `options` (Object): Fetch options (same as native fetch)

**Returns:** Promise resolving to response object

##### `createBackgroundMessageHandler(customHandler)`

Create a background message handler function.

**Parameters:**
- `customHandler` (Function): Custom handler function (optional)

**Returns:** Message handler function

##### `registerBackgroundListener(customHandler)`

Register background message listener.

**Parameters:**
- `customHandler` (Function): Custom handler function (optional)

##### `unregisterBackgroundListener()`

Unregister background message listener.

## Response Format

The library returns responses in the following format:

```javascript
{
  status: 200,           // HTTP status code
  headers: {             // Response headers
    'content-type': 'application/json',
    // ... other headers
  },
  data: {                // Response data (parsed JSON or text)
    // ... response data
  }
}
```

## Error Handling

The library provides comprehensive error handling:

```javascript
try {
  const response = await fetchProxy.sendFetchRequestToBackground(url, options);
  // Handle successful response
} catch (error) {
  if (error.message === 'Request timeout') {
    // Handle timeout
  } else if (error.message.includes('Chrome runtime API not available')) {
    // Handle missing Chrome API
  } else {
    // Handle other errors
  }
}
```

## TypeScript Support

Full TypeScript support is included:

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

## Browser Compatibility

- Chrome 42+
- Edge 79+
- Firefox 48+ (with manifest v3 limitations)

## Development

```bash
# Install dependencies
npm install

# Build the project
npm run build

# Development mode (watch files)
npm run dev

# Run tests
npm test
```

## Example Chrome Extension Manifest

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

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please [open an issue](https://github.com/your-username/chrome-extension-fetch-proxy/issues) on GitHub.