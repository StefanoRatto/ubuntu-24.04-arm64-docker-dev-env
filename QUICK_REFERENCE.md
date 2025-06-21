# Quick Reference Card

## 🚀 Quick Start
```bash
./setup.sh                    # Build and start everything
```

## 🔗 Connection Details
- **SSH**: `ssh dev@localhost -p 2222`
- **Authentication**: SSH key (dev-local.pub pre-configured)
- **VS Code/Cursor**: `dev@localhost:2222` (uses SSH key automatically)

## 📋 Container Management
```bash
docker compose up -d          # Start container
docker compose down           # Stop container
docker compose logs -f        # View logs
docker compose ps             # Check status
docker compose build          # Rebuild image
```

## 🌐 Port Mappings
- SSH: `localhost:2222`
- HTTP: `localhost:80`
- React/Next.js Dev: `localhost:3000`
- Dev Server: `localhost:8000`
- Alt Dev Server: `localhost:8080`

## 📁 Full Home Directory Persistence
- **Host home**: `./home/dev` → `/home/dev` (complete user home directory)
- **VM-like experience**: All files, configs, and data persist between restarts
- **Includes**: Projects, databases, configs, shell history, app data, etc.
- **SSH keys**: `./authorized_keys` → `/home/dev/.ssh/authorized_keys`
- **Persistent caches**: npm, yarn, vim/nvim config, node_modules cache, dev tools cache

## 🛠️ Development Commands (inside container)
```bash
# Next.js
npx create-next-app@latest my-app --typescript
cd my-app && npm run dev

# React
npx create-react-app my-react-app --template typescript
cd my-react-app && npm start

# Node.js
npm init -y
npm install express typescript @types/node

# Python
python3 -m venv myenv
source myenv/bin/activate
pip install requests numpy pandas
python3 -m pytest
jupyter notebook

# Go
go mod init myproject
go run main.go
go build -o myapp main.go
go test ./...
gopls

# PHP
composer init
composer require monolog/monolog
php -S localhost:8000
php -l script.php  # syntax check

# C/C++
gcc -o program program.c
g++ -o program program.cpp
gdb program
clang -o program program.c
make
cmake ..
valgrind ./program

# SQLite (persistent on host)
cd /home/dev/databases
sqlite3 database.db

# System monitoring
htop

# Advanced editing
nvim filename.txt
```

## 💾 Volume Management
```bash
docker volume ls              # List all volumes
docker volume inspect dev_npm_cache  # Inspect volume
docker volume rm dev_npm_cache       # Remove volume (careful!)
```

## 🔧 Troubleshooting
```bash
docker exec -it dev-environment bash    # Access container shell
docker compose restart                  # Restart container
docker system prune                     # Clean up Docker
docker volume ls                        # Check persistent volumes
ls -la ~/.ssh/dev-local*               # Check SSH key permissions
ssh-keygen -l -f ~/.ssh/dev-local      # Test SSH key
ls -la home/dev/                       # Check home directory permissions
```

## 🔄 Rebuilding with Changes
```bash
docker compose down           # Stop container
docker compose build          # Rebuild image
docker compose up -d          # Start with new config
``` 