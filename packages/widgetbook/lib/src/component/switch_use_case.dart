import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Switch',
  type: Switch,
  path: '[component]/',
)
Widget buildWdsSwitchUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Switch',
    description: '정보를 특정 주제나 그룹으로 나누어 구분하고 접근할 수 있습니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  return const _SwitchPlayground();
}

class _SwitchPlayground extends StatefulWidget {
  const _SwitchPlayground();
  @override
  State<_SwitchPlayground> createState() => _SwitchPlaygroundState();
}

class _SwitchPlaygroundState extends State<_SwitchPlayground> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    final size = context.knobs.object.dropdown<WdsSwitchSize>(
      label: 'size',
      options: WdsSwitchSize.values,
      initialOption: WdsSwitchSize.small,
      labelBuilder: (v) => v.name,
    );

    final enabled = context.knobs.boolean(
      label: 'isEnabled',
      initialValue: true,
    );

    final WdsSwitch child;
    if (size == WdsSwitchSize.small) {
      child = WdsSwitch.small(
        value: _value,
        isEnabled: enabled,
        onChanged: (v) => setState(() => _value = v),
      );
    } else {
      child = WdsSwitch.large(
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
        'colors: active=primary, inactive=neutral.v200, knob=white',
      ],
      child: child,
    );
  }
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Switch',
    children: [
      WidgetbookSubsection(
        title: 'size',
        labels: ['small', 'large'],
        content: Wrap(
          spacing: 32,
          children: [
            _SwitchDemo(size: WdsSwitchSize.small, enabled: true),
            _SwitchDemo(size: WdsSwitchSize.large, enabled: true),
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
            _SwitchDemo(size: WdsSwitchSize.small, enabled: true),
            _SwitchDemo(size: WdsSwitchSize.small, enabled: false),
            _SwitchDemo(size: WdsSwitchSize.large, enabled: true),
            _SwitchDemo(size: WdsSwitchSize.large, enabled: false),
          ],
        ),
      ),
    ],
  );
}

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo({required this.size, required this.enabled});

  final WdsSwitchSize size;

  final bool enabled;

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    if (widget.size == WdsSwitchSize.small) {
      return WdsSwitch.small(
        value: _value,
        isEnabled: widget.enabled,
        onChanged: (v) => setState(() => _value = v),
      );
    }

    return WdsSwitch.large(
      value: _value,
      isEnabled: widget.enabled,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}
