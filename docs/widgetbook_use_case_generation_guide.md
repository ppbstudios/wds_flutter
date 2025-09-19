# Widgetbook Use-Case Generation Instructions

Generate comprehensive Widgetbook use cases for Flutter components that showcase different variants and configurations effectively using standardized layout components.

## Standardized Layout Components

### Required Imports

All use cases must import the standardized widgetbook components:

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
```

### Layout Structure

Use `WidgetbookPageLayout` as the root container for all use cases:

```dart
@UseCase(name: 'default', type: ComponentType)
Widget buildComponentNameUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Component Name',
    description: 'Brief description of the component purpose',
    children: [
      // Playground section
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      // Demonstration sections
      _buildDemonstrationSection(context),
      const SizedBox(height: 32),
      // Resource section (optional)
      _buildResourceSection(context),
    ],
  );
}
```

### Playground Section

Use `WidgetbookPlayground` for interactive component testing:

```dart
Widget _buildPlaygroundSection(BuildContext context) {
  // Knob configurations
  final parameter1 = context.knobs.string(label: 'Parameter1', initialValue: 'Default');
  final parameter2 = context.knobs.boolean(label: 'Parameter2', initialValue: true);
  
  return WidgetbookPlayground(
    height: 200, // Optional fixed height
    child: YourComponent(
      parameter1: parameter1,
      parameter2: parameter2,
      onAction: () => debugPrint('Component action triggered'),
    ),
    info: [
      'Parameter1: $parameter1',
      'Parameter2: $parameter2',
    ],
  );
}
```

Note: Provide human-friendly descriptions for each knob in Korean UX writing style only when your project localization policy requires Korean. Otherwise, prefer concise English descriptions.

### Component-specific Strategy (WDS)

- Button: Expose variant (`cta/primary/secondary`) and size (`xlarge/large/medium/small/tiny`) knobs. Use a single-line label for realistic text.
- SquareButton: Show fixed specs (height/padding/typography) in the info panel. Expose only `isEnabled` and label knobs.
- TextButton: Expose variant (`text/underline/icon`), size (`medium/small`), and `isEnabled`. For the icon variant, visually confirm the trailing icon.

### New Component Use Case Recipe (Generic)

Use this recipe whenever a new component is added to the design guide:

1. Identify critical parameters → create knobs for them (text, enabled, variant, size, etc.).
2. Add a Playground with a fixed height and an info panel summarizing the current configuration.
3. Add Demonstration sections covering:
   - Variants (e.g., primary/secondary/tertiary)
   - Sizes (e.g., large/medium/small)
   - States (e.g., enabled/pressed/disabled)
4. Ensure callbacks debugPrint useful debug messages for quick verification.
5. Keep composition consistent using `WidgetbookPageLayout`, `WidgetbookSection`, and `WidgetbookSubsection`.
6. For WDS, ensure typography and colors are derived from tokens (no hard-coded values).

### Demonstration Sections

Use `WidgetbookSection` and `WidgetbookSubsection` for organized demonstrations:

```dart
Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Component Variants',
    children: [
      WidgetbookSubsection(
        title: 'Types',
        labels: ['Primary', 'Secondary', 'Tertiary'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            YourComponent.primary(onPressed: () => debugPrint('Primary')),
            const SizedBox(width: 16),
            YourComponent.secondary(onPressed: () => debugPrint('Secondary')),
            const SizedBox(width: 16),
            YourComponent.tertiary(onPressed: () => debugPrint('Tertiary')),
          ],
        ),
      ),
      const SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'Sizes',
        labels: ['Large', 'Medium', 'Small'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            YourComponent.large(onPressed: () => debugPrint('Large')),
            const SizedBox(width: 16),
            YourComponent.medium(onPressed: () => debugPrint('Medium')),
            const SizedBox(width: 16),
            YourComponent.small(onPressed: () => debugPrint('Small')),
          ],
        ),
      ),
    ],
  );
}
```

### Theme Integration

The widgetbook automatically uses `WidgetbookTheme` which provides:
- Consistent WDS typography styles
- WDS color scheme integration
- Proper Material Design 3 theming
- Both light and dark theme support

## Core Requirements

### UseCase Annotation Structure

Each use case must have a properly configured `@UseCase` annotation:

```dart
@UseCase(
  name: 'variantName',    // Required: Unique identifier for this variant
  type: ComponentType,    // Required: The Flutter widget class being showcased
)
```

**Naming Rules:**

- Single use case: `name: 'default'`
- Multiple use cases: Use descriptive names like `'with_label'`, `'disabled'`, `'loading'`
- Names must be unique within the same component type

### Method Signature Requirements

**Exact signature pattern:**

```dart
Widget build[ComponentName][VariantName]UseCase(BuildContext context) {
  // Implementation
}
```

**Naming conventions:**

- Single use case: `buildProgressIndicatorUseCase`
- Multiple use cases: `buildProgressIndicatorWithLabelUseCase`, `buildProgressIndicatorDisabledUseCase`
- Always return `Widget`
- Always accept exactly one parameter: `BuildContext context`

## Parameter Configuration Strategy

### Priority System

1. **Critical parameters** (required, affects core functionality): Always use knobs
2. **Visual parameters** (colors, sizes, styles): Use knobs when they demonstrate component flexibility
3. **Behavioral parameters** (enabled/disabled, loading states): Use knobs for interactive demonstration
4. **Callback parameters**: Implement with descriptive debugPrint statements
5. **Complex objects**: Hardcode with meaningful defaults, add TODO comments

### Knob Selection Logic

- **Bounded numeric values**: Use sliders (opacity: 0.0-1.0, progress: 0-100)
- **Unbounded numeric values**: Use input fields (dimensions, counts)
- **Enums/predefined options**: Use list knobs
- **Text content**: Use string inputs
- **Feature toggles**: Use boolean checkboxes

## Comprehensive Knobs API

### Basic Types

```dart
// Strings
context.knobs.string(label: 'text', initialValue: 'Hello World')
context.knobs.stringOrNull(label: 'optionalText', initialValue: null)

