#!/bin/bash
# Agentic Toolkit Installer (Bash)
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Ippollo/Specwright/main/install.sh | bash

REPO_URL="https://github.com/Ippollo/Specwright.git"
REPO_URL_ALT="https://github.com/Ippollo/agentic-toolkit.git"
TEMP_DIR="/tmp/agentic-toolkit-temp"

# 1. Clean up
rm -rf "$TEMP_DIR"

echo -e "\033[0;36m🚀 Installing Agentic Toolkit from $REPO_URL...\033[0m"

# 2. Clone the toolkit
if ! git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
    echo -e "\033[0;33mRetrying with $REPO_URL_ALT...\033[0m"
    if ! git clone --depth 1 "$REPO_URL_ALT" "$TEMP_DIR"; then
        echo -e "\033[0;31mError: Failed to clone toolkit repository.\033[0m"
        exit 1
    fi
fi

# 3. Setup Project Structure
echo -e "\033[0;90m📦 Setting up project structure...\033[0m"

mkdir -p ".agent/workflows"

# 4. Copy Components
cp -f "$TEMP_DIR/workflows/"*.md ".agent/workflows/" 2>/dev/null

FOLDERS=("agents" "skills" "templates")
for FOLDER in "${FOLDERS[@]}"; do
    if [ -d "$TEMP_DIR/$FOLDER" ]; then
        echo -e "\033[0;90m  -> Copying $FOLDER...\033[0m"
        cp -rf "$TEMP_DIR/$FOLDER" .
    fi
done

# 5. Clean up
rm -rf "$TEMP_DIR"

echo -e "\n\033[0;32m✨ Agentic Toolkit successfully installed!\033[0m"
echo -e "Try these commands in your AI assistant:"
echo -e "  /constitution - Set project rules"
echo -e "  /brainstorm    - Explore ideas"
echo -e "  /new <name>   - Start a new feature"
echo -e "  /plan          - Create an implementation plan"
echo -e "\n\033[0;36mEnjoy your superpower! 🦸\033[0m"
