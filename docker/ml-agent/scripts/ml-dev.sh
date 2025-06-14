#!/bin/bash

# Continue ML Agent Development Script
set -e

echo "🤖 Continue ML Agent Development Environment"
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
    echo "  start         - Start full ML agent environment (FastAPI + JupyterLab)"
    echo "  api           - Start FastAPI server only"
    echo "  jupyter       - Start JupyterLab only"
    echo "  with-redis    - Start with Redis cache/message queue"
    echo "  stop          - Stop all services"
    echo "  restart       - Restart services"
    echo "  logs          - Show logs"
    echo "  shell         - Open shell in container"
    echo "  build         - Build Docker image"
    echo "  clean         - Clean up containers and volumes"
    echo "  test          - Run tests"
    echo ""
    echo "Development modes:"
    echo "  1. Full environment:  $0 start"
    echo "  2. API only:         $0 api"
    echo "  3. Jupyter only:     $0 jupyter"
    echo "  4. With Redis:       $0 with-redis"
    echo ""
}

# Parse command
COMMAND=${1:-"help"}

case $COMMAND in
    "start")
        echo "🚀 Starting ML Agent development environment..."
        cd ../compose && docker-compose up -d ml-agent-dev
        
        echo ""
        echo "✅ ML Agent environment started!"
        echo ""
        echo "🚀 FastAPI Server: http://localhost:8000"
        echo "📊 JupyterLab: http://localhost:8888"
        echo ""
        echo "📖 API Endpoints:"
        echo "  GET  /health - Health check"
        echo "  POST /agent/query - Agent query endpoint"
        echo ""
        echo "📋 Useful Commands:"
        echo "  - View logs: $0 logs"
        echo "  - Open shell: $0 shell"
        echo "  - Stop environment: $0 stop"
        echo "  - Run tests: $0 test"
        ;;
        
    "api")
        echo "🚀 Starting FastAPI server only..."
        cd ../compose && docker-compose --profile api-only up -d ml-agent-api
        
        echo ""
        echo "✅ FastAPI server started!"
        echo ""
        echo "🚀 FastAPI Server: http://localhost:8001"
        echo ""
        echo "📖 API Endpoints:"
        echo "  GET  /health - Health check"
        echo "  POST /agent/query - Agent query endpoint"
        ;;
        
    "jupyter")
        echo "📊 Starting JupyterLab only..."
        cd ../compose && docker-compose --profile jupyter-only up -d ml-agent-jupyter
        
        echo ""
        echo "✅ JupyterLab started!"
        echo ""
        echo "📊 JupyterLab: http://localhost:8889"
        echo ""
        echo "💡 Use JupyterLab for:"
        echo "  - ML model experimentation"
        echo "  - Data analysis and visualization"
        echo "  - LangChain agent development"
        ;;
        
    "with-redis")
        echo "🚀 Starting ML Agent environment with Redis..."
        cd ../compose && docker-compose --profile with-redis up -d
        
        echo ""
        echo "✅ ML Agent environment with Redis started!"
        echo ""
        echo "🚀 FastAPI Server: http://localhost:8000"
        echo "📊 JupyterLab: http://localhost:8888"
        echo "📦 Redis: localhost:6379"
        echo ""
        echo "💡 Redis available for:"
        echo "  - Caching agent responses"
        echo "  - Message queue for async tasks"
        echo "  - Session storage"
        ;;
        
    "stop")
        echo "🛑 Stopping ML Agent development environment..."
        cd ../compose && docker-compose down
        echo "✅ Environment stopped."
        ;;
        
    "restart")
        echo "🔄 Restarting ML Agent development environment..."
        cd ../compose && docker-compose down
        cd ../compose && docker-compose up -d
        echo "✅ Environment restarted."
        ;;
        
    "logs")
        echo "📋 Showing logs from ML Agent development environment..."
        cd ../compose && docker-compose logs -f
        ;;
        
    "shell")
        echo "🐚 Opening shell in ML Agent development container..."
        # Try to exec into the running container
        if docker ps --format "table {{.Names}}" | grep -q "continue-ml-agent"; then
            CONTAINER=$(docker ps --format "{{.Names}}" | grep "continue-ml-agent" | head -1)
            docker exec -it $CONTAINER bash
        else
            echo "No running ML agent container found. Starting a temporary one..."
            cd ../compose && docker-compose run --rm ml-agent-dev bash
        fi
        ;;
        
    "build")
        echo "🔨 Building ML Agent development image..."
        cd ../compose && docker-compose build
        echo "✅ Image built successfully."
        ;;
        
    "test")
        echo "🧪 Running ML Agent tests..."
        if docker ps --format "table {{.Names}}" | grep -q "continue-ml-agent"; then
            CONTAINER=$(docker ps --format "{{.Names}}" | grep "continue-ml-agent" | head -1)
            docker exec -it $CONTAINER pytest tests/ -v
        else
            echo "Starting temporary container for testing..."
            cd ../compose && docker-compose run --rm ml-agent-dev pytest tests/ -v
        fi
        ;;
        
    "clean")
        echo "🧹 Cleaning up containers and volumes..."
        cd ../compose && docker-compose down -v
        docker system prune -f
        echo "✅ Cleanup completed."
        echo ""
        echo "⚠️ Note: This will remove all ML models and data."
        echo "Make sure to backup important data before cleaning."
        ;;
        
    "help"|*)
        usage
        ;;
esac 