# Continue Docker Development Environments

This directory contains Docker configurations for different development scenarios of the Continue AI code assistant project.

## 🏗️ Architecture Overview

The Docker setup is organized into three main development environments:

```
docker/
├── full-project/     # Complete project development (Extension + GUI + Core)
├── frontend-only/    # Lightweight React/Vite/Storybook for GUI development
├── ml-agent/         # Python/LangChain ML agent development
└── shared/           # Shared configurations and utilities
```

## 🎯 Development Environments

### 1. **Full Project Development** (`full-project/`)

**Purpose**: Complete VS Code extension development with all components working together.

**Components**:
- VS Code Extension debugging
- GUI (React/TypeScript) 
- Core (TypeScript/Node.js)
- Binary packaging
- Extension host debugging

**Use Cases**:
- VS Code extension development and debugging
- End-to-end testing
- Integration testing
- Extension packaging and distribution

### 2. **Frontend Only Development** (`frontend-only/`)

**Purpose**: Lightweight React development for GUI components.

**Components**:
- React with Vite
- Storybook for component development
- React Flow for diagram components
- Tailwind CSS
- Hot module replacement

**Use Cases**:
- UI component development
- Storybook stories creation
- React Flow diagram components
- CSS/styling development
- Fast frontend iteration

### 3. **ML Agent Development** (`ml-agent/`)

**Purpose**: Python/LangChain agent development that communicates with TypeScript.

**Components** (Future):
- Python 3.11+ environment
- LangChain framework  
- ML/AI libraries (numpy, pandas, etc.)
- HTTP API server
- Vector databases
- Model management

**Use Cases**:
- AI agent development
- LangChain integration
- ML model experimentation
- HTTP API development
- Agent-to-Extension communication

## 🚀 Quick Start

### Full Project Development
```bash
cd docker/full-project
./scripts/dev.sh start
# Access VS Code at http://localhost:8080
```

### Frontend Only Development
```bash
cd docker/frontend-only  
./scripts/frontend-dev.sh start
# Access Storybook at http://localhost:6006
# Access Vite dev at http://localhost:5173
```

### ML Agent Development (Future)
```bash
cd docker/ml-agent
./scripts/ml-dev.sh start
# Access Jupyter at http://localhost:8888
# Access API at http://localhost:8000
```

## 📁 Directory Structure

```
docker/
├── README.md                 # This file
├── .dockerignore            # Shared ignore rules
├── shared/                  # Shared configurations
│   ├── scripts/            # Common utility scripts
│   └── configs/            # Shared config files
├── full-project/           # Complete project development
│   ├── dockerfiles/        # All Dockerfiles for full project
│   ├── compose/            # Docker Compose configurations
│   ├── scripts/            # Management scripts
│   └── configs/            # Environment-specific configs
├── frontend-only/          # Lightweight frontend development
│   ├── dockerfiles/        # Frontend-specific Dockerfiles
│   ├── compose/            # Frontend Docker Compose
│   ├── scripts/            # Frontend management scripts
│   └── configs/            # Frontend configurations
└── ml-agent/               # ML agent development (future)
    ├── dockerfiles/        # Python/ML Dockerfiles
    ├── compose/            # ML Docker Compose
    ├── scripts/            # ML management scripts
    └── configs/            # ML configurations
```

## 🔄 Communication Between Environments

### Extension ↔ ML Agent Communication
- **HTTP API**: RESTful API for extension-to-agent communication
- **WebSocket**: Real-time bidirectional communication
- **Message Queue**: Async task processing (Redis/RabbitMQ)
- **Shared Volume**: File-based data exchange

### Development Workflow
1. **Frontend Development**: Create UI components in `frontend-only`
2. **ML Agent Development**: Build AI agents in `ml-agent`
3. **Integration**: Test full system in `full-project`
4. **Packaging**: Bundle ML agent as runtime in extension

## 🛠️ Management Scripts

Each environment includes management scripts:
- `dev.sh` - Main development environment controller
- `build.sh` - Build Docker images
- `test.sh` - Run tests in containers
- `clean.sh` - Clean up containers and volumes

## 🌟 Future Enhancements

- **ML Agent Runtime**: Python agent packaged as binary for extension
- **Multi-GPU Support**: CUDA support for ML development
- **Cloud Integration**: Easy deployment to cloud environments
- **CI/CD Integration**: Automated testing and building
- **Performance Monitoring**: Development performance metrics

## 🔧 Common Docker Issues & Quick Fixes

### Error -35 (File System Issues)
**Issue**: `Unknown system error -35` during packaging or file copying
**Solution**: ✅ Fixed with Docker-aware scripts that skip problematic operations in containers

### esbuild Version Mismatch  
**Issue**: `Host version does not match binary version`
**Solution**: ✅ Fixed with automatic Docker environment detection

### Development Workflow
- **✅ Edit Code**: On HOST machine (your local editor)
- **✅ Debug Extension**: In CONTAINER (F5 debugging)
- **✅ Build VSIX**: On HOST machine (not in Docker)

**Quick Start**:
```bash
# Start development environment
docker exec -it continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh"

# Open VS Code at http://localhost:8080 and press F5 to debug
```

For detailed troubleshooting, see [Full Project Troubleshooting Guide](./full-project/README.md#-troubleshooting--docker-development-guide).

## 📖 Usage Guide

For detailed usage instructions for each environment, see:
- [Full Project Development](./full-project/README.md)
- [Frontend Only Development](./frontend-only/README.md)
- [ML Agent Development](./ml-agent/README.md) (Coming Soon) 