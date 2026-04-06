#!/bin/bash
# setup.sh — Deploy Claude Code config from this dotfiles repo to ~/.claude/
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

# --- Google Drive knowledge-base directories (macOS only) ---
GDRIVE_CANDIDATES=(
    "$HOME/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/My Drive/claude/knowledge-base"
    "$HOME/Library/CloudStorage/GoogleDrive-wfukuokaya@gmail.com/マイドライブ/claude/knowledge-base"
)

for candidate in "${GDRIVE_CANDIDATES[@]}"; do
    parent="$(dirname "$candidate")"
    if [ -d "$parent" ]; then
        mkdir -p "$candidate/sessions" \
                 "$candidate/nuggets/r-patterns" \
                 "$candidate/nuggets/methods" \
                 "$candidate/nuggets/statistics" \
                 "$candidate/nuggets/tooling" \
                 "$candidate/nuggets/data-management" \
                 "$candidate/topics"
        echo "Created: Google Drive knowledge-base directories at $candidate"
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
echo ""
echo "Run 'claude' in Positron terminal to start."
