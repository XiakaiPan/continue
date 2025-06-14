#!/bin/bash

# Continue VS Code Extension Development Setup Script
# This runs when the container starts to follow CONTRIBUTING.md workflow

set -e

echo "🚀 Continue VS Code Extension Development Environment"
echo "📋 Following CONTRIBUTING.md workflow..."
echo ""

# Check if dependencies are already installed
if [ ! -d "/app/node_modules" ] || [ ! -d "/app/core/node_modules" ] || [ ! -d "/app/gui/node_modules" ] || [ ! -d "/app/extensions/vscode/node_modules" ]; then
    echo "📦 Step 1: Installing all dependencies using VS Code task equivalent..."
    echo "   (This follows: Tasks: Run Task -> install-all-dependencies)"
    echo ""
    
    # Run the install dependencies script directly
    if [ -f "/app/scripts/install-dependencies.sh" ]; then
        echo "Running /app/scripts/install-dependencies.sh..."
        cd /app && ./scripts/install-dependencies.sh
    else
        echo "❌ install-dependencies.sh not found! Please check your workspace."
        exit 1
    fi
    
    echo ""
    echo "✅ Dependencies installation completed!"
else
    echo "✅ Dependencies already installed, skipping installation."
fi

echo ""
echo "🐛 Step 2: Ready for Extension Debugging!"
echo ""
echo "To debug the extension (following CONTRIBUTING.md):"
echo "1. Open VS Code at http://localhost:8080"
echo "2. Switch to 'Run and Debug' view (Ctrl+Shift+D)"
echo "3. Select 'Launch extension' from dropdown"
echo "4. Press F5 or click the play button"
echo "5. This will open a new VS Code window with the extension installed"
echo ""
echo "📁 Debugging files location:"
echo "   - Launch config: .vscode/launch.json"
echo "   - Tasks config: .vscode/tasks.json"
echo "   - Extension host will use: ${CONTINUE_GLOBAL_DIR:-/app/extensions/.continue-debug}"
echo "   - Manual testing: manual-testing-sandbox/"
echo ""
echo "🔧 Available ports:"
echo "   - 8080: Code Server (VS Code in browser)"
echo "   - 3000: Core server"
echo "   - 5173: GUI dev server (Vite)"
echo "   - 9229: Node.js debugger"
echo "   - 5900: VNC (if needed)"
echo ""
echo "🎯 Success criteria: Extension debugs successfully with F5!"
echo ""

# Start supervisor to manage services
echo "🔄 Starting services with supervisor..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf 