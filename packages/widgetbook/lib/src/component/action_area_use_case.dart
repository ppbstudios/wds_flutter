import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'ActionArea',
  type: ActionArea,
  path: '[component]/',
)
Widget buildWdsFixedActionAreaUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'ActionArea',
    description: '사용자가 인터페이스를 통해 상호작용을 할 수 있는 공간을 제공합니다.',
    children: [
      _buildFixedPlayground(context),
      _buildFixedDemonstration(context),
    ],
  );
}

Widget _buildFixedPlayground(BuildContext context) {
  final variant = context.knobs.object.dropdown<String>(
    label: 'variant',
    options: const ['normal', 'filter', 'division'],
    initialOption: 'normal',
  );

  final labelPrimary = context.knobs.string(
    label: 'primary label',
    initialValue: '메인액션',
  );
  final labelSecondary = context.knobs.string(
    label: 'secondary label',
    initialValue: '대체액션',
  );

  final area = switch (variant) {
    'filter' => WdsActionArea.filter(
        secondary: WdsButton(
          onTap: () => debugPrint('secondary'),
          variant: WdsButtonVariant.secondary,
          size: WdsButtonSize.xlarge,
          child: Text(labelSecondary),
        ),
        primary: WdsButton(
          onTap: () => debugPrint('primary'),
          size: WdsButtonSize.xlarge,
          child: Text(labelPrimary),
        ),
      ),
    'division' => WdsActionArea.division(
        secondary: WdsButton(
          onTap: () => debugPrint('secondary'),
          variant: WdsButtonVariant.secondary,
          size: WdsButtonSize.xlarge,
          child: Text(labelSecondary),
        ),
        primary: WdsButton(
          onTap: () => debugPrint('primary'),
          size: WdsButtonSize.xlarge,
          child: Text(labelPrimary),
        ),
      ),
    _ => WdsActionArea.normal(
        primary: WdsButton(
          onTap: () => debugPrint('primary'),
          size: WdsButtonSize.xlarge,
          child: Text(labelPrimary),
        ),
      ),
  };

  return WidgetbookPlayground(
    backgroundColor: WdsColors.coolNeutral50,
    info: const [
      'height: 81',
      'padding: 16 all',
      'top border: 1px alternative',
    ],
    child: SizedBox(
      height: 120,
      child: Align(alignment: Alignment.bottomCenter, child: area),
    ),
  );
}

Widget _buildFixedDemonstration(BuildContext context) {
  return WidgetbookSection(
    title: 'ActionArea',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: const ['normal', 'filter', 'division'],
        content: Column(
          spacing: 16,
          children: [
            WdsActionArea.normal(
              primary: WdsButton(
                onTap: () {},
                size: WdsButtonSize.xlarge,
                child: const Text('메인액션'),
              ),
            ),
            WdsActionArea.filter(
              secondary: WdsButton(
                onTap: () {},
                variant: WdsButtonVariant.secondary,
                size: WdsButtonSize.xlarge,
                child: const Text('대체액션'),
              ),
              primary: WdsButton(
                onTap: () {},
                size: WdsButtonSize.xlarge,
                child: const Text('메인액션'),
              ),
            ),
            WdsActionArea.division(
              secondary: WdsButton(
                onTap: () {},
                variant: WdsButtonVariant.secondary,
                size: WdsButtonSize.xlarge,
                child: const Text('대체액션'),
              ),
              primary: WdsButton(
                onTap: () {},
                size: WdsButtonSize.xlarge,
                child: const Text('메인액션'),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
