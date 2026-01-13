import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Checkbox',
  type: Checkbox,
  path: '[component]/',
)
Widget buildWdsCheckboxUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Checkbox',
    description: '하나 또는 여러 항목을 선택할 때 사용합니다. 값/활성화 상태에 따라 시각이 달라집니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  return const _CheckboxPlayground();
}

class _CheckboxPlayground extends StatefulWidget {
  const _CheckboxPlayground();
  @override
  State<_CheckboxPlayground> createState() => _CheckboxPlaygroundState();
}

class _CheckboxPlaygroundState extends State<_CheckboxPlayground> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    final size = context.knobs.object.dropdown<WdsCheckboxSize>(
      label: 'size',
      options: WdsCheckboxSize.values,
      initialOption: WdsCheckboxSize.small,
      labelBuilder: (v) => v.name,
    );

    final enabled = context.knobs.boolean(
      label: 'isEnabled',
      initialValue: true,
    );

    final WdsCheckbox child;
    if (size == WdsCheckboxSize.small) {
      child = WdsCheckbox.small(
        value: _value,
        isEnabled: enabled,
        onChanged: (v) => setState(() => _value = v),
      );
    } else {
      child = WdsCheckbox.large(
        value: _value,
        isEnabled: enabled,
        onChanged: (v) => setState(() => _value = v),
      );
    }

    return WidgetbookPlayground(
      info: [
        'size: ${size.name}',
        'state: ${enabled ? 'enabled' : 'disabled'}',
        'value: $_value',
        'backgroundColor: ${_value ? 'cta' : 'null'}',
        'border: ${_value ? 'null' : 'neutral'} / radius: 4px',
      ],
      child: child,
    );
  }
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Checkbox',
    children: [
      WidgetbookSubsection(
        title: 'size',
        labels: ['small', 'large'],
        content: Wrap(
          spacing: 32,
          children: [
            _CheckboxDemo(size: WdsCheckboxSize.small, enabled: true),
            _CheckboxDemo(size: WdsCheckboxSize.medium, enabled: true),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'disabled'],
        content: Wrap(
          spacing: 32,
          children: [
            _CheckboxDemo(size: WdsCheckboxSize.small, enabled: true),
            _CheckboxFixedValue(
              size: WdsCheckboxSize.small,
              enabled: false,
              value: true,
            ),
            _CheckboxDemo(size: WdsCheckboxSize.medium, enabled: true),
            _CheckboxFixedValue(
              size: WdsCheckboxSize.medium,
              enabled: false,
              value: true,
            ),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'value',
        labels: ['false', 'true'],
        content: Wrap(
          spacing: 32,
          children: [
            _CheckboxFixedValue(
              size: WdsCheckboxSize.small,
              enabled: true,
              value: false,
            ),
            _CheckboxFixedValue(
              size: WdsCheckboxSize.small,
              enabled: true,
              value: true,
            ),
            _CheckboxFixedValue(
              size: WdsCheckboxSize.medium,
              enabled: true,
              value: false,
            ),
            _CheckboxFixedValue(
              size: WdsCheckboxSize.medium,
              enabled: true,
              value: true,
            ),
          ],
        ),
      ),
    ],
  );
}

class _CheckboxDemo extends StatefulWidget {
  const _CheckboxDemo({required this.size, required this.enabled});

  final WdsCheckboxSize size;
  final bool enabled;

  @override
  State<_CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<_CheckboxDemo> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    if (widget.size == WdsCheckboxSize.small) {
      return WdsCheckbox.small(
        value: _value,
        isEnabled: widget.enabled,
        onChanged: (v) => setState(() => _value = v),
      );
    }
    return WdsCheckbox.large(
      value: _value,
      isEnabled: widget.enabled,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

class _CheckboxFixedValue extends StatelessWidget {
  const _CheckboxFixedValue({
    required this.size,
    required this.enabled,
    required this.value,
  });

  final WdsCheckboxSize size;
  final bool enabled;
  final bool value;

  @override
  Widget build(BuildContext context) {
    if (size == WdsCheckboxSize.small) {
      return WdsCheckbox.small(
        value: value,
        isEnabled: enabled,
        onChanged: (_) {},
      );
    }
    return WdsCheckbox.large(
      value: value,
      isEnabled: enabled,
      onChanged: (_) {},
    );
  }
}
