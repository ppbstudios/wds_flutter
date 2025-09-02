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
    options: WdsToastVariant.values,
    initialOption: WdsToastVariant.text,
    labelBuilder: (v) => v.name,
  );

  final message = context.knobs.string(
    label: 'message',
    initialValue: '작업이 완료되었습니다',
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
    title: 'Toast Variants',
    children: [
      WidgetbookSubsection(
        title: 'text',
        labels: ['기본 텍스트', '긴 메시지'],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsToast.text(message: '저장되었습니다'),
            WdsToast.text(message: '변경 사항이 성공적으로 저장되었습니다'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'icon',
        labels: ['성공', '정보', '경고'],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsToast.icon(
              message: '저장되었습니다',
              leadingIcon: WdsIcon.blank, // You can replace with appropriate success icon
            ),
            WdsToast.icon(
              message: '새로운 업데이트가 있습니다',
              leadingIcon: WdsIcon.blank, // You can replace with appropriate info icon
            ),
            WdsToast.icon(
              message: '네트워크 연결을 확인해주세요',
              leadingIcon: WdsIcon.blank, // You can replace with appropriate warning icon
            ),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'message length',
        labels: ['짧은 메시지', '중간 메시지', '긴 메시지'],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsToast.text(message: '완료'),
            WdsToast.text(message: '파일이 업로드되었습니다'),
            WdsToast.text(message: '사용자 프로필 정보가 성공적으로 업데이트되었습니다'),
          ],
        ),
      ),
    ],
  );
}