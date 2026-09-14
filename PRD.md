# webp-paste PRD (Day-Zero)

## 해결하려는 문제
Obsidian Excalidraw와 tldraw 공유 캔버스에 스크린샷을 넣을 때 PNG 용량이 크다. Chrome은 클립보드에 WebP를 못 넣으므로, 맥 메뉴 막대에서 복사 즉시 WebP 파일로 바꿔 `⌘V`로 붙인다.

## 기능 요구사항
### A. 변환
1. 클립보드 붙여넣기(`Cmd+V`) 또는 파일 드롭 시 자동으로 WebP 변환. 합격: 입력 직후 `image/webp` Blob이 생기고 미리보기가 바뀐다.
2. 품질은 고정 기본값(눈에 띄게 깨지지 않는 선). 슬라이더 없음.

### B. 반출
1. WebP 저장: `.webp` 다운로드. 합격: 클릭 시 `image/webp` 파일이 내려간다.
2. 미리보기 드래그: 생성된 파일을 드래그할 수 있게 한다. 합격: `dragstart`에서 File이 dataTransfer에 실린다.
3. 앱 클립보드 쓰기는 하지 않는다. Chrome은 `image/webp` write가 거절되고, 기본 ‘이미지 복사’는 PNG가 되므로 미리보기 우클릭은 WebP 저장 메뉴로 바꾼다.

### C. 피드백
1. 원본 용량, 결과 용량, 감소 비율을 보여 준다.

## 기술 제약 (지금 확정 가능한 것만)
- 본류는 맥 메뉴 막대와 윈도우 트레이 앱. 웹 페이지는 드래그/저장 보조. 윈도우는 WebP만 (AVIF는 맥 ImageIO).
- 서버 업로드 없음. ImageIO는 WebP를 못 써서 libwebp 정적 링크.
- 편집기, 스토어, 폴더 일괄, 로그인 시 자동 실행은 하지 않는다.

## 미지 영역 선언 — 추측으로 확정하지 말 것
탐사 결과는 `FINDINGS.md`. 2026-09-09 Chromium 스파이크에서 아래는 확인됨.
- `canvas.toBlob('image/webp')` 성공
- `clipboard.write`는 `image/png`만. `image/webp`는 NotAllowedError
- `file://`도 secure context일 수 있으나 localhost를 권장
- 같은 페이지 `dragstart`에 WebP File이 실림. 다른 앱으로의 드롭은 미검증 → 실패 시 다운로드 후 드롭

## 작업 방식 — 수직 슬라이스
0. 스파이크: localhost에서 WebP Blob + 클립보드 write 확인 → FINDINGS.md
1. 붙여넣기/드롭 → WebP 미리보기 + 용량 표시
2. 복사 + 다운로드 + 드래그
3. 실패 메시지(이미지 아님, WebP 미지원, 클립보드 권한)

## 안전장치
- 원본 파일을 삭제·덮어쓰지 않는다. 새 Blob만 만든다.
- 네트워크로 이미지를 보내지 않는다.

## 성공 기준
- 스크린샷을 붙여넣으면 WebP가 생기고 용량이 줄어든 숫자가 보인다.
- `.webp`를 저장하거나 드래그해서 Excalidraw/tldraw에 넣을 수 있다.
