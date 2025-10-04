# Helm Repository

This repository automatically publishes Helm charts to GitHub Pages, creating a Helm repository that you can use to install the test-app chart.

## Helm Repository URL

```
https://albal.github.io/docker-test
```

## Setup

### Add the Helm Repository

```bash
helm repo add test-app https://albal.github.io/docker-test
helm repo update
```

### Search Available Charts

```bash
helm search repo test-app
```

This will show all available versions of the test-app chart.

## Installation

### Install Latest Version

```bash
helm install my-test-app test-app/test-app
```

### Install Specific Version

```bash
helm install my-test-app test-app/test-app --version 1.0.0
```

### Install with Custom Values

```bash
# Using dev values
helm install my-test-app test-app/test-app -f helm/test-app/values-dev.yaml

# Using prod values
helm install my-test-app test-app/test-app -f helm/test-app/values-prod.yaml

# Override specific values
helm install my-test-app test-app/test-app \
  --set image.tag=v1.0.0 \
  --set replicaCount=3 \
  --set ingress.enabled=true \
  --set ingress.host=test-app.example.com
```

## Upgrading

```bash
# Update repository index
helm repo update

# Upgrade to latest version
helm upgrade my-test-app test-app/test-app

# Upgrade to specific version
helm upgrade my-test-app test-app/test-app --version 1.0.1
```

## Uninstalling

```bash
helm uninstall my-test-app
```

## How It Works

The Helm repository is automatically maintained through GitHub Actions:

1. **On Release**: When a new version tag (e.g., `v1.0.0`) is pushed:
   - The Helm chart is packaged
   - The chart is added to the GitHub release
   - The chart is copied to the `gh-pages` branch
   - The Helm repository index (`index.yaml`) is updated
   - Changes are committed and pushed to `gh-pages`

2. **GitHub Pages**: The `gh-pages` branch is served via GitHub Pages, making it accessible as a Helm repository

3. **Index File**: The `index.yaml` file contains metadata about all available chart versions

## Manual Setup (First Time)

If the `gh-pages` branch doesn't exist yet, you can create it manually:

```bash
# Create an orphan gh-pages branch
git checkout --orphan gh-pages
git rm -rf .

# Create a basic index.html
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Test App Helm Repository</title>
</head>
<body>
    <h1>Test App Helm Repository</h1>
    <p>Add this repository:</p>
    <pre>helm repo add test-app https://albal.github.io/docker-test</pre>
</body>
</html>
EOF

# Initialize empty Helm index
helm repo index . --url https://albal.github.io/docker-test

# Commit and push
git add .
git commit -m "Initialize Helm repository"
git push origin gh-pages
```

Then enable GitHub Pages in your repository settings:
- Go to Settings → Pages
- Source: Deploy from a branch
- Branch: `gh-pages` / `root`
- Save

## Verify Repository

After setup, verify the repository is accessible:

```bash
# Check if the repository URL is accessible
curl -I https://albal.github.io/docker-test/index.yaml

# Add and test the repository
helm repo add test-app https://albal.github.io/docker-test
helm repo update
helm search repo test-app
```

## Repository Structure

The `gh-pages` branch contains:

```
gh-pages/
├── index.html          # Human-readable repository page
├── index.yaml          # Helm repository index
├── test-app-1.0.0.tgz # Packaged chart version 1.0.0
├── test-app-1.0.1.tgz # Packaged chart version 1.0.1
└── ...
```

## Troubleshooting

### Repository Not Found

If `helm repo add` fails:
- Verify GitHub Pages is enabled for the `gh-pages` branch
- Check that the `index.yaml` file exists at https://albal.github.io/docker-test/index.yaml
- Wait a few minutes after pushing to `gh-pages` (GitHub Pages may take time to deploy)

### Chart Version Not Available

If a specific chart version is not found:
- Verify the release was created with a proper version tag (e.g., `v1.0.0`)
- Check the GitHub Actions workflow completed successfully
- Run `helm repo update` to refresh your local cache
- Check the `index.yaml` file for available versions

### Permission Denied

If the workflow fails to push to `gh-pages`:
- Ensure GitHub Actions has write permissions (Settings → Actions → General → Workflow permissions → Read and write permissions)
- Verify the `GITHUB_TOKEN` is available in the workflow

## Best Practices

1. **Semantic Versioning**: Use semantic versioning for releases (e.g., `v1.0.0`, `v1.1.0`, `v2.0.0`)
2. **Changelog**: Include a changelog in release notes
3. **Testing**: Test charts before releasing by installing from the local package
4. **Cleanup**: Optionally, remove old chart versions from `gh-pages` to reduce repository size
5. **Documentation**: Update chart README.md with breaking changes and upgrade notes

## Alternative Installation Methods

### From GitHub Release Assets

```bash
# Download chart from release
wget https://github.com/albal/docker-test/releases/download/v1.0.0/test-app-1.0.0.tgz

# Install from local file
helm install my-test-app test-app-1.0.0.tgz
```

### From Local Repository

```bash
# Package the chart locally
helm package helm/test-app

# Install from local package
helm install my-test-app ./test-app-*.tgz
```

## Resources

- [Helm Documentation](https://helm.sh/docs/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Helm Chart Repository Guide](https://helm.sh/docs/topics/chart_repository/)
