# Test App Helm Chart

A Helm chart for deploying the test-app application on Kubernetes.

## Features

- 🚀 **Easy deployment** with sensible defaults
- 📊 **Horizontal Pod Autoscaling** support
- 🔒 **ServiceAccount** management
- 🌐 **Ingress** support with TLS
- 📝 **Git metadata** annotations on pods
- ☸️ **Kubernetes namespace** automatically displayed in the app
- ⚙️ **Configurable** resources and replicas

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+

## Installation

### Install from GitHub Release

```bash
# Download the chart from the latest release
wget https://github.com/your-org/k8s-manifests/releases/download/v1.0.0/test-app-1.0.0.tgz

# Install the chart
helm install test-app test-app-1.0.0.tgz
```

### Install from Local Chart

```bash
# From the repository root
helm install test-app ./helm/test-app
```

### Install with Custom Values

```bash
helm install test-app ./helm/test-app \
  --set image.repository=your-dockerhub-username/test-app \
  --set image.tag=v1.0.0 \
  --set replicaCount=3
```

## Configuration

The following table lists the configurable parameters and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `2` |
| `image.repository` | Image repository | `your-dockerhub-username/test-app` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Image tag (defaults to appVersion) | `""` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.hosts[0].host` | Hostname | `test-app.example.com` |
| `resources.limits.cpu` | CPU limit | `100m` |
| `resources.limits.memory` | Memory limit | `128Mi` |
| `resources.requests.cpu` | CPU request | `50m` |
| `resources.requests.memory` | Memory request | `64Mi` |
| `autoscaling.enabled` | Enable HPA | `false` |
| `autoscaling.minReplicas` | Minimum replicas | `2` |
| `autoscaling.maxReplicas` | Maximum replicas | `10` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU % | `80` |

## Examples

### Basic Installation

```bash
helm install test-app ./helm/test-app \
  --set image.tag=latest
```

### Enable Ingress

```bash
helm install test-app ./helm/test-app \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=test-app.yourdomain.com
```

### Enable Autoscaling

```bash
helm install test-app ./helm/test-app \
  --set autoscaling.enabled=true \
  --set autoscaling.minReplicas=2 \
  --set autoscaling.maxReplicas=10
```

### Production Configuration

Create a `values-prod.yaml`:

```yaml
replicaCount: 3

image:
  repository: your-dockerhub-username/test-app
  tag: v1.0.0
  pullPolicy: Always

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 20
  targetCPUUtilizationPercentage: 70

ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: test-app.yourdomain.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: test-app-tls
      hosts:
        - test-app.yourdomain.com
```

Install with:

```bash
helm install test-app ./helm/test-app -f values-prod.yaml
```

## Upgrading

```bash
# Upgrade to a new version
helm upgrade test-app ./helm/test-app --set image.tag=v1.1.0

# Upgrade with new values file
helm upgrade test-app ./helm/test-app -f values-prod.yaml
```

## Uninstalling

```bash
helm uninstall test-app
```

## Versioning

The chart version is automatically updated when creating a new GitHub release:

1. Create a git tag: `git tag v1.0.0`
2. Push the tag: `git push origin v1.0.0`
3. Create a GitHub release from the tag
4. The workflow will:
   - Update `Chart.yaml` with the version
   - Package the Helm chart
   - Attach it to the GitHub release
   - Build and push the Docker image with the same version

## Testing

```bash
# Lint the chart
helm lint ./helm/test-app

# Dry-run installation
helm install test-app ./helm/test-app --dry-run --debug

# Template the chart
helm template test-app ./helm/test-app
```

## Troubleshooting

### Check Pod Status

```bash
kubectl get pods -l app.kubernetes.io/name=test-app
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Check Service

```bash
kubectl get svc -l app.kubernetes.io/name=test-app
kubectl describe svc test-app
```

### Check Ingress

```bash
kubectl get ingress
kubectl describe ingress test-app
```

### View Git Metadata

```bash
kubectl get pod <pod-name> -o jsonpath='{.metadata.annotations}'
```

## Development

### Update Chart

1. Modify templates or values
2. Update version in `Chart.yaml`
3. Test locally: `helm upgrade test-app ./helm/test-app`

### Package Chart

```bash
helm package ./helm/test-app
```

## License

Your License Here
