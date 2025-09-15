# 역할

이 봇의 역할은 아래 정의된 규칙을 기반으로 Widget(컴포넌트)들을 유지보수하고 생성합니다.

# 개요

윙크(WINC) 디자인 시스템(WDS)에서 컴포넌트를 어떻게 정리하는 지 정의한 문서입니다.
Foundation 관련 생성 규칙은 @design_token_generation_guide.md 에서 확인할 수 있고, 모든 컴포넌트는 생성된 디자인토큰을 기반으로 합니다. 단, 디자인 토큰으로 정의되어 있지 않은 내용은 enum 혹은 static class 변수들로 관리합니다.

# WDS 컴포넌트 규칙

material design 과 별도로 만드는 package 이며, 
`import 'package:flutter/widgets.dart';` 에 있는 Widget들로 custom한 Widget을 구성합니다.

## 공통 설계 가이드 (enum/생성자)

- 고정 스펙(크기/패딩/라운드/아이콘 크기 등)은 "데이터를 담는 enum"으로 관리합니다.
  - 각 enum 값은 `const` 생성자를 통해 실제 스펙 값을 보유합니다.
  - 장점: 스펙이 한 곳에 응집되고, 분기/매핑 함수를 줄여 가독성과 유지보수성 향상.
- 제한된 선택지만 허용되는 경우, `named constructor`로 인스턴스 생성을 제한합니다.
  - 예: `WdsSwitch.small(...)`, `WdsSwitch.large(...)`
  - 런타임 분기 대신 생성 시점에 크기가 고정되어 오류 여지를 줄입니다.

