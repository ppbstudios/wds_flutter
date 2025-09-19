import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Slider',
  type: Slider,
  path: '[component]/',
)
Widget buildWdsSliderUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Slider',
    description: '특정 범위에 대한 값을 선택할 때 사용합니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  return const _SliderPlayground();
}

class _SliderPlayground extends StatefulWidget {
  const _SliderPlayground();
  @override
  State<_SliderPlayground> createState() => _SliderPlaygroundState();
}

class _SliderPlaygroundState extends State<_SliderPlayground> {
  WdsRangeValues _values = const WdsRangeValues(start: 20, end: 80);

  @override
  Widget build(BuildContext context) {
    final minValue = context.knobs.double.slider(
      label: 'minValue',
      description: '최소값을 설정할 수 있어요',
      min: -100,
      max: 100,
      divisions: 200,
    );

    final maxValue = context.knobs.double.slider(
      label: 'maxValue',
      description: '최대값을 설정할 수 있어요',
      initialValue: 100,
      max: 200,
      divisions: 200,
    );

    final hasTitle = context.knobs.boolean(
      label: 'hasTitle',
      description: '가운데 선택된 범위를 표기할 수 있어요',
    );

    final enabled = context.knobs.boolean(
      label: 'isEnabled',
      description: '상호작용 가능 여부를 설정할 수 있어요',
      initialValue: true,
    );

    final divisions = context.knobs.int.input(
      label: 'divisions',
      description: '움직일 수 있는 총 구간 수를 설정할 수 있어요. (기본값 10)',
      initialValue: 10,
    );

    // Ensure values are within the valid range
    final adjustedValues = WdsRangeValues(
      start: _values.start.clamp(minValue, maxValue),
      end: _values.end.clamp(minValue, maxValue),
    );

    if (adjustedValues != _values) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _values = adjustedValues);
      });
    }

    return WidgetbookPlayground(
      info: [
        'range: ${_values.start.round()}~${_values.end.round()}',
        'minValue: ${minValue.round()}',
        'maxValue: ${maxValue.round()}',
        'hasTitle: $hasTitle',
        'divisions: $divisions',
        'state: ${enabled ? 'enabled' : 'disabled'}',
        'track: height=4px, colors=borderAlternative/primary',
        'knob: size=20px, interaction=32px',
        'tap track: moves nearest knob to tap position',
      ],
      child: WdsSlider(
        minValue: minValue,
        maxValue: maxValue,
        values: _values,
        hasTitle: hasTitle,
        isEnabled: enabled,
        divisions: divisions,
        onChanged: enabled
            ? (newValues) {
                setState(() => _values = newValues);
                debugPrint(
                  'Slider values changed: ${newValues.start.round()}~${newValues.end.round()}',
                );
              }
            : null,
      ),
    );
  }
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Slider',
    children: [
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'disabled'],
        content: _SliderStatesDemo(),
      ),
      SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'hasTitle',
        labels: ['true', 'false'],
        content: _SliderTitleDemo(),
      ),
      SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'ranges',
        labels: [
          '0~100 (단위: 10)',
          '0~1000 (단위: 50)',
          '-50~50 (단위: 20)',
        ],
        content: _SliderRangeDemo(),
      ),
      SizedBox(height: 32),
    ],
  );
}

class _SliderStatesDemo extends StatefulWidget {
  const _SliderStatesDemo();
  @override
  State<_SliderStatesDemo> createState() => _SliderStatesDemoState();
}

class _SliderStatesDemoState extends State<_SliderStatesDemo> {
  WdsRangeValues _enabledValues = const WdsRangeValues(start: 30, end: 70);
  final WdsRangeValues _disabledValues =
      const WdsRangeValues(start: 40, end: 80);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enabled slider
        WdsSlider(
          minValue: 0,
          maxValue: 100,
          values: _enabledValues,
          hasTitle: true,
          divisions: 10,
          onChanged: (values) {
            setState(() => _enabledValues = values);
            debugPrint(
              'Enabled slider: ${values.start.round()}~${values.end.round()}',
            );
          },
        ),
        // Disabled slider
        WdsSlider(
          minValue: 0,
          maxValue: 100,
          values: _disabledValues,
          hasTitle: true,
          isEnabled: false,
          divisions: 10,
          onChanged: null,
        ),
      ],
    );
  }
}

