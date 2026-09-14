# FINDINGS — Chromium + Mac (2026-09-09)

## Mac ImageIO WebP encode

`CGImageDestinationCopyTypeIdentifiers()`에 WebP 없음. 읽기는 되고 쓰기는 안 됨.
이 맥(macOS 26.6) 목적 타입에는 `public.avif`, `public.heic`, `public.png` 등은 있음.
인코딩은 Homebrew `libwebp.a` + `libsharpyuv.a`를 정적 링크. 런타임에 brew 불필요.

픽스처 1600×900 PNG 64,789 B → WebP 8,856 B (`WebPEncodeRGBA` q=82).
`--once`: PNG 클립보드 → `public.file-url` / `NSFilenamesPboardType` 의 `.webp` 파일.
이미 `.webp`면 skip `already-webp`. 텍스트는 `not-image`.

## Mac ImageIO AVIF encode

`public.avif`는 `CGImageDestinationCopyTypeIdentifiers()`에 있음. `UTType.avif` 멤버는 없고 `UTType(filenameExtension: "avif")` / `public.avif`로 생성.
같은 픽스처 PNG 64,789 B → AVIF 31,614 B (`kCGImageDestinationLossyCompressionQuality` 0.82). 매직 `ftypavif`. WebP q=82(8,856 B)보다 큼.

libwebp `82`와 ImageIO `0.82`는 같은 스케일이 아님. 알파/썸네일 아님(원본·RGBA 재래스터 모두 31,614 B). ImageIO AVIF는 0.6 이상에서 용량만 급증.

| 설정 | 용량 | PSNR |
|---|---|---|
| WebP q=82 | 8,856 B | 40.96 dB |
| AVIF 0.50 | 4,610 B | 39.12 dB |
| AVIF 0.60 | 9,179 B | 41.16 dB |
| AVIF 0.82 | 31,614 B | 41.80 dB |

## Chromium 스파이크 (웹 페이지)

환경: Chrome (DevTools MCP) · `http://127.0.0.1:8765/` · macOS

## canvas.toBlob('image/webp')

성공. `blob.type === "image/webp"`. 같은 캔버스에서 PNG/JPEG도 생성됨.

| MIME | 320×180 단색+도형 |
|---|---|
| image/webp q=0.82 | 1,284 B |
| image/png | 3,505 B |
| image/jpeg q=0.82 | 2,429 B |

1600×900 픽스처 PNG 64,789 B → WebP 9,314 B (−86%). 미리보기 `naturalWidth/Height`는 원본과 같음.

긴 변 3000×2000 입력은 `MAX_EDGE` 적용 후 2560×1707.

## clipboard.write

| 페이로드 | 결과 |
|---|---|
| `image/webp` only | `NotAllowedError`: Type image/webp not supported on write |
| `image/webp` + `image/png` | 동일 이유로 실패 (항목 전체가 거절됨) |
| `image/png` only | 성공 |

`isSecureContext` true, `clipboard-write` permission granted.

`clipboard.read()`를 호출하면 권한 프롬프트가 뜨고, 이후 `write`가 멈출 수 있다. 앱은 read를 쓰지 않는다. `write`가 멈춰도 미리보기는 먼저 그리고, 복사는 2.5초 안에 끝나지 않으면 실패로 처리한다.

앱은 클립보드에 쓰지 않는다. 용량 절감 경로는 `.webp` 다운로드/드래그. Chrome 우클릭 “이미지 복사”도 PNG다.

## file://

`file:///Users/chokoty/webp-paste/index.html` 도 Chromium에선 secure context. 이 세션에서는 PNG 클립보드 write와 변환이 성공했다. 콘솔에 `file:` unique origin 경고가 남음. 일반 Chrome 프로필에서는 클립보드가 막힐 수 있어 localhost를 권장.

## 드래그

`dragstart`에서 `dataTransfer.items.add(File)` 로 `image/webp` 파일이 실림. `types`에 `Files`, `DownloadURL` 포함.

다른 탭(tldraw / Obsidian)으로의 실제 드롭은 이 세션에서 자동화하지 못함. 실패하면 **WebP 저장 후 파일 드롭**이 실사용 경로.

## 실패 메시지

- `text/plain` 파일 → "이미지 파일이 아닙니다."
- 빈 드롭/`null` → 동일

## 콘솔

앱 자체 에러는 없음. `favicon.ico` 404는 인라인 SVG 아이콘으로 제거.

## 실사용 함의

Excalidraw / tldraw에 **용량을 줄여** 넣으려면 붙여넣기(PNG)가 아니라 **WebP 파일**(드래그 또는 저장)을 쓴다.
