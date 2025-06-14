#!/bin/bash

# Continue Docker Development Environment Controller
set -e

echo "🐳 Continue Docker Development Controller"
echo "========================================="

# Function to show usage
usage() {
    echo "Usage: $0 [ENVIRONMENT] [COMMAND]"
    echo ""
    echo "Environments:"
    echo "  full-project   - Complete VS Code extension development"
    echo "  frontend       - Frontend-only development (React/Vite/Storybook)"
    echo "  ml-agent       - ML agent development (Python/LangChain)"
    echo ""
    echo "Commands:"
    echo "  start          - Start the development environment"
    echo "  stop           - Stop the development environment"
    echo "  restart        - Restart the development environment"
    echo "  logs           - Show logs"
    echo "  shell          - Open shell in container"
    echo "  build          - Build Docker images"
    echo "  clean          - Clean up containers and volumes"
    echo ""
    echo "Examples:"
    echo "  $0 full-project start    # Start full VS Code extension development"
    echo "  $0 frontend start        # Start frontend-only development"
    echo "  $0 ml-agent start        # Start ML agent development"
    echo "  $0 full-project shell    # Open shell in full project container"
    echo ""
    echo "Quick Start Guide:"
    echo "==================="
    echo "1. Full Project Development (VS Code Extension):"
    echo "   $0 full-project start"
    echo "   → VS Code: http://localhost:8080"
    echo "   → Press F5 to debug extension"
    echo ""
    echo "2. Frontend Development (GUI Components):"
    echo "   $0 frontend start"
    echo "   → Vite: http://localhost:5173"
    echo "   → Storybook: $0 frontend storybook"
    echo ""
    echo "3. ML Agent Development (Future):"
    echo "   $0 ml-agent start"
    echo "   → FastAPI: http://localhost:8000"
    echo "   → JupyterLab: http://localhost:8888"
    echo ""
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Parse arguments
ENVIRONMENT=${1:-""}
COMMAND=${2:-""}

# Validate environment
case $ENVIRONMENT in
    "full-project"|"full"|"extension"|"vscode")
        SCRIPT_PATH="full-project/scripts/dev.sh"
        ENV_NAME="Full Project (VS Code Extension)"
        ;;
    "frontend"|"frontend-only"|"gui"|"react")
        SCRIPT_PATH="frontend-only/scripts/frontend-dev.sh"
        ENV_NAME="Frontend Only (React/Vite/Storybook)"
        ;;
    "ml-agent"|"ml"|"python"|"langchain")
        SCRIPT_PATH="ml-agent/scripts/ml-dev.sh"
        ENV_NAME="ML Agent (Python/LangChain)"
        ;;
    "")
        echo "❌ No environment specified."
        echo ""
        usage
        exit 1
        ;;
    *)
        echo "❌ Unknown environment: $ENVIRONMENT"
        echo ""
        usage
        exit 1
        ;;
esac

# Validate command
if [ -z "$COMMAND" ]; then
    echo "❌ No command specified."
    echo ""
    usage
    exit 1
fi

# Check if script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "❌ Script not found: $SCRIPT_PATH"
    echo "Make sure you're running this from the project root directory."
    exit 1
fi

# Execute the environment-specific script
echo "🚀 Running: $ENV_NAME - $COMMAND"
echo "-------------------------------------------"
echo ""

# Make script executable if it isn't already
chmod +x "$SCRIPT_PATH"

# Run the script with the command
./"$SCRIPT_PATH" "$COMMAND"

echo ""
echo "-------------------------------------------"
echo "✅ Command completed: $ENV_NAME - $COMMAND" 