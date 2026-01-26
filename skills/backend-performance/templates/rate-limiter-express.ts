/**
 * TEMPLATE: Express Rate Limiter Middleware
 * 
 * Dependencies:
 *   npm install express redis
 *   npm install -D @types/express
 */

import { Request, Response, NextFunction } from 'express';
import { createClient } from 'redis';

const redis = createClient();
/* Ensure redis is connected before using */

/**
 * Basic Fixed Window Rate Limiter
 * @param limit Max requests per window
 * @param windowSeconds Window duration
 */
export const rateLimiter = (limit: number, windowSeconds: number) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const ip = req.ip || 'unknown';
      const key = `ratelimit:${ip}`;

      const requests = await redis.incr(key);

      // Set expiry on first request
      if (requests === 1) {
        await redis.expire(key, windowSeconds);
      }

      const ttl = await redis.ttl(key);

      // Set Headers (Good Practice)
      res.set('X-RateLimit-Limit', limit.toString());
      res.set('X-RateLimit-Remaining', Math.max(0, limit - requests).toString());
      res.set('X-RateLimit-Reset', (Date.now() / 1000 + ttl).toFixed(0));

      if (requests > limit) {
        return res.status(429).json({
          error: 'Too Many Requests',
          message: `Limit exceeded. Try again in ${ttl} seconds.`
        });
      }

      next();
    } catch (err) {
      console.error('Rate Limit Error:', err);
      // Fail open (allow request) so Redis outage doesn't kill app
      next(); 
    }
  };
};