e.g. enum with spec values + named constructors (Switch)
``` dart
enum WdsSwitchSize {
  small(spec: Size(39, 24), padding: EdgeInsets.all(3), knobSize: 18),
  large(spec: Size(52, 32), padding: EdgeInsets.all(4), knobSize: 24);

  const WdsSwitchSize({
    required this.spec,
    required this.padding,
    required this.knobSize,
  });

  final Size spec;        // track 크기
  final EdgeInsets padding; // track 내부 여백
  final double knobSize;  // knob 지름
}

class WdsSwitch extends StatefulWidget {
  const WdsSwitch.small({ required this.value, required this.onChanged, this.isEnabled = true, super.key })
      : size = WdsSwitchSize.small;
  const WdsSwitch.large({ required this.value, required this.onChanged, this.isEnabled = true, super.key })
      : size = WdsSwitchSize.large;

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;
  final WdsSwitchSize size;
}
```

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
cta | WdsColors.neutral900(#121212) | WdsColors.white(#FFFFFF) | WdsRadius.full | null
primary | WdsColors.blue400(#5B7BF3) | WdsColors.white(#FFFFFF) | WdsRadius.full | null
secondary | WdsColors.white(#FFFFFF) | WdsColors.textNormal(#121212) | .full | BorderSide(color: WdsColors.borderNeutral)


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
xlarge | Size(double.infinity, 48) | WdsTypography.body15NormalBold | EdgeInsets.symmetric(horizontal: 16, vertical: 13)
large | Size(double.infinity, 40) | WdsTypography.body15NormalBold | EdgeInsets.symmetric(horizontal: 16, vertical: 11)
medium | Size(double.infinity, 36) | WdsTypography.body13NormalMedium | EdgeInsets.symmetric(horizontal: 16, vertical: 10)
small | Size(double.infinity, 30) | WdsTypography.caption12Medium | EdgeInsets.symmetric(horizontal: 16, vertical: 7) 
tiny | Size(double.infinity, 28) | WdsTypography.caption12Medium | EdgeInsets.symmetric(horizontal: 16, vertical: 6)

e.g. code
``` dart
enum WdsButtonSize {
    xlarge(
        size: Size(double.infinity, 48),
        typography: WdsTypography.body15NormalBold,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    ),
    large(
        size: Size(double.infinity, 40),
        typography: WdsTypography.body15NormalBold,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    ),
    medium(
        size: Size(double.infinity, 36),
        typography: WdsTypography.body13NormalMedium,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
    small(
        size: Size(double.infinity, 30),
        typography: WdsTypography.caption12Medium,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
    ),
    tiny(
        size: Size(double.infinity, 28),
        typography: WdsTypography.caption12Medium,
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
    disabled(backgroundOpacity: WdsOpacity.opacity40),
    pressed(backgroundOpacity: WdsOpacity.opacity10);

    const WdsButtonState({
        required this.backgroundOpacity,
        required this.overalyColor,
    });

    final double? backgroundOpacity;
    final Color? overlayColor;
}
```


## TextButton

> Button 과는 속성이 다소 다른 버튼으로 배경색이나 테두리가 없는 버튼으로 텍스트로만 구성됩니다. 주로 강조가 덜한 보조적인 액션에 사용합니다.

### TextButton - 공통

텍스트 색상이 모든 variant 내에서 같습니다.
- color: `WdsColors.textNeutral`

### TextButton - variant

속성 | decoration | decorationColor | trailing
--- | --- | --- | --- 
text | null | null | null
underline |  TextDecoration.underline | `WdsColors.textNeutral` | null
icon | null | null | chevronRight

trailing에 오는 icon은 packages/foundation 내 정의되어있는 WdsIcon에서 불러옵니다.

### TextButton - size


속성 | size | typography | icon size | padding
--- | --- | --- | --- | --- 
medium | Size(double.infinity, 30) | WdsTypography.body15NormalMedium | 20x20 | EdgeInsets.symmetric(vertical: 4)
small | Size(double.infinity, 28) | WdsTypography.body13NormalMedium | 16x16 | EdgeInsets.symmetric(vertical: 5)


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
- `WdsColors.textDisable`

---

## SquareButton

버튼과 다르게 SquareButton은 단일 size, typography (색상 제외), padding 이 같은 버튼입니다. 단, state는 아래 2가지로 구분됩니다.
- `enabled`
- `disabled`

여기서 `pressed` 는 웹인 경우 hovered 상태도 포함되며 #Button에 구현되어 있는 pressed(hover)와 같은 메커니즘으로 구성됩니다. disabled 일 때 opacity 설정하는 방법도 같습니다.

### SquareButton - 고정된 속성
속성 | 값
--- | ---
size | `Size(double.infinity, 32)`
typography | `WdsTypography.caption12Medium`
padding | `EdgeInsets.symmetric(horizontal: 17, vertical: 8)`

### SquareButton - state

state | backgroundColor | color | radius | borderSide 
--- | --- | --- | --- | --- 
enabled | WdsColors.white(#FFFFFF) | WdsColors.textNeutral(#4E4E4E) | .v4 | BorderSide(color: WdsColors.borderAlternative)
disabled | WdsColors.white(#FFFFFF) | WdsColors.textNeutral(#4E4E4E) | .v4 | BorderSide(color: WdsColors.borderAlternative)

## IconButton

> 아이콘을 사용하여 특정 동작의 수행을 돕는 Widget 입니다. 

구성요소는 가운데 위치할 아이콘과 padding 그리고 pressed 됐을 때 생기는 dimmed 영역이 있습니다.

아이콘 자체는 24px * 24px로 구성되어 있으며, interaction은 그보다 넓은 40px * 40px로 구성되어 있습니다. 
interaction 영역은 CircleBorder 처럼 원형으로 구성되며 pressed 색상은 Button에서 주는 효과와 동일합니다. 
interaction은 icon 영역까지 `EdgeInsets.all(8)`만큼의 padding을 갖습니다. 

### IconButton - state

pressed(hover)는 위에서도 언급했듯이 Button과 같은 메커니즘을 갖습니다. 그 외로 갖는 state 값은 

- `enabled`
- `disabled`

입니다. Button과 동일하게 disabled 상태일 때 opacity를 적용합니다.


## Header

> 화면 상단에 위치하는 내비게이션입니다. material 라이브러리에서 쓰이는 AppBar와 같은 역할을 하며, MaterialApp 에서도 사용할 수 있도록 PreferredSize 클래스를 확장해서 구현합니다.

**Header 구성 요소:**

속성 | Type | 비고
--- | --- | ---
leading | `Widget` | 좌측 아이콘 등 배치
title | `Widget` | 중앙 타이틀
actions | `List<Widget>` | 우측 아이콘 목록
hasCenterTitle | `bool` | `leading`이 없고 `title`만 있을 때 중앙 정렬 허용

Header 는 leading, title, 그리고 action 영역으로 나뉩니다. 왼쪽부터 오른쪽으로 차례대로 leading, title, 그리고 action이 배치되며 leading과 action에는 아이콘들이 위치할 수 있습니다.
leading이 없고 title만 존재할 때 hasCenterTitle 여부를 설정할 수 있습니다.

### Header - 고정된 속성

고정된 속성으로는 size, padding, backgroundColor, 그리고 typography 가 있습니다.

속성 | 값 | 비고
--- | --- | ---
size | `Size(double.infinity, 50)` |
padding | `EdgeInsets.symmetric(horizontal: 16, vertical: 5)` |
backgroundColor | `WdsColors.backgroundNormal` |
typography | `WdsTypography.heading17Bold` |
title width (.search 변형) | 전체 가용 너비의 `204/360`(≈`0.567`) | `.search`에서만 `FractionallySizedBox(widthFactor: 0.567)` 적용

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

> 화면 하단에 위치한 내비게이션입니다. 각 탭 별로 icon과 label이 하나의 쌍(pair)를 이룹니다. 고정 padding으로 `EdgeInsets.symmetric(vertical: 1)`를 가집니다.

BottomNavigation은 위,아래 각 1px씩 padding과 BottomNavigationItem(height: 45) 그리고 상단에 border(WdsColors.borderAlternative, 1px) 까지 총 48px의 높이를 가집니다.

### BottomNavigationItem
구성 요소 | Type
--- | ---
icon | `WdsNavigationIcon`
label | `String`

icon의 interaction 영역은 다음과 같습니다.

속성 | 값
--- | ---
width | 전체 너비의 1/N 만큼
height | 45px 고정

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
                style: WdsTypography.caption10Medium.copyWith(
                    color: cta,
                ),
            ),
        ],
    ),    
)
```

선택 상태 | Text 폰트 굵기
--- | ---
선택됨 | `.caption10Bold`
선택 안됨 | `.caption10Medium`


## SearchField

> 콘텐츠를 검색할 때 사용합니다.

flutter/widget 라이브러리 내에는 TextField같은 컴포넌트가 없기 때문에 SearchField만 예외로 flutter/material을 사용해야 합니다.

TextField나 TextFormField를 사용할 떄는 항상 부모의 크기가 정해져야 하므로 ConstrainedBox 같이 영역을 정해둘 수 있는 요소들과 함께 사용해야 합니다.

### SearchField - state

state는 enabled와 disabled 2가지로 나뉩니다. enabled 일 때만 텍스트 입력이 가능하고 disabled인 경우에는 입력이 불가능 합니다.

### SearchField - size
너비와 높이는 다음과 같습니다.

항목 | 값 | 비고
--- | --- | ---
최소 width | 250px |
최대 width | `double.infinity` | 사용 가능한 최대 너비 사용
height | 36px | 고정 높이

### SearchField - radius

`WdsRadius.full` 를 갖습니다.

### SearchField - backgroundColor

`WdsColors.backgroundAlternative`를 갖습니다.

### SearchField - padding
항목 | 값 | 비고
--- | --- | ---
padding | `EdgeInsets.symmetric(horizontal: 12, vertical: 6)` | state와 무관하게 동일

### SearchField - typography

state별 typography와 color는 다음과 같습니다.

state | typography | color
--- | --- | ---
enabled | `WdsTypography.body15NormalRegular` | `WdsColors.textNormal`
disabled | `WdsTypography.body15NormalRegular` | `WdsColors.textAlternative`

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

> 길지 않은 텍스트를 입력할 때 사용합니다.

### TextField - variant

- outlined
- box

이렇게 2가지 있습니다.

outlined는 좌측 상단에 Label이 위치하고 있으며 바로 아래 텍스트 입력란이 있습니다. 그리고 텍스트 입력란은 underlined 형태로 존재하며, hint text를 지정할 수 있습니다.

box는 Label이 없으며 오직 텍스트 입력란과 border만 존재합니다. border는 radius가 8px이며 solid한 1px `WdsColors.borderAlternative` 입니다.

### TextField - state

state는 아래 5가지를 가집니다.

- enabled: 기본 상태
- focused: 입력 포커스를 가진 상태
- active: 값이 1자 이상 존재하는 상태(포커스 유무와 무관)
- error: 유효성 오류가 존재하는 상태
- disabled: 비활성화 상태

상태별 표현은 variant에 따라 다릅니다.

outlined

항목 | 상태 | 값
--- | --- | ---
underline | enabled | 1px `WdsColors.borderAlternative`
underline | focused | 2px `WdsColors.statusPositive`
underline | error | 2px `WdsColors.statusDestructive`
label.typography | all | `WdsTypography.body13NormalRegular`
label.color | disabled | `WdsColors.textDisable`
label.color | 그 외 | `WdsColors.textAlternative`
hint.typography | all | `WdsTypography.body15NormalRegular`
hint.color | enabled | `WdsColors.textAlternative`
hint.color | disabled | `WdsColors.textDisable`
hint.color | focused/error/active | `WdsColors.textAlternative`
error(문구) | error | typography `WdsTypography.caption12Regular`, color `WdsColors.statusDestructive`
helper/counter | all | typography `WdsTypography.caption12Regular`, color `WdsColors.textAlternative`

box

항목 | 상태 | 값
--- | --- | ---
border.radius | all | 8 (`WdsRadius.v8`)
border.thickness/color | enabled | 1px `WdsColors.borderAlternative`
border.thickness/color | focused | 1px `WdsColors.statusPositive`
border.thickness/color | error | 1px `WdsColors.statusDestructive`
hint.typography | all | `WdsTypography.body15NormalRegular`
hint.color | enabled | `WdsColors.textAlternative`
hint.color | disabled | `WdsColors.textDisable`
hint.color | focused/error/active | `WdsColors.textAlternative`
input.color | disabled | `WdsColors.textAlternative`
input.color | 그 외 | `WdsColors.textNormal`
trailing | 조건 | 값이 있을 때 또는 포커스일 때 clear 버튼 표시

### TextField - size
항목 | 값 | 비고
--- | --- | ---
최소 width | 250px |
최대 width | `double.infinity` | 사용 가능한 최대 너비 사용
높이(outlined) | 시각적 고정 | 포커스 시 underline 두께 증가를 하단 패딩 보정으로 흡수
높이(box) | 약 44px | 패딩 포함, 1줄 기준 유지

### TextField - radius & border

variant | border/radius
--- | ---
outlined | underline only, 굵기는 상태(state)에 따라 1px/2px로 변경
box | `BorderRadius.all(Radius.circular(8))` 고정, 테두리 1px

### TextField - padding

variant | padding
--- | ---
outlined | label 아래 텍스트 영역의 수직 7px, 좌우 0px
box | `EdgeInsets.symmetric(horizontal: 16, vertical: 10)`

### TextField - typography

(state) 참고

### TextField - cursor

속성 | 값
--- | ---
color | `WdsColors.textNormal`
width | 2px
radius | `WdsRadius.full`

### TextField - helper text

입력란 하단에 추가 설명 또는 오류 메시지를 표시할 수 있습니다.

- 기본: `WdsColors.textAlternative`
- error: `WdsColors.statusDestructive` (border와 일관성 유지)
- 위치: 입력 영역 하단에서
    - underline: 6px 여백
    - box: 8px 여백

에러 상태(state = `error`)에서는 helper와 error를 동시에 노출합니다.

- 좌측: 에러 메시지
  - typography: `WdsTypography.caption12Regular`
  - color: `WdsColors.statusDestructive`
  - 최대 1줄, 넘치면 말줄임 처리
- 우측: 헬퍼 텍스트
  - typography: `WdsTypography.caption12Regular`
  - color: `WdsColors.textAlternative`
  - 최대 1줄, 우측 정렬, 넘치면 말줄임 처리

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
  - typography: `WdsTypography.body13NormalRegular`
  - color: `WdsColors.statusPositive`

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

> 정보를 카테고리화하거나 필터링에 사용되는 소형 컴포넌트입니다. 주로 태그나 라벨로 활용하며, leading 및 trailing 영역과 중앙의 label로 구성됩니다.

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
pill | WdsRadius.full
square | WdsRadius.v8

### Chip - variant

정해진 Variant만 사용할 수 있습니다.

- `outline`: 투명 배경에 테두리만 있는 형태
- `solid`: 배경색이 채워진 형태

variant에 따라서 backgroundColor, color, borderSide가 정해집니다.

속성 | backgroundColor | color | borderSide
--- | --- | --- | ---
outline | null | WdsColors.textNeutral | BorderSide(color: WdsColors.borderAlternative)
solid | WdsColors.backgroundAlternative | WdsColors.textNormal | null

### Chip - size

px 단위로 이루어집니다. width는 Hug 방식으로 내용에 맞게 wrapping 됩니다. height는 속성 별로 정해집니다.

**outline인 경우**

속성 | size | typography | padding
--- | --- | --- | ---
xsmall | Size(double.infinity, 24) | WdsTypography.caption12Regular | EdgeInsets.symmetric(horizontal: 12, vertical: 6)
small | Size(double.infinity, 30) | WdsTypography.body13NormalRegular | EdgeInsets.symmetric(horizontal: 12, vertical: 6)  
medium | Size(double.infinity, 34) | WdsTypography.body13NormalRegular | EdgeInsets.symmetric(horizontal: 12, vertical: 8)
large | Size(double.infinity, 38) | WdsTypography.body13NormalRegular | EdgeInsets.symmetric(horizontal: 12, vertical: 10)

**solid인 경우**

속성 | size | typography | padding
--- | --- | --- | ---
xsmall | Size(double.infinity, 24) | WdsTypography.caption12Medium | EdgeInsets.symmetric(horizontal: 14, vertical: 6)
small | Size(double.infinity, 30) | WdsTypography.body13NormalMedium | EdgeInsets.symmetric(horizontal: 14, vertical: 6)  
medium | Size(double.infinity, 34) | WdsTypography.body13NormalMedium | EdgeInsets.symmetric(horizontal: 14, vertical: 8)
large | Size(double.infinity, 38) | WdsTypography.body13NormalMedium | EdgeInsets.symmetric(horizontal: 14, vertical: 10)

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
- `focused`: 선택된 상태로, 두 variant 모두 배경색이 `cta`(#121212)로 변경되고 텍스트 및 아이콘 색상이 `WdsColors.white`(#FFFFFF)로 변경됨
- `disabled`: 전체적으로 0.4 opacity 적용

focused 상태에서는 hover/pressed overlay가 적용되지 않습니다. 따라서 아이콘과 텍스트는 완전한 흰색으로 표시됩니다. 또한 outline variant에서도 테두리는 제거되며 배경만 `cta`로 표시됩니다.

**focused state 상세:**
- 배경색: `cta` (WdsColors.neutral900, #121212)
- 텍스트 색상: `WdsColors.white` (#FFFFFF)  
- 아이콘 색상: `WdsColors.white` (#FFFFFF)
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

## Select

> 좌측 상단에 제목(title)이 있을 수도, 없을 수도 있습니다.

### Select - variant

- `normal`
- `blocked`

모든 variant는 `isEnabled` 상태를 가집니다(`inactive`/`active`).
단, `blocked` 인 경우에만 `isEnabled == false`일 때 title과 hint text가 `disable` 색상을 사용합니다.

### Select - state

- `enabled`: 상호작용 가능
- `disabled`: 상호작용 불가

### Select - layout & style
항목 | 상태/조건 | 값 | 비고
--- | --- | --- | ---
padding | - | `EdgeInsets.fromLTRB(16, 12, 16, 12)` |
radius | - | `WdsRadius.v8` |
border | normal | `BorderSide(color: primary, width: 1)` |
border | blocked | `BorderSide(color: WdsColors.borderAlternative, width: 1)` |
backgroundColor | normal | `WdsColors.white` |
backgroundColor | blocked | `WdsColorNeutral.v50` |
title.typography | - | `WdsTypography.body14NormalRegular` |
title.color | 기본 | `WdsColors.textNormal` |
title.color | blocked + disabled | `WdsColors.textDisable` |
hint text | enabled | typography `WdsTypography.body14NormalRegular`, color `WdsColors.textNormal` |
hint text | disabled | typography `WdsTypography.body14NormalRegular`, color `WdsColors.textAlternative` | `blocked`는 `disable`
trailing 간격 | - | 10px | 아이콘과 텍스트 사이
아이콘 | 닫힘 | `chevronDown` |
아이콘 | 열림 | `chevronUp` |

---

## Tab

> 문자 기반 탭으로 가로 스크롤이 가능합니다.

### TextTabs - 속성

속성 | Type | 비고
--- | --- | ---
tabs | `List<WdsTextTab>` | 표시할 탭들의 리스트
controller | `WdsTextTabsController?` | 탭 컨트롤러 (선택사항)
onTap | `ValueChanged<int>?` | 탭 선택 시 호출되는 콜백

### TextTabs - controller

`WdsTextTabsController`는 Material의 TabController와 유사한 패턴을 따릅니다.

``` dart
final controller = WdsTextTabsController(
  length: 4,
  initialIndex: 0,
);

// 사용법
WdsTextTabs(
  tabs: [...],
  controller: controller,
  onTap: (index) => controller.setIndex(index),
)
```

### TextTabs - state
상태 | color | typography | 비고
--- | --- | --- | ---
enabled | `WdsColors.textAlternative` | `WdsTypography.body15NormalMedium` |
focused | `WdsColors.textNormal` | `WdsTypography.body15NormalBold` |
featured | 디자인 의도 색상 | `WdsTypography.body15NormalBold` | 강조 필요 시

### TextTabs - spacing & scroll
항목 | 값 | 비고
--- | --- | ---
좌측 시작 padding | 16px | 첫 번째 탭
탭 간 간격 | 20px | 탭 사이 간격
우측 끝 padding | 16px | 마지막 탭
상하 padding | 8px |

### LineTabs - 속성

속성 | Type | 비고
--- | --- | ---
tabs | `List<String>` | 표시할 탭들의 리스트
controller | `WdsTextTabsController?` | 탭 컨트롤러 (선택사항)
onTap | `ValueChanged<int>?` | 탭 선택 시 호출되는 콜백

### LineTabs

> 선택된 탭에 underline이 표시됩니다. 탭 별 너비는 사용 가능한 최대 너비를 탭 수(2 또는 3)로 균등 분할합니다.

항목 | 상태 | 값 | 비고
--- | --- | --- | ---
label.typography | 선택됨 | `WdsTypography.body15ReadingBold` |
label.color | 선택됨 | `WdsColors.textNormal` |
label.padding | 선택됨 | `EdgeInsets.fromLTRB(16, 11, 16, 9)` | underline 2px 고려
label.typography | 선택 안됨 | `WdsTypography.body15ReadingMedium` |
label.color | 선택 안됨 | `WdsColors.textNeutral` |
label.padding | 선택 안됨 | `EdgeInsets.fromLTRB(16, 11, 16, 10)` |
underline | 선택됨 | 높이 2px, 너비 탭 full, color `WdsColors.black` |
underline | 선택 안됨 | 1px solid `WdsColors.borderAlternative` |
탭 개수 | - | 2개 또는 3개 |

---

## PaginationDot

> 페이지를 작은 점(dot) 형태로 표시하여 사용자가 현재 페이지와 다른 페이지로 쉽게 이동할 수 있도록 돕습니다.

PaginationDot은 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
isActive | `bool` | 'true' : 현재 페이지 / 'false' : 비활성 페이지

### PaginationDot - variant

| 항목          | 값              | 비고 |
|---------------|-----------------|------|
| dot 최소 개수 | 2               | 1개는 의미 없음 |
| dot 최대 개수 | 제한 없음       | 10개 이상 시 가독성 저하 |

### PaginationDot - style

| 항목 | 상태/조건 | 값   | 비고 |
| --- | ------  | --- | --- |
| size            |    -    | `Size(6, 6)` |
| backgroundColor | active | `WdsColors.textNormal` |
| backgroundColor | inactive | `WdsColors.textAssistive` |

## PaginationCount
페이지 번호를 숫자 형태로 표시하는 페이지네이션 방식입니다.

PaginationCount는 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
| currentPage | `int` | 현재 페이지
| totalPage | `int` | 전체 페이지


### PaginationCount - style

항목 | 상태/조건 | 값 | 비고
--- | --- | --- | ---
width      | - | `Hug` | 페이지 수에 따라 유동적 
background | - | `WdsColors.cta` | 배경 색
background.opacity | - | `WdsOpacity.opacity80` | 배경 투명도
radius  | - | `WdsRadius.full` | pill 형태 유지
padding | - | `EdgeInsets.fromLTRB(10, 4, 10, 4)` | 내부 여백 설정

### PaginationCount - textStyle (current / total)
항목 | 상태 | 값 | 비고
--- | --- | --- | ---
text.typography | - | `WdsSemanticTypography.caption11Regular` | 텍스트 타이포그래피 
text.color | current | `WdsColors.white` | 현재 페이지 텍스트 색상
text.color | total | `WdsColors.textAssistive` | 전체 페이지 텍스트 색상
text.opacity | - | `WdsOpacity.opacity80` | 전체 페이지 텍스트 투명도
separator.spacing | - | 3px | current/total 시각적 구분 확보

### PaginationCount - textStyle (separator)
항목 | 상태 | 값 | 비고
--- | --- | --- | ---
text | - | `/` |   구분 텍스트
text.typography | - | `WdsSemanticTypography.caption11Regular` | 텍스트 타이포그래피 
text.color | - | `WdsColors.textAlternative` |  구분 텍스트 색상

---

## ActionArea
> 화면 하단에서 주요 액션(결제, 다음 단계 등)을 안정적으로 수행하게 하는 영역입니다.

- `ActionArea`: 버튼 조합만 있는 고정형

두 컴포넌트 모두 다음 공통 스타일을 따릅니다.

항목 | 값 | 비고
--- | --- | ---
border(top) | `1px WdsColors.borderAlternative` |
backgroundColor | `WdsColors.white` |
padding | `EdgeInsets.all(16)` |

CTA는 기본적으로 `WdsButton`을 사용하고, 특별한 언급이 없으면 size는 `WdsButtonSize.xlarge` 입니다.

### ActionArea

고정된 높이를 갖는 단순 버튼 영역입니다.

항목 | 값 | 비고
--- | --- | ---
height | `81px` | 고정 높이
border(top) | `1px WdsColors.borderAlternative` | 공통
backgroundColor | `WdsColors.white` | 공통
padding | `EdgeInsets.all(16)` | 공통

#### ActionArea - variant

variant | 버튼 구성 | 레이아웃/크기 | spacing
--- | --- | --- | ---
normal | CTA 1개 | `Expanded` 로 가로 전체 사용, size `xlarge` | -
filter | 2개: `.secondary`(좌), `.cta`(우) | 좌측 고정너비 `110px`(size `xlarge`), 우측 `Expanded` 로 stretch | 12px
division | 2개: `.secondary` + `.cta` | 두 버튼 모두 `Expanded`, 너비 비율 1:1, size `xlarge` | 12px

예시

``` dart
// normal
Expanded(child: WdsButton(variant: WdsButtonVariant.cta, size: WdsButtonSize.xlarge, child: const Text('메인액션')));

// filter
Row(spacing: 12, children: [
  SizedBox(
    width: 110,
    child: WdsButton(variant: WdsButtonVariant.secondary, size: WdsButtonSize.xlarge, child: const Text('대체액션')),
  ),
  Expanded(
    child: WdsButton(variant: WdsButtonVariant.cta, size: WdsButtonSize.xlarge, child: const Text('메인액션')),
  ),
]);

// division
Row(spacing: 12, children: [
  Expanded(child: WdsButton(variant: WdsButtonVariant.secondary, size: WdsButtonSize.xlarge, child: const Text('대체액션'))),
  Expanded(child: WdsButton(variant: WdsButtonVariant.cta, size: WdsButtonSize.xlarge, child: const Text('메인액션'))),
]);
```

### 접근성 및 동작

- 고정/동적 유형 모두 안전 영역(safe area)을 고려해 하단 제스처 바와 겹치지 않도록 합니다.
- 버튼 `disabled` 상태는 `opacity 0.4` 규칙을 따릅니다(버튼 규칙과 동일).
- 상단 보조 영역의 정보는 스크린리더가 읽을 수 있도록 텍스트 위주로 제공합니다.


## Switch

> 설정의 on/off를 토글하는 컴포넌트입니다. 값 변화 시 애니메이션으로 전환됩니다.

### Switch - size

속성 | track(size) | knob | padding | 비고
--- | --- | --- | --- | ---
small | 39x24 | 18x18 | EdgeInsets.all(3) | 컴팩트
large | 52x32 | 24x24 | EdgeInsets.all(4) | 상하 4px 여백

### Switch - state

- enabled: 상호작용 가능, `onChanged` 호출됨
- disabled: 상호작용 불가, 색상에 `withAlpha(40)` 적용(약 40% 투명도)

### Switch - value

- false(inactive): 꺼짐 상태, knob는 왼쪽
- true(active): 켜짐 상태, knob는 오른쪽

### Switch - color

- active(track): `primary`
- inactive(track): `WdsColors.neutral200`
- knob: `WdsColors.white`

### Switch - background(track)

- backgroundColor: `WdsColors.neutral200`
- padding: size 별로 상이(small: `EdgeInsets.all(3)`, large: `EdgeInsets.all(4)`)

large는 track 높이 32, knob 24로 상하 4px 여백이 생깁니다. small은 track 높이 24, knob 18로 상하 3px 여백을 둡니다.

### Switch - interaction

- 터치/클릭 시 `value`가 토글되며, `onChanged(bool next)`를 호출합니다.
- knob 위치 전환은 `Curves.easeIn`으로 애니메이션되며, `Duration(milliseconds: 200)`을 사용합니다.

### Switch - 생성 방법

- `WdsSwitch.small(value: $v, onChanged: $cb)`
- `WdsSwitch.large(value: $v, onChanged: $cb)`

size는 생성자에서 명시적으로 선택하며, 런타임에 변경하지 않습니다.

e.g. layout
``` dart
SizedBox.fromSize(
  size: $size.spec, // enum 에 캡슐화된 track 스펙
  child: DecoratedBox(
    decoration: BoxDecoration(
      color: $value ? primary : WdsColors.neutral200,
      borderRadius: BorderRadius.circular($size.spec.height / 2),
    ),
    child: Padding(
      padding: $size.padding,
      child: AnimatedAlign(
        alignment: $value ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: WdsColors.white,
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(dimension: $size.knobSize),
        ),
      ),
    ),
  ),
)
```

## Checkbox

> 사용자가 여러 항목 중에서 하나 또는 여러 개를 선택할 수 있도록 돕습니다. 값(true/false)과 활성화 여부(isEnabled)로 표현이 달라집니다.

### Checkbox - size

속성 | spec | margin | 비고
--- | --- | --- | ---
large | 24x24 | `EdgeInsets.all(3)` | 기본
small | 20x20 | `EdgeInsets.all(2)` | 컴팩트

e.g. enum
``` dart
enum WdsCheckboxSize {
  small(spec: Size(20, 20), margin: EdgeInsets.all(2)),
  large(spec: Size(24, 24), margin: EdgeInsets.all(3));

