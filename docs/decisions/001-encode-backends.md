# ADR-001: Encode backends

## Status
Accepted

## Date
2026-09-14

## Context
Chrome will not `clipboard.write(image/webp)`. The useful path is to put a WebP **file** on the clipboard so canvases paste the file. ImageIO on macOS can read WebP but cannot write it. Windows WIC WebP is decode-only on typical installs.

## Decision
- **macOS:** statically link Homebrew `libwebp.a` + `libsharpyuv.a`. AVIF via ImageIO `public.avif`.
- **Windows:** ImageSharp managed WebP encoder. No libwebp DLL, no AVIF.

## Alternatives
- One C library for both platforms — needs MinGW/CGO cross-compile from a Mac. Rejected.
- WIC / WinRT encoder — not available without extra Store codecs, and encode is not guaranteed. Rejected.
- Python + Pillow tray — worse install for users. Rejected.

## Consequences
Mac and Windows output sizes will not match exactly (libwebp vs ImageSharp). Both must still be smaller than the PNG fixture. Windows has no AVIF toggle.
