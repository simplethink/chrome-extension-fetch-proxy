/**
 * Chrome Extension Fetch Proxy
 * A library for handling cross-origin fetch requests in Chrome extensions
 * through background script communication
 */

class ChromeExtensionFetchProxy {
  /**
   * Create a ChromeExtensionFetchProxy instance
   * @param {Object} options - Configuration options
   * @param {string} [options.messageType='SANDBOX_FETCH'] - Message type for communication
   * @param {number} [options.timeout=10000] - Request timeout in milliseconds
   * @param {boolean} [options.debug=false] - Enable debug logging
   */
  constructor(options = {}) {
    this.messageType = options.messageType || 'SANDBOX_FETCH';
    this.timeout = options.timeout || 10000;
    this.debug = options.debug || false;
  }

  /**
   * Send fetch request from content script to background script
   * @param {string} url - Request URL
   * @param {Object} options - Fetch options
   * @returns {Promise} Response data
   */
  async sendFetchRequestToBackground(url, options = {}) {
    return new Promise((resolve, reject) => {
      if (this.debug) {
        console.log('Sending fetch request to background:', { url, options });
      }

      // Set timeout
      const timeoutId = setTimeout(() => {
        reject(new Error('Request timeout'));
      }, this.timeout);

      // Check if chrome.runtime is available
      if (typeof chrome === 'undefined' || !chrome.runtime) {
        clearTimeout(timeoutId);
        reject(new Error('Chrome runtime API not available'));
        return;
      }

      chrome.runtime.sendMessage({
        type: this.messageType,
        url: url,
        options: options
      }, (response) => {
        clearTimeout(timeoutId);
        
        if (chrome.runtime.lastError) {
          if (this.debug) {
            console.error('Communication error with background:', chrome.runtime.lastError);
          }
          reject(chrome.runtime.lastError);
        } else {
          if (this.debug) {
            console.log('Received response from background:', response);
          }
          if (response && response.error) {
            reject(new Error(response.error));
          } else {
            resolve(response);
          }
        }
      });
    });
  }

  /**
   * Create background message handler
   * @param {Function} customHandler - Custom handler function (optional)
   * @returns {Function} Message handler function
   */
  createBackgroundMessageHandler(customHandler) {
    return (message, sender, sendResponse) => {
      if (message.type === this.messageType) {
        if (this.debug) {
          console.log('Background processing fetch request:', message);
        }

        // Support custom handler
        if (customHandler) {
          return customHandler(message, sender, sendResponse);
        }

        // Default processing logic
        fetch(message.url, message.options)
          .then(async response => {
            const responseData = {
              status: response.status,
              headers: {}
            };
            
            // Copy response headers
            for (let [key, value] of response.headers.entries()) {
              responseData.headers[key] = value;
            }
            
            const clonedResponse = response.clone();

            // Try to parse JSON, fallback to text
            try {
              responseData.data = await response.json();
            } catch (e) {
              responseData.data = await clonedResponse.text();
            }
            
            if (this.debug) {
              console.log('Background fetch completed, returning response:', responseData);
            }
            sendResponse(responseData);
          })
          .catch(error => {
            if (this.debug) {
              console.error('Background fetch error:', error);
            }
            sendResponse({ error: error.message });
          });
        return true; // Keep message channel open for async response
      }
      
      return false;
    };
  }

  /**
   * Register background message listener
   * @param {Function} customHandler - Custom handler function (optional)
   */
  registerBackgroundListener(customHandler) {
    if (typeof chrome !== 'undefined' && chrome.runtime) {
      chrome.runtime.onMessage.addListener(
        this.createBackgroundMessageHandler(customHandler)
      );
    } else {
      console.warn('Chrome runtime API not available');
    }
  }

  /**
   * Unregister background message listener
   */
  unregisterBackgroundListener() {
    if (typeof chrome !== 'undefined' && chrome.runtime) {
      chrome.runtime.onMessage.removeListener(
        this.createBackgroundMessageHandler()
      );
    }
  }
}

// Export for different environments
if (typeof module !== 'undefined' && module.exports) {
  module.exports = ChromeExtensionFetchProxy;
} else if (typeof window !== 'undefined') {
  window.ChromeExtensionFetchProxy = ChromeExtensionFetchProxy;
}

// Default export for ES modules
export default ChromeExtensionFetchProxy;