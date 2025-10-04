# Helm Chart Deployment Guide

## 📦 What's Been Created

### Helm Chart Structure
```
helm/test-app/
├── Chart.yaml              # Chart metadata and versioning
├── values.yaml             # Default configuration values
├── values-dev.yaml         # Development environment values
├── values-prod.yaml        # Production environment values
├── README.md              # Comprehensive documentation
├── .helmignore            # Files to ignore when packaging
└── templates/
    ├── _helpers.tpl       # Template helpers
    ├── deployment.yaml    # Kubernetes Deployment
    ├── service.yaml       # Kubernetes Service
    ├── ingress.yaml       # Kubernetes Ingress (optional)
    ├── serviceaccount.yaml # ServiceAccount
    └── hpa.yaml           # HorizontalPodAutoscaler (optional)
```

### Scripts
- `deploy-helm.sh` - Quick deployment script with multiple commands
- Updated `docker-build-push.yml` - GitHub Actions workflow with Helm support

## 🚀 Quick Start

### 1. Local Development

```bash
# Build the Docker image
./build-test.sh

# Deploy to local Kubernetes (minikube/kind/docker-desktop)
./deploy-helm.sh install latest

# Check status
./deploy-helm.sh status

# Access the app
./deploy-helm.sh port-forward
# Then open http://localhost:8888
```

### 2. Deploy to Kubernetes Cluster

```bash
# Install with default values
helm install test-app ./helm/test-app

# Install with development values
helm install test-app ./helm/test-app -f ./helm/test-app/values-dev.yaml

# Install with production values
helm install test-app ./helm/test-app -f ./helm/test-app/values-prod.yaml \
  --set image.repository=your-username/test-app \
  --set image.tag=v1.0.0
```

## 🏷️ Release Process with GitHub Actions

### Creating a Release

1. **Make your changes** and commit them:
   ```bash
   git add .
   git commit -m "Your changes"
   git push
   ```

2. **Create and push a version tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

3. **Create a GitHub Release**:
   - Go to GitHub → Releases → "Draft a new release"
   - Select your tag (v1.0.0)
   - Add release notes
   - Click "Publish release"

### What Happens Automatically

When you create a release (with a `v*` tag), the GitHub Actions workflow will:

1. ✅ **Build the Docker image** with git metadata
2. ✅ **Tag the image** with the version (e.g., `v1.0.0`)
3. ✅ **Push to Docker Hub**
4. ✅ **Update Chart.yaml** with the version number
5. ✅ **Package the Helm chart** as `.tgz`
6. ✅ **Attach the chart** to the GitHub release
7. ✅ **Add installation instructions** to release notes

### After Release

Users can install directly from the release:

```bash
# Download the chart
wget https://github.com/your-org/k8s-manifests/releases/download/v1.0.0/test-app-1.0.0.tgz

# Install it
helm install test-app test-app-1.0.0.tgz
```

## 🔧 Configuration Examples

### Enable Ingress

```bash
helm install test-app ./helm/test-app \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=test-app.example.com
```

### Enable Auto-scaling

```bash
helm install test-app ./helm/test-app \
  --set autoscaling.enabled=true \
  --set autoscaling.minReplicas=3 \
  --set autoscaling.maxReplicas=20
```

### Set Resource Limits

```bash
helm install test-app ./helm/test-app \
  --set resources.limits.cpu=200m \
  --set resources.limits.memory=256Mi \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi
```

## 📊 Monitoring Deployments

### View Pods
```bash
kubectl get pods -l app.kubernetes.io/name=test-app
```

### View Git Metadata on Pods
```bash
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{.metadata.annotations}{"\n\n"}{end}'
```

### Check Helm Release
```bash
helm list
helm status test-app
helm get values test-app
```

## 🔄 Upgrading

### Upgrade to New Version
```bash
helm upgrade test-app ./helm/test-app --set image.tag=v1.1.0
```

### Rollback
```bash
# View history
helm history test-app

# Rollback to previous version
helm rollback test-app

# Rollback to specific revision
helm rollback test-app 2
```

## 🧪 Testing Before Deploy

```bash
# Lint the chart
helm lint ./helm/test-app

# Dry-run (see what will be created)
helm install test-app ./helm/test-app --dry-run --debug

# Template (generate YAML)
helm template test-app ./helm/test-app > output.yaml
```

## 🔐 Required Secrets

For the GitHub Actions workflow to work, set these secrets:

- `DOCKERHUB_USERNAME` - Your Docker Hub username
- `DOCKERHUB_TOKEN` - Docker Hub access token
- `GITHUB_TOKEN` - Automatically provided by GitHub

## 📝 Version Numbering

Follow semantic versioning: `vMAJOR.MINOR.PATCH`

- **v1.0.0** - First stable release
- **v1.0.1** - Bug fix
- **v1.1.0** - New feature
- **v2.0.0** - Breaking change

## 🎯 Next Steps

1. Update `values.yaml` with your Docker Hub username
2. Update `.github/workflows/docker-build-push.yml` with your image name
3. Add GitHub secrets (DOCKERHUB_USERNAME, DOCKERHUB_TOKEN)
4. Test locally: `./deploy-helm.sh install latest`
5. Create your first release: `git tag v1.0.0 && git push origin v1.0.0`
6. Watch the GitHub Actions workflow run
7. Deploy to production from the release artifacts!
