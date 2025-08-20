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
│   ├── tokens/                     # [Package] tokens
│   │   ├── atomic/                 # Primitive tokens + generated
│   │   ├── semantic/               # Semantic tokens + generated
│   │   └── component_specific/     # Component-specifc tokens + generated
│   ├── foundation/                 # [Package] foundation
│   │   ├── wds_typography.dart     # Composite of tokens
│   │   ├── wds_theme.dart          # Overriden Material ThemeData
│   ├── components/                 # [Package] components
│   ├── widgetbook/                # [Package] widgetbook
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

# package: token_generator

주어진 JSON을 파싱하는 패키지

e.g. JSON 예시

``` JSON
{
    "color": {
      "Blue": {
        "50": {
          "$type": "color",
          "$value": "#e6ebfd"
        },
        "100": {
          "$type": "color",
          "$value": "#cdd8ff"
        },
        "200": {
          "$type": "color",
          "$value": "#a3b6ff"
        },
        "300": {
          "$type": "color",
          "$value": "#819bff"
        },
        "400": {
          "$type": "color",
          "$value": "#5b7bf3"
        },
        "500": {
          "$type": "color",
          "$value": "#325af0"
        },
        "600": {
          "$type": "color",
          "$value": "#254cdf"
        },
        "700": {
          "$type": "color",
          "$value": "#1c3ec0"
        },
        "800": {
          "$type": "color",
          "$value": "#0a2ba9"
        },
        "900": {
          "$type": "color",
          "$value": "#092178"
        }
      },
    }
}
```

- `$type`에 따라서 `$value`에 어떤 타입을 사용할 건 지 미리 알 수 있습니다.
- 사용할 수 있는 타입 정보는 아래 #Token_Value_Types 확인합니다.
- Styles는 enum으로 구성할 수 있으나 Primitive한 속성들은 클래스로 구현 지향합니다.

# Token Value Types

| Common Name            | W3C DTCG Official | Composite/Property 설명                                   | TS JSON Type                        | SD Type      | DTCG Type    |
|------------------------|-------------------|----------------------------------------------------------|-------------------------------------|--------------|--------------|
| Color Token            | ✓                 | border, shadow의 Property 가능                           | color                               | color        | color        |
| Typography Token       | ✓                 | Composite                                                | typography                          | typography   | typography   |
| Font Family Token      | ✓                 | typography의 Property                                    | fontFamilies, fontFamily            | fontFamily   | fontFamily   |
| Font Weight Token      | ✓                 | typography의 Property                                    | fontWeights, fontWeight             | fontWeight   | fontWeight   |
| Font Size Token        | ✓                 | typography의 Property                                    | fontSizes, fontSize                 | fontSize     | fontSize     |
| Line Height Token      | ✓                 | typography의 Property                                    | lineHeights, lineHeight             | lineHeight   | NA           |
| Letter Spacing Token   | ✓                 | typography의 Property                                    | letterSpacing                       | dimension    | dimension    |
| Paragraph Spacing Token| X                 | typography의 Property (TS에만, DTCG에는 없음)             | paragraphSpacing                    | dimension    | dimension    |
| Text Case Token        | X                 | typography의 Property (TS에만, DTCG에는 없음)             | textCase                            | textCase     | NA           |
| Text Decoration Token  | X                 | typography의 Property (TS에만, DTCG에는 없음)             | textDecoration                      | textDecoration| NA           |
| Dimension Token        | ✓                 | border, shadow, typography의 Property 가능                | dimension                           | dimension    | dimension    |
| Number Token           | ✓                 |                                                          | number                              | number       | number       |
| Border Token           | ✓                 | Composite                                                | border                              | border       | border       |
| Box Shadow Token       | ✓                 | Composite                                                | boxShadow                           | shadow       | shadow       |
| Border Radius Token    | X                 |                                                          | borderRadius                        | dimension    | dimension    |
| Border Width Token     | X                 |                                                          | borderWidth                         | dimension    | dimension    |
| Spacing Token          | X                 |                                                          | spacing                             | dimension    | dimension    |
| Sizing Token           | X                 |                                                          | sizing                              | dimension    | dimension    |
| Asset Token            | X                 |                                                          | asset                               | asset        | NA           |
| Boolean Token          | X                 |                                                          | boolean                             | boolean      | NA           |
| Text Token             | X                 |                                                          | text                                | content      | NA           |
| Other Token            | X                 |                                                          | other                               | other        | NA           |
| Opacity Token          | X                 |                                                          | opacity                             | opacity      | NA           |
| Composition Token      | X                 | composition 내 각 타입이 개별적으로 추가됨                | composition                         | (각 타입별)  | NA           |


- DTCG Type으로 주어지니 Token 별 Type을 미리 선점할 수 있습니다.
- 아래 #JSON_예시 를 보고 미리 클래스를 어떻게 구성할 지 계획할 수 있습니다.


## JSON 예시

