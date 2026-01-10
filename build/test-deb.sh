#!/bin/bash
set -e
if ! command -v docker >/dev/null 2>&1; then
    echo "Error: Docker not found."
    exit 1
fi
if ! docker info >/dev/null 2>&1; then
    echo "Starting Docker..."
    if command -v systemctl >/dev/null 2>&1; then
        sudo systemctl start docker
    elif command -v rc-service >/dev/null 2>&1; then
        sudo rc-service docker start
    else
        echo "Error: Unable to start Docker."
        exit 1
    fi
    sleep 2
fi
DEB_FILE=$(ls ./*.deb 2>/dev/null | head -1)
if [ -z "$DEB_FILE" ]; then
    echo "Error: No .deb file found in current directory. Run build-deb.sh first."
    exit 1
fi
echo "Found .deb file: $DEB_FILE"
CONTAINER_NAME="test-debian-sudo"
echo "Starting detached Debian container..."
CONTAINER_ID=$(docker run -d --name "$CONTAINER_NAME" debian:latest tail -f /dev/null)
echo "Container started with ID: $CONTAINER_ID"
echo "Copying .deb file into container..."
docker cp "$DEB_FILE" "$CONTAINER_NAME:/root/"
echo "Setup complete."
echo "To enter the container: docker exec -it $CONTAINER_NAME /bin/bash"
echo "To stop the container: docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME"