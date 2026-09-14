# webp-paste Windows tray

Same job as the Mac menu bar: copy an image, clipboard becomes a small WebP **file**, paste into tldraw / Excalidraw with Ctrl+V.

## Flow
- Tray icon. Default on.
- On: new image on the clipboard is resized (long edge 2560) and written as WebP quality 82, then the clipboard is replaced with that file (`CF_HDROP` / `SetFileDropList` only — no PNG payload).
- Off: clipboard is not touched.
- Menu: 변환 (checkbox), last size `원본 → N WebP (−N%)`, 저장…, 종료.
- No windows, sliders, login item, network, or AVIF. AVIF stays Mac-only (ImageIO).

## Convert / skip
Convert: PNG, JPEG, TIFF, BMP, HEIC/AVIF files ImageSharp can read, or a clipboard bitmap (`ContainsImage`), while on.
Skip: off; text; our own write; already `.webp`; GIF; PDF; multiple files; encode failure (leave clipboard).
Temps: `%LOCALAPPDATA%\webp-paste\` (keep 12).

## Architecture
One WinForms process, no visible window. `AddClipboardFormatListener` / `WM_CLIPBOARDUPDATE`. Encode: SixLabors.ImageSharp lossy WebP (no native libwebp on Windows). `--convert in out.webp` for CI.

## Verify
- `webp-paste.exe --convert fixtures/screenshot.png out.webp` → RIFF/WEBP, smaller than input.
- After a PNG screenshot is on the clipboard, the drop list is a `.webp` under the cache dir.
