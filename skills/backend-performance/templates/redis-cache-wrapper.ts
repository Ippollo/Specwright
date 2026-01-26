/**
 * TEMPLATE: Redis Cache Wrapper
 * 
 * Dependencies:
 *   npm install redis
 */

import { createClient } from 'redis';

// Simplified types for demo
type RedisClient = ReturnType<typeof createClient>;

export class CacheService {
  private client: RedisClient;
  private defaultTTL: number;

  constructor(client: RedisClient, defaultTTLSeconds: number = 300) {
    this.client = client;
    this.defaultTTL = defaultTTLSeconds;
  }

  /**
   * Generic wrapper to Get-or-Set data.
   * prevents needing to write get/set logic repeatedly.
   */
  async getOrSet<T>(
    key: string,
    fetcher: () => Promise<T>,
    ttlSeconds?: number
  ): Promise<T> {
    
    // 1. Try Fetch
    const cached = await this.client.get(key);
    if (cached) {
      return JSON.parse(cached) as T;
    }

    // 2. Fetch Source
    const freshData = await fetcher();

    // 3. Save
    if (freshData) {
      await this.client.set(key, JSON.stringify(freshData), {
        EX: ttlSeconds || this.defaultTTL
      });
    }

    return freshData;
  }

  async invalidate(keyPattern: string): Promise<void> {
    // Note: In production scan/unlink is safer than keys/del for massive sets
    const keys = await this.client.keys(keyPattern);
    if (keys.length > 0) {
      await this.client.del(keys);
    }
  }
}
