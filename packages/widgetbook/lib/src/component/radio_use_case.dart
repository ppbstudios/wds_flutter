import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Radio',
  type: Radio,
  path: '[component]/',
)
Widget buildWdsRadioUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Radio',
    description: '그룹 내에서 하나의 옵션만 선택할 수 있는 Radio 컴포넌트입니다. groupValue와 개별 value를 비교하여 선택 여부를 판단합니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  return const _RadioPlayground();
}

class _RadioPlayground extends StatefulWidget {
  const _RadioPlayground();
  @override
  State<_RadioPlayground> createState() => _RadioPlaygroundState();
}

class _RadioPlaygroundState extends State<_RadioPlayground> {
  String? _groupValue;

  @override
  Widget build(BuildContext context) {
    final size = context.knobs.object.dropdown<WdsRadioSize>(
      label: 'size',
      options: WdsRadioSize.values,
      initialOption: WdsRadioSize.small,
      labelBuilder: (v) => v.name,
    );

    final enabled = context.knobs.boolean(
      label: 'isEnabled',
      initialValue: true,
    );

    final options = ['Option A', 'Option B', 'Option C'];

    return WidgetbookPlayground(
      info: [
        'size: ${size.name}',
        'state: ${enabled ? 'enabled' : 'disabled'}',
        'groupValue: $_groupValue',
        'selected backgroundColor: white',
        'selected border: 2px statusPositive',
        'selected inner circle: primary',
        'unselected border: ${size == WdsRadioSize.small ? '1.25px' : '1.5px'} borderNeutral',
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in options) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (size == WdsRadioSize.small)
                  WdsRadio<String>.small(
                    value: option,
                    groupValue: _groupValue,
                    isEnabled: enabled,
                    onChanged: (value) => setState(() => _groupValue = value),
                  )
                else
                  WdsRadio<String>.large(
                    value: option,
                    groupValue: _groupValue,
                    isEnabled: enabled,
                    onChanged: (value) => setState(() => _groupValue = value),
                  ),
                const SizedBox(width: 8),
                Text(option, style: WdsTypography.body15NormalMedium),
              ],
            ),
            if (option != options.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Radio',
    children: [
      WidgetbookSubsection(
        title: 'size',
        labels: ['small', 'large'],
        content: Wrap(
          spacing: 32,
          children: [
            _RadioDemo(size: WdsRadioSize.small, enabled: true),
            _RadioDemo(size: WdsRadioSize.large, enabled: true),
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
            _RadioDemo(size: WdsRadioSize.small, enabled: true),
            _RadioDemo(size: WdsRadioSize.small, enabled: false),
            _RadioDemo(size: WdsRadioSize.large, enabled: true),
            _RadioDemo(size: WdsRadioSize.large, enabled: false),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'value',
        labels: ['unselected', 'selected'],
        content: Wrap(
          spacing: 32,
          children: [
            _RadioFixedValue(
              size: WdsRadioSize.small,
              enabled: true,
              value: 'A',
              groupValue: null, // unselected
            ),
            _RadioFixedValue(
              size: WdsRadioSize.small,
              enabled: true,
              value: 'A',
              groupValue: 'A', // selected
            ),
            _RadioFixedValue(
              size: WdsRadioSize.large,
              enabled: true,
              value: 'A',
              groupValue: null, // unselected
            ),
            _RadioFixedValue(
              size: WdsRadioSize.large,
              enabled: true,
              value: 'A',
              groupValue: 'A', // selected
            ),
          ],
        ),
      ),
    ],
  );
}

class _RadioDemo extends StatefulWidget {
  const _RadioDemo({required this.size, required this.enabled});

  final WdsRadioSize size;
  final bool enabled;

  @override
  State<_RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<_RadioDemo> {
  String? _groupValue;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final option in ['A', 'B']) ...[
          if (widget.size == WdsRadioSize.small)
            WdsRadio<String>.small(
              value: option,
              groupValue: _groupValue,
              isEnabled: widget.enabled,
              onChanged: (value) => setState(() => _groupValue = value),
            )
          else
            WdsRadio<String>.large(
              value: option,
              groupValue: _groupValue,
              isEnabled: widget.enabled,
              onChanged: (value) => setState(() => _groupValue = value),
            ),
          if (option != 'B') const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _RadioFixedValue extends StatelessWidget {
  const _RadioFixedValue({
    required this.size,
    required this.enabled,
    required this.value,
    required this.groupValue,
  });

  final WdsRadioSize size;
  final bool enabled;
  final String value;
  final String? groupValue;

  @override
  Widget build(BuildContext context) {
    if (size == WdsRadioSize.small) {
      return WdsRadio<String>.small(
        value: value,
        groupValue: groupValue,
        isEnabled: enabled,
        onChanged: (_) {}, // No-op for demonstration
      );
    }
    return WdsRadio<String>.large(
      value: value,
      groupValue: groupValue,
      isEnabled: enabled,
      onChanged: (_) {}, // No-op for demonstration
    );
  }
}