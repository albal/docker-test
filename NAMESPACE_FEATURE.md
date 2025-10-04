# Kubernetes Namespace Display Feature

## Overview

The application now displays the Kubernetes namespace it's running in when deployed to a Kubernetes cluster. This feature is automatically enabled by the Helm chart.

## Changes Made

### 1. HTML Updates (`test-index.html`)

- Added a new info card to display the Kubernetes namespace
- The card is hidden by default and only shows when the namespace value is set
- JavaScript checks if the namespace placeholder has been replaced with an actual value

```html
<div class="info-card" id="namespace-card" style="display: none;">
    <div class="info-label">Kubernetes Namespace:</div>
    <div class="info-value" id="namespace">__K8S_NAMESPACE__</div>
</div>
```

### 2. Entrypoint Script Updates (`test-entrypoint.sh`)

- Added handling for the `K8S_NAMESPACE` environment variable
- Replaces the `__K8S_NAMESPACE__` placeholder in the HTML
- Defaults to "N/A" if not running in Kubernetes
- Logs the namespace on container startup

```bash
K8S_NAMESPACE="${K8S_NAMESPACE:-N/A}"
sed -i "s/__K8S_NAMESPACE__/${K8S_NAMESPACE}/g" /usr/share/nginx/html/index.html
```

### 3. Helm Chart Updates (`helm/test-app/templates/deployment.yaml`)

- Automatically injects the `K8S_NAMESPACE` environment variable using Kubernetes downward API
- Uses `fieldRef` to get the namespace from pod metadata

```yaml
env:
- name: K8S_NAMESPACE
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
```

### 4. Workflow Updates (`.github/workflows/docker-build-push.yml`)

- **Fixed 403 errors**: Updated to use `softprops/action-gh-release@v2`
- **Added permissions**: Set `contents: write` and `packages: write` permissions
- **Better release handling**: Added `fail_on_unmatched_files: false` to handle re-runs
- **Helm repository instructions**: Updated release notes with Helm repo installation steps

### 5. Documentation Updates

- Updated main `README.md` with namespace feature
- Updated Helm chart `README.md` to list namespace as a feature
- Updated `values.yaml` with comments about automatic namespace injection
- Added configuration section explaining Kubernetes environment variables

## How It Works

### In Docker (Standalone)

When running in Docker without Kubernetes:
- The namespace card will show "N/A" and remain hidden
- The app functions normally without any Kubernetes-specific features

```bash
docker run -p 8888:80 test-app:latest
```

### In Kubernetes (with Helm)

When deployed to Kubernetes using the Helm chart:
1. Kubernetes automatically injects the namespace via the downward API
2. The environment variable `K8S_NAMESPACE` is set to the pod's namespace
3. The entrypoint script replaces the placeholder in the HTML
4. The namespace card becomes visible in the UI

```bash
# Deploy to 'production' namespace
kubectl create namespace production
helm install my-test-app test-app/test-app -n production

# The app will display "Kubernetes Namespace: production"
```

## Testing

### Test in Docker (No Namespace)

```bash
./build-test.sh
docker run -p 8888:80 test-app:latest
# Open http://localhost:8888
# Namespace card should not be visible
```

### Test with Manual Environment Variable

```bash
docker run -p 8888:80 -e K8S_NAMESPACE=test-namespace test-app:latest
# The namespace card should show "test-namespace"
```

### Test in Kubernetes

```bash
# Deploy to a specific namespace
kubectl create namespace demo
helm install test-app ./helm/test-app -n demo

# Port forward to test
kubectl port-forward -n demo svc/test-app 8888:80

# Open http://localhost:8888
# Should display "Kubernetes Namespace: demo"
```

## GitHub Actions Workflow Fix

### The 403 Error Issue

The workflow was failing with:
```
⚠️ GitHub release failed with status: 403
```

**Root Causes:**
1. Missing `contents: write` permission for the workflow
2. Using older version of `softprops/action-gh-release` (v1)
3. Release might already exist from manual creation

**Solutions Applied:**
1. ✅ Added explicit permissions block with `contents: write` and `packages: write`
2. ✅ Updated to `softprops/action-gh-release@v2` which has better error handling
3. ✅ Added `fail_on_unmatched_files: false` to handle edge cases
4. ✅ Added `make_latest: true` to mark releases as latest

### Next Steps

1. **Commit the changes:**
   ```bash
   git add -A
   git commit -m "Add Kubernetes namespace display feature and fix workflow permissions"
   git push origin main
   ```

2. **Delete and recreate the tag** (to trigger workflow with new permissions):
   ```bash
   # Delete local and remote tag
   git tag -d v1.0.0
   git push origin :refs/tags/v1.0.0
   
   # Delete the release on GitHub (via web UI or gh cli)
   gh release delete v1.0.0 --yes
   
   # Create new tag and push
   git tag v1.0.0
   git push origin v1.0.0
   ```

3. **Or create a new version:**
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```

4. **Check GitHub Actions workflow** runs successfully

5. **Verify GitHub Pages** is enabled for `gh-pages` branch (Settings → Pages)

## Verification Checklist

- [ ] Docker build completes successfully
- [ ] Container runs and serves the webpage
- [ ] Namespace card is hidden when running in Docker
- [ ] Helm chart installs without errors
- [ ] Namespace is displayed correctly in Kubernetes
- [ ] GitHub Actions workflow completes without 403 errors
- [ ] Helm chart is packaged and attached to release
- [ ] Helm repository is updated on `gh-pages` branch
- [ ] Helm repository is accessible via GitHub Pages

## Benefits

1. **Better Observability**: Users can immediately see which namespace the pod is running in
2. **Multi-Tenancy**: Helpful in clusters with multiple namespaces/environments
3. **Debugging**: Easier to identify which environment you're looking at
4. **Zero Configuration**: Automatically works with the Helm chart
5. **Backward Compatible**: Works in Docker without Kubernetes

## Additional Environment Variables You Can Add

The same pattern can be used to add more Kubernetes metadata:

```yaml
env:
- name: K8S_NAMESPACE
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
- name: K8S_POD_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
- name: K8S_POD_IP
  valueFrom:
    fieldRef:
      fieldPath: status.podIP
- name: K8S_NODE_NAME
  valueFrom:
    fieldRef:
      fieldPath: spec.nodeName
```

Then update the HTML and entrypoint script to display these values!