  const WdsCheckboxSize({
    required this.spec,
    required this.margin,
  });

  final Size spec;
  final EdgeInsets margin;
}
```

### Checkbox - state

상태 | 설명
--- | ---
enabled | 상호작용 가능, `onChanged` 호출됨
disabled | 상호작용 불가, 전체적으로 `opacity 0.4` 적용(색상은 `withAlpha(WdsOpacity.opacity40.toAlpha())` 등 동일 메커니즘)

### Checkbox - value

값 | 설명
--- | ---
false | 체크 해제 상태, 체크 마크 표기 없음
true | 체크 상태, 체크 마크 표기 및 배경 채움

### Checkbox - backgroundColor

- `true`: `cta`
- `false`: `null`

### Checkbox - border & radius

- `true`: `border = null`
- `false`: `border = BorderSide(color: WdsColors.borderNeutral, width: 1.5)`
- `borderRadius`: `WdsRadius.xs` (size와 무관하게 동일)

### Checkbox - check mark

- 체크 마크는 `value == true`일 때만 노출됩니다.
- 그려지는 방향은 왼쪽에서 오른쪽으로 진행합니다.
- 기준 좌표계(large 기준)는 내부 20x20 영역을 (0,0)~(20,20)으로 사용합니다. 실제 렌더 트리는 `SizedBox(spec) > Padding(margin) > ClipRRect > CustomPaint(20x20)` 구조이므로, 체크 마크 좌표는 (0,0)~(20,20) 기준으로 그립니다.
  ~~~ dart
  const markPath = [
    Offset(4.75, 9.75), // left-top-check-mark
    Offset(8.5, 13.5),  // middle-bottom-check-mark
    Offset(15.5, 6.5),  // top-right-check-mark
  ];
  ~~~
- small(20x20, margin 2) 사이즈는 동일한 형태를 비율에 맞게 축소하여 렌더링합니다.

### Checkbox - layout tree

위젯 트리는 다음과 같습니다.

```
SizedBox(spec)
  > Padding(margin)
    > ClipRRect(borderRadius: WdsRadius.xs)
      > CustomPaint(size: 20x20)
