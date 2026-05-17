#!/bin/bash
set -e

echo "========================================="
echo "  Finalizing Development Environment"
echo "========================================="

# Configure git
echo "[1/4] Configuring git..."
git config --global --add safe.directory '*'
git config --global core.editor nano
git config --global color.ui auto
git config --global init.defaultBranch main
git config --global pull.rebase false

# Configure Python
echo "[2/4] Configuring Python..."
pip3 install --upgrade pip --break-system-packages 2>/dev/null || true

# Configure Node.js
echo "[3/4] Configuring Node.js..."
npm config set registry https://registry.npmjs.org/

# Set permissions
echo "[4/4] Setting permissions..."
chown -R developer:developer /workspace 2>/dev/null || true

echo ""
echo "========================================="
echo "  Setup Complete!"
echo "========================================="
echo ""
echo "Workspace structure:"
echo "  /workspace/projects  - Your projects"
echo "  /workspace/scripts   - Custom scripts"
echo "  /workspace/logs      - Log files"
echo "  /workspace/config    - Configuration files"
echo "  /workspace/data      - Data files"
echo "  /workspace/backups   - Backups"
echo "  /workspace/tmp       - Temporary files"
echo ""
