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
- title width (.search 변형): 전체 가용 너비의 `204/360`(≈`0.567`)로 제한
  - 구현: `.search`에서만 `FractionallySizedBox(widthFactor: 0.567)` 적용

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

- 선택된 BottomNavigationItem의 Text는 `WdsFontWeight.bold` 을 갖습니다.
- 선택안된 BottomNavigationItem의 Text는 `WdsFontWeight.medium` 을 갖습니다.


## SearchField

콘텐츠를 검색할 때 사용합니다.

flutter/widget 라이브러리 내에는 TextField같은 컴포넌트가 없기 때문에 SearchField만 예외로 flutter/material을 사용해야 합니다.

TextField나 TextFormField를 사용할 떄는 항상 부모의 크기가 정해져야 하므로 ConstrainedBox 같이 영역을 정해둘 수 있는 요소들과 함께 사용해야 합니다.

### SearchField - state

state는 enabled와 disabled 2가지로 나뉩니다. enabled 일 때만 텍스트 입력이 가능하고 disabled인 경우에는 입력이 불가능 합니다.

### SearchField - size

너비는 최소, 최대 너비가 있습니다.
- 최소 width: 250px
- 최대 width: `double.infinity` 로 사용할 수 있는 최대 너비를 사용하면 합니다.

높이는 36px로 고정 높이입니다.

### SearchField - radius

`WdsAtomicRadius.full` 를 갖습니다.

### SearchField - backgroundColor

`WdsSemanticColorBackgroud.alternative`를 갖습니다.

### SearchField - padding

state와 무방하게 기본적으로 `EdgeInsets.symmetric(horizontal: 12, vertical: 6)`을 갖습니다.

### SearchField - typography

먼저, state가 enabled인 경우
- typography는 `WdsSemanticTypography.body15NormalRegular`를 따릅니다.
- color는 `WdsSemanticColorText.normal`를 따릅니다.

반대로 state가 disabled인 경우에는 
- typography는 `WdsSemanticTypography.body15NormalRegular`를 따릅니다.
- color는 `WdsSemanticColorText.alternative`를 따릅니다.

### SearchField - trailing

state가 disabled인 경우 trailing은 null로 존재하지 않습니다. state가 enabled이고 입력된 텍스트의 길이가 0보다 클 때만 존재합니다.

- trailing icon: `WdsIcon.circleFilledClose.build(width: 24, height: 24)`를 사용합니다.

trailing을 적용한 모습은 다음과 같습니다.

``` dart
WdsIconButton(
    onTap: $clearText, 
    icon: WdsIcon.circleFilledClose.build(width: 24, height: 24),
)
```

trailing이 존재하면 텍스트 영역과 horizontal 하게 8px 만큼의 spacing을 갖습니다.

### SearchField - textfield

고정 높이 24px에 위 아래 1px 씩 padding을 갖습니다. 따라서 텍스트 필드 영역은 고정높이 22px을 갖게됩니다. 예시 코드로 확인하면 아래와 같이 작성할 수 있습니다.

``` dart
Padding(
    padding: EdgeInsets.symmetric(vertical: 1),
    child: LimitedBox(
        maxHeight: 22,
        child: TextField( ... ),
    ),
)
```

## TextField

길지 않은 텍스트를 입력할 때 사용합니다.

### TextField - variant

- outlined
- box

이렇게 2가지 있습니다.

outlined는 좌측 상단에 Label이 위치하고 있으며 바로 아래 텍스트 입력란이 있습니다. 그리고 텍스트 입력란은 underlined 형태로 존재하며, hint text를 지정할 수 있습니다.

box는 Label이 없으며 오직 텍스트 입력란과 border만 존재합니다. border는 radius가 8px이며 solid한 1px `WdsSemanticColorBorder.alternative` 입니다.

### TextField - state

state는 아래 5가지를 가집니다.

- enabled: 기본 상태
- focused: 입력 포커스를 가진 상태
- active: 값이 1자 이상 존재하는 상태(포커스 유무와 무관)
- error: 유효성 오류가 존재하는 상태
- disabled: 비활성화 상태

상태별 표현은 variant에 따라 다릅니다.

- outlined
  - underline: 
    - `enabled` 1px `WdsSemanticColorBorder.alternative`
    - `focused` 2px `WdsSemanticColorStatus.positive`
    - `error` 2px `WdsSemanticColorStatus.destructive`
  - label: 모든 state 동일
    - typography: `WdsSemanticTypography.body13NormalRegular`
    - color: 
        - `disabled`: `WdsSemanticColorText.disable`
        - 나머지: `WdsSemanticColorText.alternative`
  - hint: typography는 통일
    - typography: `WdsSemanticTypography.body15NormalRegular`
    - color:
        - `disabled`: `WdsSemanticColorText.disable`
        - 나머지: `WdsSemanticColorText.alternative`
  - error: state == `error` 일 때만 
    - typography: `WdsSemanticTypography.caption12Regular`
    - color: `WdsSemanticColorStatus.destructive`
  - helper 혹은 counter
    - typography: `WdsSemanticTypography.caption12Regular`
    - color: `WdsSemanticColorText.alternative`

