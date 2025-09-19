import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'MenuItem',
  type: MenuItem,
  path: '[component]/',
)
Widget buildWdsMenuItemUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'MenuItem',
    description: '텍스트 기반 선택 요소 정보를 섹션 또는 그룹으로 나눌 수 있는 연속적인 수직 집합체입니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final iconType = context.knobs.object.dropdown<String>(
    label: 'icon',
    options: [
      'blank',
      'arrowRight',
      'arrowDown',
      'arrowUp',
      'arrowLeft',
    ],
    initialOption: 'blank',
    description: '아이콘을 선택해요',
  );

  final text = context.knobs.string(
    label: 'text',
    initialValue: '텍스트',
    description: '메뉴 아이템에 표시될 텍스트를 정의해요',
  );

  final icon = switch (iconType) {
    'arrowRight' => WdsIcon.chevronRight,
    'arrowDown' => WdsIcon.chevronDown,
    'arrowUp' => WdsIcon.chevronUp,
    'arrowLeft' => WdsIcon.chevronLeft,
    _ => null,
  };

  return WidgetbookPlayground(
    info: [
      'Text: $text',
      'Icon: ${iconType == 'none' ? 'None' : iconType}',
    ],
    child: icon != null
        ? WdsMenuItem.icon(
            text: text,
            icon: icon,
            onTap: () {},
          )
        : WdsMenuItem.text(
            text: text,
            onTap: () {},
          ),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'MenuItem',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: [
          'text',
          'icon',
        ],
        content: Column(
          spacing: 8,
          children: [
            WdsMenuItem.text(
              text: '텍스트만 있는 메뉴 아이템',
              onTap: () {},
            ),
            WdsMenuItem.icon(
              text: '오른쪽 화살표 아이콘 메뉴 아이템',
              icon: WdsIcon.chevronRight,
              onTap: () {},
            ),
          ],
        ),
      ),
    ],
  );
}
