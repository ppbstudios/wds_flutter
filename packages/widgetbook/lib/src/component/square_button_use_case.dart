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

  final button = WdsSquareButton(
    onTap: () => debugPrint('SquareButton pressed'),
    isEnabled: isEnabled,
    child: Text(
      text,
      style: WdsTypography.caption12Medium,
    ),
  );

  return WidgetbookPlayground(
    info: [
      'size: height32 @fixed',
      'typography: caption12Medium @fixed',
      'padding: horizontal17, vertical8 @fixed',
      'state: ${isEnabled ? 'enabled' : 'disabled'}',
    ],
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
            WdsSquareButton(
              onTap: () => debugPrint('Square enabled'),
              child: const Text('텍스트'),
            ),
            WdsSquareButton(
              onTap: () => debugPrint('Square disabled'),
              isEnabled: false,
              child: const Text('텍스트'),
            ),
          ],
        ),
      ),
    ],
  );
}
