import http from 'k6/http';
import { check, sleep } from 'k6';

/* 
  USAGE: 
  k6 run load-test.js
  
  ENVIRONMENT VARIABLES:
  TARGET_URL=http://localhost:3000 k6 run load-test.js
*/

export const options = {
  // Simulation Stages
  stages: [
    { duration: '30s', target: 20 }, // Ramp up to 20 users
    { duration: '1m', target: 20 },  // Sustained load
    { duration: '30s', target: 50 }, // Spiking to 50
    { duration: '1m', target: 50 },  // Sustained high load
    { duration: '30s', target: 0 },  // Ramp down
  ],
  
  // Failure Thresholds
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests must be < 500ms
    http_req_failed: ['rate<0.01'],   // < 1% errors
  },
};

const BASE_URL = __ENV.TARGET_URL || 'http://localhost:3000';

export default function () {
  // 1. Define Request
  const res = http.get(`${BASE_URL}/api/health`);

  // 2. Assertions
  check(res, {
    'status is 200': (r) => r.status === 200,
    'latency < 500ms': (r) => r.timings.duration < 500,
  });

  // 3. Pacing (Think Time)
  sleep(1); 
}
