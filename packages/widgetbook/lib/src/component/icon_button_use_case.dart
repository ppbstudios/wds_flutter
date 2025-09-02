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
  final icon = context.knobs.object.dropdown<WdsIcon>(
    label: 'icon',
    initialOption: WdsIcon.blank,
    options: WdsIcon.values,
    labelBuilder: (v) => v.name,
  );

  final button = WdsIconButton(
    onTap: () => debugPrint('IconButton pressed: $icon'),
    icon: icon.build(),
    isEnabled: enabled,
  );

  return WidgetbookPlayground(
    backgroundColor: WdsColors.coolNeutral50,
    info: [
      'icon: ${icon.name}',
      'state: ${enabled ? 'enabled' : 'disabled'}',
    ],
    child: button,
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
              onTap: () => debugPrint('enabled'),
              icon: WdsIcon.blank.build(),
            ),
            WdsIconButton(
              onTap: null,
              isEnabled: false,
              icon: WdsIcon.blank.build(),
            ),
          ],
        ),
      ),
    ],
  );
}