```

### Checkbox - animation

- 배경 채움은 중심에서 가장자리로 퍼지도록 채웁니다.
- 색상 채움은 `CustomPaint`로 구현합니다.
- 애니메이션은 `Duration(milliseconds: 300)` + `Curves.easeIn`을 사용합니다.
- 체크 마크 경로는 왼쪽에서 오른쪽으로 그리며 진행도에 따라 부분 경로를 렌더링합니다.


## Radio

> 사용자가 여러 옵션 중에서 하나만 선택할 수 있도록 돕습니다. Checkbox와 달리 그룹 내에서 오직 하나의 항목만 선택 가능하며, `groupValue`와 개별 `value`를 비교하여 선택 여부를 판단합니다.

Radio는 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
value | `T` | 해당 Radio가 갖는 고유 값
groupValue | `T?` | 현재 선택된 그룹 값 
onChanged | `ValueChanged<T?>?` | 선택 시 호출되는 콜백
isEnabled | `bool` | Radio 활성화 여부 (`false` 시 'disabled' 상태)

### Radio - size

속성 | spec | margin | inner circle | 비고
--- | --- | --- | --- | ---
small | 20x20 | `EdgeInsets.all(1.67)` | 6.67px | 컴팩트
large | 24x24 | `EdgeInsets.all(2)` | 10px | 기본

레이아웃: `SizedBox > Padding > radio`

### Radio - state

상태 | 설명
--- | ---
enabled | 상호작용 가능, `onChanged` 호출됨
disabled | 상호작용 불가, 전체적으로 `opacity 0.4` 적용

### Radio - value (선택 상태)

상태 | border | backgroundColor | inner circle
--- | --- | --- | ---
선택됨 (`value == groupValue`) | 2px `WdsColors.statusPositive` (inside) | `WdsColors.white` | 원형, `WdsColors.primary`
선택 안됨 (`value != groupValue`) | 1.25px `WdsColors.borderNeutral` (small) / 1.5px (large) | `null` | 없음

### Radio - 생성 방법

Radio는 제네릭 타입을 사용하여 다양한 값 타입을 지원합니다.

``` dart
WdsRadio<String>.small(
  value: 'option1',
  groupValue: selectedValue,
  onChanged: (String? value) => setState(() => selectedValue = value),
)

WdsRadio<String>.large(
  value: 'option2', 
  groupValue: selectedValue,
  onChanged: (String? value) => setState(() => selectedValue = value),
)
```


## Toast

> 화면에 잠시 나타났다 사라지는 짧은 알림 메시지로, 사용자가 수행한 작업에 대한 피드백을 제공합니다.

Toast는 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
message | `String` | 토스트에 표시될 메시지 내용
leadingIcon | `WdsIcon?` | 선택사항인 앞쪽 아이콘 (icon variant에서만 사용)
variant | `WdsToastVariant` | Toast의 표시 형태 (text 또는 icon)

### Toast - variant

정해진 Variant만 사용할 수 있습니다.

- `text`: 텍스트만 표시하는 기본 형태
- `icon`: 아이콘과 텍스트를 함께 표시하는 형태

### Toast - 고정된 속성

모든 Toast는 동일한 시각적 속성을 갖습니다.

속성 | 값 | 비고
--- | --- | ---
backgroundColor | `WdsColors.cta` (#121212) | 고정
borderRadius | 8px | 고정
typography | `WdsTypography.body14NormalMedium` | 
textColor | `WdsColors.white` (#FFFFFF) |
padding (outer) | `EdgeInsets.symmetric(horizontal: 16, vertical: 9)` | DecoratedBox 내부

### Toast - layout

variant에 따라 레이아웃 구조가 달라집니다.

**text variant:**
```
DecoratedBox > Padding (outer) > Padding (inner) > Text
```

**icon variant:**
```
DecoratedBox > Padding (outer) > Row: (Padding > WdsIcon + Padding > Text)
```

### Toast - icon 속성 (icon variant)

아이콘이 포함된 경우의 세부 속성입니다.

속성 | 값 | 비고
--- | --- | ---
iconSize | 24x24 |
iconColor | `WdsColors.white` (#FFFFFF) |
iconSpacing | 6px | 아이콘과 텍스트 사이 간격
iconPadding | `EdgeInsets.symmetric(vertical: 3)` | 아이콘 상하 여백

### Toast - padding

variant에 따른 내부 패딩 구조입니다.

variant | inner padding | 비고
--- | --- | ---
text | `EdgeInsets.symmetric(vertical: 5)` | 텍스트 주변 여백
icon | `EdgeInsets.symmetric(vertical: 3)` (아이콘), `EdgeInsets.symmetric(vertical: 5)` (텍스트) | 각각 독립적 여백

### Toast - 생성 방법

named constructor로 생성할 수 있습니다.

``` dart
// 텍스트만 표시
WdsToast.text(message: '저장되었습니다')

// 아이콘과 함께 표시
WdsToast.icon(
  message: '작업이 완료되었습니다',
  leadingIcon: WdsIcon.checkCircle,
)
```

### Toast - 표시 유틸리티(show/dismiss)

앱 어디에서나 간단히 토스트를 띄우고 자동으로 닫히도록 하기 위해 Overlay 기반 유틸리티를 제공합니다. Material(또는 Cupertino) 앱 컨텍스트 내에서 호출되어야 하며, 기본 지속시간은 2000ms입니다.

``` dart
// 텍스트 토스트
final controller = WdsToastUtil.showText(
  context,
  message: '저장되었습니다',
  duration: const Duration(milliseconds: 2000),
);

// 아이콘 토스트
final controller2 = WdsToastUtil.showIcon(
  context,
  message: '작업이 완료되었습니다',
  icon: WdsIcon.blank,
  duration: const Duration(milliseconds: 1500),
);

