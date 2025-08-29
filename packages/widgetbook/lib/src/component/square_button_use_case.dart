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
    description:
        '고정된 크기와 타이포그래피, 패딩을 가지는 사각형 버튼입니다.\nhover/pressed 시 동일한 피드백 오버레이를 제공하며, 비활성 상태는 투명도로 표현합니다.',
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
    onTap: () => print('SquareButton pressed'),
    isEnabled: isEnabled,
    child: Text(
      text,
      style: WdsSemanticTypography.caption12Medium,
    ),
  );

  return WidgetbookPlayground(
    info: [
      'size: height32 fixed',
      'typography: caption12Medium fixed',
      'padding: horizontal17, vertical8 fixed',
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
              onTap: () => print('Square enabled'),
              child: const Text('텍스트'),
            ),
            WdsSquareButton(
              onTap: () => print('Square disabled'),
              isEnabled: false,
              child: const Text('텍스트'),
            ),
          ],
        ),
      ),
    ],
  );
}
