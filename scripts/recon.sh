#!/usr/bin/env bash
# recon.sh — Phase 1 (Recon) helper for Eng Reverse.
# Read-only triage of a local artifact. Does NOT touch any network or live target.
# Usage: ./recon.sh <path-to-artifact> [outdir]
set -euo pipefail

ARTIFACT="${1:?usage: recon.sh <artifact> [outdir]}"
OUT="${2:-recon-out}"
mkdir -p "$OUT"

echo "[*] Eng Reverse recon on: $ARTIFACT"
echo "[*] Output: $OUT"

have() { command -v "$1" >/dev/null 2>&1; }

{
  echo "## file type"
  file "$ARTIFACT" 2>/dev/null || true
  echo
  echo "## size / hashes"
  wc -c < "$ARTIFACT" | sed 's/^/bytes: /'
  (sha256sum "$ARTIFACT" 2>/dev/null || shasum -a 256 "$ARTIFACT" 2>/dev/null) || true
} > "$OUT/00-identity.txt"

# Entropy / packing hint
if have binwalk; then
  binwalk -E "$ARTIFACT" > "$OUT/01-entropy.txt" 2>&1 || true
  binwalk "$ARTIFACT" > "$OUT/02-signatures.txt" 2>&1 || true
fi

# Strings
if have strings; then
  strings -a -n 6 "$ARTIFACT" > "$OUT/03-strings.txt" 2>/dev/null || true
  echo "[*] strings: $(wc -l < "$OUT/03-strings.txt") lines"
fi

# Binary metadata
if have rabin2; then
  { echo "### info"; rabin2 -I "$ARTIFACT";
    echo "### imports"; rabin2 -i "$ARTIFACT";
    echo "### exports/symbols"; rabin2 -s "$ARTIFACT"; } > "$OUT/04-rabin2.txt" 2>&1 || true
elif have readelf; then
  readelf -a "$ARTIFACT" > "$OUT/04-readelf.txt" 2>&1 || true
fi

# Mitigations (best effort)
if have checksec; then
  checksec --file="$ARTIFACT" > "$OUT/05-checksec.txt" 2>&1 || true
fi

echo "[*] Recon complete. Review $OUT/ then pick the narrowest region for Analysis."
echo "[*] Reminder: establish authorization before any dynamic/live phase."
