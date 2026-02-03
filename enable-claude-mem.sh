#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# enable-claude-mem.sh
# Drop this file into ANY project root and run it once.
# ------------------------------------------------------------

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR_DIR="$PROJECT_ROOT/.cursor"
HOOKS_DIR="$CURSOR_DIR/hooks"

echo "🔧 Enabling claude-mem for project:"
echo "    $PROJECT_ROOT"
echo

# Ensure Cursor folders exist
mkdir -p "$HOOKS_DIR"

# ------------------------------------------------------------------
# Create the per-project wrapper hook
# ------------------------------------------------------------------
cat > "$HOOKS_DIR/claude-mem-ingest.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

# This file lives in <project>/.cursor/hooks/
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Force claude-mem to attribute everything to THIS project
export CLAUDE_MEM_PROJECT_ROOT="$PROJECT_ROOT"

# Forward stdin payload to global claude-mem ingest
exec "$HOME/.claude-mem/bin/claude-mem-ingest.sh"
EOF

chmod +x "$HOOKS_DIR/claude-mem-ingest.sh"

# ------------------------------------------------------------------
# Create Cursor hooks.json
# ------------------------------------------------------------------
cat > "$CURSOR_DIR/hooks.json" << 'EOF'
{
  "version": 1,
  "hooks": {
    "afterShellExecution": [
      { "command": ".cursor/hooks/claude-mem-ingest.sh" }
    ],
    "afterFileEdit": [
      { "command": ".cursor/hooks/claude-mem-ingest.sh" }
    ],
    "afterMCPExecution": [
      { "command": ".cursor/hooks/claude-mem-ingest.sh" }
    ]
  }
}
EOF

echo "✅ claude-mem enabled"
echo
echo "Next steps:"
echo "  1) Cmd+Q Cursor (fully quit)"
echo "  2) Reopen Cursor"
echo "  3) Open this project"
echo "  4) Run any agent prompt"
echo
echo "Verify with:"
echo "  cat /tmp/claude-mem-debug/last-root.txt"
