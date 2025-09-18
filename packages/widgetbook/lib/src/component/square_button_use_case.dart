import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'SquareButton',
  type: SquareButton,
  path: '[component]/',
)
Widget buildWdsSquareButtonUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'SquareButton',
    description: '사용자가 원하는 동작을 수행할 수 있도록 돕습니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'variant',
    options: ['normal', 'step'],
    initialOption: 'normal',
    description: '버튼의 variant를 선택해요',
  );

  final isEnabled = context.knobs.boolean(
    label: 'isEnabled',
    initialValue: true,
    description: '버튼의 활성화 상태를 정의해요',
  );

  final text = context.knobs.string(
    label: 'text',
    initialValue: '텍스트',
    description: '버튼의 텍스트를 정의해요',
  );

  final Widget button;

  final List<String> info;

  if (variant == 'step') {
    button = WdsSquareButton.step(
      leadingButton: InkWell(
        onTap: () => debugPrint('Minus button pressed'),
        child: WdsIcon.minus.build(
          color: WdsColors.cta,
          width: 16,
          height: 16,
        ),
      ),
      trailingButton: InkWell(
        onTap: () => debugPrint('Plus button pressed'),
        child: WdsIcon.plus.build(
          color: WdsColors.cta,
          width: 16,
          height: 16,
        ),
      ),
      isEnabled: isEnabled,
      child: Text(text),
    );
  } else {
    button = WdsSquareButton.normal(
      onTap: () => debugPrint('Normal SquareButton pressed'),
      isEnabled: isEnabled,
      child: Text(text),
    );
  }

  info = [
    'state: ${isEnabled ? 'enabled' : 'disabled'}',
    'variant: step',
  ];

  return WidgetbookPlayground(
    info: info,
    child: button,
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Button',
    spacing: 32,
    children: [
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'disabled'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsSquareButton.normal(
              onTap: () => debugPrint('Normal enabled'),
              child: const Text('텍스트'),
            ),
            WdsSquareButton.normal(
              onTap: () => debugPrint('Normal disabled'),
              isEnabled: false,
              child: const Text('텍스트'),
            ),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'variant',
        labels: ['normal', 'step'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsSquareButton.normal(
              onTap: () => debugPrint('Normal variant'),
              child: const Text('텍스트'),
            ),
            WdsSquareButton.step(
              leadingButton: InkWell(
                onTap: () => debugPrint('Step minus'),
                child: WdsIcon.minus.build(
                  color: WdsColors.cta,
                  width: 16,
                  height: 16,
                ),
              ),
              trailingButton: InkWell(
                onTap: () => debugPrint('Step plus'),
                child: WdsIcon.plus.build(
                  color: WdsColors.cta,
                  width: 16,
                  height: 16,
                ),
              ),
              child: const Text('텍스트'),
            ),
          ],
        ),
      ),
    ],
  );
}
