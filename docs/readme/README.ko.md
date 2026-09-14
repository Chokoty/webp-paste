<h1 align="center">
  <img src="../assets/icon.png" alt="webp-paste" width="72" valign="middle" /> webp-paste
</h1>

<p align="center">
  <strong>스크린샷을 복사하면 WebP 파일이 됩니다.</strong><br/>
  맥은 메뉴 막대, 윈도우는 트레이. 이미지는 이 컴퓨터 안에서만 변환되고 업로드하지 않습니다.
</p>

<p align="center">
  <img src="../assets/hero.png" alt="PNG 스크린샷을 WebP로 줄여 tldraw / Excalidraw에 붙이는 흐름" width="960" />
</p>

[English README](../../README.md)

tldraw와 Obsidian Excalidraw는 클립보드에 있는 것을 그대로 붙입니다. PNG 스크린샷은 용량이 큽니다. Chrome은 클립보드에 WebP를 쓰지 못하므로 (`NotAllowedError`), 이 앱은 **파일**을 올려 둡니다. `⌘V` / `Ctrl+V`가 그 파일을 붙입니다.

픽스처 PNG(1600×900, 63.3 KB)는 맥에서 **8.6 KB WebP (−86%)**.

## 쓰는 방법

### 맥

```bash
brew install webp          # 빌드할 때만
./mac/build.sh
open mac/dist/webp-paste.app
```

아이콘이 켜져 있으면 이미지 복사가 WebP 파일이 됩니다. 원본 PNG가 필요하면 메뉴에서 **변환**을 끕니다. **포맷**에서 AVIF로 바꿀 수 있습니다. 파일을 남기려면 **저장…**.

품질 0.82, 긴 변 2560px. 임시 파일은 `~/Library/Caches/webp-paste/`.

### 윈도우

[.NET 8 SDK](https://dot.net)로 빌드합니다.

```powershell
./win/build.ps1
./win/dist/webp-paste.exe
```

`main` 푸시마다 CI가 `webp-paste.exe` 아티팩트를 올립니다. 트레이에서 **변환**을 끄면 클립보드를 건드리지 않습니다. 윈도우는 WebP만 지원합니다. 임시 파일은 `%LOCALAPPDATA%\webp-paste\`.

## 웹 페이지 (드래그/저장)

Chrome은 클립보드에 WebP를 못 넣습니다. 파일로 저장하거나 드래그할 때만 이 페이지를 씁니다.

```bash
python3 -m http.server 8765
```

[http://127.0.0.1:8765](http://127.0.0.1:8765)

## 라이선스

MIT. [LICENSE](../../LICENSE).