// 수동 닫기
controller.dismiss();
```

#### 구현/채택 근거
- flutter/material의 `ScaffoldMessenger.showSnackBar`는 토스트의 디자인/레이아웃 제약과 다르며, 액션 버튼 등 스낵바 성격에 가깝습니다.
- 네이티브(플랫폼 채널) 연동은 비용이 크고 WDS 일관 색/타이포/레이아웃 제어가 어렵습니다.
- 따라서 Flutter Overlay 위에 `WdsToast`를 올리는 방식을 채택했습니다. SafeArea를 고려해 하단 중앙에 배치하고, 지정한 `Duration` 경과 시 자동 dismiss 합니다.

## Snackbar

> 사용자가 수행한 작업에 대한 피드백을 제공합니다. Toast와 달리 추가적인 조치를 취할 수 있는 버튼이 포함되어 있습니다.

Snackbar는 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
message | `String` | 주요 메시지 내용
description | `String?` | 보조 설명 텍스트 (description variant에서만 사용)
leadingIcon | `WdsIcon?` | 선택사항인 앞쪽 아이콘
action | `Widget` | 우측에 위치하는 액션 버튼 (WdsTextButton)
variant | `WdsSnackbarVariant` | Snackbar의 표시 형태

### Snackbar - variant

정해진 Variant만 사용할 수 있습니다.

- `normal`: 단일 메시지와 액션 버튼
- `description`: 주 메시지와 보조 설명이 함께 표시
- `multiLine`: 2줄까지 표시 가능한 긴 메시지와 액션 버튼

### Snackbar - 고정된 속성

모든 Snackbar는 동일한 시각적 속성을 갖습니다.

속성 | 값 | 비고
--- | --- | ---
backgroundColor | `WdsColors.cta` (#121212) | 고정
borderRadius | 8px | 고정
padding | `EdgeInsets.fromLTRB(16, 9, 16, 9)` | 외부 패딩

### Snackbar - layout

variant에 따라 레이아웃 구조가 달라집니다.

**normal variant:**
```
Row: (Expanded > Padding > Text) + SizedBox(8px) + WdsTextButton
```

**description variant:**
```
Row: (Expanded > Padding > Column(Text(주), Text(보조))) + SizedBox(8px) + WdsTextButton
```

**multiLine variant:**
```
Row: (Expanded > Padding > Text(maxLines: 2)) + SizedBox(8px) + WdsTextButton
```

### Snackbar - text 속성

variant별 텍스트 스타일과 제약사항입니다.

variant | message 속성 | description 속성 | maxLines | overflow
--- | --- | --- | --- | ---
normal | `WdsTypography.body14NormalMedium`, `WdsColors.white` | - | 1 | ellipsis
description | `WdsTypography.body14NormalMedium`, `WdsColors.white` | `WdsTypography.caption12Regular`, `WdsColors.textAssistive` | 각각 1 | ellipsis
multiLine | `WdsTypography.caption12Regular`, `WdsColors.textAssistive` | - | 2 | ellipsis

### Snackbar - padding

모든 variant에서 내부 텍스트 영역은 동일한 패딩을 갖습니다.

속성 | 값 | 비고
--- | --- | ---
text padding | `EdgeInsets.symmetric(vertical: 5)` | Expanded 내부 Padding

### Snackbar - leadingIcon (선택사항)

아이콘이 포함된 경우의 세부 속성입니다.

속성 | 값 | 비고
--- | --- | ---
iconSize | 24x24 |
iconColor | `WdsColors.white` (#FFFFFF) |
iconSpacing | 6px | 아이콘과 콘텐츠 사이 간격
iconPosition | centerLeft | 세로 중앙 정렬

### Snackbar - action

우측에 위치하는 액션 버튼의 속성입니다.

속성 | 값 | 비고
--- | --- | ---
component | `WdsTextButton` | 
variant | `.underline` 또는 `.icon` | 
spacing | 8px | 콘텐츠와 액션 버튼 사이 간격


## Tooltip

> 설명적 내용이 필요한 경우에 사용합니다.

Tooltip은 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
message | `String` | 툴팁에 표시될 메시지
hasArrow | `bool` | 화살표 표시 여부 (`true` 시 화살표 표시)
hasCloseButton | `bool` | 닫기 버튼 표시 여부 (`true` 시 우측에 닫기 버튼 표시)
alignment | `WdsTooltipAlignment` | 툴팁 위치 설정
onClose | `VoidCallback?` | 닫기 버튼이 눌렸을 때 콜백 (hasCloseButton이 true일 때만)

### Tooltip - 고정된 속성

모든 Tooltip은 동일한 시각적 속성을 갖습니다.

속성 | 값 | 비고
--- | --- | ---
backgroundColor | `WdsColors.cta` (#121212) | 고정
borderRadius | `WdsRadius.sm` | 고정
typography | `WdsTypography.body14NormalMedium` | 
textColor | `WdsColors.white` (#FFFFFF) |
minWidth | 64px | 최소 너비
padding | `EdgeInsets.fromLTRB(10, 8, 10, 8)` | 외부 패딩
contentPadding | `EdgeInsets.symmetric(horizontal: 2)` | 텍스트 내부 패딩

### Tooltip - arrow

화살표가 표시되는 경우의 속성입니다.

속성 | 값 | 비고
--- | --- | ---
arrowWidth | 24px | 고정
arrowHeight | 8px | 고정
arrowTriangleWidth | 12px | 실제 삼각형 너비 (24px - 6px - 6px)
sidePadding | 6px | 화살표 양쪽 여백
tipPadding | 1.54px | 화살표 끝 부분 여백

화살표는 alignment에 따라 회전되며, 이등변삼각형으로 렌더링됩니다. 툴팁 컨테이너와의 시각적 연결을 위해 1px overlap이 적용됩니다.

### Tooltip - closeButton

닫기 버튼이 표시되는 경우의 속성입니다.

속성 | 값 | 비고
--- | --- | ---
icon | `WdsIcon.close` | 고정 아이콘, 다른 아이콘 사용 불가
buttonSize | 20x20px | 고정 영역
spacing | 8px | 콘텐츠와 버튼 사이 간격
position | 우측 | 텍스트와 같은 행에 위치
layout | hug content | 콘텐츠 크기에 맞춰 축소 (Flexible 사용)

### Tooltip - alignment

툴팁의 위치를 결정하는 열거형입니다.

alignment | 설명
--- | ---
topLeft | 대상의 왼쪽 위에 위치, 화살표는 아래쪽 왼쪽을 향함
topCenter | 대상의 중앙 위에 위치, 화살표는 아래쪽 중앙을 향함
topRight | 대상의 오른쪽 위에 위치, 화살표는 아래쪽 오른쪽을 향함
rightTop | 대상의 오른쪽 위에 위치, 화살표는 왼쪽 위를 향함
rightCenter | 대상의 오른쪽 중앙에 위치, 화살표는 왼쪽 중앙을 향함
rightBottom | 대상의 오른쪽 아래에 위치, 화살표는 왼쪽 아래를 향함
bottomLeft | 대상의 왼쪽 아래에 위치, 화살표는 위쪽 왼쪽을 향함
bottomCenter | 대상의 중앙 아래에 위치, 화살표는 위쪽 중앙을 향함
bottomRight | 대상의 오른쪽 아래에 위치, 화살표는 위쪽 오른쪽을 향함
leftTop | 대상의 왼쪽 위에 위치, 화살표는 오른쪽 위를 향함
leftCenter | 대상의 왼쪽 중앙에 위치, 화살표는 오른쪽 중앙을 향함
leftBottom | 대상의 왼쪽 아래에 위치, 화살표는 오른쪽 아래를 향함

### Tooltip - layout

hasCloseButton에 따라 레이아웃 구조가 달라집니다.

**hasCloseButton = false:**
```
CustomPaint > DecoratedBox > Padding > Text
```

**hasCloseButton = true:**
```
CustomPaint > DecoratedBox > Padding > Row(mainAxisSize.min): (Flexible > Text) + SizedBox(8px) + IconButton(20x20)
```

닫기 버튼이 있는 경우 `Row`는 `MainAxisSize.min`으로 설정되고, 텍스트는 `Flexible`로 감싸져 콘텐츠 크기에 맞춰 축소됩니다 (hug content). 닫기 아이콘은 `WdsIcon.close`로 고정됩니다.
  
- true: border 2px `WdsColors.primary`
- false


## DotBadge

알림을 표시하는 작은 아이콘이나 배지로, 사용자가 특정 항목이나 상태에 대해 새로운 정보나 업데이트가 있음을 시각적으로 알려주는 요소입니다.

DotBadge는 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
child | `Widget` | 배지가 위치할 자식 위젯
color | `Color?` | 점 배지의 색상 (기본값: WdsColors.orange600)
alignment | `Alignment?` | 자식 위젯 기준 배지의 정렬 위치, null이면 미표기

### DotBadge - 고정된 속성

모든 DotBadge는 동일한 시각적 속성을 갖습니다.

속성 | 값 | 비고
--- | --- | ---
size | 4x4px | 고정 크기
shape | `CircleBorder()` | 원형 모양
기본 색상 | `WdsColors.orange600` | color가 null일 때 사용

### DotBadge - alignment

배지가 자식 위젯 기준으로 위치할 수 있는 9개 위치를 지원합니다.

alignment | 설명
--- | ---
topLeft | 자식 위젯의 왼쪽 위 모서리
topCenter | 자식 위젯의 위쪽 중앙
topRight | 자식 위젯의 오른쪽 위 모서리
middleLeft | 자식 위젯의 왼쪽 중앙
middleCenter | 자식 위젯의 중앙
middleRight | 자식 위젯의 오른쪽 중앙
bottomLeft | 자식 위젯의 왼쪽 아래 모서리
bottomCenter | 자식 위젯의 아래쪽 중앙
bottomRight | 자식 위젯의 오른쪽 아래 모서리

### DotBadge - layout

DotBadge는 Stack과 Align을 사용하여 자식 위젯 크기에 맞춰 배지 위치를 결정합니다.

``` dart
Stack(
  clipBehavior: Clip.none,
  alignment: Alignment.center,
  children: [
    Positioned.fill(
      top: -2,
      right: -2,
      bottom: -2,
      left: -2,
      child: Align(
        alignment: alignment!,
        child: SizedBox.square(
          dimension: 4,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: color ?? WdsColors.orange600,
            ),
          ),
        ),
      ),
    ),
    child,
  ],
)
```

### DotBadge - 사용 방법

#### 기본 사용법
``` dart
WdsDotBadge(
  alignment: Alignment.topRight,
  child: Icon(Icons.notifications),
)
```

#### 색상 지정
``` dart
WdsDotBadge(
  alignment: Alignment.topRight,
  color: WdsColors.red500,
  child: Icon(Icons.mail),
)
```

#### 배지 숨기기
``` dart
WdsDotBadge(
  alignment: null, // 배지 숨김
  child: Icon(Icons.home),
)
```

### DotBadge - 확장 메서드

모든 위젯에 배지 기능을 추가할 수 있는 확장 메서드를 제공합니다.

``` dart
// 기본 사용 (topRight 위치)
Icon(Icons.settings).addDotBadge()

// 색상과 위치 지정
Icon(Icons.settings).addDotBadge(
  color: WdsColors.blue500,
  alignment: Alignment.topLeft,
)
```

### DotBadge - 믹스인

StatelessWidget 컴포넌트에서도 배지를 사용할 수 있도록 믹스인을 제공합니다.

``` dart
class MyWidget extends StatelessWidget with WdsBadgeMixin {
  @override
  Widget build(BuildContext context) {
    return addDotBadge(
      alignment: Alignment.topRight,
      child: Icon(Icons.favorite),
    );
  }
}
```

## Divider

> 디자인 요소와 정보를 구분하는 데 사용합니다.
이를 통해 각 요소의 디자인 가독성이 향상됩니다.

### Divider - 개요
시각적 구분을 위한 선(line) 컴포넌트입니다. 방향(가로/세로)과 두께(variant)에 따라 고정 스펙을 사용합니다.

### Divider - 속성

속성 | Type | 비고
--- | --- | ---
variant | `WdsDividerVariant` | `normal`, `thick`
isVertical | `bool` | `false`(기본), 세로선은 named constructor로 생성
color | `Color` | 고정값 `WdsColors.borderAlternative`

e.g. enum
``` dart
enum WdsDividerVariant { normal, thick }
```

### Divider - 생성 방법(방향)
가로/세로 방향은 생성자에서 고정합니다.

``` dart
// 기본(가로, normal)
const WdsDivider();

