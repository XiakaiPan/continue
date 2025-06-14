#!/bin/bash

# Continue VS Code Extension Development Script
# Following CONTRIBUTING.md workflow

set -e

echo "🚀 Continue VS Code Extension Development Environment"
echo "📋 Following CONTRIBUTING.md workflow..."
echo ""

# Check if we're in a Docker container
if [ -f /.dockerenv ]; then
    echo "✅ Running inside Docker container"
    echo "🌐 Code Server available at: http://localhost:8080"
    echo "🔍 VNC available at: localhost:5900 (if needed for debugging)"
    echo ""
fi

# Parse command
COMMAND=${1:-"setup"}

case $COMMAND in
    "start")
        echo "🔧 Starting Continue VS Code Extension Development Environment..."
        cd "$(dirname "$0")/../compose" && docker-compose --profile vscode up -d continue-vscode-dev
        
        echo ""
        echo "✅ Environment started successfully!"
        echo ""
        echo "🚀 Following CONTRIBUTING.md Workflow:"
        echo "📋 Step 1: Dependencies will be installed when you enter container"
        echo "📋 Step 2: Ready for extension debugging"
        echo ""
        echo "🌐 VS Code Server: http://localhost:8080" 
        echo "🎯 GUI Dev Server: http://localhost:5173"
        echo "🔧 Core Server: http://localhost:3000"
        echo "🐛 Debug Port: 9229"
        echo ""
        echo "📖 Debug the Extension:"
        echo "  1. Open http://localhost:8080 in your browser"
        echo "  2. Go to 'Run and Debug' view (Ctrl+Shift+D)"
        echo "  3. Select 'Launch extension' from dropdown"
        echo "  4. Press F5 or click play button"
        echo "  5. New VS Code window opens with extension installed"
        echo ""
        echo "🎯 Success: Extension debugs with F5!"
        echo ""
        echo "📋 Useful Commands:"
        echo "  - Setup dependencies: $0 setup"
        echo "  - View logs: $0 logs"
        echo "  - Open shell: $0 shell"
        echo "  - Stop environment: $0 stop"
        ;;
        
    "stop")
        echo "🛑 Stopping Continue VS Code Extension Development Environment..."
        cd "$(dirname "$0")/../compose" && docker-compose --profile vscode down
        echo "✅ Environment stopped."
        ;;
        
    "restart")
        echo "🔄 Restarting Continue VS Code Extension Development Environment..."
        COMPOSE_DIR="$(dirname "$0")/../compose"
        cd "$COMPOSE_DIR" && docker-compose --profile vscode down
        cd "$COMPOSE_DIR" && docker-compose --profile vscode up -d continue-vscode-dev
        echo "✅ Environment restarted."
        ;;
        
    "logs")
        echo "📋 Showing logs from VS Code development environment..."
        cd "$(dirname "$0")/../compose" && docker-compose --profile vscode logs -f continue-vscode-dev
        ;;
        
    "shell")
        echo "🐚 Opening shell in VS Code development container..."
        cd "$(dirname "$0")/../compose" && docker-compose --profile vscode exec continue-vscode-dev bash
        ;;
        
    "build")
        echo "🔨 Building VS Code extension development image..."
        cd "$(dirname "$0")/../compose" && docker-compose --profile vscode build continue-vscode-dev
        echo "✅ Image built successfully."
        ;;
        
    "clean")
        echo "🧹 Cleaning up containers and volumes..."
        cd "$(dirname "$0")/../compose" && docker-compose --profile vscode down -v
        echo "✅ Cleanup completed."
        ;;
        
    "setup"|"install")
        # This is the dependency installation part (moved from above)
        echo "📦 Installing all dependencies using VS Code task equivalent..."
        echo "   (This follows: Tasks: Run Task -> install-all-dependencies)"
        echo ""
        
        # Run the install dependencies script directly
        if [ -f "./scripts/install-dependencies.sh" ]; then
            echo "Running ./scripts/install-dependencies.sh..."
            ./scripts/install-dependencies.sh
        else
            echo "❌ install-dependencies.sh not found! Please check your workspace."
            exit 1
        fi
        
        echo ""
        echo "✅ Dependencies installation completed!"
        ;;
        
    *)
        echo "❌ Unknown command: $COMMAND"
        echo ""
        echo "Available commands:"
        echo "  start    - Start the development environment"
        echo "  stop     - Stop the development environment"
        echo "  restart  - Restart the development environment"
        echo "  logs     - Show logs"
        echo "  shell    - Open shell in container"
        echo "  build    - Build Docker images"
        echo "  clean    - Clean up containers and volumes"
        echo "  setup    - Install dependencies (CONTRIBUTING.md workflow)"
        ;;
esac 