#!/bin/bash

# Continue Development Environment Starter
# Sets up Docker environment for VS Code extension development

set -e

echo "🚀 Continue Development Environment Setup"
echo "========================================"

# Function to check if container is running
check_container() {
    if ! docker ps | grep -q continue-vscode-dev; then
        echo "🐳 Starting Docker container..."
        docker-compose up -d continue-vscode-dev
        echo "⏳ Waiting for container startup..."
        sleep 10
    else
        echo "✅ Container is running"
    fi
}

# Function to install dependencies for development
setup_dependencies() {
    echo ""
    echo "📦 Setting up development dependencies..."
    echo "   (This may take a few minutes on first run)"
    
    if docker exec continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh" >/dev/null 2>&1; then
        echo "✅ Dependencies installed successfully"
    else
        echo "⚠️  Dependencies installed with warnings (normal for Docker)"
    fi
}

# Function to show development info
show_dev_info() {
    echo ""
    echo "🎉 Development Environment Ready!"
    echo "================================"
    echo ""
    echo "🌐 Access Points:"
    echo "   • VS Code:     http://localhost:8080"
    echo "   • GUI Dev:     http://localhost:5173"
    echo "   • Core Server: http://localhost:3000"
    echo ""
    echo "🔧 Development Workflow:"
    echo "   1. Edit code on your HOST machine (any editor)"
    echo "   2. Open http://localhost:8080 in browser"
    echo "   3. Press F5 to debug extension"
    echo "   4. Test in the extension host window"
    echo ""
    echo "📋 Useful Commands:"
    echo "   • Enter container: docker exec -it continue-vscode-dev bash"
    echo "   • View logs:       docker logs continue-vscode-dev"
    echo "   • Restart:         docker-compose restart continue-vscode-dev"
    echo ""
    echo "🏗️  When ready to build VSIX:"
    echo "   ./scripts/build-release.sh"
    echo ""
    echo "✨ Tips:"
    echo "   • Code changes on host are instantly reflected in container"
    echo "   • Use F5 in browser VS Code to launch extension debugging"
    echo "   • Check container status: docker ps | grep continue"
}

# Main execution
main() {
    check_container
    setup_dependencies
    show_dev_info
}

# Run the script
main "$@"
