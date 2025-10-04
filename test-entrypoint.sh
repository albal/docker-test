#!/bin/sh

# Use environment variables passed from build args
GIT_INFO="${GIT_COMMIT} (${GIT_BRANCH})"

# Get hostname
HOSTNAME=$(hostname)

# Get container ID (first 12 chars of hostname typically)
CONTAINER_ID=$(hostname)

# Replace placeholders in HTML
sed -i "s/__GIT_COMMIT__/${GIT_INFO}/g" /usr/share/nginx/html/index.html
sed -i "s/__HOSTNAME__/${HOSTNAME}/g" /usr/share/nginx/html/index.html
sed -i "s/__CONTAINER_ID__/${CONTAINER_ID}/g" /usr/share/nginx/html/index.html

echo "==================================="
echo "Test App Started"
echo "Git Commit: ${GIT_INFO}"
echo "Build Date: ${BUILD_DATE}"
echo "Hostname: ${HOSTNAME}"
echo "Container ID: ${CONTAINER_ID}"
echo "==================================="

# Execute the CMD
exec "$@"
