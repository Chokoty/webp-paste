# Agent notes

Local clipboard converter. Images never leave the machine. No server, no accounts, no extra UI.

## Skills

Use **ponytail** (simplest thing that works) and **superpowers** (TDD, verify before claiming done). Both Claude Code and Grok should follow this file.

## Build

```bash
./scripts/check.sh          # macOS: build + encode fixtures/screenshot.png
./mac/build.sh              # macOS app only
# Windows (PowerShell):
./win/build.ps1
./win/dist/webp-paste.exe --convert fixtures/screenshot.png out.webp
```

Needs Homebrew `webp` on macOS (`libwebp.a` + `libsharpyuv.a`, statically linked). Windows encode is ImageSharp (pure managed). Runtime brew is not required on Mac.

## Behavior that must stay

- Copy image → clipboard becomes a **file** (WebP, or AVIF on Mac), not a PNG payload. Canvases (tldraw / Excalidraw) take the file on paste.
- Quality 82, long edge 2560, keep 12 temp files.
- Skip: GIF, PDF, multiple files, already the selected format, our own write, convert-off.
- Do not delete user files. Temps: `~/Library/Caches/webp-paste/` (Mac), `%LOCALAPPDATA%\webp-paste\` (Windows).
- Windows is WebP only. AVIF is Mac ImageIO.

## Layout

- `mac/` AppKit menu bar. `encode_webp.c` wraps libwebp. ImageIO cannot write WebP.
- `win/` WinForms tray. `WM_CLIPBOARDUPDATE`, `Clipboard.SetFileDropList`.
- `index.html` fallback for drag/save. Chrome cannot `clipboard.write(image/webp)`.
- `scripts/check.sh` is the regression gate. Do not weaken it.
