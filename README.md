# Test App - Docker & Kubernetes Demo

A modern web application that displays git commit information, hostname, and container details with a random color background on each refresh. Built with nginx and designed for Docker and Kubernetes deployments.

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)

## 🌟 Features

- 🎨 **Random color background** that changes on each page refresh
- 📝 **Git metadata display** - shows commit hash and branch
- 🖥️ **Host information** - displays hostname and container ID
- ☸️ **Kubernetes namespace** - automatically displayed when running in K8s
- 🐳 **Docker-optimized** - lightweight nginx-alpine base image
- ☸️ **Kubernetes-ready** - complete Helm chart included
- 🤖 **CI/CD automated** - GitHub Actions for build and deploy
- 🏷️ **Multi-platform** - supports amd64 and arm64 architectures

## 🏗️ Project Structure

```
.
├── Dockerfile.test              # Docker build configuration
├── test-index.html              # Main HTML application
├── test-entrypoint.sh           # Container entrypoint script
├── build-test.sh                # Local Docker build script
├── deploy-helm.sh               # Helm deployment helper script
├── .github/
│   └── workflows/
│       └── docker-build-push.yml  # CI/CD pipeline
├── helm/
│   └── test-app/               # Helm chart for Kubernetes
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-dev.yaml
│       ├── values-prod.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── ingress.yaml
│           ├── serviceaccount.yaml
│           └── hpa.yaml
├── GITHUB_ACTIONS_README.md     # CI/CD setup guide
└── HELM_DEPLOYMENT_GUIDE.md     # Kubernetes deployment guide
```

## 🚀 Quick Start

### Prerequisites

- **Docker** 20.10+
- **Git** 2.0+
- **Kubernetes** 1.19+ (for Helm deployment)
- **Helm** 3.0+ (for Kubernetes deployment)

### Local Development

1. **Clone the repository**:
   ```bash
   git clone https://github.com/albal/docker-test.git
   cd docker-test
   ```

2. **Build the Docker image**:
   ```bash
   ./build-test.sh
   ```

3. **Run the container**:
   ```bash
   docker run -d -p 8888:80 --name test-app test-app:latest
   ```

4. **View the application**:
   ```bash
   open http://localhost:8888
   # Or visit http://localhost:8888 in your browser
   ```

5. **Stop and remove**:
   ```bash
   docker stop test-app && docker rm test-app
   ```

## 🐳 Docker Usage

### Build with Git Information

The Docker image accepts build arguments for git metadata:

```bash
docker build -f Dockerfile.test \
  --build-arg GIT_COMMIT=$(git rev-parse --short HEAD) \
  --build-arg GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD) \
  --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  -t test-app:latest .
```

### Pull from Docker Hub

```bash
docker pull albal/test-app:latest
docker run -d -p 8888:80 albal/test-app:latest
```

### Build Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `GIT_COMMIT` | Git commit SHA (short) | `unknown` |
| `GIT_BRANCH` | Git branch name | `unknown` |
| `BUILD_DATE` | ISO 8601 build timestamp | `unknown` |

## ☸️ Kubernetes Deployment

### Quick Deploy with Helm

```bash
# Install the chart
./deploy-helm.sh install latest

# Check status
./deploy-helm.sh status

# Port forward to local machine
./deploy-helm.sh port-forward
```

### Manual Helm Installation

```bash
# Basic installation
helm install test-app ./helm/test-app

# Production installation
helm install test-app ./helm/test-app \
  -f ./helm/test-app/values-prod.yaml \
  --set image.repository=albal/test-app \
  --set image.tag=v1.0.0
```

### Enable Ingress

```bash
helm install test-app ./helm/test-app \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=test-app.yourdomain.com
```

For detailed Kubernetes deployment instructions, see [HELM_DEPLOYMENT_GUIDE.md](HELM_DEPLOYMENT_GUIDE.md).

## 🤖 CI/CD Pipeline

This project uses GitHub Actions for automated builds and deployments.

### Automated Workflow

On every push to `main` or creation of a release tag:

1. ✅ Builds Docker image with git metadata
2. ✅ Pushes to Docker Hub
3. ✅ Updates Helm chart version (on releases)
4. ✅ Packages and attaches Helm chart to release
5. ✅ Supports multi-platform builds (amd64, arm64)

### Creating a Release

```bash
# Tag the release
git tag v1.0.0
git push origin v1.0.0

# Create release on GitHub
# The workflow will automatically build and publish
```

