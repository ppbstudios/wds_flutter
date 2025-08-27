import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'IconButton',
  type: IconButton,
  path: '[component]/',
)
Widget buildWdsIconButtonUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'IconButton',
    description: '아이콘 중심의 동작 트리거를 제공합니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'isEnabled', initialValue: true);
  final iconName = context.knobs.object.dropdown<String>(
    label: 'icon',
    initialOption: 'chevronRight',
    options: ['chevronRight', 'wincLogo'],
  );

  Widget icon = switch (iconName) {
    'chevronRight' => WdsIcon.chevronRight.build(width: 24, height: 24),
    'wincLogo' => WdsIcon.wincLogo.build(width: 24, height: 24),
    _ => WdsIcon.chevronRight.build(width: 24, height: 24),
  };

  final button = WdsIconButton(
    onTap: () => print('IconButton pressed: $iconName'),
    icon: icon,
    isEnabled: enabled,
  );

  return WidgetbookPlayground(
    height: 144,
    layout: PlaygroundLayout.center,
    backgroundColor: WdsColorCoolNeutral.v50,
    child: button,
    info: [
      'icon: $iconName',
      'state: ${enabled ? 'enabled' : 'disabled'}',
    ],
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'IconButton',
    spacing: 32,
    children: [
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'disabled'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsIconButton(
              onTap: () => print('enabled'),
              icon: WdsIcon.chevronRight.build(width: 24, height: 24),
            ),
            WdsIconButton(
              onTap: () {},
              isEnabled: false,
              icon: WdsIcon.chevronRight.build(width: 24, height: 24),
            ),
          ],
        ),
      ),
    ],
  );
}
