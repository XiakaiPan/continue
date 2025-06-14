# Docker Development Environment for Continue

⚠️ **MOVED**: Docker configurations have been reorganized and moved to the `docker/` directory.

Please see [**docker/README.md**](./docker/README.md) for the complete Docker development guide.

## Quick Migration Guide

The Docker setup has been restructured into three organized environments:

### 🏗️ New Structure

```
docker/
├── README.md                # Complete documentation  
├── continue-docker.sh       # Main controller script
├── full-project/           # VS Code extension development
├── frontend-only/          # React/Vite/Storybook development  
└── ml-agent/               # Python/LangChain development
```

### 🚀 Quick Start

**Instead of old commands, use:**

```bash
# Full VS Code extension development
./docker/continue-docker.sh full-project start

# Frontend-only development  
./docker/continue-docker.sh frontend start

# ML agent development (future)
./docker/continue-docker.sh ml-agent start
```

### 📖 What Changed

| **Old** | **New** |
|---------|---------|
| `./scripts/vscode-dev.sh start` | `./docker/continue-docker.sh full-project start` |
| Dockerfiles in root | `docker/*/dockerfiles/` |
| Single docker-compose.yml | Environment-specific compose files |
| Mixed development modes | Separated: full-project, frontend-only, ml-agent |

### 🎯 Environment Guide

- **`full-project`**: Complete VS Code extension development with all components
- **`frontend`**: Lightweight React/Vite/Storybook for GUI components
- **`ml-agent`**: Python/LangChain environment for AI agent development

For detailed instructions, see [**docker/README.md**](./docker/README.md). 