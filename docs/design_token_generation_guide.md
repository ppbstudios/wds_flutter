# 요청

token_generator 로직을 아래 요구사항을 기반으로 작성

# 역할

@design_token_background.md, @guide.md 을 분석해 어떤 일을 해야하는 지 파악합니다. JSON 데이터를 순수 Dart 코드로 변환해 primitive(atomic), semantic, 그리고 component_specific 관련 디자인 토큰을 제작해야 합니다. 제작 시에는 @token_generator/ 를 통해 제작합니다. 

# 개요

제공되는 JSON은 
- @tokens/design_system_atomic.json
- @tokens/design_system_semantic.json

으로 Figma에서 export된 JSON이 파일로 주어질 예정입니다. 생성되는 디자인 토큰 관련 Dart 클래스는 모두 JSON 기반이어야하며, JSON에 없는 데이터는 Dart 클래스로 생성되지 않습니다.

- atomic (primitive)
- semantic
- component_specific

으로 대분류를 3가지로 나눕니다. 생성된 토큰들은 다른 패키지에 적용됩니다. 

적용되는 패키지:
- @foundation/ 
- @components/ 

그리고 이 2개의 패키지에서 생성되는 요소들은 @widgetbook.dart 패키지로 Import 되어 Flutter Web이 빌드돼 디자이너, 기획자와 소통하는 데 사용됩니다.

JSON이 변경될 때 마다 token 부터 components 까지 mapping 되어야 하므로 정해진 규칙이 있어야 변경되는 값에 유연하게 대체할 수 있습니다.

# 요구사항

JSON의 객체를 구분 지을 때 가장 안쪽 객체는 상시

``` JSON
{
  "$type": "some type",
  "$value": "some value"
}
```

를 갖습니다. 해당 값을 key 로 갖는 key - value 쌍은 특정 클래스 나 static 변수로 생성되야 합니다.

그리고 static 변수들을 포함한 클래스는 바로 상위 객체가 됩니다. 

예를 들어, 

``` JSON
{
  "Blue": {
    "50": { "$type": "some type", "$value": "some value" },
    "100": { "$type": "some type", "$value": "some value" },
    ...
  }
}
```
이런 JSON이 있을 때는 

``` dart
class WdsColorBlue {
  const WdsColorBlue._();

  static const Color v50 = Color(0xFFE6EBFD);
  static const Color v100 = Color(0xFFCDD8FF);
  ...
}
```
와 같은 클래스가 생성됩니다. key가 "{number}"인 경우에는 `v{number}`로 변수명을 작성합니다.

@design_system_atomic.json 안에 보면 "color"라는 상위 객체로 "Blue", "Sky", "Pink" 등 다양한 색상이 구성되어 있는 걸 볼 수 있는데, 이럴 때 가장 상위 객체가 전체를 갖는 클래스로 생성되면 됩니다.

여기서 주의할 점은 `WdsColorXXX._()` 처럼 private 생성자를 사용해야하기 때문에 하나의 라이브러리로 묶어야 합니다. 하나의 라이브러리로 묶을 때는 part 를 활용합니다.

``` 
├── color/
│   ├── wds_color_blue.dart
│   ├── wds_color_pink.dart
│   ├── ...
├── color.dart
```

이 때 color.dart 는 

``` dart
part 'color/wds_color_blue.dart';
part 'color/wds_color_pink.dart';

```

이런 식으로 하나의 라이브러리를 형성하도록 구현합니다.

## Design Token Type Mapping Instructions: primitive

@design_system_atomic.json 에 해당합니다. atomic 디렉토리 내 생성된 모든 파일은 `atomic/atomic.dart` 안에서 export 되어야 합니다.

atomic/atomic.dart 예시
``` dart
library;

export 'color.dart';
export 'font.dart';
export 'radius.dart';
```

- 파일명 규칙: atomic 단일 파일은 `.g.dart`를 사용하지 않습니다. 예) `wds_atomic_radius.dart`, `wds_atomic_opacity.dart`
- 집계 클래스: `WdsColor`, `WdsFont`와 같은 상위 집계 클래스는 생성하지 않습니다. 각 그룹 클래스만(part) 생성합니다.

### Overview

This document outlines the conversion rules for DTCG (Design Tokens Community Group) $type values to Flutter/Dart types in the token generator.

