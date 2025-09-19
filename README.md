# wds_flutter
Flutter를 위한 WDS(WINC Design System)

[![Netlify Status](https://github.com/ppbstudios/wds_flutter/actions/workflows/deploy-widgetbook.yml/badge.svg?branch=main)](https://github.com/ppbstudios/wds_flutter/actions/workflows/deploy-widgetbook.yml)

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
