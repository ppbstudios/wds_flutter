# 디자인 토큰 생성기 요구사항

## 개요

token_generator를 통해 JSON 데이터를 순수 Dart 코드로 변환하여 primitive(atomic), semantic 디자인 토큰을 생성합니다.
foundation은 개발자가 수작업으로 구현합니다.

### 입력 파일
| 파일명 | 역할 | 출처 |
|-------|------|------|
| `design_system_atomic.json` | 원시(primitive) 토큰 정의 | Figma 내보내기 |
| `design_system_semantic.json` | 의미적(semantic) 토큰 정의 | Figma 내보내기 |

### 출력 구조
| 토큰 레벨 | 생성 위치 | 관리 방식 | 설명 |
|----------|----------|----------|------|
| Atomic | `tokens/lib/atomic/` | 자동 생성 | 원시 디자인 값들 |
| Semantic | `tokens/lib/semantic/` | 자동 생성 | 의미적 토큰들 |

### 패키지 연동 구조
```
JSON → tokens(자동생성) → foundation(수작업) → components(사용)
```

## JSON 구조 요구사항

모든 토큰의 최하위 객체는 다음 구조를 가져야 합니다:
```json
{
  "$type": "토큰 타입",
  "$value": "토큰 값"
}
```

### 클래스 생성 규칙

| JSON 구조 | 생성되는 Dart 클래스 |
|-----------|-------------------|
| 숫자 키 (`"50", "100"`) | `v` 접두사 (`v50`, `v100`) |
| 문자 키 (`"blue", "primary"`) | 카멜케이스 변환 |
| 중첩 객체 | part 클래스로 분리 |

#### 예시
```json
{
  "Blue": {
    "50": { "$type": "color", "$value": "#e6ebfd" },
    "100": { "$type": "color", "$value": "#cdd8ff" }
  }
}
```

```dart
class WdsColorBlue {
  const WdsColorBlue._();
  
  static const Color v5 = Color(0xFFF9EDCE);
  static const Color v50 = Color(0xFFE6EBFD);
  static const Color v100 = Color(0xFFCDD8FF);
}
```

### 라이브러리 구조

| 파일 구조 | 파일 내용 |
|-----------|----------|
| `color/wds_atomic_color_blue.dart` | `part of '../wds_atomic_color.dart';` |
| `color/wds_atomic_color_pink.dart` | `part of '../wds_atomic_color.dart';` |
| `wds_atomic_color.dart` | 메인 라이브러리 + part 선언 |

```dart
// wds_atomic_color.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import "package:flutter/widgets.dart";

part 'color/wds_atomic_color_blue.dart';
part 'color/wds_atomic_color_pink.dart';
```

## 패키지 Import 가이드

### 기본 원칙
| 상황 | 사용할 패키지 | 이유 |
|------|-------------|------|
| 기본 위젯 | `package:flutter/widgets.dart` | Material 독립성 유지 |
| Color 클래스 필요 | `package:flutter/material.dart` | Color 클래스 사용 |
| 복잡한 위젯 (TabBar 등) | `package:flutter/material.dart` | 선별적 Material 사용 |


## Atomic 토큰 생성 규칙

### 파일 구조
```
atomic/
├── wds_atomic_color/                # Part 파일들
├── wds_atomic_color.dart            # 메인 라이브러리
├── wds_atomic_font/                 # Part 파일들
├── wds_atomic_font.dart             # 메인 라이브러리
├── wds_atomic_opacity.dart
├── wds_atomic_radius.dart
├── wds_atomic_space.dart
└── wds_atomic.dart                  # Export 파일
```

### atomic.dart 구조
```dart
library;

export 'wds_atomic_color.dart';
export 'wds_atomic_font.dart';
export 'wds_atomic_radius.dart';
export 'wds_atomic_opacity.dart';
export 'wds_atomic_space.dart';
```

### 생성 규칙
| 규칙 | 적용 방법 |
|------|----------|
| 파일명 | `.g.dart` 사용하지 않음 |
| 클래스명 | Color: `WdsAtomicColor{그룹명}`, Font: `WdsAtomicFont{그룹명}` |
| 집계 클래스 | 생성하지 않음 (part만 생성) |

## 타입 변환 규칙

