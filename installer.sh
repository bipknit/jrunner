#!/bin/bash

# conf
RUNNER_URL="https://raw.githubusercontent.com/bipknit/runR/main/runr.sh"
INSTALL_DIR="$HOME/bin"
RUNNER_FILE="$INSTALL_DIR/runr.sh"
ALIAS_NAME="r"
SHELL_RC=""

# detect shell config file
if [[ -n "$ZSH_VERSION" ]]; then
    SHELL_RC="$HOME/.zshrc"
    ALIAS_SYNTAX="alias $ALIAS_NAME='$RUNNER_FILE'"
elif [[ -n "$BASH_VERSION" ]]; then
    SHELL_RC="$HOME/.bashrc"
    ALIAS_SYNTAX="alias $ALIAS_NAME='$RUNNER_FILE'"
elif [[ "$SHELL" == *csh* ]]; then
    SHELL_RC="$HOME/.cshrc"
    ALIAS_SYNTAX="alias $ALIAS_NAME '$RUNNER_FILE'"
elif [[ "$SHELL" == *fish* ]]; then
    SHELL_RC="$HOME/.config/fish/config.fish"
    ALIAS_SYNTAX="alias $ALIAS_NAME '$RUNNER_FILE'"
else
    echo "Unsupported shell. Please add alias manually."
fi



mkdir -p "$INSTALL_DIR"

echo "Downloading runner script..."
if command -v curl &>/dev/null; then
    curl -fsSL "$RUNNER_URL" -o "$RUNNER_FILE"
elif command -v wget &>/dev/null; then
    wget -q "$RUNNER_URL" -O "$RUNNER_FILE"
else
    echo "Error: curl or wget is required to download the script."
    exit 1
fi

# make it executable
chmod +x "$RUNNER_FILE"
echo "Runner installed at $RUNNER_FILE"

# ask if you trust this thing to append alias
if [[ -n "$SHELL_RC" ]]; then
    echo "Do you want to add alias '$ALIAS_NAME' to $SHELL_RC? [y/N]"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        # avoid duplicate alias
        if ! grep -q "alias $ALIAS_NAME=" "$SHELL_RC"; then
            echo "alias $ALIAS_NAME='$RUNNER_FILE'" >> "$SHELL_RC"
            echo "Alias added to $SHELL_RC"
            echo "Reload your shell or run: source $SHELL_RC"
        else
            echo "Alias already exists in $SHELL_RC"
        fi
    else
        echo "Skipped adding alias."
    fi
fi

echo "Installation complete."
echo "Do you want to destroy the installation script? [y/N]"
read -r answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "Destroying script..."
    rm -- "$0"
    exit 0
fi