**Type Conversion Table**

  | $type            | Target Dart Type | Conversion Logic                                                               |
  |------------------|------------------|--------------------------------------------------------------------------------|
  | color            | Color            | Convert hex values to Flutter Color objects from package:flutter/material.dart |
  | dimension        | double           | Convert rem to px (1rem = 16px), handle px values, parse as double             |
  | text             | String           | Use as string literal with proper escaping                                     |
  | number           | double           | Convert to double type                                                         |
  | boxShadow        | List<BoxShadow>  | Convert to Flutter BoxShadow objects (see details below)                       |
  | lineHeight       | double           | Handle "AUTO" as 1.0, otherwise convert number to double                       |
  | fontSize         | double           | Convert string numbers to double                                               |
  | letterSpacing    | double           | Use px if number; percentage to em only (no fontSize multiply)                 |
  | paragraphSpacing | Ignored          | Skip this type (could be used in StrutStyle later)                             |

**For "font relevant keys**:
- DO parse "font" for root key
- DO parse "family" for map key
- DO parse "size" for map key
- DO parse "weight" for map key
- DO parse "lineHeight" for map key
- DO NOT parse "lineHeights" for root key
- DO NOT parse "fontSize" for root key
- DO NOT parse "letterSpacing" for root key
- DO NOT parse "paragraphSpacing" for root key
- DO NOT parse "textCase" for root key

### Detailed Conversion Rules

**color Type**
  - Input: Hex color strings (e.g., "#FF5733")
  - Output: Flutter Color object (e.g., Color(0xFFFF5733))
  - Import: package:flutter/material.dart

**dimension Type**
  - Input: String with units or numeric value
  - Conversion:
    - "1rem" → 16.0 (1rem = 16px)
    - "24px" → 24.0
    - "12" → 12.0
  - Output: double value

**boxShadow Type**
  - Input: Object or array of shadow definitions
  - Properties mapping:
    - color → Color (converted from hex)
    - x, y OR offsetX, offsetY → Offset(x, y)
    - blur OR blurRadius → blurRadius
    - spread OR spreadRadius → spreadRadius
    - type should equal "dropShadow"
  - Output: List<BoxShadow>
  - Example:
``` dart
  BoxShadow(
    offset: Offset(0, 3),
    blurRadius: 16,
    spreadRadius: 0,
    color: Color(0x0C000000),
  )
```

**lineHeight Type**
  - Input: String or number
  - Conversion:
    - "AUTO" → 1.0
    - Any numeric string → parse as double
  - Output: double

**fontSize Type**
  - Input: String containing number
  - Conversion: Parse string to double
  - Output: double

**letterSpacing Type**
  - Input: em number (e.g., -0.02), or percentage string (e.g., -2.4%)
  - 규칙(업데이트):
    - 숫자(예: -0.4)로 오면 px(논리 픽셀)로 간주해 그대로 사용합니다.
    - 문자열 퍼센트(예: "-2.4%")로 오면 em으로 변환만 합니다: `em = percentage / 100.0` → `-0.024`.
    - 더 이상 fontSize를 곱하지 않습니다. 사용처(Flutter)는 px 또는 em을 그대로 받습니다.

**opacity Type (atomic/opacity)**
  - Input: number in percentage (e.g., 5, 10, 60)
  - 규칙: 0.0~1.0으로 정규화해서 출력합니다. `normalized = value / 100.0`
  - 예: `5 → 0.05`, `60 → 0.6`

  - Base font size fallback: fontSize가 명시되지 않은 경우, CLI 옵션 `--base-font-size`(기본 16.0)를 곱해 px를 계산합니다.
    - 사용 예: `dart run bin/main.dart -k semantic -i tokens/design_system_semantic.json -o packages/tokens --base-font-size 16.0`

**weight Type**
  - Input: number (e.g. 600)
  - Conversion:
    - 600 → FontWeight.w600
    - unavailable value → FontWeight.w400
  - Output: FontWeight
  
## Design Token Type Mapping Instructions: semantic

@design_system_semantic.json 에 해당합니다.

### Overview

semantic 작업은 primitive 작업이 이루어진 뒤에 진행할 수 있습니다. 이유는 Semantic 내 "$value"는 primitive에서 정의된 값을 활용하기 때문입니다.

### "color"

예를 들어 "$type"이 "color"인 경우,
``` JSON
{
  "Primary": {
    "$type": "color",
    "$value": "{color.Neutral.900}"
  }
}
```
은 Dart로 생성될 때, 위 primitive가 성공적으로 생성되면

atomic/color/wds_color_neutral.dart
``` dart
class WdsColorNeutral {
  const WdsColorNeutral._();
  static const Color v50 = Color(0xFFF6F6F6);
  static const Color v100 = Color(0xFFE3E3E3);
  static const Color v200 = Color(0xFFD3D3D3);
  static const Color v300 = Color(0xFFBCBCBC);
  static const Color v400 = Color(0xFFA2A2A2);
  static const Color v500 = Color(0xFF6D6D6D);
  static const Color v600 = Color(0xFF4E4E4E);
  static const Color v700 = Color(0xFF373737);
  static const Color v800 = Color(0xFF212121);
  static const Color v900 = Color(0xFF121212);
}
```