### 변환 표
| $type | Dart 타입 | 변환 규칙 | Import 패키지 |
|-------|----------|----------|-------------|
| `color` | `Color` | 헥스코드 → `Color(0xFFHEXCODE)` | `flutter/material.dart` |
| `dimension` | `double` | rem→px (1rem=16px), px→숫자 | - |
| `text` | `String` | 문자열 그대로, 이스케이프 처리 | - |
| `number` | `double` | 숫자 타입으로 변환 | - |
| `boxShadow` | `List<BoxShadow>` | BoxShadow 객체 배열로 변환 | `flutter/material.dart` |
| `lineHeight` | `double` | "AUTO" → 1.0, 숫자 → double | - |
| `fontSize` | `double` | 문자열 숫자 → double | - |
| `letterSpacing` | `double` | 픽셀 또는 em 단위 | - |
| `paragraphSpacing` | 무시 | 생성하지 않음 | - |

### 상세 변환 규칙

#### Color 타입
```
입력: "#FF5733"
출력: Color(0xFFFF5733)
```

#### Dimension 타입
| 입력 | 출력 | 규칙 |
|------|------|------|
| `"1rem"` | `16.0` | 1rem = 16px |
| `"24px"` | `24.0` | px 단위 제거 |
| `"12"` | `12.0` | 숫자 그대로 |

#### BoxShadow 타입
```json
{
  "color": "#000000",
  "x": 0,
  "y": 3,
  "blur": 16,
  "spread": 0,
  "type": "dropShadow"
}
```

```dart
BoxShadow(
  offset: Offset(0, 3),
  blurRadius: 16,
  spreadRadius: 0,
  color: Color(0x0C000000),
)
```

#### LetterSpacing 타입
| 입력 | 출력 | 변환 규칙 |
|------|------|----------|
| `-0.4` | `-0.4` | px로 간주, 그대로 사용 |
| `"-2.4%"` | `-0.024` | `percentage / 100.0` |

#### Opacity 타입
| 입력 | 출력 | 변환 규칙 |
|------|------|----------|
| `5` | `0.05` | `value / 100.0` |
| `60` | `0.6` | 0.0~1.0 정규화 |

#### FontWeight 타입
| 입력 | 출력 |
|------|------|
| `600` | `FontWeight.w600` |
| 없는 값 | `FontWeight.w400` |

### 폰트 관련 키 파싱 규칙

| 키 이름 | 파싱 여부 | 비고 |
|---------|----------|------|
| `font` | ✅ | 루트 키로 파싱 |
| `family` | ✅ | 맵 키로 파싱 |
| `size` | ✅ | 맵 키로 파싱 |
| `weight` | ✅ | 맵 키로 파싱 |
| `lineHeight` | ✅ | 맵 키로 파싱 |
| `lineHeights` | ❌ | 루트 키로 파싱 안 함 |
| `fontSize` | ❌ | 루트 키로 파싱 안 함 |
| `letterSpacing` | ❌ | 루트 키로 파싱 안 함 |
| `paragraphSpacing` | ❌ | 루트 키로 파싱 안 함 |
| `textCase` | ❌ | 루트 키로 파싱 안 함 |

## Semantic 토큰 생성 규칙

### 생성 조건
- [필수] Atomic 토큰 생성 완료 후 진행
- Semantic의 `$value`는 primitive 토큰 참조
- 별도 그룹 없이 단일 객체인 경우 `$type`에 맞는 파일에 변수로 생성
  - `const Color $cta = WdsAtomicColorNeutral.v900`;
  - 변수명 앞에 `$` prefix 붙이기

### Color 토큰 예시

#### 입력 JSON
```json
{
  "primary": {
    "$type": "color",
    "$value": "{color.blue.400}"
  }
}
```

#### 생성 결과
```dart
// semantic/wds_semantic_color.dart
import "package:flutter/material.dart";
import "../atomic/wds_atomic_color.dart";

const Color $cta = WdsAtomicColorNeutral.v900;
const Color $primary = WdsAtomicColorBlue.v400;
const Color $secondary = WdsAtomicColorPink.v500;
```

