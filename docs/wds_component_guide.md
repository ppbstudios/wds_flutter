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

### Button - variant

정해진 Variant만 사용할 수 있습니다. 

- `cta`
- `primary`
- `secondary`

variant에 따라서 backgroundColor, color, radius, borderSide 가 정해집니다.

여기서 radius는 [WdsAtomicRadius](../packages/tokens/lib/atomic/wds_atomic_radius.dart)를 활용합니다.

속성 | backgroundColor | color | radius | borderSide
--- | --- | --- | --- | ---
cta | WdsColorNeutral.v900(#121212) | WdsColorCommon.white(#FFFFFF) | .full | null
primary | WdsColorBlue.v400(#5B7BF3) | WdsColorCommon.white(#FFFFFF) | .full | null
secondary | WdsColorCommon.white(#FFFFFF) | WdsSemanticColorText.normal(#121212) | .full | BorderSide(color: WdsSemanticColorBorder.neutral)


e.g. code
``` dart
enum WdsButtonVariant {
    cta,
    primary,
    secondary;
}
```


### Button - size

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

### Button - state

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


## TextButton

Button 과는 속성이 다소 다른 버튼으로 배경색이나 테두리가 없는 버튼으로 텍스트로만 구성됩니다. 주로 강조가 덜한 보조적인 액션에 사용합니다.

### TextButton - 공통

텍스트 색상이 모든 variant 내에서 같습니다.
- color: `WdsSemanticColorText.neutral`

### TextButton - variant

속성 | decoration | decorationColor | trailing
--- | --- | --- | --- 
text | null | null | null
underline |  TextDecoration.underline | `WdsSemanticColorText.neutral` | null
icon | null | null | chevronRight

trailing에 오는 icon은 packages/foundation 내 정의되어있는 WdsIcon에서 불러옵니다.

### TextButton - size


속성 | size | typography | icon size | padding
--- | --- | --- | --- | --- 
medium | Size(double.infinity, 30) | WdsSemanticTypography.body15NormalMedium | 20x20 | EdgeInsets.symmetric(vertical: 4)
small | Size(double.infinity, 28) | WdsSemanticTypography.body13NormalMedium | 16x16 | EdgeInsets.symmetric(vertical: 5)


이 때 trailing에 오는 아이콘은 icon size 만큼 영역을 가지며, 텍스트와 여유 공간없이 바로 붙어있으며 상하 padding은 1px로 조정됩니다.

e.g. code - variant: medium
``` dart
Row(
    mainAxisSize: MainAxisSize.min,
    children: [
        Text('텍스트'),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 1),
            child: WdsIcon.chevronRight.build(
                width: 20,
                height: 20,
            ),
        ),
    ]
),
```

### TextButton - state

- enabled
- disabled

위 2개의 상태를 가지며 disabled 인 상태일 떄는 텍스트, decoration, icon 모두 같은 색상을 갖습니다.
- `WdsSemanticColorText.disable`

---

## SquareButton

버튼과 다르게 SquareButton은 단일 size, typography (색상 제외), padding 이 같은 버튼입니다. 단, state는 아래 2가지로 구분됩니다.
- `enabled`
- `disabled`

여기서 `pressed` 는 웹인 경우 hovered 상태도 포함되며 #Button에 구현되어 있는 pressed(hover)와 같은 메커니즘으로 구성됩니다. disabled 일 때 opacity 설정하는 방법도 같습니다.

### SquareButton - 고정된 속성

- size: `Size(double.infinity, 32)`
- typography: `WdsSemanticTypography.caption12Medium`
- padding: `EdgeInsets.symmetric(horizontal: 17, vertical: 8)`

### SquareButton - state

state | backgroundColor | color | radius | borderSide 
--- | --- | --- | --- | --- 
enabled | WdsColorCommon.white(#FFFFFF) | WdsSemanticColorText.neutral(#4E4E4E) | .v4 | BorderSide(color: WdsSemanticColorBorder.alternative)
disabled | WdsColorCommon.white(#FFFFFF) | WdsSemanticColorText.neutral(#4E4E4E) | .v4 | BorderSide(color: WdsSemanticColorBorder.alternative)

## Header

화면 상단에