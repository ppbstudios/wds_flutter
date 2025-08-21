# 역할

이 봇의 역할은 디자인 시스템을 생성하고 원칙들에 따라 시스템을 유지보수합니다.
아래 정보를 참고하여, 디자인 토큰이 주어졌을 때 관련 코드를 생성하고 클래스화해서 컴포넌트까지 적용할 수 있도록 만들어 주세요.


# 개요

윙크(WINC)란 서비스의 디자인 시스템 (WDS, WINC Design System)을 만들고 라이브러리화 하기 위한 프로젝트입니다.

현재 윙크 서비스는 디자인 시스템 없이 많은 컴포넌트가 파편화되어있는 상태이고, 이를 하나의 관리요소로 모아줄 필요가 있고 유저들에게 일관된 UI를 제공해야 합니다.

디자인 시스템을 활용할 때 모두 design token으로 관리합니다.

# 목표

- 디자인 토큰 자동화: JSON 형식으로 정의된 디자인 토큰을 Dart 코드로 자동 생성하여 Flutter 프로젝트에서 타입-세이프(Type-safe)하게 사용할 수 있는 시스템을 구축한다.

- 자동화 도구:
Dart의 build_runner와 source_gen 라이브러리를 활용하여 코드 생성 프로세스를 자동화한다.

- 독립성 및 버전 관리:
생성된 토큰(wds_tokens)은 기존 소스 코드와 독립적으로 관리되어야 하며, 버전 관리가 가능해야 한다.

- 외부 연동:
생성된 토큰은 최종적으로 Widgetbook과 연동될 수 있어야 한다.

## Design Token 관리하는 법

### Primitive Token 정의

Color, Spacing, Opacity, FontWeight 등 원초적인 값들을 먼저 정의합니다.

e.g. pink/400
~~~
Primitive token - Value
pink/400 - #F55DAF
~~~

- DO NOT 정의된 Primitive Token을 곧바로 Component에 적용하지 않습니다.
- DO 오직 Semantic token 혹은 Component-specific token과 연결해서 사용합니다.


### Semantic/Component-specific Token

Primitive Token에 정의된 값들을 어떻게 사용할 지 정의합니다. 예를 들어 "버튼이 눌릴 때 색상을 정의"할 때는 토큰을 아래 처럼 정의합니다. 
~~~
button-primary-pressed
~~~
Semantic 과 Component-specific 은 같은 레벨(hierarchy)이며,
~~~
Value - Primitivie - (Semantic) - (Component-specific) - Component
~~~
순으로 

- "Value - Primitive - Semantic - Component"
- "Value - Primitive - Component-specific - Component"

이렇게 정의될 수 있습니다.

# Design System 생성 및 관리 전략

윙크(WINC)는 Flutter 기반으로 만들어진 서비스로 모든 컴포넌트를 생성해 내기에는 시간과 공수가 많이 들어 Material Design을 활용하기로 했습니다.

``` yaml
uses-material-design: true
``` 

Material Design의 요소들을 재정의(override)하고 별도로 추가가 필요한 컴포넌트들 제작하기로 했습니다.

## 프로젝트 구조

```
/wds
├── packages/
│   ├── tokens/                     # [Package] tokens (generated)
│   │   ├── atomic/                 # Primitive tokens
│   │   ├── semantic/               # Semantic tokens
│   │   └── component_specific/     # Component-specifc tokens
│   ├── foundation/                 # [Package] foundation
│   ├── components/                 # [Package] components
│   ├── widgetbook/                 # [Package] widgetbook
├── tools/
│   └── token_generator/            # [Package] JSON to Dart generator
├── wds_atomic_color.json           # Primitive color styles
```


### 패키지 제작 및 우선순위 

1. token_generator
2. tokens
3. foundation
4. components
5. widgetbooks

---

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
  - `lib/atomic/wds_atomic_colors.g.dart` 등
- `packages/widgetbooks`는 Flutter 패키지이며 `widgetbook` 의존성을 사용합니다.


## 위젯북 패키지

- `packages/widgetbooks`에서 위젯북 추가
  - `flutter pub add widgetbook`
  - 또는 `pubspec.yaml`에 `widgetbook` 의존성 추가 후 `melos bootstrap`


---

Written by [seunghwanly](https://github.com/seunghwanly)