#!/bin/bash

# Continue Frontend-Only Development Script
set -e

echo "🎨 Continue Frontend Development Environment"
echo "============================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Function to show usage
usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start         - Start Vite development server"
    echo "  storybook     - Start Storybook development server"
    echo "  combined      - Start both Vite and Storybook"
    echo "  stop          - Stop all services"
    echo "  restart       - Restart services"
    echo "  logs          - Show logs"
    echo "  shell         - Open shell in container"
    echo "  build         - Build Docker image"
    echo "  clean         - Clean up containers and volumes"
    echo ""
    echo "Development modes:"
    echo "  1. Vite only:     $0 start"
    echo "  2. Storybook only: $0 storybook"
    echo "  3. Combined:      $0 combined"
    echo ""
}

# Parse command
COMMAND=${1:-"help"}

case $COMMAND in
    "start")
        echo "🚀 Starting Vite development server..."
        cd ../compose && docker-compose up -d frontend-vite
        
        echo ""
        echo "✅ Vite development server started!"
        echo ""
        echo "📦 Vite Dev Server: http://localhost:5173"
        echo ""
        echo "📋 Useful Commands:"
        echo "  - View logs: $0 logs"
        echo "  - Open shell: $0 shell"
        echo "  - Stop server: $0 stop"
        ;;
        
    "storybook")
        echo "📚 Starting Storybook development server..."
        cd ../compose && docker-compose --profile storybook up -d frontend-storybook
        
        echo ""
        echo "✅ Storybook development server started!"
        echo ""
        echo "📚 Storybook: http://localhost:6006"
        echo ""
        echo "📋 Useful Commands:"
        echo "  - View logs: $0 logs"
        echo "  - Open shell: $0 shell"
        echo "  - Stop server: $0 stop"
        ;;
        
    "combined")
        echo "🚀 Starting combined frontend development environment..."
        cd ../compose && docker-compose --profile combined up -d frontend-dev
        
        echo ""
        echo "✅ Combined frontend environment started!"
        echo ""
        echo "📦 Vite Dev Server: http://localhost:5173"
        echo "📚 Storybook: http://localhost:6006"
        echo ""
        echo "📋 Useful Commands:"
        echo "  - View logs: $0 logs"
        echo "  - Open shell: $0 shell"
        echo "  - Stop servers: $0 stop"
        ;;
        
    "stop")
        echo "🛑 Stopping frontend development environment..."
        cd ../compose && docker-compose down
        echo "✅ Environment stopped."
        ;;
        
    "restart")
        echo "🔄 Restarting frontend development environment..."
        cd ../compose && docker-compose down
        cd ../compose && docker-compose up -d
        echo "✅ Environment restarted."
        ;;
        
    "logs")
        echo "📋 Showing logs from frontend development environment..."
        cd ../compose && docker-compose logs -f
        ;;
        
    "shell")
        echo "🐚 Opening shell in frontend development container..."
        # Try to exec into the running container
        if docker ps --format "table {{.Names}}" | grep -q "continue-frontend"; then
            CONTAINER=$(docker ps --format "{{.Names}}" | grep "continue-frontend" | head -1)
            docker exec -it $CONTAINER bash
        else
            echo "No running frontend container found. Starting a temporary one..."
            cd ../compose && docker-compose run --rm frontend-vite bash
        fi
        ;;
        
    "build")
        echo "🔨 Building frontend development image..."
        cd ../compose && docker-compose build
        echo "✅ Image built successfully."
        ;;
        
    "clean")
        echo "🧹 Cleaning up containers and volumes..."
        cd ../compose && docker-compose down -v
        docker system prune -f
        echo "✅ Cleanup completed."
        ;;
        
    "help"|*)
        usage
        ;;
esac 