#### 하위 깊이가 있는 경우
```dart
// semantic/color/wds_semantic_color_background.dart
part of '../wds_semantic_color.dart';

class WdsSemanticColorBackground {
  const WdsSemanticColorBackground._();
  
  static const Color normal = WdsColorCommon.white;
  static const Color alternative = WdsColorNeutral.v50;
}
```

### Typography 토큰

#### 구성 요소
| 속성 | 타입 | 매핑 |
|------|------|------|
| `family` | `text` | `WdsAtomicFontFamily.pretendard` |
| `weight` | `number` | `WdsAtomicFontWeight.bold` |
| `size` | `number` | `WdsAtomicFontSize.v18` |
| `lineHeight` | `number` | `height` 계산 (배수) |
| `letterSpacing` | `number` | 픽셀 또는 em 단위 |

#### 생성 예시
```dart
import '../atomic/atomic.dart';

class WdsSemanticTypography {
  const WdsSemanticTypography._();
  
  static const TextStyle bold = TextStyle(
    fontFamily: WdsAtomicFontFamily.pretendard,
    fontWeight: WdsAtomicFontWeight.bold,
    fontSize: WdsAtomicFontSize.v18,
    height: WdsAtomicFontLineHeight.v26 / WdsAtomicFontSize.v18, // 배수 계산
    letterSpacing: -0.024, // -2.4% → -0.024
  );
}
```

`letterSpacing` 값이 없는 경우에는 `0`으로 통일

### Height 계산 규칙
| 조건 | 계산 방법 |
|------|----------|
| lineHeight가 숫자 | `height = lineHeight / fontSize` |
| lineHeight가 "AUTO" | `height = 1.0` |

### Body 계열 예외 처리

일반 구조는 2단계 (`Heading18 > bold`), Body는 3단계 허용 (`Body15 > Normal > bold`)
- Body는 Reading, Normal 로 분류됨

#### 예시 JSON
```json
{
  "Typography": {
    "Body15": {
      "Normal": {
        "bold": { /* 스타일 정의 */ },
        "medium": { /* 스타일 정의 */ }
      },
      "Reading": {
        "bold": { /* 스타일 정의 */ }
      }
    }
  }
}
```


### Shadow 토큰

#### 개요
- shadow는 color에 알파가 포함된 색상을 사용합니다. 기존 color 처리와 동일하게 변환합니다.
- 구조: `shadow > 그룹(예: coolNeutral, Neutral) > 상태(예: normal, emphasize, strong, heavy) > 레이어(shadow1, shadow2, shadow3)`
- 각 상태는 `List<BoxShadow>`로 생성됩니다. 레이어 순서대로 배열에 담깁니다.

#### 지원 속성
| 키 | 타입 | 매핑 |
|----|------|------|
| `color` 또는 `Color` | `color` | `Color`로 변환 또는 `{color.*}` 참조 처리 |
| `blur` | `number` | `WdsAtomicBlur.*` 참조 또는 숫자 |
| `offsetY` 또는 `offstY` | `number` | `WdsAtomicOffsetY.*` 참조 또는 숫자 |

주의: `offsetX`는 현재 스펙에 없으며 X는 0으로 고정됩니다. `spread`는 0.0 고정.

#### 예시 JSON
```json
{
  "shadow": {
    "coolNeutral": {
      "normal": {
        "shadow1": {
          "color": {"$type": "color", "$value": "#819bff1f"},
          "blur": {"$type": "number", "$value": "{blur.sm}"},
          "offsetY": {"$type": "number", "$value": "{offsetY.xs}"}
        }
      }
    }
  }
}
```

#### 생성 결과
```dart
// semantic/wds_semantic_shadow.dart
import "package:flutter/material.dart";
import "../atomic/atomic.dart";

part 'shadow/wds_semantic_shadow_cool_neutral.dart';

// semantic/shadow/wds_semantic_shadow_cool_neutral.dart
part of '../wds_semantic_shadow.dart';

class WdsSemanticShadowCoolNeutral {
  const WdsSemanticShadowCoolNeutral._();

  static const List<BoxShadow> normal = [
    BoxShadow(
      offset: Offset(0, WdsAtomicOffsetY.xs),
      blurRadius: WdsAtomicBlur.sm,
      spreadRadius: 0.0,
      color: Color(0x1F819BFF),
    ),
  ];
}
```
| `Body15 > Normal > bold` | `body15NormalBold` |
| `Body15 > Normal > medium` | `body15NormalMedium` |
| `Body15 > Reading > regular` | `body15ReadingRegular` |
| `Heading18 > bold` | `heading18Bold` |

