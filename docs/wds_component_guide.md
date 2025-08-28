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

## IconButton

아이콘을 사용하여 특정 동작의 수행을 돕는 Widget 입니다. 구성요소는 가운데 위치할 아이콘과 padding 그리고 pressed 됐을 때 생기는 dimmed 영역이 있습니다.
아이콘 자체는 24px * 24px로 구성되어 있으며, interaction은 그보다 넓은 40px * 40px로 구성되어 있습니다. interaction 영역은 CircleBorder 처럼 원형으로 구성되며 pressed 색상은 Button에서 주는 효과와 동일합니다. interaction은 icon 영역까지 `EdgeInsets.all(8)`만큼의 padding을 갖습니다. 

### IconButton - state

pressed(hover)는 위에서도 언급했듯이 Button과 같은 메커니즘을 갖습니다. 그 외로 갖는 state 값은 

- `enabled`
- `disabled`

입니다. Button과 동일하게 disabled 상태일 때 opacity를 적용합니다.


## Header

화면 상단에 위치하는 내비게이션입니다. material 라이브러리에서 쓰이는 AppBar와 같은 역할을 하며, MaterialApp 에서도 사용할 수 있도록 PreferredSize 클래스를 확장해서 구현합니다.

**Header 구성 요소:**
- `leading`: `Widget`
- `title`: `Widget`
- `actions`: `List<Widget>`
- `hasCenterTitle`: `bool`

Header 는 leading, title, 그리고 action 영역으로 나뉩니다. 왼쪽부터 오른쪽으로 차례대로 leading, title, 그리고 action이 배치되며 leading과 action에는 아이콘들이 위치할 수 있습니다.
leading이 없고 title만 존재할 때 hasCenterTitle 여부를 설정할 수 있습니다.

### Header - 고정된 속성

고정된 속성으로는 size, padding, backgroundColor, 그리고 typography 가 있습니다.

- size: `Size(double.infinity, 50)`
- padding: `EdgeInsets.symmetric(horizontal: 16, vertical: 5)`
- backgroundColor: `WdsSemanticColorBackgroud.normal`
- typography: `WdsSemanticTypography.heading17Bold`

padding은 양 끝에 위치한 leading 과 actions의 interaction 영역을 고려했습니다.

### Header - leading

leading은 hasCenterTitle 이 true 일 때 는 null이어야 하고, 주로 WdsIconButton이 위치하게 됩니다. WdsIconButton이 위치할 때는 interaction 범위를 생각해서 40px * 40px 크기로 설정합니다.

### Header - actions

actions는 여러 IconButton들이 위치할 수 있습니다. IconButton들은 첫 번째 element가 왼쪽부터 위치하며 마지막 element는 오른쪽에 위치하게 됩니다. 

``` dart
Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
        WdsIconButton( ... ),
        WdsIconButton( ... )
    ],
)
```

이런 식으로 위치하게 되며 spacing은 0px 입니다. 최대 3개까지 올 수 있으며 variant 마다 다르게 설정될 수 있습니다. 예를 들면 search 인 경우에는 actions는 length 가 1이 최대입니다.

빈 리스트인 경우에는 아무 Widget도 화면에 표시되지 않습니다.

### Header - variant

variant | leading | title | hasCenterTitle | actions
--- | --- | --- | --- | --- 
logo | WdsIcon.wincLogo.build() | null | false | defaultValue = []
title | - | `required` 입력된 값 | true | defaultValue = []
search | - | `required` SearchField | true | defaultValue = [] (actions.length == 1)

named constructor로 생성할 수 instance를 제한을 둡니다.

``` dart
WdsHeader.logo({
    this.actions = const [],
    super.key,
}) : leading = WdsIcon.wincLogo.build(),
     title = null,
     hasCenterTitle = false;

WdsHeader.title({
    required this.title,
    this.leading,
    this.actions = const [],
    super.key,
}) : hasCenterTitle = true;

WdsHeader.search({
    required this.title,
    this.leading,
    this.actions = const [],
    super.key,
}) : hasCenterTitle = true,
     assert(actions.length == 1, 'actions 는 최대 1개만 추가할 수 있습니다.');
```

이 때 `title`이 `Text` Widget인 경우에는 정해진 typography로 style을 override 해줍니다. Type 검사 또는 DefaultTextStyle 을 업데이트 합니다.


## BottomNavigation

화면 하단에 위치한 내비게이션입니다. 각 탭 별로 icon과 label이 하나의 쌍(pair)를 이룹니다. 고정 padding으로 `EdgeInsets.symmetric(vertical: 1)`를 가집니다.

BottomNavigation은 위,아래 각 1px씩 padding과 BottomNavigationItem(height: 45) 그리고 상단에 border(WdsSemanticColorBorder.alternative, 1px) 까지 총 48px의 높이를 가집니다.

### BottomNavigationItem

구성 요소는 
- icon: `WdsNavigationIcon`
- label: `String`

입니다.

icon의 interaction 영역은 
- width: 전체 너비의 1/N 만큼
- height: 45px 고정

icon의 위치는 interaction 영역의 center 위치하고 `EdgeInsets.symmetric(vertical: 3)`만큼의 padding을 갖습니다. icon의 Widget configuration은 아래처럼 정의할 수 있습니다.

``` dart
/// fixed-width: 32px
/// fixed-height: 39px
SizedBox(
    width: 32,
    height: 39,
    child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
            WdsNavigationIcon.home.build(isActive: $selected),
            Text(
                '홈',
                style: WdsSemanticTypography.caption10Medium.copyWith(
                    color: cta,
                ),
            ),
        ],
    ),    
)
```