atomic/color.dart
``` dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import "package:flutter/material.dart";

part 'color/wds_color_blue.dart';
part 'color/wds_color_brand.dart';
part 'color/wds_color_common.dart';
part 'color/wds_color_cool_neutral.dart';
part 'color/wds_color_neutral.dart';
part 'color/wds_color_orange.dart';
part 'color/wds_color_pink.dart';
part 'color/wds_color_sky.dart';
part 'color/wds_color_yellow.dart';
```

Semantic 색상 파일은 다음처럼 생성됩니다.

semantic/color.dart
``` dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import "package:flutter/material.dart";
import "../atomic/color.dart";

const Color cta = WdsColorNeutral.v900;
const Color primary = WdsColorBlue.v400;
const Color secondary = WdsColorPink.v500;
```

하위 depth가 있는 경우, 그룹은 part 클래스로만 제공됩니다.

semantic/color/wds_semantic_color_background.dart
``` dart
part of '../color.dart';

class WdsSemanticColorBackground {
  const WdsSemanticColorBackground._();
  static const Color normal = WdsColorCommon.white;
  static const Color alternative = WdsColorNeutral.v50;
}
```

상위 집계 클래스(`WdsSemanticColor`)는 생성하지 않으며, `semantic/semantic.dart`에서 color/typography를 export 합니다.

### "typography"

하나의 Typography를 구성하는 요소들은
- family: "text"
- weight: "number"
- size: "number"
- lineheight: "number"
- letterSpacing: "number"
이 있습니다.

각 key에 해당되는 값들은 `WdsFontXXX`과 mapping 되어야 합니다.

예시 (업데이트된 규칙 반영)
``` dart
import '../atomic/atomic.dart';

class WdsSemanticTypography {
  const WdsSemanticTypography._();
  static const TextStyle bold = TextStyle(
    fontFamily: WdsFontFamily.pretendard,
    fontWeight: WdsFontWeight.bold,
    fontSize: WdsFontSize.v18,
    // height는 배수로 변환되어 출력됩니다: height = lineHeight / fontSize
    height: WdsFontLineHeight.v26 / WdsFontSize.v18,
    // letterSpacing은 숫자(px)는 그대로, %는 em으로만 변환해 출력됩니다
    letterSpacing: -0.024, // 예: -2.4% → -0.024
  );
}
```

여기서 height는 Flutter의 요구사항대로 배수 값으로 생성됩니다. JSON에서 제공되는 lineHeight가 px(숫자)라면 생성기는 `height = lineHeight / fontSize`로 변환합니다. 만약 `lineHeight`가 `AUTO`면 1.0을 사용합니다.

또한 `letterSpacing` 값이 숫자면 px로 간주해 그대로 사용하고, 문자열 %면 em으로만 변환합니다. 폰트 크기는 더 이상 곱하지 않습니다.

@design_system_semantic.json 에 해당합니다. semantic 디렉토리 내 생성된 모든 파일은 `semantic/semantic.dart` 안에서 export 되어야 합니다.

semantic/semantic.dart 예시
``` dart
library;

export 'color.dart';
export 'typography.dart';
```

### Body 계열 예외 처리 규칙

일반적인 Typography 구조는 `Heading18 > bold | medium | regular` 처럼 2단계입니다. 그러나 Body는 예외적으로 3단계 중첩을 가질 수 있습니다.

예시(JSON)
```json
{
  "Typography": {
    "Body15": {
      "Normal": {
        "bold": { "family": {...}, "weight": {...}, "lineHeight": {...}, "size": {...}, "letterSpacing": {...} },
        "medium": { ... },
        "regular": { ... }
      },
      "Reading": {
        "bold": { ... },
        "medium": { ... },
        "regular": { ... }
      }
    }
  }
}
```

생성기는 다음과 같이 중첩 그룹 이름을 포함해 필드명을 생성합니다.
- `Body15 > Normal > bold` → `body15NormalBold`
- `Body15 > Normal > medium` → `body15NormalMedium`
- `Body15 > Reading > regular` → `body15ReadingRegular`

즉, 3단계인 경우 `style_group_variant`를 연결하여 카멜케이스로 필드명을 만듭니다. 2단계(일반) 구조는 기존과 동일하게 `style_variant`를 사용합니다.

---

Written by [seunghwanly](https://github.com/seunghwanly)