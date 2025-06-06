import { MMKV } from '@tencent/mmkv'

/**
 * 数据存储工具类
 */
export default class StorageUtils {
  private storage: MMKV;

  constructor() {
    this.storage = MMKV.defaultMMKV();
    this.storage.enableAutoKeyExpire(MMKV.ExpireInDay);
  }

  /**
   * 存储数据：string
   * @param key   存储的key
   * @param value   需要存储的数据
   * @param expires   过期时间
   */
  saveItem(key: string, params: string, expires?: number | null) {
    let storage_expires = expires ? expires : 0;
    this.storage.encodeString(key, params, storage_expires);
  }

  /**
   * 获取数据：boolean
   * @param key
   * @returns
   */
  async getItem(key: string) {
    if (!this.storage.containsKey(key)) {
      throw new Error('Key not found');
    }
    return this.storage.decodeString(key) as string;
  }

  /**
   * 清除指定key缓存
   */
  removeItem(key: string): void {
    this.storage.removeValueForKey(key);
  }

  /**
   * 清除所有缓存
   */
  clear(keys?: Array<string>): void {
    if (keys && keys.length > 0) {
      this.storage.removeValuesForKeys(keys);
    } else {
      this.storage.clearAll();
    }
  }

  /**
   * 获取所有缓存key
   */
  getAllKeys(): Array<string> {
    return this.storage.allKeys();
  }
}
