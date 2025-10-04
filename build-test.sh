#!/bin/bash

# Build the Docker image
IMAGE_NAME="test-app"
IMAGE_TAG="latest"

# Get git information
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
echo "Git Commit: ${GIT_COMMIT}"
echo "Git Branch: ${GIT_BRANCH}"
echo "Build Date: ${BUILD_DATE}"
echo ""

docker build -f Dockerfile.test \
    --build-arg GIT_COMMIT=${GIT_COMMIT} \
    --build-arg GIT_BRANCH=${GIT_BRANCH} \
    --build-arg BUILD_DATE="${BUILD_DATE}" \
    -t ${IMAGE_NAME}:${IMAGE_TAG} .

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "To run the container:"
    echo "  docker run -d -p 8888:80 --name test-app ${IMAGE_NAME}:${IMAGE_TAG}"
    echo ""
    echo "To view the app:"
    echo "  Open http://localhost:8888 in your browser"
    echo ""
    echo "To stop and remove:"
    echo "  docker stop test-app && docker rm test-app"
else
    echo "❌ Build failed!"
    exit 1
fi