- box
  - border: 
    - radius 8 (`WdsAtomicRadius.v8`)
    - thickness, color
      - `enabled` 1px `WdsSemanticColorBorder.alternative`
      - `focused` 1px `WdsSemanticColorStatus.positive`
      - `error` 1px `WdsSemanticColorStatus.destructive`
  - hint: 
    - `enabled`, `disabled`
        - typography: `WdsSemanticTypography.body13NormalRegular`
        - color: `WdsSemanticColorText.alternative`
    - 나머지
        - typography: `WdsSemanticTypography.body13NormalRegular`
        - color: `WdsSemanticColorText.normal`
  - input:
    - `disabled`: `WdsSemanticColorText.alternative`
    - 그 외: `WdsSemanticColorText.normal`
  - trailing: 값이 있을 때 또는 포커스일 때 trailing clear 버튼 표시(아래 참고)

### TextField - size

- 최소 width: 250px
- 최대 width: `double.infinity`
- 높이: 1줄 기준 시각적 고정 높이를 유지합니다.
  - outlined: 포커스 시 underline 두께(1→2px) 증가를 하단 패딩 보정으로 흡수하여 높이 변화가 없도록 합니다.
  - box: 패딩을 포함해 1줄 기준 약 44px을 유지합니다.

### TextField - radius & border

- outlined: underline only, 굵기는 상태(state)에 따라 1px/2px로 변경, box는 항상 1px
- box: `BorderRadius.all(Radius.circular(8))` 고정

### TextField - padding

- outlined: label 아래 텍스트 영역의 수직 padding은 7px, 좌우는 0px
- box: `EdgeInsets.symmetric(horizontal: 16, vertical: 10)`

### TextField - typography

(state) 참고

### TextField - cursor

- color: `WdsSemanticColorText.normal`
- width: 2px
- radius: `WdsAtomicRadius.full`

### TextField - helper text

입력란 하단에 추가 설명 또는 오류 메시지를 표시할 수 있습니다.

- 기본: `WdsSemanticColorText.alternative`
- error: `WdsSemanticColorStatus.destructive` (border와 일관성 유지)
- 위치: 입력 영역 하단에서
    - underline: 6px 여백
    - box: 8px 여백

### TextField - trailing

- box: 값이 존재할 때만 clear 아이콘을 노출합니다.
  - icon: `WdsIcon.circleFilledClose.build(width: 24, height: 24)`
  - interaction: `WdsIconButton` 사용, 텍스트와 가로 8px 간격
- outlined: 기본적으로 trailing을 사용하지 않으나, 아래 "verified" 패턴에서 버튼을 조합해 사용할 수 있습니다.

e.g. code - box variant, trailing clear
``` dart
Row(
  mainAxisSize: MainAxisSize.min,
  spacing: 8,
  children: [
    Expanded(child: TextField(/* ... */)),
    if ($hasValue)
      WdsIconButton(
        onTap: $clearText,
        icon: WdsIcon.circleFilledClose.build(width: 24, height: 24),
      ),
  ],
)
```

### TextField - verified (outlined + button)

휴대폰 인증/코드 전송과 같이 입력과 액션 버튼이 결합되는 패턴입니다. outlined variant에서만 사용합니다.

- 구성: `outlined TextField` + 우측 `Button`
- 버튼 size: `WdsButtonSize.small` 권장
- 버튼 state: TextField의 state와 독립적으로 동작(단, `disabled` 인 입력은 버튼도 `disabled` 처리 권장)
- spacing: 텍스트 영역과 버튼 사이 가로 16px
- 타이머 노출이 필요한 경우 오른쪽 정렬 caption을 함께 표기
  - typography: `WdsSemanticTypography.body13NormalRegular`
  - color: `WdsSemanticColorStatus.positive`

e.g. code - verified 패턴
``` dart
Row(
  spacing: 16,
  children: [
    Expanded(child: TextField(/* outlined */)),
    WdsButton(
      onTap: $onVerify,
      size: WdsButtonSize.small,
      variant: WdsButtonVariant.secondary,
      child: const Text('텍스트'),
    ),
  ],
)
```

### TextField - accessibility

- label은 항상 제공하거나, 시각적으로 숨길 경우 `semanticsLabel`을 설정합니다.
- 에러 메시지는 텍스트로도 제공하여 스크린리더가 읽을 수 있도록 합니다.

---

## Chip

