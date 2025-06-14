#!/bin/bash

# Continue Development Environment Cleanup
# Stops containers and cleans up build artifacts

echo "🧹 Continue Development Environment Cleanup"
echo "==========================================="

# Stop containers
echo "🛑 Stopping Docker containers..."
if docker ps | grep -q continue-vscode-dev; then
    docker-compose down
    echo "✅ Containers stopped"
else
    echo "✅ No containers running"
fi

# Clean build artifacts
echo ""
echo "🗑️  Cleaning build artifacts..."

# Remove VSIX files
if ls *.vsix >/dev/null 2>&1; then
    rm -f *.vsix
    echo "   ✅ Removed VSIX files"
else
    echo "   ✅ No VSIX files to remove"
fi

# Show results
echo ""
echo "🎉 Cleanup Complete!"
echo "==================="
echo ""
echo "🔄 To restart development:"
echo "   ./dev-start.sh"
echo ""
echo "🏗️  To build release:"
echo "   ./release.sh"
