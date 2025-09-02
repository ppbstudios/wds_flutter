import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Toast',
  type: Toast,
  path: '[component]/',
)
Widget buildWdsToastUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Toast',
    description: '화면에 잠시 나타났다 사라지는 짧은 알림 메시지로, 사용자가 수행한 작업에 대한 피드백을 제공합니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final variant = context.knobs.object.dropdown<WdsToastVariant>(
    label: 'variant',
    description: 'icon으로 선택해서 icon을 설정해 보세요',
    options: WdsToastVariant.values,
    initialOption: WdsToastVariant.text,
    labelBuilder: (v) => v.name,
  );

  final message = context.knobs.string(
    label: 'message',
    description: 'Toast에 표시될 메시지를 입력해 주세요',
    initialValue: '메시지에 마침표를 찍어요.',
  );

  final icon = context.knobs.object.dropdown<WdsIcon>(
    label: 'icon',
    initialOption: WdsIcon.blank,
    options: WdsIcon.values,
    labelBuilder: (v) => v.name,
  );

  return WidgetbookPlayground(
    info: [
      'variant: ${variant.name}',
      'message: "$message"',
      if (variant == WdsToastVariant.icon) 'icon: ${icon.name}',
      'backgroundColor: cta (#121212)',
      'borderRadius: 8px',
      'textStyle: body14NormalMedium',
      'textColor: white',
      if (variant == WdsToastVariant.icon) 'iconSize: 24x24',
      if (variant == WdsToastVariant.icon) 'iconSpacing: 6px',
    ],
    child: variant == WdsToastVariant.text
        ? WdsToast.text(message: message)
        : WdsToast.icon(message: message, leadingIcon: icon),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Toast',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['text', 'icon'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsToast.text(message: '메시지에 마침표를 찍어요.'),
            WdsToast.icon(
              message: '메시지에 마침표를 찍어요.',
              leadingIcon: WdsIcon.blank,
            ),
          ],
        ),
      ),
    ],
  );
}
