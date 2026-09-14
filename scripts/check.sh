#!/bin/zsh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BIN="$ROOT/mac/dist/webp-paste.app/Contents/MacOS/WebPPaste"

"$ROOT/mac/build.sh"

webp="$(mktemp /tmp/webp-paste.XXXXXX.webp)"
avif="$(mktemp /tmp/webp-paste.XXXXXX.avif)"
trap 'rm -f "$webp" "$avif"' EXIT

"$BIN" --convert "$ROOT/fixtures/screenshot.png" "$webp"
"$BIN" --convert "$ROOT/fixtures/screenshot.png" "$avif"

python3 - "$ROOT/fixtures/screenshot.png" "$webp" "$avif" <<'PY'
import pathlib, sys
png, webp, avif = (pathlib.Path(p) for p in sys.argv[1:])
src = png.stat().st_size
w = webp.read_bytes()
a = avif.read_bytes()
if w[:4] != b"RIFF" or w[8:12] != b"WEBP":
    raise SystemExit(f"not webp: {w[:12]!r}")
if b"ftyp" not in a[:32] or b"avif" not in a[:32]:
    raise SystemExit(f"not avif: {a[:16]!r}")
if len(w) >= src:
    raise SystemExit(f"webp not smaller: {len(w)} >= {src}")
if len(a) >= src:
    raise SystemExit(f"avif not smaller: {len(a)} >= {src}")
print(f"ok  png {src}  webp {len(w)}  avif {len(a)}")
PY
