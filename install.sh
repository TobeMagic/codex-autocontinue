#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
TARGET="${BIN_DIR}/codex-autocontinue"
ALIAS_TARGET="${BIN_DIR}/codex-continue"

mkdir -p "$BIN_DIR"
cp "$SCRIPT_DIR/codex-autocontinue" "$TARGET"
chmod +x "$TARGET"
ln -sfn "$TARGET" "$ALIAS_TARGET"

echo "Installed: $TARGET"
echo "Alias:     $ALIAS_TARGET"
if ! echo "$PATH" | tr ':' '\n' | grep -Fx "$BIN_DIR" >/dev/null 2>&1; then
  echo "Warning: $BIN_DIR is not in PATH. Add this to ~/.bashrc:"
  echo "  export PATH=\"$BIN_DIR:\$PATH\""
fi