// 가로, 두꺼운 두께
const WdsDivider(variant: WdsDividerVariant.thick);

// 세로(단일 스펙: 1 x 32)
const WdsDivider.vertical();
```

e.g. build configuration (구현 예 아님)
``` dart
// 가로 divider: width = double.infinity, height = 1 또는 6, color = WdsColors.borderAlternative
SizedBox(
  width: double.infinity,
  height: $height, // 1(normal) | 6(thick)
  child: const DecoratedBox(
    decoration: BoxDecoration(color: WdsColors.borderAlternative),
  ),
);

// 세로 divider: width = 1, height = 32, color = WdsColors.borderAlternative
SizedBox(
  width: 1,
  height: 32,
  child: const DecoratedBox(
    decoration: BoxDecoration(color: WdsColors.borderAlternative),
  ),
);
```

### Divider - color
- 고정: `WdsColors.borderAlternative`

### Divider - size

방향 | variant | width | height | 비고
--- | --- | --- | --- | ---
가로 | normal | `double.infinity` | 1px | 전체 너비로 늘어남
가로 | thick | `double.infinity` | 6px | 강조 구분선
세로 | normal | 1px | 32px | 단일 스펙만 제공

### Divider - 사용 예시
``` dart
// 가로, 보통 두께
const WdsDivider();

// 가로, 두꺼운 두께
const WdsDivider(variant: WdsDividerVariant.thick);

// 세로(고정 스펙: 1 x 32)
const WdsDivider.vertical();
```

## Slider

> 특정 범위에 대한 값을 선택할 때 사용합니다.

Slider는 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | ---
minValue | `double` | 최소값
maxValue | `double` | 최대값
values | `RangeValues` | 현재 선택된 범위 (start, end)
divisions | `int?` | 슬라이더 분할 단위 (선택사항)
onChanged | `ValueChanged<RangeValues>?` | 값 변경 시 콜백
hasTitle | `bool` | 상단에 선택된 범위 표시 여부
isEnabled | `bool` | 슬라이더 활성화 여부 (`false` 시 'disabled' 상태)

### Slider - state

아래 2가지 상태를 가집니다.

상태 | 설명
--- | ---
enabled | 상호작용 가능, `onChanged` 호출됨
disabled | 상호작용 불가, 색상 변경 적용

### Slider - 구성 요소

Slider는 여러 레이어로 구성됩니다 (아래부터 위 순서로 렌더링).

구성 요소 | 속성 | 값 | 비고
--- | --- | --- | ---
background track | height | 4px | 전체 트랙 배경
background track | width | `double.infinity` | 가용 전체 너비
background track | borderRadius | `WdsRadius.full` |
background track | color | `WdsColors.borderAlternative` |
background track | margin | `EdgeInsets.symmetric(horizontal: 8)` | knob 영역 확보
active track | height | 4px | 선택된 범위 표시
active track | color | `WdsColors.primary` |
active track | width | knob 간 거리만큼 동적 | start~end 구간
knob | size | 20x20px | 원형 핸들
knob | backgroundColor | `WdsColors.primary` |
knob | border | 2px `WdsColors.white` (inside) |
knob | shape | `CircleBorder` | CustomPaint로 구현
knob interaction | size | 32x32px | 터치/호버 영역
knob interaction | borderRadius | `WdsRadius.full` |
knob interaction | backgroundColor | `WdsColors.cta.withAlpha(WdsOpacity.opacity5.toAlpha())` | hover/pressed 시에만 표시

### Slider - title

`hasTitle`이 `true`일 때 상단에 선택된 범위를 표시합니다.

속성 | 값 | 비고
--- | --- | ---
typography | `WdsTypography.heading16Bold` |
color | `WdsColors.textNormal` | enabled 상태
color (disabled) | `WdsColors.textDisable` | disabled 상태
format | `"${start} ~ ${end}"` | 선택된 범위 텍스트

e.g. code - hasTitle layout
``` dart
Column(
  spacing: 12,
  children: [
    if (hasTitle) _buildTitle(),
    _buildSlider(),
  ],
)
```

### Slider - disabled state

비활성화 상태에서는 다음과 같이 색상이 변경됩니다.

구성 요소 | disabled 상태 색상 | 비고
--- | --- | ---
title | `WdsColors.textDisable` |
active track | `WdsColors.borderAlternative` |
knob | `WdsColors.borderAlternative` | border는 `WdsColors.white` 유지

### Slider - interaction

상호작용 동작 및 제약사항입니다.

동작 | 설명
--- | ---
knob 이동 | 좌우로 각각 독립적 이동 가능
범위 제약 | 왼쪽 knob은 start값, 오른쪽 knob은 end값
동일값 허용 | `start == end` 상황 허용
interaction 표시 | hover/pressed 시 32x32 영역 표시
division 단위 | `divisions`가 설정된 경우 해당 단위로만 이동


## SectionMessage

> 특정 섹션이나 영역 내에서 중요한 정보나 피드백을 전달하는 메시지입니다. 사용자가 필요한 행동을 취할 수 있도록 돕습니다.

SectionMessage는 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
message | `String` | 메시지에 표시될 텍스트 내용
leadingIcon | `WdsIcon?` | 선택사항인 앞쪽 아이콘
variant | `WdsSectionMessageVariant` | 메시지의 표시 형태 (normal, highlight, warning)

### SectionMessage - variant

정해진 Variant만 사용할 수 있습니다.

- `normal`: 기본 정보 전달 형태
- `highlight`: 긍정적인 정보나 성공 상태 표시
- `warning`: 주의가 필요한 정보나 경고 상태 표시

### SectionMessage - 고정된 속성

모든 SectionMessage는 동일한 레이아웃 속성을 갖습니다.

속성 | 값 | 비고
--- | --- | ---
padding | `EdgeInsets.all(16)` | 모든 variant 고정
iconSize | 16x16 | 아이콘 크기 고정
iconPosition | leading | 아이콘 위치 고정
iconSpacing | 4px | 아이콘과 텍스트 사이 간격

### SectionMessage - variant별 속성

variant에 따라 색상이 달라집니다.

속성 | normal | highlight | warning
--- | --- | --- | ---
backgroundColor | `WdsColors.backgroundAlternative` | `WdsColors.blue50` | `WdsColors.orange50`
textColor | `WdsColors.textNeutral` | `WdsColors.statusPositive` | `WdsColors.statusCautionaty`
iconColor | `WdsColors.neutral500` | `WdsColors.primary` | `WdsColors.statusCautionaty`

### SectionMessage - 생성 방법

named constructor로 생성할 수 있습니다.

``` dart
// 기본 정보 메시지
WdsSectionMessage.normal(
  message: '정보를 확인해주세요',
  leadingIcon: WdsIcon.info,
)

// 긍정적 메시지
WdsSectionMessage.highlight(
  message: '작업이 완료되었습니다',
  leadingIcon: WdsIcon.checkCircle,
)

// 경고 메시지
WdsSectionMessage.warning(
  message: '주의가 필요한 사항입니다',
  leadingIcon: WdsIcon.warning,
)
```

### SectionMessage - 구현 세부사항

- **borderRadius**: `WdsRadius.v8` (8px)
- **Row spacing**: 4px (아이콘과 텍스트 사이)
- **MainAxisSize**: `MainAxisSize.min` (콘텐츠 크기에 맞춤)
- **Typography**: `WdsTypography.body14NormalMedium`

## Badge

> 정보의 개수를 강조하기 위해 사용합니다. 장바구니 아이템, 알림 등 개수에 대한 표기가 필요한 경우에 활용합니다. 중요도에 맞게 CTA/Primary 컬러를 사용합니다.

Badge는 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
count | `int` | 표시할 개수 (0은 표시하지 않음)
targetIcon | `Widget` | Badge가 붙을 대상 아이콘 위젯

### Badge - 고정된 속성

모든 Badge는 동일한 시각적 속성을 갖습니다.

속성 | 값 | 비고
--- | --- | ---
backgroundColor | `WdsColors.primary` | 고정
borderRadius | `WdsRadius.full` | 완전한 원형
padding | `EdgeInsets.fromLTRB(4, 2, 4, 2)` | 고정
typography | `WdsTypography.caption9SemiBold` | 9px, Pretendard, w600
textColor | `WdsColors.white` | 고정
letterSpacing | 0.03px | 고정
lineHeight | 128% | 고정

### Badge - 개수 표시 규칙

- 0은 표시하지 않음
- 1부터 99까지 숫자로 표시
- 100부터는 "99+"로 표시

### Badge - 위치 및 크기

Badge는 항상 대상 아이콘의 오른쪽 아래에 위치합니다.

속성 | 값 | 비고
--- | --- | ---
targetIconSize | 24x24 | 대상 아이콘 크기 (0,0 ~ 23,23)
stackSize | 24x24 | 원본 아이콘 크기 유지 (overflow 허용)
badgePosition | 동적 계산 | digitCount에 따라 left 위치 조정
interactionArea | 24x24 | 터치 영역 (아이콘 크기와 동일)

### Badge - 사용 방법

Extension을 통해 아이콘에 Badge를 추가할 수 있습니다.

``` dart
// 기본 사용법
WdsIcon.cart.build().addBadge(count: 4);