### Export 구조
```dart
// semantic/wds_semantic.dart
library;

export 'wds_semantic_color.dart';
export 'wds_semantic_typography.dart';
```

## Foundation 패키지 연동

### 연동 흐름
1. **tokens 생성**: token_generator로 atomic, semantic 토큰을 `packages/tokens/`에 생성
2. **foundation 갱신(수작업)**: tokens 변경 사항을 반영하여 `packages/foundation/lib/` 파일들을 직접 수정
3. **components 사용**: foundation을 통해서만 토큰 접근

### Components 사용 원칙

#### 올바른 사용법
```dart
// ✅ foundation을 통한 접근
import 'package:wds_foundation/wds_foundation.dart';

class WdsButton extends StatelessWidget {
  const WdsButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(  // Container 대신 DecoratedBox
        decoration: const BoxDecoration(
          color: WdsColors.primary,  // foundation 인터페이스
          borderRadius: BorderRadius.all(Radius.circular(WdsRadius.sm)),
        ),
        child: Padding(  // 별도 Padding
          padding: const EdgeInsets.symmetric(
            horizontal: WdsSpacing.md5,
            vertical: WdsSpacing.md3,
          ),
          child: Text(
            label,
            style: WdsTypography.buttonLabel,  // foundation 인터페이스
          ),
        ),
      ),
    );
  }
}
```

#### 금지된 사용법
```dart
// ❌ tokens 직접 접근
import 'package:wds_tokens/atomic/wds_atomic_color.dart';  // 직접 import 금지

class BadButton extends StatelessWidget {
  @override  // const 생성자 누락
  Widget build(BuildContext context) {
    return Container(  // Container 남용
      color: WdsAtomicColorBlue.v400,  // tokens 직접 사용 금지
    );
  }
}
```

### 위젯 구성 원칙

| 원칙 | 적용 방법 |
|------|----------|
| 단순한 Widget Tree | 불필요한 중첩 최소화 |
| const 최적화 | 모든 생성자에 const 적용 |
| 전용 위젯 활용 | Container → DecoratedBox + Padding |

## CLI 옵션

### CLI 옵션

| 옵션 | 설명 | 기본값 | 예시 |
|------|------|--------|------|
| `-k` | 토큰 종류 (atomic/semantic) | - | `-k semantic` |
| `-i` | 입력 파일 경로 | - | `-i tokens/design_system_atomic.json` |
| `-o` | 출력 디렉토리 | - | `-o packages/tokens` |
| `--base-font-size` | 기본 폰트 크기 | 16.0 | `--base-font-size 16.0` |

### 단계별 실행 예시

```bash  
# 1. Atomic 토큰 생성
dart run bin/main.dart \
  -k atomic \
  -i tokens/design_system_atomic.json \
  -o packages/tokens

# 2. Semantic 토큰 생성
dart run bin/main.dart \
  -k semantic \
  -i tokens/design_system_semantic.json \
  -o packages/tokens \
  --base-font-size 16.0

# 3. Foundation 통합 인터페이스 갱신(수작업)
# tokens 변경 사항을 참고하여 packages/foundation/lib/*.dart 업데이트
```

### 파이프라인 자동화
```bash
#!/bin/bash
# generate_tokens.sh

echo "🔥 토큰 생성 파이프라인 시작"

echo "📦 1단계: Atomic 토큰 생성 중..."
dart run bin/main.dart -k atomic -i tokens/design_system_atomic.json -o packages/tokens

echo "📦 2단계: Semantic 토큰 생성 중..."  
dart run bin/main.dart -k semantic -i tokens/design_system_semantic.json -o packages/tokens --base-font-size 16.0

echo "📦 3단계: Foundation 통합 인터페이스 수작업 갱신..."
echo "   ↳ packages/foundation/lib/colors.dart 등 직접 수정"

echo "✅ 토큰 생성 완료!"
echo "💡 이제 components에서 'package:foundation/foundation.dart'를 import하여 사용하세요."
```

---

Written by [seunghwanly](https://github.com/seunghwanly)