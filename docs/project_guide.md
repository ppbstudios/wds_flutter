# 역할

이 봇의 역할은 디자인 시스템을 생성하고 원칙들에 따라 시스템을 유지보수합니다.
아래 정보를 참고하여, 디자인 토큰이 주어졌을 때 관련 코드를 생성하고 클래스화해서 컴포넌트까지 적용할 수 있도록 만들어 주세요.

# 개요

윙크(WINC)란 서비스의 디자인 시스템 (WDS, WINC Design System)을 만들고 라이브러리화 하기 위한 프로젝트입니다.

현재 윙크 서비스는 디자인 시스템 없이 많은 컴포넌트가 파편화되어있는 상태이고, 이를 하나의 관리요소로 모아줄 필요가 있고 유저들에게 일관된 UI를 제공해야 합니다.

디자인 시스템을 활용할 때 모두 design token으로 관리합니다.

# 목표

- **디자인 토큰 자동화**: JSON 형식으로 정의된 디자인 토큰을 Dart 코드로 자동 생성하여 Flutter 프로젝트에서 타입-세이프(Type-safe)하게 사용할 수 있는 시스템을 구축한다.
- **통합 인터페이스 제공**: foundation 패키지를 통해 모든 토큰에 대한 일관된 접근 방식을 제공하여 개발자 경험을 향상시킨다.
- **자동화 도구**: Dart의 build_runner와 source_gen 라이브러리를 활용하여 코드 생성 프로세스를 자동화한다.
- **독립성 및 버전 관리**: 생성된 토큰(wds_tokens)은 기존 소스 코드와 독립적으로 관리되어야 하며, 버전 관리가 가능해야 한다.
- **외부 연동**: 생성된 토큰은 최종적으로 Widgetbook과 연동될 수 있어야 한다.

## Design Token 관리하는 법

Primitive, Semantic, 그리고 Component-specific 순으로 Token을 정리합니다.

### Primitive Token 정의

Color, Spacing, Opacity, FontWeight 등 원초적인 값들을 먼저 정의합니다.

e.g. pink/400
~~~
Primitive token - Value
pink/400 - #F55DAF
~~~

- **DO NOT** 정의된 Primitive Token을 곧바로 Component에 적용하지 않습니다.
- **DO** 오직 Foundation의 통합 인터페이스를 통해서만 사용합니다.

### Semantic Token

Primitive Token에 정의된 값들을 의미적으로 어떻게 사용할지 정의합니다.

~~~
primary, secondary, cta 등
~~~

### Component-specific Token (예정)

특정 컴포넌트에서 사용될 토큰들을 정의합니다. 현재는 foundation 패키지에서 수동으로 관리하며, 향후 자동화 예정입니다.

~~~
button-primary-pressed, input-border-focused 등
~~~

토큰 계층 구조:
~~~
Value → Primitive → Foundation(통합 인터페이스) → Component
~~~

# Design System 생성 및 관리 전략

윙크(WINC)는 Flutter 기반으로 만들어진 서비스로 **독립적인 디자인 시스템**을 구축합니다.

## 위젯 구성 전략

- **기본 방침**: `flutter/widgets.dart` 패키지를 최대한 활용하여 Material Design에 독립적인 컴포넌트 제작
- **선별적 Material 사용**: TabBar, DatePicker 등 복잡한 인터랙션이 필요한 컴포넌트에 한해서만 Material 위젯 활용
- **WDS 고유성**: Google Material Design 언어에 종속되지 않는 윙크만의 디자인 아이덴티티 구축

## 위젯 구성 원칙

- **DO** 최대한 단순한 Widget Tree 구성을 이어가기
- **DO** const를 최대한 활용할 수 있게 caching 요소를 확보  
- **DO** Container 같은 위젯을 활용하기 보다는 DecoratedBox, Padding 등 필요한 요소들만 활용

### 위젯 구성 예시

