# thoaivk Development Profile

This is a comprehensive development environment configured for multi-language programming with Ruby on Rails, Golang, Rust, and JavaScript/Node.js.

## 🚀 Features

### Programming Languages & Tools

#### Ruby Development
- **Ruby 3.3** (latest stable)
- **Bundler** for dependency management
- Rails installed per-project via bundler
- Shell aliases: `be`, `rc`, `rs`, `rspec`

#### Go Development
- **Go 1.22**
- **gopls** - Language Server Protocol
- **golangci-lint** - Comprehensive linter
- **delve** - Debugger
- **gotools** - goimports, godoc, etc.

#### Rust Development
- **rustc & cargo**
- **rust-analyzer** - LSP
- **clippy** - Linter
- **rustfmt** - Formatter

#### JavaScript/Node.js Development
- **Node.js 22** (LTS)
- **npm, yarn, pnpm** - Package managers
- **TypeScript** + Language Server
- **ESLint & Prettier** - Code quality
- **Nodemon** - Hot reload

### Databases

#### Available Database Tools
- **PostgreSQL 16** + pgcli
- **MySQL 8.0** + mycli
- **Redis 7**
- **SQLite**

#### Docker Compose Services
Pre-configured docker-compose files in `~/docker-compose/`:
- `postgresql.yml` - PostgreSQL
- `mysql.yml` - MySQL
- `redis.yml` - Redis
- `kafka.yml` - Kafka + Zookeeper + Kafka UI
- `full-stack.yml` - All databases together

### Development Tools

#### Editor
- **Neovim** (nightly) with LazyVim
- **Pre-configured plugins**:
  - `fzf-lua` - Fuzzy finder
  - `tree-sitter` - Syntax highlighting
  - `oil.nvim` - File explorer
  - `hurl.nvim` - HTTP testing
  - Mason for LSP management (configured via LazyVim)

#### Shell
- **Zsh** with:
  - Auto-completion
  - Syntax highlighting
  - Auto-suggestions
  - Git integration in prompt
- **Fish** shell (alternative)
- **Bash** (fallback)

#### Version Control
- **Git** with useful aliases
- **LazyGit** - Git TUI (`lg` command)
- **git-lfs** - Large file support

#### Docker & Containers
- **Docker** + **docker-compose**
- **LazyDocker** - Docker TUI (`ld` command)
- **kubectl** - Kubernetes CLI
- **k9s** - Kubernetes TUI

#### API Development
- **httpie** - Better curl
- **curl**
- **postman**
- **hurl** - HTTP testing tool

#### Code Quality
- **shellcheck** - Shell script linter
- **hadolint** - Dockerfile linter
- **yamllint** - YAML linter

## 📁 Directory Structure

```
~/.config/
├── nvim/                    # Neovim configuration
│   ├── init.lua
│   └── lua/
│       ├── config/          # Core config
│       │   ├── lazy.lua
│       │   ├── options.lua
│       │   └── keymaps.lua
│       └── plugins/         # Plugin configurations
│           ├── fzf-lua.lua
│           ├── oil.lua
│           ├── hurl.lua
│           └── treesitter.lua
│
~/docker-compose/            # Docker service templates
├── postgresql.yml
├── mysql.yml
├── redis.yml
├── kafka.yml
├── full-stack.yml
└── README.md

~/code/go/                   # Go workspace (GOPATH)
├── bin/                     # Go binaries
├── pkg/                     # Go packages
└── src/                     # Go source code

~/.bundle/                   # Ruby bundler packages
~/.cargo/                    # Rust cargo home
~/.rustup/                   # Rust toolchain
~/.npm-global/               # Global npm packages
```

## 🎯 Quick Start Guide

### First Boot

1. **Login**:
   ```bash
   Username: thoaivk
   Password: changeme  # Change this immediately!
   ```

2. **Change Password**:
   ```bash
   passwd
   ```

3. **Start Neovim** (first time will install plugins):
   ```bash
   nvim
   ```
   Wait for LazyVim to install all plugins.

### Starting Database Services

```bash
# Start PostgreSQL
pgstart
# or
docker-compose -f ~/docker-compose/postgresql.yml up -d

# Start MySQL
mysqlstart

# Start Redis
redisstart

# Start all services
docker-compose -f ~/docker-compose/full-stack.yml up -d
```

### Connecting to Databases

```bash
# PostgreSQL
pgcli postgresql://dev:devpassword@localhost:5432/dev_database

# MySQL
mycli -h localhost -u dev -pdevpassword dev_database

# Redis
redis-cli
```