class _SliderTitleDemo extends StatefulWidget {
  const _SliderTitleDemo();
  @override
  State<_SliderTitleDemo> createState() => _SliderTitleDemoState();
}

class _SliderTitleDemoState extends State<_SliderTitleDemo> {
  WdsRangeValues _valuesWithTitle = const WdsRangeValues(start: 25, end: 75);
  WdsRangeValues _valuesWithoutTitle = const WdsRangeValues(start: 35, end: 65);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // With title
        WdsSlider(
          minValue: 0,
          maxValue: 100,
          values: _valuesWithTitle,
          hasTitle: true,
          divisions: 10,
          onChanged: (values) {
            setState(() => _valuesWithTitle = values);
            debugPrint(
              'With title: ${values.start.round()}~${values.end.round()}',
            );
          },
        ),
        // Without title
        WdsSlider(
          minValue: 0,
          maxValue: 100,
          values: _valuesWithoutTitle,
          divisions: 10,
          onChanged: (values) {
            setState(() => _valuesWithoutTitle = values);
            debugPrint(
              'Without title: ${values.start.round()}~${values.end.round()}',
            );
          },
        ),
      ],
    );
  }
}

class _SliderRangeDemo extends StatefulWidget {
  const _SliderRangeDemo();
  @override
  State<_SliderRangeDemo> createState() => _SliderRangeDemoState();
}

class _SliderRangeDemoState extends State<_SliderRangeDemo> {
  WdsRangeValues _range1Values = const WdsRangeValues(start: 20, end: 80);
  WdsRangeValues _range2Values = const WdsRangeValues(start: 200, end: 800);
  WdsRangeValues _range3Values = const WdsRangeValues(start: -20, end: 30);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 0-100 range
        WdsSlider(
          minValue: 0,
          maxValue: 100,
          values: _range1Values,
          hasTitle: true,
          divisions: 10,
          onChanged: (values) {
            setState(() => _range1Values = values);
            debugPrint(
              'Range 0-100: ${values.start.round()}~${values.end.round()}',
            );
          },
        ),
        // 0-1000 range
        WdsSlider(
          minValue: 0,
          maxValue: 1000,
          values: _range2Values,
          hasTitle: true,
          divisions: 20,
          onChanged: (values) {
            setState(() => _range2Values = values);
            debugPrint(
              'Range 0-1000: ${values.start.round()}~${values.end.round()}',
            );
          },
        ),
        // -50 to 50 range
        WdsSlider(
          minValue: -50,
          maxValue: 50,
          values: _range3Values,
          hasTitle: true,
          divisions: 5,
          onChanged: (values) {
            setState(() => _range3Values = values);
            debugPrint(
              'Range -50~50: ${values.start.round()}~${values.end.round()}',
            );
          },
        ),
      ],
    );
  }
}

class _SliderTapDemo extends StatefulWidget {
  const _SliderTapDemo();
  @override
  State<_SliderTapDemo> createState() => _SliderTapDemoState();
}

class _SliderTapDemoState extends State<_SliderTapDemo> {
  WdsRangeValues _tapDemoValues = const WdsRangeValues(start: 30, end: 70);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tap anywhere on the track to move the nearest knob to that position',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 16),
        WdsSlider(
          minValue: 0,
          maxValue: 100,
          values: _tapDemoValues,
          hasTitle: true,
          divisions: 100,
          onChanged: (values) {
            setState(() => _tapDemoValues = values);
            debugPrint(
              'Tap demo: ${values.start.round()}~${values.end.round()}',
            );
          },
        ),
      ],
    );
  }
}
