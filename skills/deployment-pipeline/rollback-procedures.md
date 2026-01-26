# Rollback Procedures

## 1. Rolling Deployment (Kubernetes)

If a new deployment is unstable, roll back to the previous revision.

### Command Line

```bash
# View rollout history
kubectl rollout history deployment/myapp

# Undo last rollout
kubectl rollout undo deployment/myapp

# Rollback to specific revision
kubectl rollout undo deployment/myapp --to-revision=2
```

## 2. Blue/Green Deployment

Switch traffic back to the "Blue" (stable) environment.

1.  **Identify Stable Service**: Ensure the old service/ingress is still active.
2.  **Switch Router**: Update the Ingress or Load Balancer to point back to the Blue service.
3.  **Verify**: Curl the endpoint to confirm it hits the old version.

## 3. Canary Deployment

Stop traffic to the new version immediately.

1.  **Set Weight to 0**:
    ```yaml
    # Istio VirtualService example
    route:
      - destination:
          host: myapp
          subset: v1
        weight: 100
      - destination:
          host: myapp
          subset: v2
        weight: 0
    ```
2.  **Apply**: `kubectl apply -f virtual-service.yaml`

## 4. Database Rollbacks

**WARNING**: Rolling back code is easy; rolling back data is hard.

- **Forward-Only Migrations**: Prefer writing a new migration to fix data than undoing schema changes.
- **Backwards Compatibility**: New schema changes should support old code (e.g., make new columns nullable).
- **Snapshot Restore**: If catastrophic, restore DB from snapshot taken pre-deploy (High downtime).