``` JSON
{
  "colors": {
    "$type": "color",
    "black": {
      "$value": "#000000"
    },
    "white": {
      "$value": "#ffffff"
    },
    "orange": {
      "100": {
        "$value": "#fffaf0"
      },
      "200": {
        "$value": "#feebc8"
      },
      "300": {
        "$value": "#fbd38d"
      },
      "400": {
        "$value": "#f6ad55"
      },
      "500": {
        "$value": "#ed8936"
      },
      "600": {
        "$value": "#dd6b20"
      },
      "700": {
        "$value": "#c05621"
      },
      "800": {
        "$value": "#9c4221"
      },
      "900": {
        "$value": "#7b341e"
      }
    }
  },
  "dimensions": {
    "0": {
      "$value": "0px"
    },
    "1": {
      "$value": "4px"
    },
    "2": {
      "$value": "8px"
    },
    "3": {
      "$value": "12px"
    },
    "4": {
      "$value": "16px"
    },
    "5": {
      "$value": "20px"
    },
    "6": {
      "$value": "24px"
    },
    "7": {
      "$value": "28px"
    },
    "8": {
      "$value": "32px"
    },
    "9": {
      "$value": "36px"
    },
    "10": {
      "$value": "40px"
    },
    "11": {
      "$value": "44px"
    },
    "12": {
      "$value": "48px"
    },
    "13": {
      "$value": "52px"
    },
    "14": {
      "$value": "56px"
    },
    "15": {
      "$value": "60px"
    },
    "$type": "dimension",
    "max": {
      "$value": "9999px"
    }
  },
  "text": {
    "fonts": {
      "$type": "fontFamily",
      "serif": {
        "$value": "Times New Roman, serif"
      },
      "sans": {
        "$value": "Open Sans, sans-serif"
      }
    },
    "weights": {
      "$type": "fontWeight",
      "light": {
        "$value": "thin"
      },
      "regular": {
        "$value": "regular"
      },
      "bold": {
        "$value": "extra-bold"
      }
    },
    "lineHeights": {
      "$type": "number",
      "normal": {
        "$value": 1.2
      },
      "large": {
        "$value": 1.8
      }
    },
    "typography": {
      "$type": "typography",
      "heading": {
        "$value": {
          "fontFamily": "{text.fonts.sans}",
          "fontWeight": "{text.weights.bold}",
          "fontSize": "{dimensions.7}",
          "lineHeight": "{text.lineHeights.large}"
        }
      },
      "body": {
        "$value": {
          "fontFamily": "{text.fonts.serif}",
          "fontWeight": "{text.weights.regular}",
          "fontSize": "{dimensions.4}",
          "lineHeight": "{text.lineHeights.normal}"
        }
      }
    }
  },
  "transitions": {
    "$type": "transition",
    "emphasis": {
      "$value": {
        "duration": "{transitions.durations.medium}",
        "delay": "{transitions.durations.instant}",
        "timingFunction": "{transitions.easingFunctions.accelerate}"
      }
    },
    "fade": {
      "$value": {
        "duration": "{transitions.durations.long}",
        "delay": "{transitions.durations.instant}",
        "timingFunction": "{transitions.easingFunctions.decelerate}"
      }
    },
    "easingFunctions": {
      "$type": "cubicBezier",
      "accelerate": {
        "$value": [
          0.5,
          0,
          1,
          1
        ]
      },
      "decelerate": {
        "$value": [
          0,
          0,
          0.5,
          1
        ]
      }
    },
    "durations": {
      "$type": "duration",
      "instant": {
        "$value": "0ms"
      },
      "short": {
        "$value": "100ms"
      },
      "medium": {
        "$value": "300ms"
      },
      "long": {
        "$value": "600ms"
      }
    }
  },
  "borders": {
    "$type": "border",
    "heavy": {
      "$value": {
        "color": "{colors.black}",
        "width": "{dimensions.1}",
        "style": "{borders.styles.solid}"
      }
    },
    "wireframe": {
      "$value": {
        "color": "{colors.orange.600}",
        "width": "{dimensions.2}",
        "style": "{borders.styles.dashed}"
      }
    },
    "styles": {
      "$type": "strokeStyle",
      "solid": {
        "$value": "solid"
      },
      "dashed": {
        "$value": {
          "dashArray": [
            "0.5rem",
            "0.25rem"
          ],
          "lineCap": "round"
        }
      }
    }
  },
  "shadows": {
    "$type": "shadow",
    "sm": {
      "$value": {
        "color": "{colors.black}",
        "offsetX": "{dimensions.0}",
        "offsetY": "{dimensions.1}",
        "blur": "{dimensions.3}"
      }
    },
    "lg": {
      "$value": {
        "color": "{colors.black}",
        "offsetX": "{dimensions.0}",
        "offsetY": "{dimensions.2}",
        "blur": "{dimensions.4}"
      }
    },
    "multi": {
      "$value": [
        "{shadows.sm}",
        "{shadows.lg}"
      ]
    }
  }
}
```

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

## Token Generator 출력 사양 (업데이트)

- `$type`이 `color`이고 `$value`가 `#RRGGBB` 형식일 때, 생성기는 Flutter `material`의 `Color` 타입 상수를 생성합니다.
  - 예: `Color(0xFFRRGGBB)`
- 숫자 키(예: `50`, `100`)는 유효한 식별자로 변환되어 `s50`, `s100` 형태로 생성됩니다.
- 그룹 클래스는 파스칼 케이스(`Blue`, `Neutral`, `CoolNeutral`)로 생성되며 `WdsAtomicColors`에서 정적 인스턴스로 노출됩니다.

## 위젯북 패키지

- `packages/widgetbooks`에서 위젯북 추가
  - `flutter pub add widgetbook`
  - 또는 `pubspec.yaml`에 `widgetbook` 의존성 추가 후 `melos bootstrap`