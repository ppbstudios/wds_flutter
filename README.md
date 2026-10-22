# wds_flutter
Flutter를 위한 WDS(WINC Design System)

[![Netlify Status](https://github.com/ppbstudios/wds_flutter/actions/workflows/deploy-widgetbook.yml/badge.svg?branch=main)](https://github.com/ppbstudios/wds_flutter/actions/workflows/deploy-widgetbook.yml)

### 앱에서 설치하기

`wds_components`, `wds_foundation`을 각각 git 의존성으로 추가하고, `ref`는 릴리스 태그가 가리키는 **전체 커밋 SHA(40자)** 로 고정합니다. 두 패키지의 `ref`는 항상 같은 SHA여야 합니다.

```yaml
dependencies:
  wds_components:
    git:
      url: git@github.com:ppbstudios/wds_flutter.git
      path: packages/components
      ref: <v0.1.0 의 전체 SHA> # v0.1.0
  wds_foundation:
    git:
      url: git@github.com:ppbstudios/wds_flutter.git
      path: packages/foundation
      ref: <v0.1.0 의 전체 SHA> # v0.1.0
```

SHA 확인: `git ls-remote git@github.com:ppbstudios/wds_flutter.git refs/tags/v0.1.0` (릴리스 태그 워크플로 Summary 에도 출력됩니다)

> ⚠️ `ref`에 태그명(`v0.1.0`)이나 짧은 SHA를 쓰면 안 됩니다. `wds_components`가 `wds_foundation`을 `path: ../foundation`으로 참조하기 때문에 pub은 이를 **전체 SHA**로 해석하는데, 앱이 다른 형태의 ref로 `wds_foundation`을 직접 선언하면 서로 다른 소스로 판단해 version solving이 실패합니다.

- 앱의 `pubspec.lock`을 커밋하고, CI에서는 `flutter pub get --enforce-lockfile`로 설치합니다.
- 업데이트할 때는 두 `ref`를 새 태그의 SHA로 함께 바꾼 뒤 `flutter pub get`을 실행합니다.

### 버전 관리 (lockstep)

`wds`, `wds_tokens`, `wds_foundation`, `wds_components`, `wds_widgetbook`은 항상 **같은 버전**을 사용합니다.

- 깨지는 변경(API 이름 변경·삭제 등): minor 업 (`0.1.0` → `0.2.0`)
- 그 외 기능 추가·수정: patch 업 (`0.1.0` → `0.1.1`)

릴리스 방법:
1. `melos run bump-version -- 0.1.1` (또는 `./tools/bump_version.sh 0.1.1`)로 전체 pubspec 버전을 변경
2. `CHANGELOG.md` 맨 위에 `### 0.1.1` 항목 작성
3. PR 머지 → `main` 푸시 시 GitHub Actions가 `v0.1.1` 태그를 자동 생성

PR에서는 패키지 간 버전 불일치나 CHANGELOG 누락이 있으면 `Version Check` 가 실패합니다 (`./tools/bump_version.sh --check`).

### Token Generator 사용법 (`tools/token_generator`)

디자인 토큰 JSON을 Dart 코드로 변환합니다. 생성된 파일은 `packages/tokens/lib/atomic/*.g.dart`에 저장됩니다.

- 요구사항: Dart SDK >= 3.2.0, Melos 설치(선택)
- 입력(JSON): 예) 루트의 `wds_core.json`
- 출력 디렉터리(`-o`): `packages/tokens` (해당 패키지에 `lib/base/token_family.dart`가 존재)

옵션 요약:
- `-i, --input`: 입력 JSON 경로 (필수)
- `-o, --out`: 출력 루트 디렉터리 (필수)
- `-l, --library`: 생성 파일의 라이브러리 이름 (기본값: `wds_tokens`)
- `-f, --overwrite`: 덮어쓰기 (기본값: true)
- `-v, --verbose`: 로그 출력 (기본값: true)

### 🚀 간편한 Shell Script 사용법

`tokens/` 폴더의 JSON 파일을 수정할 때마다 사용할 수 있는 간편한 shell script가 제공됩니다.

**기본 사용:**
```bash
./generate_tokens.sh                    # 모든 토큰 생성 (atomic + semantic)
./generate_tokens.sh atomic             # atomic 토큰만 생성
./generate_tokens.sh semantic           # semantic 토큰만 생성
```

**옵션과 함께 사용:**
```bash
./generate_tokens.sh -v semantic        # verbose 출력과 함께 semantic 토큰 생성
./generate_tokens.sh --base-font-size 18.0 semantic  # 커스텀 폰트 크기로 semantic 토큰 생성
./generate_tokens.sh -n atomic          # 동기화 없이 atomic 토큰만 생성
```

**도움말 보기:**
```bash
./generate_tokens.sh --help
```

**주요 기능:**
- ✨ 간단한 명령어로 긴 `dart run` 명령어 대체
- 🎨 컬러 출력으로 성공/실패/경고 구분
- 🔍 자동 검증으로 입력/출력 디렉터리 확인
- ⚙️ verbose, sync, base-font-size 등 모든 옵션 지원
- 🚨 명확한 에러 메시지와 도움말 제공

### 기존 실행 방법

실행 방법 1) 로컬에서 직접 실행

```bash
dart run /Users/seunghwanly/Documents/wds_flutter/tools/token_generator/bin/main.dart \
  -i /Users/seunghwanly/Documents/wds_flutter/wds_core.json \
  -o /Users/seunghwanly/Documents/wds_flutter/packages/tokens
```

실행 방법 2) 전역 활성화 후 실행

```bash
dart pub global activate --source path /Users/seunghwanly/Documents/wds_flutter/tools/token_generator
wds_tokens -i /Users/seunghwanly/Documents/wds_flutter/wds_core.json -o /Users/seunghwanly/Documents/wds_flutter/packages/tokens
```

실행 결과
- 색상 계열: `lib/atomic/wds_atomic_<root>.g.dart`에 `Color` 정적 상수 및 그룹 클래스 생성
- 문자열 계열: 동일 경로에 문자열 상수 생성

예시 입력/출력 매핑
- 입력: `/Users/seunghwanly/Documents/wds_flutter/wds_core.json`
- 출력: `/Users/seunghwanly/Documents/wds_flutter/packages/tokens/lib/atomic/...`

트러블슈팅
- 명령이 인식되지 않을 경우: `flutter pub get` 또는 `melos run install` 실행 후 재시도
- 전역 실행이 되지 않을 경우: `~/.pub-cache/bin`이 PATH에 포함되어 있는지 확인