// Booleans
context.knobs.boolean(label: 'enabled', initialValue: true)
context.knobs.booleanOrNull(label: 'optionalFlag', initialValue: null)

// Integers
context.knobs.int.input(label: 'count', initialValue: 5)
context.knobs.int.slider(label: 'progress', initialValue: 50, min: 0, max: 100, divisions: 10)
context.knobs.intOrNull.input(label: 'optionalCount', initialValue: null)
context.knobs.intOrNull.slider(label: 'progress', initialValue: null, min: 0, max: 100, divisions: 10)

// Doubles
context.knobs.double.input(label: 'value', initialValue: 1.5)
context.knobs.double.slider(label: 'opacity', initialValue: 0.8, min: 0.0, max: 1.0, divisions: 20)
context.knobs.doubleOrNull.input(label: 'value', initialValue: null)
context.knobs.doubleOrNull.slider(label: 'optionalOpacity', initialValue: null, min: 0.0, max: 1.0)
```

### Advanced Types

```dart
// Dropdown lists
context.knobs.object.dropdown<TextAlign>(
  label: 'textAlign',
  initialOption: TextAlign.center,
  options: [TextAlign.left, TextAlign.center, TextAlign.right],
  labelBuilder: (value) => value.name,
)

// Colors
context.knobs.color(label: 'primaryColor', initialValue: Colors.blue)
context.knobs.colorOrNull(label: 'optionalColor', initialValue: null)

// DateTime
context.knobs.dateTime(
  label: 'selectedDate',
  initialValue: DateTime.now(),
  start: DateTime.now().subtract(const Duration(days: 365)),
  end: DateTime.now().add(const Duration(days: 365)),
)

// Duration
context.knobs.duration(label: 'animationDuration', initialValue: const Duration(milliseconds: 300))
```

## Advanced Component Handling

### State Management Integration

For components requiring external state:

```dart
// Example: Component requiring a provider
@UseCase(name: 'with_data', type: DataWidget)
Widget buildDataWidgetWithDataUseCase(BuildContext context) {
  return MockDataProvider(
    data: _generateMockData(),
    child: DataWidget(
      onItemSelected: (item) => debugPrint('Selected item: ${item.id}'),
      showLoading: context.knobs.boolean(label: 'showLoading', initialValue: false),
    ),
  );
}
```

### Complex Parameter Handling

```dart
// For unmappable parameters
final customObject = CustomConfiguration(
  // Hardcoded meaningful defaults
  apiEndpoint: 'https://api.example.com',
  timeout: const Duration(seconds: 30),
); // TODO: User should configure CustomConfiguration manually

// For asset references
final iconPath = 'assets/icons/star.svg'; // Verify asset exists in pubspec.yaml
```

### Callback Implementation Patterns

```dart
// Simple callbacks
onPressed: () => debugPrint('Button pressed'),

// Callbacks with data
onChanged: (value) => debugPrint('Value changed to: $value'),

// Complex callbacks
onFormSubmitted: (formData) {
  debugPrint('Form submitted with data:');
  debugPrint('  - Name: ${formData.name}');
  debugPrint('  - Email: ${formData.email}');
},

// Async callbacks
onSave: () async {
  debugPrint('Save operation started');
  await Future.delayed(const Duration(seconds: 1));
  debugPrint('Save operation completed');
},
```

### Theme handling

Themes are globally injected and must not be provided.

## Use Case Variant Strategies

### Single Component, Multiple Variants

Create variants that showcase different states and configurations:

```dart
// Default state
@UseCase(name: 'default', type: CustomButton)
Widget buildCustomButtonUseCase(BuildContext context) { /* ... */ }

// Loading state
@UseCase(name: 'loading', type: CustomButton)
Widget buildCustomButtonLoadingUseCase(BuildContext context) { /* ... */ }

// Disabled state
@UseCase(name: 'disabled', type: CustomButton)
Widget buildCustomButtonDisabledUseCase(BuildContext context) { /* ... */ }

