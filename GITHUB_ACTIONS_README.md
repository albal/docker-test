# Test App - Docker Build & Push

This repository contains a GitHub Actions workflow that automatically builds and pushes a Docker image to Docker Hub.

## 🚀 Features

- Builds Docker image with git commit info, branch, and build date
- Pushes to Docker Hub automatically on push to main/master
- Supports multi-platform builds (amd64, arm64)
- Tags images with version tags and commit SHAs
- Uses Docker layer caching for faster builds

## 🔧 Setup Instructions

### 1. Set Up Docker Hub Secrets

You need to configure two secrets in your GitHub repository:

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** and add:

   - **Name**: `DOCKERHUB_USERNAME`  
     **Value**: Your Docker Hub username

   - **Name**: `DOCKERHUB_TOKEN`  
     **Value**: Your Docker Hub access token

#### How to Create a Docker Hub Access Token:

1. Log in to [Docker Hub](https://hub.docker.com)
2. Click your username → **Account Settings**
3. Go to **Security** → **New Access Token**
4. Give it a name (e.g., "GitHub Actions")
5. Set permissions to **Read, Write, Delete**
6. Copy the token (you won't see it again!)
7. Use this token as `DOCKERHUB_TOKEN` in GitHub secrets

### 2. Update Docker Image Name

Edit `.github/workflows/docker-build-push.yml` and change:

```yaml
env:
  DOCKER_IMAGE: your-dockerhub-username/test-app
```

Replace `your-dockerhub-username` with your actual Docker Hub username.

## 📦 Workflow Triggers

The workflow runs on:

- **Push to main/master branch** - Builds and pushes with `:latest` and `:commit-sha` tags
- **Push tag** (e.g., `v1.0.0`) - Builds and pushes with version tag and `:latest`
- **Pull request** - Builds only (doesn't push)
- **Manual trigger** - Use "Run workflow" button in Actions tab

## 🏷️ Image Tagging Strategy

- **Main/Master branch**: 
  - `your-username/test-app:latest`
  - `your-username/test-app:abc1234` (commit SHA)

- **Version tags** (e.g., `v1.0.0`):
  - `your-username/test-app:v1.0.0`
  - `your-username/test-app:latest`

- **Other branches**:
  - `your-username/test-app:branch-name`

## 🐳 Running the Image

After the workflow completes, pull and run your image:

```bash
# Pull the latest image
docker pull your-username/test-app:latest

# Run the container
docker run -d -p 8888:80 --name test-app your-username/test-app:latest

# View the app
open http://localhost:8888
```

## 🔍 View Build Status

Check the **Actions** tab in your GitHub repository to see build status and logs.

## 📝 Build Arguments

The workflow passes these build arguments to the Docker image:

- `GIT_COMMIT` - Short git commit SHA
- `GIT_BRANCH` - Current branch name
- `BUILD_DATE` - ISO 8601 formatted build timestamp

These are displayed in the running application.
