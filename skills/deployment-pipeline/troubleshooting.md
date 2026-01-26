# Troubleshooting Guide

## 1. Build Failures

### `npm install` fails

- **Cause**: Lockfile mismatch or network issue.
- **Fix**: Run `npm ci` locally to reproduce. clear cache `npm cache clean --force`. Check Node version.

### Docker Build fails

- **Cause**: Missing file in context or permission error.
- **Fix**: Check `.dockerignore`. Ensure all files needed are copied. Check file permissions.

## 2. Test Failures

### Flaky Tests

- **Cause**: Race conditions, relying on external services.
- **Fix**: Mock all external calls. Use `jest.retryTimes(3)`.

### Environment Mismatch

- **Cause**: Tests pass locally but fail in CI.
- **Fix**: Use Docker for tests to ensure identical environment. Check dependency versions.

## 3. Deployment Failures

### CrashLoopBackOff

- **Cause**: Application crashing on startup.
- **Fix**:
  1. `kubectl logs <pod-name>`
  2. Check for missing env vars.
  3. Check for database connection issues.

### ImagePullBackOff

- **Cause**: K8s cannot pull the image.
- **Fix**:
  1. Check image name/tag spelling.
  2. Check image registry credentials.

### Readiness Probe Failed

- **Cause**: App is running but `/health` endpoint is failing.
- **Fix**:
  1. Increase `initialDelaySeconds`.
  2. Check application logs for slow startup.