// Extension 구현
extension WdsBadgeExtension on Widget {
  Widget addBadge({
    required int count,
  }) {
    if (count <= 0) {
      return this;
    }

    return Stack(
      children: [
        this,
        Positioned(
          right: 0,
          top: 0,
          child: WdsBadge(count: count),
        ),
      ],
    );
  }
}
```

### Badge - 크기별 차이

개수에 따라 Badge 크기와 위치가 달라집니다.

개수 범위 | 크기 | 위치 조정 | 비고
--- | --- | --- | ---
1 | 16x16 | left: 12px | 한 자리 수 (특별 처리)
2-9 | 16x16 | left: 7px | 한 자리 수
10-99 | 20x16 | left: 2px | 두 자리 수 (가로 확장)
100+ | 24x16 | left: 2px | "99+" 표시 (최대 크기)

### Badge - Overflow 허용 방식

Badge가 원본 아이콘 크기를 유지하면서 overflow를 허용합니다.

``` dart
Stack(
  clipBehavior: Clip.none, // overflow 허용
  children: [
    originalWidget, // 원본 위젯 그대로 유지 (24x24)
    Positioned(
      left: 19.5, // Badge 중앙이 (19.5, 19.5)에 위치
      top: 19.5,  // 아이콘 24x24 기준 오른쪽 아래 중앙
      child: WdsBadge(count: count),
    ),
  ],
)
```

### Badge - 위치 계산

- **아이콘 크기**: 24x24 (픽셀 0,0 ~ 23,23)
- **Stack 크기**: 24x24 (원본 아이콘 크기 유지)
- **Badge 위치**: `left: 12 - ((digitCount - 1) * 5), top: 12`
- **digitCount**: 1자리=1, 2자리=2, 3자리 이상=2 (99+)
- **Overflow**: Badge가 아이콘 영역을 벗어나도 표시됨

### Badge - 위치 계산 공식

``` dart
int digitCount = count.toString().length;
if (digitCount > 2) {
  digitCount = 2; // 99+는 2자리로 처리
}

Positioned(
  left: 12 - ((digitCount - 1) * 5), // 동적 위치 계산
  top: 12, // 고정 상단 위치
  child: WdsBadge(count: count),
)
```

### Badge - 레이아웃 영향

- **Row/Column**: 아이콘 크기(24x24)만큼만 공간 차지
- **AppBar**: 높이가 늘어나지 않음
- **Overflow**: Badge가 아이콘 영역을 벗어나도 정상 표시

## Sheet

사용자가 화면에서 다른 작업을 진행하기 전에 반드시 확인하여야 하는 대화 상자입니다. 필요한 경우 Detach 해서 쓸 수 있습니다.

Sheet는 4가지 요소로 구분됩니다:

```dart
Column(
  children: [
    if (variant != WdsSheetVariant.nudging) handle,
    header,
    view,
    if (bottom != null) bottom,
  ],
)
```

속성 | Type | 비고
--- | --- | ---
onClose | `VoidCallback` | Sheet 닫기 콜백
title | `String` | Sheet 제목
variant | `WdsSheetVariant` | Sheet 타입 (fixed, draggable, nudging)
size | `WdsSheetSize` | Sheet 크기 (max, min)
isVisible | `bool` | Sheet 표시 여부
child | `Widget` | Sheet 내부 컨텐츠
bottom | `Widget?` | Sheet 하단 영역 (옵션)
image | `Widget?` | nudging variant에서 사용할 이미지 (옵션)
description | `String?` | nudging variant에서 사용할 설명 텍스트 (옵션)

### Sheet - variant

정해진 Variant만 사용할 수 있습니다.

- `fixed`
- `draggable` 
- `nudging`

**fixed**
- View의 높이는 컨텐츠에 따라 최대 높이까지 자유롭게 조정 가능
- fixed의 최대 View 높이는 max 또는 min 만 가능
- 페이지 아래에서 위로 올라오며 닫기 버튼 또는 Dimmed 영역 터치 또는 페이지를 아래로 스크롤 시 Sheet를 닫을 수 있습니다.

**draggable**
- view의 높이는 max, min 전환만 가능하며 컨텐츠가 view 높이를 넘어갈 시 스크롤이 발생
- 페이지 아래에서 위로 올라오며 닫기 버튼 또는 Dimmed 영역 터치 또는 페이지를 아래로 스크롤 시 Sheet를 닫을 수 있습니다.

**nudging**
- 고객에게 유익한 정보 제공 또는 행동을 유도할때 사용합니다
- 간소화된 텍스트와 이미지만을 사용해 빠른 메세지 전달이 가능합니다
- 영역을 Stack으로 구성하여 컨텐츠와 이미지/텍스트를 분리

### Sheet - size

각 variant별로 정해진 크기만 사용할 수 있습니다.

**fixed**
- `max`: constraints.maxHeight * 0.878 (674/768)
- `min`: constraints.maxHeight * 0.349 (268/768)

**draggable**
- `max`: constraints.maxHeight * 0.930 (714/768)
- `min`: constraints.maxHeight * 0.500 (384/768)

**nudging**
- `max`: constraints.maxHeight * 0.492 (378/768)
- `min`: constraints.maxHeight * 0.305 (234/768)

### Sheet - 구조

**Handle 영역 (fixed, draggable만)**
- top으로 7px padding이 있으며 40x5 px 크기에 `WdsColors.borderAlternative` 색상으로 `WdsRadius.full` radius
- 영역의 고정 높이는 12px

**Header 영역**
- padding: `EdgeInsets.symmetric(horizontal: 16, vertical: 13)` 고정
- 가운데 text, 오른쪽 끝에 trailing icon button 위치
- trailing icon button: `WdsIcon.close`
- header text: `WdsTypography.heading17Bold`, `WdsColors.textNormal`
- 영역 크기는 고정인데 비율은 360px에서 204px 비로 고정
- 고정 높이 영역 50px

**View 영역**
- padding: `EdgeInsets.all(16)` 고정

**Bottom 영역 (옵션)**
- bottom이 있는 경우, SafeArea로 감싸고 left, top, right의 padding은 16px
- bottom은 최소 16px (노치 핸드폰처럼 하단 viewPadding이 달라질 수 있기 때문)

**Nudging 구조**
```dart
Stack(
  children: [
    Column(children: [header, view, if (bottom != null) bottom]),
    Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (image != null) 
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: image),
            ),
          Text(title, style: WdsTypography.heading18Bold, textAlign: TextAlign.center),
          SizedBox(height: 10),
          Text(description, style: WdsTypography.body15NormalRegular, textAlign: TextAlign.center),
        ],
      ),
    ),
  ],
)
```

## Thumbnail

일정한 비율의 이미지로 콘텐츠를 미리 보여줍니다. 네트워크 이미지와 에셋 이미지를 모두 지원하며, 캐싱 기능을 통해 성능을 최적화합니다.

Thumbnail은 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
imagePath | `String` | 이미지 경로 (URL 또는 에셋 경로)
size | `WdsThumbnailSize` | 썸네일 크기 (xxs, xs, sm, md, lg, xl, xxl)
hasRadius | `bool` | 모서리 둥글기 적용 여부

### Thumbnail - 자동 감지

이미지 경로에 따라 자동으로 네트워크/에셋을 구분합니다.

- **네트워크 이미지**: `http://` 또는 `https://`로 시작하는 URL
- **에셋 이미지**: `assets/`로 시작하는 경로 또는 상대 경로

### Thumbnail - size

px 단위로 이루어집니다. 모든 크기는 정사각형이며, xl만 179x250의 직사각형입니다.

속성 | size | 비고
--- | --- | ---
xxs | Size(64, 64) | 가장 작은 크기
xs | Size(74, 74) | 작은 크기
sm | Size(90, 90) | 작은-중간 크기
md | Size(106, 106) | 중간 크기
lg | Size(140, 140) | 큰 크기
xl | Size(179, 250) | 가로형 직사각형
xxl | Size(200, 200) | 가장 큰 정사각형

e.g. enum
``` dart
enum WdsThumbnailSize {
  xxs(size: Size(64, 64)),
  xs(size: Size(74, 74)),
  sm(size: Size(90, 90)),
  md(size: Size(106, 106)),
  lg(size: Size(140, 140)),
  xl(size: Size(179, 250)),
  xxl(size: Size(200, 200));

  const WdsThumbnailSize({
    required this.size,
  });

  final Size size;
}
```

### Thumbnail - radius

모서리 둥글기 설정입니다.

속성 | 값 | 비고
--- | --- | ---
true | `BorderRadius.all(Radius.circular(WdsRadius.xs))` | 둥근 모서리 적용
false | `null` | 직각 모서리

### Thumbnail - 네트워크 이미지 처리

네트워크 이미지는 `cached_network_image` 패키지를 사용하여 캐싱됩니다.

- **원본 URL**: 입력된 URL을 그대로 사용
- **에러 처리**: 로딩 실패 시 고정 placeholder 표시

### Thumbnail - placeholder

이미지 로딩 중에 표시되는 고정 위젯입니다.

속성 | 값 | 비고
--- | --- | ---
placeholder | `WdsColors.coolNeutral100` 배경의 회색 사각형 | 고정, 변경 불가

### Thumbnail - 생성 방법

단일 생성자로 네트워크/에셋 이미지를 모두 처리합니다.

``` dart
// 네트워크 이미지 (자동 감지)
WdsThumbnail(
  imagePath: 'https://example.com/image.jpg',
  size: WdsThumbnailSize.md,
  hasRadius: true,
)

// 에셋 이미지 (자동 감지)
WdsThumbnail(
  imagePath: 'assets/images/thumbnail.png',
  size: WdsThumbnailSize.lg,
  hasRadius: false,
)
```

### Thumbnail - 에러 처리

이미지 로딩 실패 시 처리 방식입니다.

- **네트워크 이미지**: 로딩 실패 시 고정 placeholder 표시
- **에셋 이미지**: 에셋 로딩 실패 시 고정 placeholder 표시
- **모든 경우**: 에러 발생 시 기본 placeholder (회색 배경) 표시

### Thumbnail - 성능 최적화

- **캐싱**: `cached_network_image`를 통한 자동 캐싱
- **메모리 관리**: 이미지 크기에 따른 적절한 해상도 선택
- **로딩 상태**: placeholder를 통한 부드러운 로딩 경험
- **const 최적화**: 가능한 모든 위젯에 `const` 키워드 적용

## Tag

상품의 상태, 배송 일정, 카테고리 등 짧고 핵심적인 정보를 시각적으로 강조하기 위해 사용됩니다.


