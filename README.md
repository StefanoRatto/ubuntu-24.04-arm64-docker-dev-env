# Containerized Development Environment

A fully persistent, secure development environment container based on Ubuntu 24.04 ARM64 with comprehensive language support and development tools.

## Features

### 🐳 **Container Technology**
- **Base OS**: Ubuntu 24.04 ARM64
- **Container Engine**: Docker with LazyDocker for management
- **Persistence**: Full home directory persistence with bind mounts
- **Security**: Non-root user with SSH key-based authentication

### 🔧 **Development Languages & Tools**

#### **JavaScript/TypeScript/Node.js**
- Node.js 20.x with npm
- TypeScript (global installation)
- Next.js framework
- React development tools
- ESLint, Prettier, Yarn
- Create React App

#### **Python**
- Python 3 with pip
- Virtual environments (venv)
- Development tools: pytest, black, flake8, mypy
- Data science packages: numpy, pandas, matplotlib, scipy
- Jupyter notebooks and IPython

#### **Go (Golang)**
- Go 1.22.4
- Go modules support
- Development tools: gopls, delve debugger, goimports
- Testing tools: gotests
- Linting: golangci-lint
- Code generation tools

#### **PHP**
- PHP 8.3 with CLI and FPM
- Common extensions (MySQL, GD, cURL, XML, etc.)
- Composer package manager
- Development-ready configuration

#### **C/C++**
- GCC and G++ compilers
- Clang and Clang++ (LLVM)
- GDB debugger
- Clang-tidy and clang-format
- Make, CMake, pkg-config
- Valgrind memory checker
- Cppcheck static analysis

#### **Database & Tools**
- SQLite3 with development headers
- Git with configuration
- SSH server for remote access
- Neovim, Vim, Nano editors
- Htop system monitor

### 🔐 **Security Features**
- **Non-root user**: `dev` with password `dev`
- **SSH key authentication**: Uses your existing SSH key pair
- **No password authentication**: SSH configured for key-based auth only
- **Sudo access**: Dev user has passwordless sudo

### 📁 **Persistence & Storage**
- **Full home directory**: `/home/dev` is fully persistent
- **Project directories**: `/home/dev/dev/projects`, `/home/dev/dev/workspace`
- **Database storage**: `/home/dev/dev/databases`
- **Package caches**: npm, pip, go modules all persisted
- **Configuration files**: All user configs preserved between sessions

### 🌐 **Network Access**
- **SSH**: Port 22 (for remote development)
- **Web servers**: Ports 80, 3000, 8000, 8080
- **Development servers**: Ready for Next.js, React, PHP, Go web apps

## Quick Start

### Prerequisites
- Docker installed on Ubuntu 24.04 ARM64
- SSH key pair (existing `dev-local` key)
- User in docker group

### 1. Setup
```bash
# Clone or navigate to this directory
cd /path/to/your/dev/environment

# Run the setup script (may need sudo for first run)
./setup.sh
```

### 2. Connect via SSH
```bash
# Connect to the container
ssh dev@localhost -p 2222

# Or with explicit key
ssh -i ~/.ssh/dev-local dev@localhost -p 2222
```

### 3. Connect via Cursor/VS Code
1. Open Cursor/VS Code
2. Install "Remote - SSH" extension
3. Connect to: `dev@localhost:2222`
4. Open folder: `/home/dev/dev/workspace`

## Development Workflows

### JavaScript/TypeScript Development
```bash
# Create new Next.js project
npx create-next-app@latest my-app
cd my-app
npm run dev

# Create React app
npx create-react-app my-react-app
cd my-react-app
npm start
```

### Python Development
```bash
# Create virtual environment
python3 -m venv myenv
source myenv/bin/activate

# Install packages
pip install -r requirements.txt

# Run tests
pytest

# Start Jupyter notebook
jupyter notebook
```

### Go Development
```bash
# Initialize new Go module
go mod init myproject
cd myproject

# Create main.go
echo 'package main

import "fmt"

func main() {
    fmt.Println("Hello, Go!")
}' > main.go

# Run the program
go run main.go

# Build executable
go build -o myapp main.go
```

**Note:** Go is properly configured for SSH sessions with PATH and GOPATH environment variables set in `.bashrc` and `.profile`.

### PHP Development
```bash
# Create PHP project
mkdir my-php-project
cd my-php-project

# Initialize with Composer
composer init

# Create simple PHP server
echo '<?php echo "Hello, PHP!"; ?>' > index.php
php -S localhost:8000
```

### C/C++ Development
```bash
# Create C program
echo '#include <stdio.h>

int main() {
    printf("Hello, C!\n");
    return 0;
}' > hello.c

# Compile and run
gcc -o hello hello.c
./hello

# Debug with GDB
gcc -g -o hello hello.c
gdb hello
```

## Container Management

### View Container Status
```bash
# Using LazyDocker (recommended)
lazydocker

# Or using Docker CLI
docker ps
docker logs dev-environment
```

### Rebuild Container
```bash
# Stop and remove existing container
docker compose down

# Rebuild with latest changes
docker compose up --build -d
```

### Access Container Shell
```bash
# Direct shell access (as root)
docker exec -it dev-environment /bin/bash

# As dev user
docker exec -it -u dev dev-environment /bin/bash
```

## Troubleshooting

### SSH Connection Issues
```bash
# Check SSH service status
docker exec dev-environment service ssh status

# View SSH logs
docker exec dev-environment tail -f /var/log/auth.log

# Fix permissions (if needed)
docker exec dev-environment chown dev:dev /home/dev/.ssh/authorized_keys
docker exec dev-environment chmod 600 /home/dev/.ssh/authorized_keys
```

### Permission Issues
```bash
# Fix home directory ownership
docker exec dev-environment chown -R dev:dev /home/dev

# Fix specific directory permissions
docker exec dev-environment chmod -R 755 /home/dev/dev
```

### Port Conflicts
If ports are already in use:
```bash
# Check what's using the ports
sudo netstat -tulpn | grep :2222
sudo netstat -tulpn | grep :3000

# Stop conflicting services or modify docker-compose.yml
```

## File Structure

```
/home/dev/
├── .ssh/                    # SSH configuration
├── .npm/                    # npm cache and config
├── .npm-global/             # Global npm packages
├── go/                      # Go workspace
│   ├── src/                 # Go source code
│   ├── bin/                 # Go binaries
│   └── pkg/                 # Go packages
├── dev/                     # Development directories
│   ├── projects/            # Your projects
│   ├── workspace/           # Active workspace
│   └── databases/           # Database files
├── Documents/               # Documents
├── Downloads/               # Downloads
└── ...                      # Standard home directories
```

## Environment Variables

The container sets up these environment variables:
- `GOPATH=/home/dev/go`
- `PATH` includes Go, npm global, and user local bins
- `NODE_VERSION=20.x`

## Security Notes

- SSH key authentication only (no passwords)
- Non-root user with sudo access
- Container isolation from host
- Persistent storage with proper permissions
- No exposed sensitive data in container

## Performance Tips

- Use volume mounts for large projects
- Leverage package manager caches
- Use language-specific development servers
- Monitor resource usage with `htop`
- Rebuild container periodically for updates

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review container logs: `docker logs dev-environment`
3. Verify SSH key permissions
4. Ensure Docker group membership
5. Check port availability

---

**Happy coding! 🚀** 