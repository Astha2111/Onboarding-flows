#!/bin/bash
# ─────────────────────────────────────────────────────────────
#  JioGames All Options Explorer
#  Double-click this file in Finder to launch the preview.
#  Requires Python 3 (pre-installed on macOS 12+).
# ─────────────────────────────────────────────────────────────

PORT=8902

echo ""
echo "  JioGames All Options Explorer"
echo "  ────────────────────────────────────"

# ── Find the master file anywhere under the home folder ──────
HTML=$(find "$HOME" -name "jiogames-selectgenreAllOptions.html" 2>/dev/null | head -1)

if [ -z "$HTML" ]; then
    echo "  ✗  Could not find jiogames-selectgenreAllOptions.html"
    echo "     Make sure all option files are saved in the same folder."
    read -p "  Press Enter to close..."
    exit 1
fi

echo "  ✓  Found file: $HTML"

# ── Kill any stale server on this port ───────────────────────
lsof -ti:$PORT | xargs kill -9 2>/dev/null

# ── Start Python server from filesystem root (/) ─────────────
cd /
python3 -m http.server $PORT &>/dev/null &
SERVER_PID=$!

echo "  ✓  Server running on http://localhost:$PORT  (PID $SERVER_PID)"

# ── URL-encode the path so spaces become %20 ─────────────────
ENCODED=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$HTML")

# ── Open the file in the default browser ─────────────────────
sleep 0.6
open "http://localhost:$PORT${ENCODED}"

echo "  ✓  Opened in browser"
echo ""
echo "  All 5 files must be in the same folder:"
echo "    jiogames-selectgenreAllOptions.html  (master)"
echo "    jiogames-selectgenreV2.html          (Option 1)"
echo "    jiogames-selectgenreV3.html          (Option 2)"
echo "    jiogames-selectgenreV0.html          (Option 3)"
echo ""
echo "  Leave this window open while reviewing."
echo "  Press Ctrl+C (or close this window) to stop the server."
echo ""

# ── Keep running until the user quits ────────────────────────
trap "kill $SERVER_PID 2>/dev/null; echo '  Server stopped.'; exit 0" INT TERM
wait $SERVER_PID
