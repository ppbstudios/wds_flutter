# wds_flutter
Flutter를 위한 WDS(WINC Design System)

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
