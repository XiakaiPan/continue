<div align="center">

![Continue logo](media/readme.png)

</div>

<h1 align="center">Continue</h1>

<div align="center">

**[Continue](https://docs.continue.dev) enables developers to create, share, and use custom AI code assistants with our
open-source [VS Code](https://marketplace.visualstudio.com/items?itemName=Continue.continue)
and [JetBrains](https://plugins.jetbrains.com/plugin/22707-continue-extension) extensions
and [hub of models, rules, prompts, docs, and other building blocks](https://hub.continue.dev)**

</div>

<div align="center">

<a target="_blank" href="https://opensource.org/licenses/Apache-2.0" style="background:none">
    <img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" style="height: 22px;" />
</a>
<a target="_blank" href="https://docs.continue.dev" style="background:none">
    <img src="https://img.shields.io/badge/continue_docs-%23BE1B55" style="height: 22px;" />
</a>
<a target="_blank" href="https://changelog.continue.dev" style="background:none">
    <img src="https://img.shields.io/badge/changelog-%96EFF3" style="height: 22px;" />
</a>
<a target="_blank" href="https://discord.gg/vapESyrFmJ" style="background:none">
    <img src="https://img.shields.io/badge/discord-join-continue.svg?labelColor=191937&color=6F6FF7&logo=discord" style="height: 22px;" />
</a>

<p></p>

## Agent

[Agent](https://continue.dev/docs/agent/how-to-use-it) enables you to make more substantial changes to your codebase

![agent](docs/static/img/agent.gif)

## Chat

[Chat](https://continue.dev/docs/chat/how-to-use-it) makes it easy to ask for help from an LLM without needing to leave
the IDE

![chat](docs/static/img/chat.gif)

## Autocomplete

[Autocomplete](https://continue.dev/docs/autocomplete/how-to-use-it) provides inline code suggestions as you type

![autocomplete](docs/static/img/autocomplete.gif)

## Edit

[Edit](https://continue.dev/docs/edit/how-to-use-it) is a convenient way to modify code without leaving your current
file

![edit](docs/static/img/edit.gif)

</div>

## Getting Started

Learn about how to install and use Continue in the docs [here](https://continue.dev/docs/getting-started/install)

## 🔨 Building VSIX Release

For building a distributable VSIX package of the Continue extension:

```bash
# One-command build (all-in-container approach)
./release.sh

# Result: continue-{VERSION}.vsix in project root
# Install: code --install-extension continue-{VERSION}.vsix
```

This consolidated approach:
- ✅ Builds everything in consistent Docker environment
- ✅ No host dependencies required (Node.js, npm, etc.)
- ✅ Works around Docker file system issues
- ✅ Produces ready-to-install VSIX file

## 🐳 Docker Development Workflows

Continue supports flexible Docker-based development for consistent environments:

### **Workflow 1: Container-Attached IDE** (Experienced Developers)
```bash
# 1. Start container
docker-compose up -d continue-vscode-dev

# 2. Attach VS Code to container
# VS Code → Remote-Containers → Attach to Running Container

# 3. Develop entirely inside container
# Complete isolation, consistent environment
```

### **Workflow 2: Host Edit + Container Build** (New Developers)
```bash
# 1. Start container & build project
docker-compose up -d continue-vscode-dev
docker exec continue-vscode-dev bash -c "cd /app && ./scripts/install-dependencies.sh"

# 2. Develop with familiar tools
# Edit on host, debug at http://localhost:8080
# Best of both worlds: familiar tools + consistent builds
```

### **Quick Reference**
```bash
./docker-dev.sh          # Show development guide
./dev-start.sh           # Setup development environment  
./release.sh             # Build VSIX package
./cleanup.sh             # Stop containers & cleanup
```

**Access Points:**
- VS Code (browser): http://localhost:8080
- GUI development: http://localhost:5173  
- Core server: http://localhost:3000

For detailed setup, see [DOCKER_DEV_GUIDE.md](./DOCKER_DEV_GUIDE.md).

## Contributing

Read the [contributing guide](https://github.com/continuedev/continue/blob/main/CONTRIBUTING.md), and
join [#contribute on Discord](https://discord.gg/vapESyrFmJ).

## License

[Apache 2.0 © 2023-2024 Continue Dev, Inc.](./LICENSE)