```dart
// ✅ 최적화된 위젯 구성 (권장)
class WdsButton extends StatelessWidget {
  const WdsButton({
    super.key,
    required this.onPressed,
    required this.label,
  });
  
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(  // Container 대신 DecoratedBox 사용
        decoration: const BoxDecoration(
          color: WdsColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(WdsRadius.sm)),
        ),
        child: Padding(  // 별도 Padding 위젯으로 분리
          padding: const EdgeInsets.symmetric(
            horizontal: WdsSpacing.md5,
            vertical: WdsSpacing.md3,
          ),
          child: Text(
            label,
            style: WdsTypography.buttonLabel,
          ),
        ),
      ),
    );
  }
}

// ✅ 필요시 Material 위젯 선별 사용
class WdsTabBar extends StatelessWidget {
  const WdsTabBar({
    super.key,
    required this.tabs,
  });
  
  final List<Widget> tabs;

  @override  
  Widget build(BuildContext context) {
    return Material(  // TabBar 사용을 위한 최소한의 Material 적용
      child: TabBar(
        tabs: tabs,
        // WDS 디자인 토큰 적용
        labelStyle: WdsTypography.tabLabel,
        indicatorColor: WdsColors.primary,
      ),
    );
  }
}

// ❌ 비효율적인 구성 (피해야 할 패턴)
class BadButton extends StatelessWidget {
  @override  // const 생성자 누락
  Widget build(BuildContext context) {
    return Container(  // ❌ Container 남용
      width: 200,     // ❌ 하드코딩된 값
      height: 48,
      margin: EdgeInsets.all(8),  // ❌ const 누락
      padding: EdgeInsets.symmetric(horizontal: 16),  // ❌ const 누락
      decoration: BoxDecoration(
        color: Colors.blue,  // ❌ 디자인 토큰 미사용
        borderRadius: BorderRadius.circular(8),  // ❌ const 누락
      ),
      child: Center(
        child: Text('Button'),  // ❌ 스타일 미적용
      ),
    );
  }
}
```

## 프로젝트 구조

```
/wds
├── packages/
│   ├── tokens/                       # [Package] tokens (generated)
│   │   ├── atomic/                   # Primitive tokens
│   │   │   ├── wds_atomic_color.dart
│   │   │   ├── wds_atomic_typography.dart
│   │   │   └── wds_atomic.dart       # Export file
│   │   ├── semantic/                 # Semantic tokens  
│   │   │   ├── wds_semantic_color.dart
│   │   │   ├── wds_semantic_typography.dart
│   │   │   └── wds_semantic.dart     # Export file
│   │   └── tokens.dart               # Main export file
│   ├── foundation/                   # [Package] foundation (unified interface)
│   │   ├── lib/
│   │   │   ├── wds_colors.dart       # WdsColors - unified color interface
│   │   │   ├── wds_typography.dart   # WdsTypography - unified typography interface
│   │   │   ├── wds_spacing.dart      # WdsSpacing - unified spacing interface  
│   │   │   └── wds_foundation.dart   # Main export file
│   │   └── pubspec.yaml
│   ├── components/                   # [Package] components
│   ├── widgetbook/                   # [Package] widgetbook
├── tools/
│   └── token_generator/              # [Package] JSON to Dart generator
├── tokens/
│   ├── design_system_atomic.json     # Primitive tokens from Figma
│   └── design_system_semantic.json   # Semantic tokens from Figma
```

## Foundation 패키지 역할

foundation 패키지는 tokens 패키지에서 생성된 atomic, semantic 토큰들을 하나의 **통합된 인터페이스**로 제공합니다.

### 주요 목적
- **통합 접근점**: 개발자가 디자인 토큰에 접근할 때 하나의 일관된 인터페이스 제공
- **미래 확장성**: component-specific 토큰이 추가될 때를 대비한 구조 준비  
- **타입 안전성**: 모든 토큰을 타입-세이프하게 접근할 수 있는 통합 클래스 제공
- **개발자 경험**: IDE 자동완성과 일관된 네이밍으로 개발 효율성 향상

### 구조 예시

```dart
// foundation/lib/colors.dart
import 'package:wds_tokens/atomic/wds_color.dart' as atomic;
import 'package:wds_tokens/semantic/wds_color.dart' as semantic;

/// WDS 컬러 시스템 통합 인터페이스
/// 
/// Components 패키지에서는 이 클래스를 통해서만 색상에 접근해야 합니다.
class WdsColors {
  const WdsColors._();

  // Semantic colors
  static const Color primary = semantic.$primary;
  static const Color cta = semantic.$cta;
  static const Color secondary = semantic.$secondary;
  
  // Atomic colors
  static const Color blue50 = WdsColorBlue.v50;
  static const Color blue400 = WdsColorBlue.v400;
  static const Color neutral900 = WdsColorNeutral.v900;
  
  // Component-specific colors (미래 확장 예시)
  // static const Color buttonPrimaryDefault = primary;
  // static const Color buttonPrimaryPressed = WdsColorBlue.v600;
  // static const Color buttonPrimaryDisabled = WdsColorNeutral.v300;
}
```

