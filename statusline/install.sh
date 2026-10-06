#!/bin/bash
# Symlink statusline.sh into ~/.claude and point settings.json at it. Needs jq.
set -e
src="$(cd "$(dirname "$0")" && pwd)/statusline.sh"
settings="$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude"
ln -sf "$src" "$HOME/.claude/statusline-command.sh"
[ -f "$settings" ] || echo '{}' > "$settings"
tmp=$(mktemp)
jq '.statusLine = {type: "command", command: "bash \"$HOME/.claude/statusline-command.sh\""}' "$settings" > "$tmp" && mv "$tmp" "$settings"
echo "Statusline installed -> $src"