## 🔧 Shell Aliases

### Git
- `ga` - git add
- `gc` - git commit
- `gco` - git checkout
- `gp` - git push
- `gs` - git status
- `gl` - git prettylog (formatted log)

### Ruby/Rails
- `be` - bundle exec
- `rc` - bundle exec rails console
- `rs` - bundle exec rails server
- `rspec` - bundle exec rspec

### Docker
- `dc` - docker-compose
- `dcu` - docker-compose up -d
- `dcd` - docker-compose down
- `dps` - docker ps
- `di` - docker images

### Tools
- `lg` - lazygit
- `ld` - lazydocker

## 💻 Neovim Usage

### Key Mappings

#### Leader Key
- Leader: `<Space>`
- Local Leader: `\`

#### File Navigation (fzf-lua)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Buffers
- `<leader>fh` - Help tags
- `<leader>fr` - Recent files

#### File Explorer (oil.nvim)
- `-` - Open parent directory

#### HTTP Testing (hurl.nvim)
- `<leader>ha` - Run all Hurl requests
- `<leader>hA` - Run request at cursor
- `<leader>hv` - Run in verbose mode

#### Window Navigation
- `<C-h/j/k/l>` - Navigate between windows
- `<C-Up/Down/Left/Right>` - Resize windows

#### Buffer Navigation
- `<S-h>` - Previous buffer
- `<S-l>` - Next buffer

## 🏗️ Project Setup Examples

### Ruby on Rails Project

```bash
# Create new Rails project
cd ~/projects
gem install rails
rails new myapp --database=postgresql

# Setup database
cd myapp
be rails db:create

# Start server
rs
```

### Go Project

```bash
# Create new Go project
mkdir -p ~/code/go/src/github.com/thoaivk/myproject
cd ~/code/go/src/github.com/thoaivk/myproject

# Initialize module
go mod init github.com/thoaivk/myproject

# Create main.go
nvim main.go
```

### Rust Project

```bash
# Create new Rust project
cd ~/projects
cargo new myproject
cd myproject

# Build and run
cargo build
cargo run
```

### Node.js/TypeScript Project

```bash
# Create new Node.js project
mkdir ~/projects/myproject && cd ~/projects/myproject
npm init -y
npm install typescript @types/node --save-dev
npx tsc --init

# Start development
nodemon index.ts
```

## 🔐 Environment Variables

Pre-configured environment variables:

```bash
# Language specific
GOPATH=$HOME/code/go
GOBIN=$HOME/code/go/bin
CARGO_HOME=$HOME/.cargo
RUSTUP_HOME=$HOME/.rustup
BUNDLE_PATH=$HOME/.bundle
NPM_CONFIG_PREFIX=$HOME/.npm-global

# Docker
DOCKER_BUILDKIT=1
COMPOSE_DOCKER_CLI_BUILD=1

# Editor
EDITOR=nvim
```

## 📦 Installing Additional Packages

To add more packages, edit `home-manager.nix`:

```nix
home.packages = [
  # Add your packages here
  pkgs.package-name
];
```

Then rebuild:
```bash
# On NixOS
sudo nixos-rebuild switch --flake ".#vm-intel-dev"

# On macOS
darwin-rebuild switch --flake ".#macbook-pro-m1-dev"
```

## 🎓 Learning Resources

### Neovim
- LazyVim docs: https://www.lazyvim.org
- `:help` in Neovim
- `:Lazy` to manage plugins

### Shell
- Zsh docs: https://zsh.sourceforge.io
- Oh My Zsh: https://ohmyz.sh

### Tools
- LazyGit tutorial: `lg` then press `?` for help
- LazyDocker tutorial: `ld` then press `?` for help

## 🚨 Troubleshooting

### Neovim plugins not loading
```bash
# In Neovim
:Lazy sync
:Lazy update
```

### Database connection issues
```bash
# Check if services are running
docker ps

# Check logs
docker logs postgres_dev
docker logs mysql_dev
```

### Permission issues with Docker
```bash
# Ensure user is in docker group
groups | grep docker

