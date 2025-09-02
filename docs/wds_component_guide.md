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

Button 과는 속성이 다소 다른 버튼으로 배경색이나 테두리가 없는 버튼으로 텍스트로만 구성됩니다. 주로 강조가 덜한 보조적인 액션에 사용합니다.

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

화면 하단에 위치한 내비게이션입니다. 각 탭 별로 icon과 label이 하나의 쌍(pair)를 이룹니다. 고정 padding으로 `EdgeInsets.symmetric(vertical: 1)`를 가집니다.

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

콘텐츠를 검색할 때 사용합니다.

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

길지 않은 텍스트를 입력할 때 사용합니다.

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

좌측 상단에 제목(title)이 있을 수도, 없을 수도 있습니다.

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

문자 기반 탭으로 가로 스크롤이 가능합니다.

### TextTabs - state
상태 | color | typography | 비고
--- | --- | --- | ---
enabled | `WdsColors.textAlternative` | `WdsTypography.body15NormalMedium` |
focused | `WdsColors.textNormal` | `WdsTypography.body15NormalBold` |
featured | 디자인 의도 색상 | `WdsTypography.body15NormalBold` | 강조 필요 시

### TextTabs - spacing & scroll
항목 | 값 | 비고
--- | --- | ---
좌측 시작 padding | 16px |
탭 간 간격 | 24px |
스크롤 끝 padding | 오른쪽으로 더 스크롤 가능할 때 없음 | 끝까지 스크롤 시 16px
상하 padding | 8px |

### LineTabs

선택된 탭에 underline이 표시됩니다. 탭 별 너비는 사용 가능한 최대 너비를 탭 수(2 또는 3)로 균등 분할합니다.

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

## ActionArea
화면 하단에서 주요 액션(결제, 다음 단계 등)을 안정적으로 수행하게 하는 영역입니다.

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

설정의 on/off를 토글하는 컴포넌트입니다. 값 변화 시 애니메이션으로 전환됩니다.

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

사용자가 여러 항목 중에서 하나 또는 여러 개를 선택할 수 있도록 돕습니다. 값(true/false)과 활성화 여부(isEnabled)로 표현이 달라집니다.

### Checkbox - size

속성 | spec | padding | 비고
--- | --- | --- | ---
large | 24x24 | `EdgeInsets.all(3)` | 기본
small | 20x20 | `EdgeInsets.all(2)` | 컴팩트

e.g. enum
``` dart
enum WdsCheckboxSize {
  small(spec: Size(20, 20), padding: EdgeInsets.all(2)),
  large(spec: Size(24, 24), padding: EdgeInsets.all(3));

  const WdsCheckboxSize({
    required this.spec,
    required this.padding,
  });

  final Size spec;
  final EdgeInsets padding;
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
- `false`: `border = BorderSide(color: WdsColors.borderNeutral)`
- `borderRadius`: `WdsRadius.xs` (size와 무관하게 동일)

### Checkbox - check mark

- 체크 마크는 `value == true`일 때만 노출됩니다.
- 그려지는 방향은 왼쪽에서 오른쪽으로 진행합니다.
- 기준 좌표계(large, 24x24 기준): 패딩 3px을 제외한 내부 20x20 영역을 (0,0)~(20,20)으로 사용합니다.
  - left-top-check-mark: (3,8), (2,9), (3,9)
  - middle-bottom-check-mark: (6,13), (7,13)
  - top-right-check-mark: (14,4), (14,5), (15,5), (13,4)
- small(20x20, padding 2) 사이즈는 동일한 형태를 비율에 맞게 축소하여 렌더링합니다.

### Checkbox - animation

- 배경 채움은 중심에서 가장자리로 퍼지도록 채웁니다.
- 색상 채움은 `CustomPaint`로 구현합니다.
- 애니메이션은 `Duration(milliseconds: 300)` + `Curves.easeIn`을 사용합니다.
- 체크 마크 경로는 왼쪽에서 오른쪽으로 그리며 진행도에 따라 부분 경로를 렌더링합니다.


## Radio

사용자가 여러 옵션 중에서 하나만 선택할 수 있도록 돕습니다. Checkbox와 달리 그룹 내에서 오직 하나의 항목만 선택 가능하며, `groupValue`와 개별 `value`를 비교하여 선택 여부를 판단합니다.

Radio는 아래 속성으로 이루어집니다.

속성 | Type | 비고
--- | --- | --- 
value | `T` | 해당 Radio가 갖는 고유 값
groupValue | `T?` | 현재 선택된 그룹 값 
onChanged | `ValueChanged<T?>?` | 선택 시 호출되는 콜백
isEnabled | `bool` | Radio 활성화 여부 (`false` 시 'disabled' 상태)

### Radio - size

속성 | spec | padding | inner circle | 비고
--- | --- | --- | --- | ---
small | 20x20 | `EdgeInsets.all(1.67)` | 6.67px | 컴팩트
large | 24x24 | `EdgeInsets.all(2)` | 10px | 기본

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

화면에 잠시 나타났다 사라지는 짧은 알림 메시지로, 사용자가 수행한 작업에 대한 피드백을 제공합니다.

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

사용자가 수행한 작업에 대한 피드백을 제공합니다. Toast와 달리 추가적인 조치를 취할 수 있는 버튼이 포함되어 있습니다.

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

설명적 내용이 필요한 경우에 사용합니다.

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
  
