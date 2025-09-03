# WDS 컴포넌트 생성 가이드

WDS 문서(`wds_component_guide.md`)를 바탕으로 컴포넌트를 클래스화하는 전략과 완료 점검 체크리스트를 정리했습니다. Button, SquareButton, TextButton을 구현하며 사용한 공통 패턴을 일반화했습니다.

## 역할

- 디자인 스펙을 일관된 코드로 변환하여 재사용성과 유지보수성을 높입니다.
- 구현 시 `package:flutter/widgets.dart`만 사용하고 `material`은 사용하지 않는 규칙을 준수합니다.
- 색상/타이포/반경/패딩 등 모든 시각 속성은 `wds_foundation`을 통해서만 참조하도록 강제합니다.
- hover/pressed/disabled 등 상호작용/상태 처리 방식을 표준화합니다.
- 리뷰·테스트·위젯북 커버리지를 위한 체크리스트를 제공합니다.
- 자동 생성·수정 작업의 기준 문서로 사용됩니다.

## 설계 전략 (Spec → Class)

- 스펙 파싱: 고정/가변 속성, state, variant, size, 색상·타이포 토큰을 표로 재구성
- 역할 분리:
  - 크기/패딩/타이포 매핑 → private helper: `_HeightBySize`, `_PaddingBySize`, `_TypographyBySize`
  - variant 스타일 매핑 → `_StyleByVariant.of(variant)`에서 `{background, foreground, radius, border}` 반환
- 텍스트 강제 스타일링: `child is Text`면 스펙 타이포로 강제 적용, 그 외엔 `DefaultTextStyle.merge`. 이 방식은 foreground color 조정 방법으로도 사용
- 합성 규칙(Composition): `DecoratedBox/ColoredBox + Padding + SizedBox` 조합으로 layout/decoration 구성. `Container` 대신 용도별 전용 위젯 사용
- 성능 최적화: 클래스 컴포넌트를 사용하고 `const` 캐싱 전략 적용. 복잡하고 중첩된 Widget Tree 대신 단순한 구조 선호
- 상태 처리:
  - enabled/disabled: disabled 시 스펙에 맞게 `WdsOpacity.opacity40.toAlpha()` 혹은 색상으로 표현
  ~~~ dart
  color: WdsColors.cta.withAlpha(WdsOpacity.opacity40.toAlpha())
  ~~~
  - pressed/hover: 웹은 `MouseRegion`, 공통은 `TweenAnimationBuilder<Color?>`로 overlay 애니메이션
- 접근성/제약: 텍스트 `maxLines: 1`, 적절한 대비(텍스트 색) 유지
- Foundation 의존성: 색상/반경/타이포/패딩은 반드시 `wds_foundation` 참조(하드코딩 회피). `wds_tokens` 직접 사용 금지
- 아이콘 처리: SVG 파일용 `SvgPicture` 사용 시 `IconTheme`이 적용되지 않으므로 색상은 직접 지정
- Import 규칙: 컴포넌트 구현 시 `package:flutter/widgets.dart`를 사용하고, `material`은 사용하지 않습니다.

## 구현 플로우

1) 파일 배치: `packages/components/lib/src/[category]/[component].dart` 생성, `wds_components.dart`에 `part` 추가

2) 스펙 모델링: enum(variant/size/state), helper(크기/패딩/타이포/스타일) 정의

3) 상호작용: `_handleTapDown/Up/Cancel`, `_overlayTargetColor` 구현, overlay 애니메이션 구성 (`MouseRegion` 포함)

4) 레이아웃: `DecoratedBox/ColoredBox + Padding + SizedBox` 단순 구조로 구성, 웹 hover 연결. Widget Tree 중첩 최소화

5) 텍스트 처리: Text 자식 강제 타이포, 그 외 `DefaultTextStyle.merge`. 색상 조정도 이 방식 활용

6) 상태 표현: disabled/pressed/hover 스펙 일치 확인

7) API 확정: required/optional 파라미터와 기본값 정리 (`onTap`, `child`, `isEnabled`, 등)

8) 성능 최적화: 모든 위젯에 `const` 생성자 적용, 클래스 컴포넌트로 helper 메서드보다 나은 성능 확보

## 성능 및 구조 최적화 가이드

- 클래스 컴포넌트 활용: helper 메서드 대신 클래스 컴포넌트로 구현하여 `const` 캐싱 전략 활용
- Widget Tree 단순화: `Container` 대신 `DecoratedBox`, `ColoredBox`, `Padding`, `SizedBox` 등 용도별 전용 위젯 사용
- `const` 최대 활용: 모든 생성자와 위젯에서 가능한 한 `const` 키워드 사용
- Foundation 패키지 의존성: `wds_foundation`의 `WdsColors`, `WdsTypography`, `WdsRadius`, `WdsSpacing` 등만 사용
- 아이콘 색상 처리: `SvgPicture` 사용 시 `IconTheme` 미적용되므로 색상 직접 지정 필요

## 새 컴포넌트가 추가될 때 문서→코드 일반화 절차

1. 문서 스펙 추출
   - 목적/사용 맥락, 필수/옵션 파라미터, 상태(state), variant, size, 고정/가변 속성 분리
   - 색상/타이포/반경/패딩/보더/아이콘 등 토큰 매핑표 작성
   - 상호작용(hover/pressed/focus/disabled)과 접근성 요건 파악

2. API 설계
   - 생성자 시그니처(필수/선택/기본값), 열거형 정의, 내부 helper로 캡슐화 범위 확정

3. 레이아웃/데코 합성
   - `ClipRRect + DecoratedBox + Padding + SizedBox + Stack`로 뼈대 구성
   - 텍스트 강제 타이포, `IconTheme`로 아이콘 색 동기화

4. 상호작용 구현
   - `_handleTapDown/Up/Cancel`, `MouseRegion`(웹), `TweenAnimationBuilder<Color?>` overlay
   - disabled 표현 스펙 일치 확인

5. Foundation 연결 검증
   - 모든 시각 속성이 `wds_foundation`으로부터만 유입되는지 확인(하드코딩 제거)
   - `wds_tokens` 직접 참조 금지, `wds_foundation` 통해서만 접근

6. 위젯북 커버리지
   - playground knob: 핵심 파라미터만 제공, info에 현재 설정값 표시
   - demonstration: variant/size/state 대표 사례 정렬·간격 일관성 유지

7. 품질 점검
   - 린트/빌드 그린, 인터랙션 시각 확인, 텍스트 줄수·오버플로 제약, 다크/라이트 테마 확인

## 최종 체크리스트

- [ ] `wds_components.dart`에 `part` 추가됨
- [ ] variant/size/state 스펙이 enum·helper로 모두 반영됨
- [ ] 배경/보더/라운드/패딩/타이포가 문서 값과 일치함
- [ ] Text 자식 강제 타이포, 비-Text엔 `DefaultTextStyle.merge` 적용됨
- [ ] hover/pressed overlay 애니메이션 동작(웹 `MouseRegion` 포함)
- [ ] disabled 표현이 문서 기준과 일치함
- [ ] 모든 시각 속성이 `wds_foundation`으로부터 참조됨(`wds_tokens` 직접 사용 및 하드코딩 없음)
- [ ] 성능 최적화: `const` 생성자 적용 및 단순한 Widget Tree 구조 확인
- [ ] SVG 아이콘의 색상이 직접 지정됨(`IconTheme` 미적용 고려)
- [ ] 위젯북 use case에서 정상 렌더링/상호작용 확인
- [ ] 린트/빌드 에러 없음