For CI/CD setup instructions, see [GITHUB_ACTIONS_README.md](GITHUB_ACTIONS_README.md).

## 📊 Application Features

### What the App Displays

- **Git Commit**: Short commit hash and branch name
- **Hostname**: Container/pod hostname
- **Container ID**: Unique container identifier
- **Random Background**: New color on each page refresh
- **Build Timestamp**: When the image was built

### Example Screenshot

The app shows a clean, modern interface with:
- Large title "🚀 Test Application"
- Three information cards with git and host details
- Refresh button with smooth animations
- Timestamp of last page load
- Randomly colored gradient background

## 🛠️ Development

### Local Testing

```bash
# Build the image
./build-test.sh

# Run locally
docker run -d -p 8888:80 --name test-app test-app:latest

# View logs
docker logs test-app

# Access shell
docker exec -it test-app sh
```

### Testing Helm Chart

```bash
# Lint the chart
helm lint ./helm/test-app

# Dry run
helm install test-app ./helm/test-app --dry-run --debug

# Generate manifests
helm template test-app ./helm/test-app > manifests.yaml
```

## 🔧 Configuration

### Docker Environment Variables

The container uses environment variables set during build:

- `GIT_COMMIT` - Git commit SHA
- `GIT_BRANCH` - Git branch name
- `BUILD_DATE` - Build timestamp

### Kubernetes Environment Variables

When running in Kubernetes, the following environment variables are automatically injected:

- `K8S_NAMESPACE` - The Kubernetes namespace where the pod is running (automatically set via fieldRef)

### Helm Values

Key configuration options in `values.yaml`:

```yaml
replicaCount: 2                        # Number of pods
image:
  repository: albal/test-app           # Docker image
  tag: latest                          # Image tag
  pullPolicy: IfNotPresent             # Pull policy

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 50m
    memory: 64Mi

autoscaling:
  enabled: false                       # Enable HPA
  minReplicas: 2
  maxReplicas: 10
```

## 📚 Documentation

- **[GITHUB_ACTIONS_README.md](GITHUB_ACTIONS_README.md)** - CI/CD setup and GitHub Actions configuration
- **[HELM_DEPLOYMENT_GUIDE.md](HELM_DEPLOYMENT_GUIDE.md)** - Complete Kubernetes deployment guide
- **[helm/test-app/README.md](helm/test-app/README.md)** - Helm chart documentation

## 🧪 Testing

### Test the Docker Build

```bash
# Build
./build-test.sh

# Run
docker run -d -p 8888:80 --name test-app test-app:latest

# Test
curl http://localhost:8888

# Cleanup
docker stop test-app && docker rm test-app
```

### Test Helm Deployment

```bash
# Install to Kubernetes
./deploy-helm.sh install latest

# Check pods
kubectl get pods -l app.kubernetes.io/name=test-app

# View logs
./deploy-helm.sh logs

# Cleanup
./deploy-helm.sh uninstall
```

## 🔒 Security

### Docker Image

- Based on official `nginx:alpine` image
- Runs as non-root user (nginx default)
- Minimal attack surface with Alpine Linux
- Regular updates via CI/CD pipeline

### Kubernetes

- ServiceAccount with least privilege
- Resource limits enforced
- SecurityContext configured
- Network policies compatible

## 📈 Monitoring

### Pod Annotations

Git metadata is stored as pod annotations:

```bash
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.annotations}'
```

### Health Checks

- **Liveness probe**: HTTP GET on port 80
- **Readiness probe**: HTTP GET on port 80
- Both with 5-second initial delay

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -am 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a pull request

## 📝 Version History

See [Releases](https://github.com/albal/docker-test/releases) for version history and changelogs.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👤 Author

**albal**
- GitHub: [@albal](https://github.com/albal)
- Docker Hub: [albal](https://hub.docker.com/u/albal)

## 🙏 Acknowledgments

- Built with [nginx](https://nginx.org/)
- Containerized with [Docker](https://www.docker.com/)
- Orchestrated with [Kubernetes](https://kubernetes.io/)
- Packaged with [Helm](https://helm.sh/)
- Automated with [GitHub Actions](https://github.com/features/actions)

## 📞 Support

If you encounter any issues or have questions:

1. Check the [documentation](#-documentation)
2. Search [existing issues](https://github.com/albal/docker-test/issues)
3. Create a [new issue](https://github.com/albal/docker-test/issues/new)

---

Made with ❤️ by albal
