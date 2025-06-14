# Full Project Development Environment

Complete VS Code extension development with all components working together.

## 🔥 Quick Reference

### Development Best Practices
- **✅ Edit Code**: On your HOST machine (local VS Code/IDE)
- **✅ Debug Extension**: In CONTAINER (http://localhost:8080 → F5)
- **🚨 Build VSIX**: In CONTAINER (host lacks node_modules) or setup host dependencies

### Critical File Structure Understanding
- **📄 Source Code**: Shared between host/container (live sync)
- **📦 node_modules**: Container-only (isolated Docker volumes)
- **🏗️ Built Artifacts**: Depend on container's node_modules

### Common Issues Fixed
- **Error -35**: File system issues → Fixed with Docker-aware scripts
- **esbuild Mismatch**: Version conflicts → Fixed with environment detection
- **VSIX Packaging**: Docker issues → Skip in development, build properly for release

### VSIX Release Process  
```bash
# Development: Skip VSIX (Docker) ✅
docker exec -it continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh"

# Release: One-Command Build (Consolidated Approach) ✅
./build-vsix.sh
# → continue-{VERSION}.vsix (in project root)
```

## 🎯 What This Environment Provides

- **VS Code Extension**: Full debugging and development support
- **Core (TypeScript)**: Continue AI core engine
- **GUI (React)**: Frontend components and UI
- **Binary**: Packaging and distribution tools
- **Extension Host**: Complete VS Code extension debugging

## 🚀 Quick Start

```bash
# From project root
./docker/continue-docker.sh full-project start

# Or run directly
cd docker/full-project/scripts
./dev.sh start
```

**Access Points:**
- **VS Code Server**: http://localhost:8080
- **GUI Dev Server**: http://localhost:5173  
- **Core Server**: http://localhost:3000
- **Debug Port**: 9229

## 🔧 Development Workflow

### 1. Start Environment
```bash
./docker/continue-docker.sh full-project start
```

### 2. Open VS Code
Open http://localhost:8080 in your browser

### 3. Start Development Services
In VS Code terminal:
```bash
# Start TypeScript watcher (monitors all projects)
supervisorctl start tsc-watch

# Start GUI development server
supervisorctl start gui-dev
```

### 4. Debug Extension
1. Press `F5` or open Command Palette → "Debug: Start Debugging"
2. Select **"Launch extension"** configuration
3. New VS Code window opens with your extension loaded
4. Test your extension in the Extension Host window

### 5. Make Changes
- Edit code in browser VS Code
- TypeScript changes auto-compile
- GUI changes hot-reload
- Extension reloads automatically

## 🐳 Docker Architecture

### Images
- **Base**: Node.js 20.19.0 Alpine
- **Features**: Code Server, X11 Virtual Display, Supervisor
- **Tools**: TypeScript, esbuild, Vite, testing tools

### Services
- **continue-vscode-dev**: Main development environment
- **continue-dev**: Basic development (fallback)
- **continue-gui**: GUI-only development

### Supervisor Services
```bash
supervisorctl status  # View all services

# Individual services:
code-server    # VS Code web interface (auto-start)
tsc-watch      # TypeScript watcher (manual start)  
gui-dev        # GUI development server (manual start)
xvfb          # Virtual display (auto-start)
```

## 📁 File Structure

```
full-project/
├── dockerfiles/
│   ├── Dockerfile.production     # Production build
│   ├── Dockerfile.dev           # Development build
│   └── Dockerfile.vscode-dev    # VS Code development
├── compose/
│   └── docker-compose.yml       # Service orchestration
└── scripts/
    └── dev.sh                   # Management script
```

## 🛠️ Available Commands

```bash
# Environment management
./dev.sh start      # Start VS Code development environment
./dev.sh stop       # Stop environment
./dev.sh restart    # Restart environment
./dev.sh shell      # Open shell in container
./dev.sh logs       # View logs
./dev.sh build      # Build Docker image
./dev.sh clean      # Clean up containers and volumes

# Inside container
supervisorctl start tsc-watch    # Start TypeScript watcher
supervisorctl start gui-dev      # Start GUI dev server
supervisorctl status             # Check service status
supervisorctl tail -f tsc-watch  # View TypeScript logs
```

## 🔍 Debugging Features

### Extension Debugging
- **F5 Launch**: Starts extension in new VS Code window
- **Breakpoints**: Full TypeScript debugging support
- **Hot Reload**: Changes trigger automatic recompilation
- **Source Maps**: Debug original TypeScript code

### Launch Configurations
- **"Launch extension"**: Main extension debugging
- **"Run tests"**: Extension test execution  
- **"Debug Jest Tests"**: Core library testing
- **"Vite"**: GUI debugging

### Port Mapping
| Service | Container | Host | Purpose |
|---------|-----------|------|---------|
| Code Server | 8080 | 8080 | VS Code web interface |
| GUI Dev | 5173 | 5173 | Vite development server |
| Core Server | 3000 | 3000 | Extension backend |
| Debugger | 9229 | 9229 | Node.js debugging |

## 🔧 Troubleshooting & Docker Development Guide

### 🐛 Common Docker Issues & Fixes

#### **Error -35 (Unknown system error -35)**
**Issue**: File system errors during packaging or copying operations.
**Root Cause**: Docker volume mounting issues between host and container.

**Solutions Applied**:
1. **JetBrains Copy Error**: Made non-critical for VS Code development
2. **VSIX Packaging Error**: Skip packaging in Docker environments (not needed for F5 debugging)
3. **File System**: Use Docker-aware file operations

**Code Locations**:
- `extensions/vscode/scripts/prepackage.js` - JetBrains copy graceful handling
- `scripts/install-dependencies.sh` - Skip VSIX packaging in Docker

#### **esbuild Version Mismatch**
**Issue**: `Host version "0.17.19" does not match binary version "0.19.11"`
**Root Cause**: ARM64 Docker containers getting incompatible pre-built binaries.

**Solution Applied**:
- Docker environment detection in `prepackage.js`
- Force npm install approach instead of custom binary downloads
- Environment variables: `CONTINUE_DEVELOPMENT=true` or `/.dockerenv` detection

**Fix Location**: `extensions/vscode/scripts/prepackage.js:365+`

#### **Network Errors During Binary Downloads**
**Issue**: `ECONNRESET` errors when downloading lancedb, sqlite3, etc.
**Impact**: Non-critical for extension debugging
**Workaround**: Continue without these dependencies for F5 debugging

### 🏠 Development Location: Host vs Container?

#### **Recommended Approach: Host Development + Container Debugging**

**✅ Best Practice**:
```bash
# 1. Develop on HOST (your local machine)
# - Use your favorite IDE/VS Code locally
# - Edit files directly on host filesystem
# - Git operations on host

# 2. Debug in CONTAINER  
# - Run Docker container for integrated debugging
# - Use F5 to launch extension in container
# - Access via http://localhost:8080
```

**Why This Works**:
- **Volume Mounting**: Container sees live host file changes
- **Hot Reload**: Changes automatically reflected in container
- **No Sync Issues**: No file synchronization problems
- **Tool Compatibility**: Use host tools without Docker limitations

#### **Development Workflow**:
```bash
# On HOST machine
cd /path/to/continue
git checkout -b my-feature

# Start Docker environment
docker exec -it continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh"

# Edit files on HOST with your preferred editor
code extensions/vscode/src/extension.ts

# Debug in CONTAINER
# 1. Open http://localhost:8080
# 2. Press F5 to launch extension
# 3. Test changes in extension host window
```

#### **Alternative: Pure Container Development**
```bash
# Access container VS Code directly
open http://localhost:8080

# All development inside container
# - Less ideal due to potential Docker file system issues
# - Good for quick testing or CI/CD environments
```

### 📦 VSIX Building & Release Process

#### **For Development (Docker)**
```bash
# VSIX packaging is SKIPPED in Docker (by design)
# This avoids error -35 file system issues
# F5 debugging works without VSIX packaging

docker exec -it continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh"
# Shows: "🐳 Docker environment detected - skipping VSIX packaging"
```

#### **🚨 REALITY CHECK: VSIX Building is Problematic in Docker**

**Problem**: Error -35 affects **ALL** Docker VSIX packaging attempts
- ❌ Building in container: `vsce package` fails with error -35
- ❌ Building on host: Missing container-only `node_modules`
- ✅ **Solution**: Copy built artifacts from container to host, then package

#### **✅ Working VSIX Build Process**

**Step 1: Build in Container (Dependencies & Compilation)**
```bash
# Build all dependencies and compile everything in container
docker exec -it continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh"

# Verify build artifacts exist
docker exec -it continue-vscode-dev ls -la /app/extensions/vscode/out/
docker exec -it continue-vscode-dev ls -la /app/extensions/vscode/gui/
```

**Step 2: Copy Built Artifacts to Host**
```bash
# Copy essential built artifacts from container to host
docker cp continue-vscode-dev:/app/extensions/vscode/out ./extensions/vscode/
docker cp continue-vscode-dev:/app/extensions/vscode/gui ./extensions/vscode/
docker cp continue-vscode-dev:/app/extensions/vscode/bin ./extensions/vscode/
docker cp continue-vscode-dev:/app/extensions/vscode/models ./extensions/vscode/

# Copy node_modules (the critical missing piece)
docker cp continue-vscode-dev:/app/extensions/vscode/node_modules ./extensions/vscode/
```

**Step 3: Package on Host (Avoids Docker File System Issues)**
```bash
# Now package on host with all dependencies present
cd extensions/vscode

# Install @vscode/vsce if not present
npm install -g @vscode/vsce

# Package extension (now works because dependencies are present)
vsce package --out ./build --no-dependencies

# Find built VSIX
ls -la build/continue-*.vsix
```

#### **📁 File & Directory Structure Explained**

```
Host Machine (your local filesystem):
├── 📁 continue/
│   ├── 📄 src/                      # ✅ Source code (shared)
│   ├── 📄 package.json              # ✅ Config (shared)
│   ├── 📁 node_modules/             # ❌ EMPTY (Docker isolated)
│   ├── 📁 out/                      # ❌ Missing (container-built)
│   ├── 📁 gui/                      # ❌ Missing (container-built)
│   └── 📁 build/                    # ✅ VSIX output (after copying)

Container (/app/extensions/vscode/):
├── 📁 continue/
│   ├── 📄 src/                      # ✅ Source code (mounted)
│   ├── 📄 package.json              # ✅ Config (mounted)
│   ├── 📁 node_modules/             # ✅ FULL (825+ packages)
│   ├── 📁 out/                      # ✅ Compiled TypeScript
│   ├── 📁 gui/                      # ✅ Built React app
│   └── 📁 bin/                      # ✅ Native binaries
```

**Why This Structure Exists**:
- **Source Sharing**: `- ../../..:/app` mounts host code into container
- **Dependency Isolation**: `- /app/node_modules` creates container-only volume
- **Build Artifacts**: Generated in container, need to be copied to host for packaging

#### **🔄 For Any Developer - Complete Workflow**
```bash
# 1. Clone and start (works on any machine)
git clone https://github.com/continuedev/continue.git
cd continue
docker-compose up -d continue-vscode-dev

# 2. Develop (edit code on host, debug in container)
docker exec -it continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh"
# Open http://localhost:8080, press F5 to debug

# 3. Build release VSIX (when needed) - ONE COMMAND!
./build-vsix.sh
# → continue-{VERSION}.vsix ready to install

# Install: code --install-extension continue-{VERSION}.vsix
```

#### **Install Built VSIX**:
```bash
# Method 1: VS Code UI
# Right-click .vsix file → "Install Extension VSIX"

# Method 2: Command line
code --install-extension extensions/vscode/build/continue-{VERSION}.vsix

# Method 3: VS Code Command Palette
# Extensions: Install from VSIX...
```

### 🔍 File System Debugging

#### **Check Docker Volume Mounting**:
```bash
# Verify host files are visible in container
docker exec -it continue-vscode-dev ls -la /app/extensions/vscode/src/

# Check if changes on host appear in container
echo "test" > test.txt
docker exec -it continue-vscode-dev cat /app/test.txt
```

#### **Extension Host Issues**
```bash
# Check virtual display
echo $DISPLAY  # should show :99

# Restart X11 server
supervisorctl restart xvfb

# Check extension host logs
supervisorctl tail -f code-server
```

#### **Build Issues**
```bash
# Check TypeScript compilation
supervisorctl tail -f tsc-watch

# Manual TypeScript build
cd /app && npm run tsc:watch

# Restart compilation
supervisorctl restart tsc-watch
```

#### **GUI Issues**
```bash
# Check GUI development server
supervisorctl tail -f gui-dev

# Restart GUI server
supervisorctl restart gui-dev

# Check ports
netstat -tlnp | grep 5173
```

### 🌟 Environment Reusability for Any Developer

#### **✅ What Works Out of the Box**
```bash
# Any developer can clone and run immediately
git clone https://github.com/continuedev/continue.git
cd continue

# Start development environment (works on any machine)
docker-compose up -d continue-vscode-dev

# Install dependencies and start debugging
docker exec -it continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh"

# Open http://localhost:8080 and press F5 to debug
```

**Why This Works for Everyone:**
- **No Host Dependencies**: Docker handles all Node.js/npm dependencies
- **Consistent Environment**: Same Node.js version, same packages, same tools
- **Cross-Platform**: Works on macOS, Linux, Windows (with Docker)
- **Isolated**: Won't interfere with developer's existing Node.js setup

#### **📋 Prerequisites for Any Developer**
```bash
# Only requirement: Docker and Docker Compose
# Check if installed:
docker --version
docker-compose --version

# If not installed, see: https://docs.docker.com/get-docker/
```

#### **🔄 Fresh Developer Workflow**
```bash
# 1. Clone project
git clone https://github.com/continuedev/continue.git
cd continue

# 2. Start Docker environment
docker-compose up -d continue-vscode-dev

# 3. Install dependencies (one-time setup)
docker exec -it continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh"

# 4. Develop! 
# - Edit code on host with any editor
# - Debug in container at http://localhost:8080
# - Press F5 to launch extension

# 5. Build release (if needed)
docker exec -it continue-vscode-dev bash -c "
  cd /app/extensions/vscode && 
  CONTINUE_DEVELOPMENT=false npm run package
"
docker cp continue-vscode-dev:/app/extensions/vscode/build/continue-*.vsix ./
```

#### **🎯 Environment Consistency**
**Same for all developers:**
- Node.js 20.19.0
- npm packages locked to specific versions  
- esbuild, TypeScript, Vite versions consistent
- VS Code server version consistent
- Development tools and paths identical

**Platform-Specific Handling:**
- Architecture detection (x64, arm64)
- Binary downloads (esbuild, sqlite3, etc.)
- File system differences handled automatically

### 🚀 Pro Tips

#### **Speed Up Development**:
```bash
# Keep container running, restart specific services
supervisorctl restart tsc-watch
supervisorctl restart gui-dev

# Don't rebuild Docker image unless Dockerfile changes
# Volume mounting means code changes are instant
```

#### **Debugging Performance**:
```bash
# Monitor resource usage
docker stats continue-vscode-dev

# Check container health
docker exec -it continue-vscode-dev supervisorctl status
```

#### **Clean Reset**:
```bash
# Nuclear option - restart everything
docker-compose down
docker-compose up -d
docker exec -it continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh"
```

#### **Team Development**:
```bash
# All developers use same commands
# No "works on my machine" issues
# Consistent build outputs
# Same debugging experience
```

## 🌟 Advanced Usage

### Custom Configuration
- Supervisor configs: `/etc/supervisor/conf.d/`
- Service logs: `/var/log/`
- VS Code settings: `/root/.local/share/code-server/`

### Extension Packaging
```bash
# Package extension
cd /app/extensions/vscode
npm run package

# View built extension
ls -la *.vsix
```

### Testing
```bash
# Run extension tests
cd /app/extensions/vscode
npm run test

# Run core tests
cd /app/core
npm test
```

## 📝 Environment Variables

```bash
NODE_ENV=development
CONTINUE_DEVELOPMENT=true
CONTINUE_GLOBAL_DIR=/app/extensions/.continue-debug
DISPLAY=:99
CHOKIDAR_USEPOLLING=true
```

## 🔄 Integration with Other Environments

This environment is designed to work with the complete project. For focused development:

- **Frontend Only**: Use `frontend-only` environment for GUI components
- **ML Agent**: Use `ml-agent` environment for Python/AI development
- **Integration Testing**: Use this environment to test all components together 