```dart
// foundation/lib/typography.dart  
import 'package:wds_tokens/atomic/wds_atomic.dart';
import 'package:wds_tokens/semantic/wds_typography.dart';

/// WDS 타이포그래피 시스템 통합 인터페이스
class WdsTypography {
  const WdsTypography._();

  // Semantic typography
  static const TextStyle heading18Bold = WdsSemanticTypography.heading18Bold;
  static const TextStyle body15Medium = WdsSemanticTypography.body15Medium;
  
  // Component-specific typography (확장 예정)
  // static const TextStyle buttonLabel = WdsSemanticTypography.body15Medium;
  // static const TextStyle inputLabel = WdsSemanticTypography.caption12Regular;
}
```

### 사용 방식

Components 패키지에서는 **오직 foundation의 통합 인터페이스만 사용**:

```dart
// ✅ 올바른 사용법
// components/lib/button/button.dart
import 'package:wds_foundation/wds_foundation.dart';

class WdsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: WdsColors.primary,        // ✅ foundation 통합 인터페이스 사용
      child: Text(
        'Button',
        style: WdsTypography.heading18Bold,  // ✅ foundation 통합 인터페이스 사용
      ),
    );
  }
}
```

```dart
// ❌ 금지된 사용법
// components/lib/button/button.dart
import 'package:wds_tokens/atomic/wds_color.dart';       // ❌ tokens 직접 import 금지
import 'package:wds_tokens/semantic/wds_color.dart';     // ❌ tokens 직접 import 금지

class WdsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: WdsColorBlue.v400,        // ❌ tokens 직접 사용 금지
      color: WdsSemanticColorPrimary,  // ❌ tokens 직접 사용 금지
    );
  }
}
```

### 패키지 제작 및 우선순위 

1. **token_generator** (JSON → Dart 코드 생성)
2. **tokens** (atomic, semantic 토큰 생성)
3. **foundation** (tokens 통합 인터페이스 제공)
4. **components** (foundation 토큰 사용)
5. **widgetbook** (모든 요소 통합 및 문서화)

## 개발 워크플로우

### 디자인 토큰 업데이트 시
1. **JSON 파일 수정** 
  - `design_system_atomic.json`
  - `design_system_semantic.json`
2. **token_generator 실행**하여 tokens 패키지 업데이트
3. **foundation 패키지의 통합 인터페이스 클래스들 수동 업데이트**
   - `WdsColors`, `WdsTypography`, `WdsSpacing` 등
4. **components, widgetbook에서 테스트**

### 새로운 컴포넌트 개발 시
1. **foundation 패키지의 통합 인터페이스만 사용** (`WdsColors`, `WdsTypography` 등)
2. **tokens 패키지 직접 접근 금지**
3. **필요한 component-specific 토큰은 foundation에 추가 후 사용**

### Component-specific 토큰 추가 시 (수동)
1. foundation 패키지의 해당 클래스에 static 필드 추가
2. 기존 semantic 토큰이나 atomic 토큰 참조
3. 명확한 주석과 함께 문서화

## 모놀리식 운영 및 Melos

- 루트(`wds_flutter/`)에서 Melos로 모든 패키지를 관리합니다.
- 루트 구성
  - `melos.yaml`
  - `pubspec.yaml` (dev_dependencies에 `melos` 선언)
- 워크스페이스 부트스트랩
  - `melos bootstrap`

```yaml
# melos.yaml (요약)
name: wds_flutter
packages:
  - packages/**
  - tools/**
```

## 패키지 표준화

- `packages/tokens`는 Flutter 패키지이며, 생성 산출물은 반드시 `lib/` 하위에 생성/배치됩니다.
  - `lib/atomic/wds_atomic_color.dart`, `lib/semantic/wds_semantic_typography.dart` 등
- `packages/foundation`은 Flutter 패키지이며, tokens 패키지에 의존합니다.
- `packages/components`는 Flutter 패키지이며, foundation 패키지에만 의존합니다.
- `packages/widgetbook`는 Flutter 패키지이며 `widgetbook` 의존성을 사용합니다.

## 위젯북 패키지

- `packages/widgetbook`에서 위젯북 추가
  - `flutter pub add widgetbook`
  - 또는 `pubspec.yaml`에 `widgetbook` 의존성 추가 후 `melos bootstrap`

## 핵심 원칙

1. **단방향 의존성**: `components → foundation → tokens`
2. **통합 접근**: components는 오직 foundation을 통해서만 토큰에 접근
3. **타입 안전성**: 모든 토큰은 컴파일 타임에 검증 가능
4. **확장성**: component-specific 토큰을 위한 구조적 준비
5. **일관성**: 모든 디자인 토큰은 하나의 일관된 인터페이스로 제공

---

Written by [seunghwanly](https://github.com/seunghwanly)