**공통요소**
- padding: horizontal 4px
- borderRadius: `WdsRadius.xs` (4px)
- typography: `WdsTypography.caption10Medium
- height: 18px, 고정 높이

### Tag - variant

- normal
- filled

아래는 기본값

**normal**
- color: `WdsColors.textNeutral`
- backgroundColor: `WdsColors.neutral50`

**filled**
- color: `WdsColors.white`
- backgroundColor: `WdsColors.primary`

다만 색상이 바뀔 수 있습니다.

## ItemCard

> 상품 정보를 집약적으로 전달하는 카드 컴포넌트입니다. 상품의 썸네일, 브랜드명, 상품명, 가격, 평점, 좋아요 등의 정보를 포함하여 상세 페이지로 유도하는 목적을 가집니다.

ItemCard는 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
onLiked | `VoidCallback` | 좋아요 버튼이 눌렸을 때 콜백
thumbnailImageUrl | `String` | 썸네일 이미지 URL
brandName | `String` | 브랜드명 (xs 크기에서는 표시되지 않음)
productName | `String` | 상품명
lensType | `String` | 렌즈 유형
diameter | `String` | 직경
originalPrice | `double` | 정가
salePrice | `double` | 판매가
rating | `double` | 평점 (0.0 ~ 5.0)
reviewCount | `int` | 리뷰 개수
likeCount | `int` | 좋아요 개수
hasLiked | `bool` | 좋아요 상태 (기본값: false)
tags | `List<WdsTag>` | 태그 목록 (기본값: 빈 리스트)

### ItemCard - size

px 단위로 이루어집니다. 크기에 따라 레이아웃이 세로형(xl, lg)과 가로형(md, xs)으로 구분됩니다.

속성 | layout | thumbnail size | 비고
--- | --- | --- | ---
xl | 세로형 | WdsThumbnailSize.xl | 가장 큰 크기, 세로 배치
lg | 세로형 | WdsThumbnailSize.lg | 큰 크기, 세로 배치
md | 가로형 | WdsThumbnailSize.md | 중간 크기, 가로 배치
xs | 가로형 | WdsThumbnailSize.xs | 가장 작은 크기, 가로 배치

e.g. enum
``` dart
enum WdsItemCardSize {
  xl,
  lg,
  md,
  xs;
}
```

### ItemCard - layout

크기에 따라 두 가지 레이아웃으로 구분됩니다.

**세로형 레이아웃 (xl, lg)**
- 썸네일이 상단에 위치
- 상품 정보가 썸네일 하단에 세로로 배치
- 브랜드명, 상품명, 렌즈 정보, 가격, 태그, 평점/좋아요 정보 순서로 배치

**가로형 레이아웃 (md, xs)**
- 썸네일이 좌측에 위치
- 상품 정보가 썸네일 우측에 세로로 배치
- md: 브랜드명 포함, xs: 브랜드명 제외

### ItemCard - thumbnail

각 크기별로 적절한 썸네일 크기를 사용합니다.

속성 | thumbnail size | hasRadius | 비고
--- | --- | --- | ---
xl | WdsThumbnailSize.xl | false | 둥근 모서리 없음
lg | WdsThumbnailSize.lg | true | 둥근 모서리 적용
md | WdsThumbnailSize.md | true | 둥근 모서리 적용
xs | WdsThumbnailSize.xs | true | 둥근 모서리 적용

### ItemCard - typography

크기별로 다른 타이포그래피를 사용합니다.

**브랜드명**
- xl/lg: `WdsTypography.body13NormalRegular`, `WdsColors.textNeutral`
- md: `WdsTypography.caption12Regular`, `WdsColors.textNeutral`
- xs: 표시되지 않음

**상품명**
- xl: `WdsTypography.body13NormalRegular`, `WdsColors.textNormal`, 최대 2줄
- lg: `WdsTypography.body13NormalRegular`, `WdsColors.textNormal`, 최대 1줄
- md: `WdsTypography.body13NormalRegular`, `WdsColors.textNormal`, 최대 1줄
- xs: `WdsTypography.caption12Medium`, `WdsColors.textNormal`, 최대 1줄

**렌즈 정보**
- xl/lg/md: `WdsTypography.caption12Regular`, `WdsColors.textAlternative`
- xs: `WdsTypography.caption11Regular`, `WdsColors.textAlternative`

**가격 정보**
- xl/lg: `WdsTypography.body15NormalBold`, `WdsColors.textNormal`
- md: `WdsTypography.body13NormalBold`, `WdsColors.textNormal`
- xs: `WdsTypography.caption12Bold`, `WdsColors.textNormal`

### ItemCard - price display

할인이 있는 경우와 없는 경우로 구분하여 표시합니다.

**할인 없는 경우**
- 판매가만 표시

**할인이 있는 경우**
- xl: 정가(취소선) + 할인율 + 판매가를 세로로 배치
- lg/md/xs: 할인율 + 판매가를 가로로 배치

할인율은 `WdsColors.secondary` 색상으로 강조 표시됩니다.

### ItemCard - tags

상품에 관련된 태그들을 표시합니다.

속성 | 값 | 비고
--- | --- | ---
spacing | 2px | 태그 간 간격
maxCount | 제한 없음 | 권장: 2개 이하
position | 가격 정보 하단 | 세로형 레이아웃에서만 표시

### ItemCard - rating & like info

평점과 좋아요 정보를 표시합니다.

**평점 정보**
- 아이콘: `WdsIcon.starFilled` (10x10px, `WdsColors.neutral200`)
- 텍스트: `"평점(리뷰수)"` 형식
- typography: `WdsTypography.caption11Regular`, `WdsColors.textAssistive`

**좋아요 정보**
- 아이콘: `WdsNavigationIcon.like` (10x10px, `WdsColors.neutral200`)
- 텍스트: 좋아요 개수
- typography: `WdsTypography.caption11Regular`, `WdsColors.textAssistive`

### ItemCard - like button

좋아요 버튼의 위치와 형태가 크기에 따라 다릅니다.

속성 | xl/lg | md | xs
--- | --- | --- | ---
position | 우측 상단 | 우측 하단 | 우측 하단
layout | 아이콘만 | 아이콘만 | 아이콘 + 개수 (세로 배치)
size | 18x18px | 18x18px | 18x18px
color (active) | `WdsColors.secondary` | `WdsColors.secondary` | `WdsColors.secondary`
color (inactive) | `WdsColors.neutral200` | `WdsColors.neutral200` | `WdsColors.neutral200`

### ItemCard - spacing

크기별로 다른 간격을 사용합니다.

속성 | xl | lg | md | xs
--- | --- | --- | --- | ---
thumbnail-content | 10px | 10px | 16px | 12px
element spacing | 4px | 4px | 4px | 2px
horizontal padding | 12px | 0px | 0px | 0px

### ItemCard - 생성 방법

named constructor로 생성할 수 있습니다.

``` dart
// 세로형 레이아웃 (xl)
WdsItemCard.xl(
  onLiked: () => print('좋아요'),
  thumbnailImageUrl: 'https://example.com/image.jpg',
  brandName: '브랜드명',
  productName: '상품명',
  lensType: '렌즈유형',
  diameter: '직경',
  originalPrice: 100000,
  salePrice: 80000,
  rating: 4.5,
  reviewCount: 123,
  likeCount: 45,
  hasLiked: false,
  tags: [WdsTag.normal('태그1'), WdsTag.filled('태그2')],
)

// 가로형 레이아웃 (xs)
WdsItemCard.xs(
  onLiked: () => print('좋아요'),
  thumbnailImageUrl: 'https://example.com/image.jpg',
  productName: '상품명',
  lensType: '렌즈유형',
  diameter: '직경',
  originalPrice: 100000,
  salePrice: 80000,
  rating: 4.5,
  reviewCount: 123,
  likeCount: 45,
  hasLiked: false,
  tags: [WdsTag.normal('태그')],
)
```

### ItemCard - state management

좋아요 상태는 `StatefulWidget`으로 관리되며, `hasLiked` 값이 변경될 때 자동으로 UI가 업데이트됩니다.

``` dart
class _WdsItemCardState extends State<WdsItemCard> {
  @override
  void didUpdateWidget(covariant WdsItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.hasLiked != widget.hasLiked) {
      setState(() {});
    }
  }
}
```

## Heading

헤딩(Heading)은 페이지 및 템플릿의 역할 및 기능을 나타내는 컴포넌트입니다. 텍스트와 관련 엘리먼트가 결합한 컴포넌트로 정보 계층 구조에 따라 사용을 유의합니다.

### Heading - 공통

- 부모 widget으로부터 size를 받아서 렌더링
  - 가로 너비만큼 stretch되는 성격을 가짐
- 크게 2가지 영역으로 나뉨
  - '타이틀', '더보기' (옵션)
    - '더보기' 버튼을 넣을 지 여부를 결정하는 요소가 필요합니다. 
  - '더보기'는 `WdsTextButton`이 위치
  - '타이틀'과 '더보기'는 gap: 16px
  - '타이틀'이 Expanded 영역
  - '타이틀'은 `Padding(padding: EdgeInsets.symmetric(vertical: 2))` 를 부모 위젯으로 갖습니다.
- padding: `EdgeInsets.symmetric(horizontal: 16, vertical: 4)`

### Heading - size

- lg
- md

lg일 때는 `WdsTextButtonVariant.text`와 `WdsTextButtonSize.small` 이 쓰입니다. 그리고 타이틀은 최대 2줄까지 작성 가능해요. `Row`로 감싸게되면 `CrossAxisAlignment.start`로 상단(top)에 맞춰서 정렬합니다.

md일 때는 `WdsTextButtonVariant.icon`과 `WdsTextBittonSize.small`이 쓰입니다.

## Loading

로딩 컴포넌트는 사용자가 처리 진행 상태를 인지할 수 있도록 안내하는 시각적 피드백 요소입니다.
로드 시간이 짧은 일반적인 상황에서 사용합니다.

### Loading - 공통

- 3개의 원형(dot)이 파동(wave) 형태로 확장/축소되는 애니메이션을 표현
  - duration: 1500ms로 repeat() 로 무한 재생
  - 각 dot에 Transform.scale 로 크기를 변경하며 wave 애니메이션 효과를 추가
  - wave는 sin 곡선을 기반으로, index마다 phase shift를 적용해 시간차 애니메이션이 발생
- Row로 구성되며, 각 dot 간격은 spacing 값으로 제어
- dot은 BoxDecoration(shape: BoxShape.circle)로 표현
- repaint 최소화를 위해 RepaintBoundary를 사용

### Loading - color 

- normal
- white

**normal**
- backgroundColor: `WdsColors.primary`

**white**
- backgroundColor: `WdsColors.white`

### Loading - size

- small
- medium

**small**
- spacing: `WdsSpacing.md2`
- size: 8

**medium**
- spacing: `WdsSpacing.md5`
- backgroundColor: 18
