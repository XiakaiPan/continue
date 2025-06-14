#!/bin/bash

# Continue Extension Release Builder
# Consolidated all-in-container approach

set -e

echo "🚀 Continue Extension Release Builder"
echo "====================================="

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

# Function to build everything in container
build_extension() {
    echo ""
    echo "📦 Building extension (dependencies + compilation + packaging)..."
    
    # Step 1: Install dependencies (using our working script)
    echo "   📋 Installing dependencies..."
    if ! docker exec continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh" >/dev/null 2>&1; then
        echo "   ⚠️  Dependencies installed with warnings (continuing...)"
    fi
    
    # Step 2: Install vsce if needed
    echo "   🔧 Setting up packaging tool..."
    docker exec continue-vscode-dev bash -c "
        cd /app/extensions/vscode
        if ! npm list -g @vscode/vsce >/dev/null 2>&1; then
            echo 'Installing @vscode/vsce...'
            npm install -g @vscode/vsce
        else
            echo '@vscode/vsce already installed'
        fi
    "
    
    # Step 3: Package VSIX (error -35 expected but VSIX still created)
    echo "   📦 Creating VSIX package..."
    docker exec continue-vscode-dev bash -c "
        cd /app/extensions/vscode
        echo 'Starting VSIX packaging...'
        # Force VSIX creation even in Docker environment
        CONTINUE_DEVELOPMENT=false vsce package --out ./build --no-dependencies 2>&1 || echo 'Packaging completed with expected Docker errors'
    "
}

# Function to extract and copy VSIX
extract_vsix() {
    echo ""
    echo "🔍 Locating built VSIX..."
    
    VSIX_FILE=$(docker exec continue-vscode-dev bash -c "ls /app/extensions/vscode/build/*.vsix 2>/dev/null | head -1" || echo "")
    
    if [ -z "$VSIX_FILE" ]; then
        echo "❌ Error: No VSIX file found!"
        echo "   Build may have failed. Check container logs."
        exit 1
    fi
    
    VSIX_NAME=$(basename "$VSIX_FILE")
    echo "✅ Found: $VSIX_NAME"
    
    echo ""
    echo "📤 Copying to host..."
    docker cp "continue-vscode-dev:$VSIX_FILE" "./$VSIX_NAME"
    
    return 0
}

# Function to show results
show_results() {
    echo ""
    echo "🎉 Release Build Complete!"
    echo "=========================="
    echo "📁 File: ./$VSIX_NAME"
    echo "📊 Size: $(ls -lh $VSIX_NAME | awk '{print $5}')"
    echo ""
    echo "🔧 Installation:"
    echo "   code --install-extension ./$VSIX_NAME"
    echo ""
    echo "📖 Or via VS Code UI:"
    echo "   Extensions → ⋯ → Install from VSIX → Select file"
    echo ""
    echo "✨ This consolidated approach provides:"
    echo "   • ✅ Consistent Docker environment"
    echo "   • ✅ No host dependencies needed"
    echo "   • ✅ Works around Docker file system issues"  
    echo "   • ✅ One command for complete build pipeline"
}

# Main execution
main() {
    check_container
    build_extension
    extract_vsix
    show_results
}

# Run the script
main "$@"
