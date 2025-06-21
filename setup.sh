#!/bin/bash

echo "🚀 Setting up Development Environment Container"
echo "================================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if docker compose is available
if ! command -v docker &> /dev/null || ! docker compose version &> /dev/null; then
    echo "❌ docker compose is not installed. Please install docker-compose-plugin and try again."
    exit 1
fi

echo "✅ Docker and docker compose are available"

# Build the image
echo "🔨 Building Docker image..."
docker compose build

if [ $? -eq 0 ]; then
    echo "✅ Image built successfully"
else
    echo "❌ Failed to build image"
    exit 1
fi

# Start the container
echo "🚀 Starting container..."
docker compose up -d

if [ $? -eq 0 ]; then
    echo "✅ Container started successfully"
else
    echo "❌ Failed to start container"
    exit 1
fi

# Wait a moment for SSH to start
echo "⏳ Waiting for SSH service to start..."
sleep 5

# Check if container is running
if docker compose ps | grep -q "Up"; then
    echo "✅ Container is running"
    echo ""
    echo "🎉 Development Environment is ready!"
    echo "================================================"
    echo "SSH Connection:"
    echo "  ssh developer@localhost -p 2222"
    echo "  Password: developer"
    echo ""
    echo "VS Code/Cursor Connection:"
    echo "  1. Install 'Remote - SSH' extension"
    echo "  2. Connect to: developer@localhost:2222"
    echo "  3. Password: developer"
    echo ""
    echo "Port Mappings:"
    echo "  SSH: localhost:2222"
    echo "  HTTP: localhost:80"
    echo "  Dev Server: localhost:8000"
    echo "  Alt Dev Server: localhost:8080"
    echo ""
    echo "Workspace: ./workspace (mounted to /home/developer/dev/workspace)"
    echo ""
    echo "Useful commands:"
    echo "  docker compose logs -f    # View logs"
    echo "  docker compose down       # Stop container"
    echo "  docker compose up -d      # Start container"
else
    echo "❌ Container failed to start properly"
    echo "Check logs with: docker compose logs"
    exit 1
fi 