정보를 카테고리화하거나 필터링에 사용되는 소형 컴포넌트입니다. 주로 태그나 라벨로 활용하며, leading 및 trailing 영역과 중앙의 label로 구성됩니다.

Chip은 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
label | `String` | 중앙에 표시되는 텍스트
leading | `Widget?` | 왼쪽에 위치하는 아이콘 또는 위젯 (선택사항)
trailing | `Widget?` | 오른쪽에 위치하는 아이콘 또는 위젯 (선택사항)
onTap | `VoidCallback?` | 칩이 눌렸을 때 콜백 (선택사항)
isEnabled | `bool` | 칩 활성화 여부 (`false` 시 'disabled' 상태)

### Chip - shape

칩의 외형을 결정하는 속성입니다.

- `pill`: 완전한 원형 모서리
- `square`: 8px 라운드 모서리

shape에 따라 radius가 정해집니다.

속성 | radius
--- | ---
pill | WdsAtomicRadius.full
square | WdsAtomicRadius.v8

### Chip - variant

정해진 Variant만 사용할 수 있습니다.

- `outline`: 투명 배경에 테두리만 있는 형태
- `solid`: 배경색이 채워진 형태

variant에 따라서 backgroundColor, color, borderSide가 정해집니다.

속성 | backgroundColor | color | borderSide
--- | --- | --- | ---
outline | null | WdsSemanticColorText.neutral | BorderSide(color: WdsSemanticColorBorder.alternative)
solid | WdsSemanticColorBackgroud.alternative | WdsSemanticColorText.normal | null

### Chip - size

px 단위로 이루어집니다. width는 Hug 방식으로 내용에 맞게 wrapping 됩니다. height는 속성 별로 정해집니다.

**outline인 경우**

속성 | size | typography | padding
--- | --- | --- | ---
xsmall | Size(double.infinity, 24) | WdsSemanticTypography.caption12Regular | EdgeInsets.symmetric(horizontal: 12, vertical: 6)
small | Size(double.infinity, 30) | WdsSemanticTypography.body13NormalRegular | EdgeInsets.symmetric(horizontal: 12, vertical: 6)  
medium | Size(double.infinity, 34) | WdsSemanticTypography.body13NormalRegular | EdgeInsets.symmetric(horizontal: 12, vertical: 8)
large | Size(double.infinity, 38) | WdsSemanticTypography.body13NormalRegular | EdgeInsets.symmetric(horizontal: 12, vertical: 10)

**solid인 경우**

속성 | size | typography | padding
--- | --- | --- | ---
xsmall | Size(double.infinity, 24) | WdsSemanticTypography.caption12Medium | EdgeInsets.symmetric(horizontal: 14, vertical: 6)
small | Size(double.infinity, 30) | WdsSemanticTypography.body13NormalMedium | EdgeInsets.symmetric(horizontal: 14, vertical: 6)  
medium | Size(double.infinity, 34) | WdsSemanticTypography.body13NormalMedium | EdgeInsets.symmetric(horizontal: 14, vertical: 8)
large | Size(double.infinity, 38) | WdsSemanticTypography.body13NormalMedium | EdgeInsets.symmetric(horizontal: 14, vertical: 10)

### Chip - state

아래 4가지로 구성됩니다.

속성 | 설명
--- | --- 
enabled | 기본값
pressed | 눌린 상태 (hover 상태도 포함)
focused | 선택된 상태
disabled | 비활성화된 상태

state에 따라 배경색과 텍스트 색상이 조정됩니다.

- `enabled`: 기본 variant 색상 적용
- `pressed`: 배경색에 0.1 opacity overlay 적용 (hover 상태 포함)
- `focused`: 선택된 상태로, 두 variant 모두 배경색이 `cta`(#121212)로 변경되고 텍스트 및 아이콘 색상이 `WdsColorCommon.white`(#FFFFFF)로 변경됨
- `disabled`: 전체적으로 0.4 opacity 적용

**focused state 상세:**
- 배경색: `cta` (WdsColorNeutral.v900, #121212)
- 텍스트 색상: `WdsColorCommon.white` (#FFFFFF)  
- 아이콘 색상: `WdsColorCommon.white` (#FFFFFF)
- 테두리: outline variant의 경우 기존 테두리 제거됨 (배경색으로 인해 불필요)

### Chip - layout

Chip은 leading, label, trailing 순서로 가로 배치됩니다.

- `leading`: 왼쪽 영역에 아이콘 배치 (16x16 또는 20x20 크기 권장)
- `label`: 중앙 영역에 텍스트 배치
- `trailing`: 오른쪽 영역에 아이콘 배치

각 요소 간 spacing은 2px입니다.

``` dart
Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 4,
    children: [
        if (leading != null) leading!,
        Text(label, style: typography),
        if (trailing != null) trailing!,
    ],
)
```