# If not, re-login after nixos-rebuild
```

## 🆚 Comparison with Base Profile (thoaivo)

| Feature | thoaivo | thoaivk |
|---------|---------|---------|
| Shell | Fish | Zsh (with Fish available) |
| Editor | Neovim nightly | Neovim nightly + LazyVim |
| Ruby | ❌ | ✅ Ruby 3.3 |
| Go | gopls only | Full Go toolchain |
| Rust | ❌ | ✅ Full Rust toolchain |
| Node.js | Basic nodejs | Node 22 + TypeScript + tools |
| Databases | ❌ | ✅ PostgreSQL, MySQL, Redis |
| Docker Compose | ❌ | ✅ Pre-configured services |
| LazyGit | ❌ | ✅ |
| LazyDocker | ❌ | ✅ |
| API Tools | ❌ | ✅ httpie, hurl, postman |

## 📝 Notes

- All database credentials are **development defaults** - change for production!
- Docker services use volumes for data persistence
- Neovim will download plugins on first launch
- Shell completion works out of the box
- All development tools are declaratively configured

## 🔄 Switching Between Profiles

To use this profile, rebuild with:

```bash
# For VM
NIXNAME=vm-intel-dev make vm/switch

# Or directly
sudo nixos-rebuild switch --flake ".#vm-intel-dev"
```

To switch back to base profile:
```bash
sudo nixos-rebuild switch --flake ".#vm-intel"
```

---

**Happy Coding! 🎉**

---

## 🔧 Mise Version Manager

### What is Mise?

**Mise** (formerly rtx) is a fast, polyglot version manager that manages multiple runtime versions. It replaces tools like `asdf`, `nvm`, `rbenv`, `pyenv`, and `gvm`.

### Why Use Mise?

- ✅ **Multiple versions** - Install Ruby 3.3, 3.2, 3.1 simultaneously
- ✅ **Auto-switching** - Entering a directory auto-activates the right version
- ✅ **Fast** - Written in Rust, much faster than asdf
- ✅ **Compatible** - Works with asdf `.tool-versions` files
- ✅ **Simple** - Single binary, no complex plugin system

### Quick Start

```bash
# Install a specific Ruby version
mise install ruby@3.2.0

# Use it in current project
mise use ruby@3.2.0

# Install specific Go version
mise install go@1.21.0
mise use go@1.21.0

# Install specific Node version
mise install node@20.0.0
mise use node@20.0.0

# List installed versions
mise ls

# List available versions
mise ls-remote ruby

# Show current versions
mise current
```

### Shell Aliases

- `mi` - mise install
- `mu` - mise use
- `ml` - mise ls
- `mc` - mise current
- `mup` - mise upgrade

### Per-Project Versions

Mise automatically detects and uses versions from:

**Option 1: .mise.toml** (recommended)
```toml
[tools]
ruby = "3.2.0"
node = "20.0.0"
go = "1.21.0"

[env]
DATABASE_URL = "postgresql://localhost/mydb"
```

**Option 2: .tool-versions** (asdf compatible)
```
ruby 3.2.0
node 20.0.0
go 1.21.0
```

### Example Workflow

```bash
# Old Rails project (Ruby 3.1)
cd ~/projects/old-app
mise use ruby@3.1.0
ruby --version  # 3.1.0

# New Rails project (Ruby 3.3)
cd ~/projects/new-app
mise use ruby@3.3.0
ruby --version  # 3.3.0

# Automatic switching
cd ~/projects/old-app
ruby --version  # Automatically uses 3.1.0!
```

### System Packages vs Mise

| Aspect | System (Nix) | Mise |
|--------|--------------|------|
| Purpose | Global defaults, LSP | Per-project versions |
| Switching | Manual rebuild | Automatic |
| Multiple versions | ❌ | ✅ |

**Recommended:** Use BOTH!
- System packages: Global defaults (Ruby 3.3, Go 1.22, Node 22)
- Mise: Project-specific versions when needed

### Complete Guide

See **`MISE_GUIDE.md`** for comprehensive documentation including:
- Installation commands
- Configuration options
- Advanced features (tasks, hooks, environment variables)
- Integration with direnv
- Troubleshooting
- Best practices

```bash
# View the full guide
cat ~/MISE_GUIDE.md
# or
nvim ~/MISE_GUIDE.md
```

### Common Use Cases

**1. Working with legacy project:**
```bash
cd legacy-app
mise use ruby@2.7.0 node@14.0.0
bundle install
npm install
```

**2. Testing across versions:**
```bash
mise install ruby@3.3.0 ruby@3.2.0 ruby@3.1.0
mise use ruby@3.3.0 && bundle exec rspec
mise use ruby@3.2.0 && bundle exec rspec
mise use ruby@3.1.0 && bundle exec rspec
```

**3. Team synchronization:**
```bash
# Commit .mise.toml to version control
git add .mise.toml
git commit -m "Add mise configuration"

# Team members just:
git clone your-repo
cd your-repo
mise install  # Installs all versions from .mise.toml
```

---
