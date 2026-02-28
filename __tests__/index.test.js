/**
 * ChromeExtensionFetchProxy Tests
 */

import ChromeExtensionFetchProxy from '../src/index';

describe('ChromeExtensionFetchProxy', () => {
  let fetchProxy;
  
  beforeEach(() => {
    fetchProxy = new ChromeExtensionFetchProxy({ debug: false });
  });

  describe('constructor', () => {
    test('should create instance with default options', () => {
      expect(fetchProxy.messageType).toBe('SANDBOX_FETCH');
      expect(fetchProxy.timeout).toBe(10000);
      expect(fetchProxy.debug).toBe(false);
    });

    test('should create instance with custom options', () => {
      const customProxy = new ChromeExtensionFetchProxy({
        messageType: 'CUSTOM_FETCH',
        timeout: 5000,
        debug: true
      });
      
      expect(customProxy.messageType).toBe('CUSTOM_FETCH');
      expect(customProxy.timeout).toBe(5000);
      expect(customProxy.debug).toBe(true);
    });
  });

  describe('sendFetchRequestToBackground', () => {
    test('should reject when chrome.runtime is not available', async () => {
      global.chrome = undefined;
      
      await expect(
        fetchProxy.sendFetchRequestToBackground('https://example.com')
      ).rejects.toThrow('Chrome runtime API not available');
    });

    test('should handle chrome.runtime.lastError', async () => {
      global.chrome = {
        runtime: {
          sendMessage: jest.fn((message, callback) => {
            chrome.runtime.lastError = new Error('Connection failed');
            callback();
          }),
          lastError: null
        }
      };

      await expect(
        fetchProxy.sendFetchRequestToBackground('https://example.com')
      ).rejects.toThrow('Connection failed');
    });
  });

  describe('createBackgroundMessageHandler', () => {
    test('should return a function', () => {
      const handler = fetchProxy.createBackgroundMessageHandler();
      expect(typeof handler).toBe('function');
    });

    test('should return false for non-matching message types', () => {
      const handler = fetchProxy.createBackgroundMessageHandler();
      const result = handler({ type: 'OTHER_TYPE' });
      expect(result).toBe(false);
    });
  });

  describe('registerBackgroundListener', () => {
    test('should warn when chrome.runtime is not available', () => {
      const consoleSpy = jest.spyOn(console, 'warn').mockImplementation();
      global.chrome = undefined;
      
      fetchProxy.registerBackgroundListener();
      expect(consoleSpy).toHaveBeenCalledWith('Chrome runtime API not available');
      
      consoleSpy.mockRestore();
    });
  });
});