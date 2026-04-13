#!/bin/bash
# setup.sh — Deploy Claude Code and Positron config from this dotfiles repo
#
# Usage:
#   git clone https://github.com/wfukuokaya/dotfiles.git
#   cd dotfiles
#   bash setup.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/.claude"
DST="$HOME/.claude"

mkdir -p "$DST"

# --- settings.json ---
if [ -f "$DST/settings.json" ]; then
    BACKUP="$DST/settings.json.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backup: $DST/settings.json -> $BACKUP"
    cp "$DST/settings.json" "$BACKUP"
fi
cp "$SRC/settings.json" "$DST/settings.json"
echo "Copied: settings.json"

# --- CLAUDE.md ---
if [ -f "$DST/CLAUDE.md" ]; then
    BACKUP="$DST/CLAUDE.md.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backup: $DST/CLAUDE.md -> $BACKUP"
    cp "$DST/CLAUDE.md" "$BACKUP"
fi
cp "$SRC/CLAUDE.md" "$DST/CLAUDE.md"
echo "Copied: CLAUDE.md"

# --- commands/ ---
mkdir -p "$DST/commands"
for f in "$SRC/commands/"*.md; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    cp "$f" "$DST/commands/$name"
    echo "Copied: commands/$name"
done

# --- skills/ ---
if [ -d "$SRC/skills" ]; then
    mkdir -p "$DST/skills"
    cp -R "$SRC/skills/"* "$DST/skills/" 2>/dev/null || true
    echo "Copied: skills/"
fi

# --- .mcp.json ---
if [ -f "$SRC/.mcp.json.example" ] && [ ! -f "$DST/.mcp.json" ]; then
    cp "$SRC/.mcp.json.example" "$DST/.mcp.json"
    echo "Created: .mcp.json from template (edit API keys before use)"
elif [ -f "$SRC/.mcp.json.example" ]; then
    echo "Skipped: .mcp.json already exists (see .mcp.json.example for reference)"
fi

# --- Positron settings.json ---
POSITRON_DST="$HOME/Library/Application Support/Positron/User"
POSITRON_SRC="$SCRIPT_DIR/positron"
if [ -f "$POSITRON_SRC/settings.json" ]; then
    mkdir -p "$POSITRON_DST"
    if [ -f "$POSITRON_DST/settings.json" ]; then
        BACKUP="$POSITRON_DST/settings.json.bak.$(date +%Y%m%d%H%M%S)"
        echo "Backup: $POSITRON_DST/settings.json -> $BACKUP"
        cp "$POSITRON_DST/settings.json" "$BACKUP"
    fi
    cp "$POSITRON_SRC/settings.json" "$POSITRON_DST/settings.json"
    echo "Copied: positron/settings.json"
fi

# --- Positron keybindings.json ---
if [ -f "$POSITRON_SRC/keybindings.json" ]; then
    mkdir -p "$POSITRON_DST"
    if [ -f "$POSITRON_DST/keybindings.json" ]; then
        BACKUP="$POSITRON_DST/keybindings.json.bak.$(date +%Y%m%d%H%M%S)"
        echo "Backup: $POSITRON_DST/keybindings.json -> $BACKUP"
        cp "$POSITRON_DST/keybindings.json" "$BACKUP"
    fi
    cp "$POSITRON_SRC/keybindings.json" "$POSITRON_DST/keybindings.json"
    echo "Copied: positron/keybindings.json"
fi

# --- Fukuokaya Sage theme ---
THEME_DST="$HOME/.positron/extensions/fukuokaya-theme"
if [ ! -d "$THEME_DST" ]; then
    echo ""
    echo "Install Fukuokaya Sage theme:"
    echo "  git clone https://github.com/wfukuokaya/fukuokaya-theme.git $THEME_DST"
else
    echo "Theme: fukuokaya-theme already installed"
fi

# --- Google Drive session directories (macOS only) ---
GDRIVE_CANDIDATES=(
    "$HOME/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/My Drive/project/claude_session"
    "$HOME/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/マイドライブ/project/claude_session"
)

for candidate in "${GDRIVE_CANDIDATES[@]}"; do
    parent="$(dirname "$candidate")"
    if [ -d "$parent" ]; then
        mkdir -p "$candidate"
        echo "Created: Google Drive session directory at $candidate"
        break
    fi
done

# --- Summary ---
echo ""
echo "=== Setup complete ==="
echo "Commands:"
for f in "$DST/commands/"*.md; do
    [ -f "$f" ] || continue
    echo "  /$(basename "$f" .md)"
done
echo "Skills:"
for f in "$DST/skills/"*.md "$DST/skills/"*/SKILL.md; do
    [ -f "$f" ] || continue
    name="$(basename "$(dirname "$f")")"
    [ "$name" = "skills" ] && name="$(basename "$f" .md)"
    echo "  /$name"
done
echo ""
echo "Note: Edit ~/.claude/.mcp.json to add your API keys."
echo "Note: Install UDEV Gothic 35NFLG font for Positron."
echo "Run 'claude' in Positron terminal to start."
