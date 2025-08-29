import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'TextButton',
  type: TextButton,
  path: '[component]/',
)
Widget buildWdsTextButtonUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'TextButton',
    description: '배경색이나 테두리가 없는 버튼으로 텍스트만으로 구성됩니다.\n주로 강조가 덜한 보조적인 액션에 사용합니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final variant = context.knobs.object.dropdown<String>(
    label: 'variant',
    options: ['text', 'underline', 'icon'],
    initialOption: 'text',
    description: '표시 형태를 정의해요',
  );

  final size = context.knobs.object.dropdown<String>(
    label: 'size',
    options: ['medium', 'small'],
    initialOption: 'medium',
    description: '텍스트 크기 및 패딩을 정의해요',
  );

  final isEnabled = context.knobs.boolean(
    label: 'isEnabled',
    initialValue: true,
    description: '활성화 여부를 정의해요',
  );

  final text = context.knobs.string(
    label: 'text',
    initialValue: '텍스트',
    description: '버튼의 텍스트를 정의해요',
  );

  final sizeValue = switch (size) {
    'medium' => WdsTextButtonSize.medium,
    'small' => WdsTextButtonSize.small,
    _ => WdsTextButtonSize.medium,
  };

  final variantValue = switch (variant) {
    'text' => WdsTextButtonVariant.text,
    'underline' => WdsTextButtonVariant.underline,
    'icon' => WdsTextButtonVariant.icon,
    _ => WdsTextButtonVariant.text,
  };

  final button = WdsTextButton(
    onTap: () => print('TextButton pressed: $variant $size'),
    isEnabled: isEnabled,
    variant: variantValue,
    size: sizeValue,
    child: Text(text),
  );

  return WidgetbookPlayground(
    child: button,
    info: [
      'variant: $variant',
      'size: $size',
      'state: ${isEnabled ? 'enabled' : 'disabled'}',
    ],
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  Widget buildOne({
    required String label,
    required String variant,
    required String size,
    bool enabled = true,
  }) {
    final sizeValue = switch (size) {
      'medium' => WdsTextButtonSize.medium,
      'small' => WdsTextButtonSize.small,
      _ => WdsTextButtonSize.medium,
    };

    final variantValue = switch (variant) {
      'text' => WdsTextButtonVariant.text,
      'underline' => WdsTextButtonVariant.underline,
      'icon' => WdsTextButtonVariant.icon,
      _ => WdsTextButtonVariant.text,
    };

    return WdsTextButton(
      onTap: () => print('pressed: $variant $size'),
      isEnabled: enabled,
      variant: variantValue,
      size: sizeValue,
      child: Text(label),
    );
  }

  return WidgetbookSection(
    title: 'Button',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['text', 'underline', 'icon'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildOne(label: '텍스트', variant: 'text', size: 'medium'),
            const SizedBox(width: 16),
            buildOne(label: '텍스트', variant: 'underline', size: 'medium'),
            const SizedBox(width: 16),
            buildOne(label: '텍스트', variant: 'icon', size: 'medium'),
          ],
        ),
      ),
      const SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'size',
        labels: ['medium', 'small'],
        content: Column(
          spacing: 16,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildOne(label: '텍스트', variant: 'text', size: 'medium'),
                const SizedBox(width: 32),
                buildOne(label: '텍스트', variant: 'text', size: 'small'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildOne(label: '텍스트', variant: 'underline', size: 'medium'),
                const SizedBox(width: 32),
                buildOne(label: '텍스트', variant: 'underline', size: 'small'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildOne(label: '텍스트', variant: 'icon', size: 'medium'),
                const SizedBox(width: 32),
                buildOne(label: '텍스트', variant: 'icon', size: 'small'),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled (true)', 'disabled (false)'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildOne(
                label: '텍스트', variant: 'text', size: 'medium', enabled: false),
            const SizedBox(width: 16),
            buildOne(
                label: '텍스트',
                variant: 'underline',
                size: 'medium',
                enabled: false),
            const SizedBox(width: 16),
            buildOne(
                label: '텍스트', variant: 'icon', size: 'medium', enabled: false),
          ],
        ),
      ),
    ],
  );
}