// With icon
@UseCase(name: 'with icon', type: CustomButton)
Widget buildCustomButtonWithIconUseCase(BuildContext context) { /* ... */ }
```

### Responsive and Theme Variants

```dart
// Different sizes
@UseCase(name: 'small', type: ProfileCard)
@UseCase(name: 'medium', type: ProfileCard)
@UseCase(name: 'large', type: ProfileCard)
```

## Quality Standards

### Code Quality

- **No descriptive comments**: Code should be self-documenting
- **Consistent formatting**: Follow Dart style guidelines
- **Meaningful defaults**: Initial values should represent realistic usage
- **Error handling**: Wrap potentially failing operations in try-catch where appropriate

### Widget Construction Rules (WDS)

- Prefer const wherever possible to reduce rebuild cost.
- Prefer layout+decoration composition over Container:
  - Use SizedBox/ConstrainedBox/LimitedBox for sizing and constraints.
  - Use Padding for insets.
  - Use DecoratedBox or ColoredBox for background, border, and radius.
- Example (Container → composition):

```dart
// Bad
// Container(
//   padding: const EdgeInsets.all(12),
//   decoration: BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(8),
//   ),
//   child: child,
// )

// Good
ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: DecoratedBox(
    decoration: const BoxDecoration(color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: child,
    ),
  ),
)
```

### Patterned Backgrounds

- Use CustomPaint with a painter for patterned areas (e.g., 45° '/' hatch).
- Keep spacing readable; if not specified, prefer slightly wider spacing for clarity.

### Use Case Coverage

Ensure use cases demonstrate:

- [ ] Default/primary functionality
- [ ] Edge cases (empty states, maximum values)
- [ ] Interactive behaviors (hover, focus, disabled states)
- [ ] Visual variants (different styles, sizes, colors)
- [ ] Error states when applicable

### Testing Considerations

```dart
// Include realistic data volumes
final items = List.generate(50, (index) => 'Item ${index + 1}');

// Test boundary conditions
final progress = context.knobs.double.slider(
  label: 'progress',
  initialValue: 0.7,
  min: 0.0,
  max: 1.0,
  divisions: 100,
); // Allows testing 0%, 100%, and intermediate values
```

## Complete Example Template

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';

@UseCase(
  name: 'default',
  type: CustomSlider,
)
Widget buildCustomSliderUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Custom Slider',
    description: 'Interactive slider component with customizable properties',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildVariantsSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final value = context.knobs.double.slider(
    label: 'value',
    initialValue: 0.5,
    min: 0.0,
    max: 1.0,
    divisions: 20,
  );
  
  final enabled = context.knobs.boolean(
    label: 'enabled',
    initialValue: true,
  );
  
  final showLabels = context.knobs.boolean(
    label: 'showLabels',
    initialValue: true,
  );

  return WidgetbookPlayground(
    height: 150,
    child: CustomSlider(
      value: value,
      enabled: enabled,
      showLabels: showLabels,
      onChanged: (value) => debugPrint('Slider value changed to: $value'),
      onChangeStart: (value) => debugPrint('Slider interaction started at: $value'),
      onChangeEnd: (value) => debugPrint('Slider interaction ended at: $value'),
    ),
    info: [
      'Value: ${value.toStringAsFixed(2)}',
      'Enabled: $enabled',
      'Show Labels: $showLabels',
    ],
  );
}

Widget _buildVariantsSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Slider Variants',
    children: [
      WidgetbookSubsection(
        title: 'States',
        labels: ['Enabled', 'Disabled'],
        content: Column(
          spacing: 16,
          children: [
            CustomSlider(
              value: 0.3,
              enabled: true,
              onChanged: (value) => debugPrint('Enabled slider: $value'),
            ),
            CustomSlider(
              value: 0.7,
              enabled: false,
              onChanged: null,
            ),
          ],
        ),
      ),
    ],
  );
}
```

## Pre-Generation Checklist

Before generating use cases, verify:

- [ ] Component class name and import path
- [ ] Required vs optional parameters
- [ ] Parameter types and constraints
- [ ] Available enum values for list knobs
- [ ] Asset dependencies and paths
- [ ] State management requirements
- [ ] Theme/localization dependencies
- [ ] Callback signatures and expected behavior
 
## Final Checklist (WDS-specific)

- [ ] Playground에 핵심 파라미터 knob 제공: 필수/시각/행동/콜백
- [ ] 정보 패널(info)에 현재 설정값을 직관적으로 표기(특히 고정 규격인 SquareButton)
- [ ] Demonstration 섹션에서 variant/size/state 별 대표 사례 제시
- [ ] Hover/Pressed/Disabled 등 인터랙션이 눈으로 확인 가능하도록 배치
- [ ] 위젯북 공통 레이아웃(WidgetbookPageLayout/Section/Subsection) 준수
- [ ] WDS 토큰 기반 텍스트/컬러/보더/라운드 일관성 유지
- [ ] 린트/빌드 오류 없음