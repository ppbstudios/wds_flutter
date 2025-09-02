import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Snackbar',
  type: Snackbar,
  path: '[component]/',
)
Widget buildWdsSnackbarUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Snackbar',
    description: '사용자가 수행한 작업에 대한 피드백을 제공합니다.\n추가적인 조치를 취할 수 있는 버튼이 포함되어 있습니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final variant = context.knobs.object.dropdown<WdsSnackbarVariant>(
    label: 'variant',
    options: WdsSnackbarVariant.values,
    initialOption: WdsSnackbarVariant.normal,
    labelBuilder: (v) => v.name,
  );

  final message = context.knobs.string(
    label: 'message',
    initialValue: '메시지에 마침표를 찍어요.',
  );

  final description = context.knobs.string(
    label: 'description',
    initialValue: '설명은 필요할때만 써요.',
  );

  final hasIcon = context.knobs.boolean(
    label: 'leadingIcon',
    description: '좌측에 Icon을 표시해요',
  );

  final icon = context.knobs.object.dropdown<WdsIcon>(
    label: 'icon',
    description: '좌측에 위치할 icon을 선택해 보세요',
    initialOption: WdsIcon.blank,
    options: WdsIcon.values,
    labelBuilder: (v) => v.name,
  );

  final actionVariant = context.knobs.object.dropdown<WdsTextButtonVariant>(
    label: 'action의 variant',
    description: 'action의 variant를 선택해 보세요',
    options: WdsTextButtonVariant.values,
    initialOption: WdsTextButtonVariant.underline,
    labelBuilder: (v) => v.name,
  );

  return WidgetbookPlayground(
    info: [
      'variant: ${variant.name}',
      'message: "$message"',
      if (variant == WdsSnackbarVariant.description)
        'description: "$description"',
      'hasLeadingIcon: $hasIcon',
      if (hasIcon) 'icon: ${icon.name}',
      'actionVariant: ${actionVariant.name}',
      'backgroundColor: cta (#121212)',
      'borderRadius: 8px',
    ],
    child: _buildSnackbarExample(
      variant: variant,
      message: message,
      description: description,
      hasIcon: hasIcon,
      icon: icon,
      actionVariant: actionVariant,
    ),
  );
}

Widget _buildSnackbarExample({
  required WdsSnackbarVariant variant,
  required String message,
  required String description,
  required bool hasIcon,
  required WdsIcon icon,
  required WdsTextButtonVariant actionVariant,
}) {
  final WdsTextButton actionButton = WdsTextButton(
    variant: actionVariant,
    size: WdsTextButtonSize.small,
    onTap: () => debugPrint('Snackbar action pressed'),
    child: Text(
      actionVariant == WdsTextButtonVariant.underline ? '실행취소' : '보기',
      style: const TextStyle(color: WdsColors.white),
    ),
  );

  switch (variant) {
    case WdsSnackbarVariant.normal:
      return WdsSnackbar.normal(
        message: message,
        action: actionButton,
        leadingIcon: hasIcon ? icon : null,
      );
    case WdsSnackbarVariant.description:
      return WdsSnackbar.description(
        message: message,
        description: description,
        action: actionButton,
        leadingIcon: hasIcon ? icon : null,
      );
    case WdsSnackbarVariant.multiLine:
      return WdsSnackbar.multiLine(
        message: '$message. 메시지가 두 줄 이상 길어지는 경우 예외적으로 사용해요.',
        action: actionButton,
        leadingIcon: hasIcon ? icon : null,
      );
  }
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Snackbar Variants',
    children: [
      WidgetbookSubsection(
        title: 'normal',
        labels: ['message', 'icon + message'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsSnackbar.normal(
              message: '파일이 저장되었습니다',
              action: WdsTextButton(
                variant: WdsTextButtonVariant.underline,
                size: WdsTextButtonSize.small,
                onTap: () => debugPrint('Undo pressed'),
                child: const Text(
                  '실행취소',
                  style: TextStyle(color: WdsColors.white),
                ),
              ),
            ),
            WdsSnackbar.normal(
              message: '메시지를 보냈습니다',
              leadingIcon: WdsIcon.blank,
              action: WdsTextButton(
                variant: WdsTextButtonVariant.icon,
                size: WdsTextButtonSize.small,
                onTap: () => debugPrint('View pressed'),
                child: const Text(
                  '보기',
                  style: TextStyle(color: WdsColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'description',
        labels: ['message + description', 'icon + message + description'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsSnackbar.description(
              message: '동기화 완료',
              description: '모든 변경 사항이 클라우드에 저장되었습니다',
              action: WdsTextButton(
                variant: WdsTextButtonVariant.underline,
                size: WdsTextButtonSize.small,
                onTap: () => debugPrint('Details pressed'),
                child: const Text(
                  '자세히',
                  style: TextStyle(color: WdsColors.white),
                ),
              ),
            ),
            WdsSnackbar.description(
              message: '업로드 완료',
              description: '3개 파일이 성공적으로 업로드되었습니다',
              leadingIcon: WdsIcon.blank,
              action: WdsTextButton(
                variant: WdsTextButtonVariant.icon,
                size: WdsTextButtonSize.small,
                onTap: () => debugPrint('View files pressed'),
                child: const Text(
                  '확인',
                  style: TextStyle(color: WdsColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'multiLine',
        labels: ['message + action', 'icon + message + action'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsSnackbar.multiLine(
              message:
                  '네트워크 연결이 불안정합니다. 잠시 후 다시 시도해 주세요. 문제가 지속되면 고객센터로 문의해 주세요.',
              action: WdsTextButton(
                variant: WdsTextButtonVariant.underline,
                size: WdsTextButtonSize.small,
                onTap: () => debugPrint('Retry pressed'),
                child: const Text(
                  '다시시도',
                  style: TextStyle(color: WdsColors.white),
                ),
              ),
            ),
            WdsSnackbar.multiLine(
              message: '백업이 완료되었습니다. 총 1,234개의 파일과 567MB의 데이터가 안전하게 백업되었습니다.',
              leadingIcon: WdsIcon.blank,
              action: WdsTextButton(
                variant: WdsTextButtonVariant.icon,
                size: WdsTextButtonSize.small,
                onTap: () => debugPrint('Details pressed'),
                child: const Text(
                  '자세히',
                  style: TextStyle(color: WdsColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
