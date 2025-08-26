# 역할

이 봇의 역할은 아래 정의된 규칙을 기반으로 Widget(컴포넌트)들을 유지보수하고 생성합니다.

# 개요

윙크(WINC) 디자인 시스템(WDS)에서 컴포넌트를 어떻게 정리하는 지 정의한 문서입니다.
Foundation 관련 생성 규칙은 @design_token_generation_guide.md 에서 확인할 수 있고, 모든 컴포넌트는 생성된 디자인토큰을 기반으로 합니다. 단, 디자인 토큰으로 정의되어 있지 않은 내용은 enum 혹은 static class 변수들로 관리합니다.

# WDS 컴포넌트 규칙

material design 과 별도로 만드는 package 이며, 
`import 'package:flutter/widgets.dart';` 에 있는 Widget들로 custom한 Widget을 구성합니다.

## Button

Button은 아래 속성으로 이루어 집니다.


속성 | Type | 비고
--- | --- | --- 
onTap | `VoidCallback` | 버튼이 눌렸을 때 콜백
backgroundColor | `Color` | 버튼 배경 색상
color | `Color` | 버튼 내 텍스트 색상
radius | `Radius` |  버튼 borderRadius, BorderRadius로 build 메소드 내 전환
borderSide | `BorderSide` | 버튼 stroke 
padding | `EdgeInsets` | 버튼 내 padding
size | `Size` | 버튼 크기 (maxWidth: double.infinity, maxHeight: 고정 높이 존재)
isEnabled | `bool` | 버튼 enabled 여부 (`false` 시 'disabled' 상태)
child | `Widget` | 버튼 내 label 위치에 오는 컴포넌트, 텍스트(`Text`) 또는 Text + Icon 조합이 올 수 도 있음

### Button - Variant

정해진 Variant만 사용할 수 있습니다. 

- `cta`
- `primary`
- `secondary`
- `square`

variant에 따라서 backgroundColor, color, radius, borderSide 가 정해집니다.

여기서 radius는 [WdsAtomicRadius](../packages/tokens/lib/atomic/wds_atomic_radius.dart)를 활용합니다.

속성 | backgroundColor | color | radius | borderSide
--- | --- | --- | --- | ---
cta | WdsColorNeutral.v900(#121212) | WdsColorCommon.white(#FFFFFF) | .full | null
primary | WdsColorBlue.v400(#5B7BF3) | WdsColorCommon.white(#FFFFFF) | .full | null
secondary | WdsColorCommon.white(#FFFFFF) | WdsSemanticColorText.normal(#121212) | .full | BorderSide(color: WdsSemanticColorBorder.neutral)
square | WdsColorCommon.white(#FFFFFF) | WdsColorNeutral.v600(#4E4E4E) | .v4 | BorderSide(color: WdsSemanticColorBorder.alternative)



e.g. code
``` dart
enum WdsButtonVariant {
    cta,
    primary,
    secondary,
    square;
}
```


### Button - Size

[Size 클래스](https://api.flutter.dev/flutter/dart-ui/Size-class.html)

px 단위로 이루어집니다. width는 Hug 방식으로 child에 맞게 wrapping 됩니다. height는 속성 별로 정해집니다.

속성 | size | typography | padding
--- | --- | --- | ---
xlarge | Size(double.infinity, 48) | WdsSemanticTypography.body15NormalBold | EdgeInsets.symmetric(horizontal: 16, vertical: 13)
large | Size(double.infinity, 40) | WdsSemanticTypography.body15NormalBold | EdgeInsets.symmetric(horizontal: 16, vertical: 11)
medium | Size(double.infinity, 36) | WdsSemanticTypography.body13NormalMedium | EdgeInsets.symmetric(horizontal: 16, vertical: 10)
small | Size(double.infinity, 30) | WdsSemanticTypography.caption12Medium | EdgeInsets.symmetric(horizontal: 16, vertical: 7) 
tiny | Size(double.infinity, 28) | WdsSemanticTypography.caption12Medium | EdgeInsets.symmetric(horizontal: 16, vertical: 6)

e.g. code
``` dart
enum WdsButtonSize {
    xlarge(
        size: Size(double.infinity, 48),
        typography: WdsSemanticTypography.body15NormalBold,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    ),
    large(
        size: Size(double.infinity, 40),
        typography: WdsSemanticTypography.body15NormalBold,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    ),
    medium(
        size: Size(double.infinity, 36),
        typography: WdsSemanticTypography.body13NormalMedium,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
    small(
        size: Size(double.infinity, 30),
        typography: WdsSemanticTypography.caption12Medium,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
    ),
    tiny(
        size: Size(double.infinity, 28),
        typography: WdsSemanticTypography.caption12Medium,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );

    const WdsButtonSize({
        required this.size,
        required this.typography,
        required this.padding,
    });

    final Size size;
    final TextStyle typography;
    final EdgeInsets padding;
}
```

### Button - State

아래 3가지로 구성됩니다. hovered와 pressed는 동일한 상태로 간주하고 처리합니다.

속성 | Type
--- | --- 
enabled | 기본값
disabled | 누를 수 없는 상태
pressed | hover 상태도 포함


``` dart
enum WdsButtonState {
    enabled(backgroundOpacity: null),
    disabled(backgroundOpacity: 0.4),
    pressed(backgroundOpacity: 0.1);

    const WdsButtonState({
        required this.backgroundOpacity,
        required this.overalyColor,
    });

    final double? backgroundOpacity;
    final Color? overlayColor;
}
```