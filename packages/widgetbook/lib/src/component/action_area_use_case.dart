import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'FixedActionArea',
  type: FixedActionArea,
  path: '[component]/',
)
Widget buildWdsFixedActionAreaUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'FixedActionArea',
    description: '하단 고정형 액션 영역(81px). normal/filter/division 변형을 확인합니다.',
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

  final labelPrimary =
      context.knobs.string(label: 'primary label', initialValue: '메인액션');
  final labelSecondary =
      context.knobs.string(label: 'secondary label', initialValue: '대체액션');

  WdsFixedActionArea area;
  switch (variant) {
    case 'filter':
      area = WdsFixedActionArea.filter(
        secondary: WdsButton(
          onTap: () => print('secondary'),
          variant: WdsButtonVariant.secondary,
          size: WdsButtonSize.xlarge,
          child: Text(labelSecondary),
        ),
        primary: WdsButton(
          onTap: () => print('primary'),
          size: WdsButtonSize.xlarge,
          child: Text(labelPrimary),
        ),
      );
      break;
    case 'division':
      area = WdsFixedActionArea.division(
        secondary: WdsButton(
          onTap: () => print('secondary'),
          variant: WdsButtonVariant.secondary,
          size: WdsButtonSize.xlarge,
          child: Text(labelSecondary),
        ),
        primary: WdsButton(
          onTap: () => print('primary'),
          size: WdsButtonSize.xlarge,
          child: Text(labelPrimary),
        ),
      );
      break;
    default:
      area = WdsFixedActionArea.normal(
        primary: WdsButton(
          onTap: () => print('primary'),
          size: WdsButtonSize.xlarge,
          child: Text(labelPrimary),
        ),
      );
  }

  return WidgetbookPlayground(
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
    title: 'Variants',
    children: [
      WidgetbookSubsection(
        title: 'normal / filter / division',
        labels: const ['normal', 'filter', 'division'],
        content: Column(
          spacing: 16,
          children: [
            WdsFixedActionArea.normal(
              primary: WdsButton(
                onTap: () {},
                size: WdsButtonSize.xlarge,
                child: const Text('메인액션'),
              ),
            ),
            WdsFixedActionArea.filter(
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
            WdsFixedActionArea.division(
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

@widgetbook.UseCase(
  name: 'DynamicActionArea',
  type: DynamicActionArea,
  path: '[component]/',
)
Widget buildWdsDynamicActionAreaUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'DynamicActionArea',
    description: '보조 정보/컨트롤 + CTA로 구성되는 동적 액션 영역',
    children: [
      _buildDynamicPlayground(context),
      _buildDynamicDemonstration(context),
    ],
  );
}

Widget _buildDynamicPlayground(BuildContext context) {
  final variant = context.knobs.object.dropdown<WdsDynamicActionAreaVariant>(
    label: 'variant',
    options: WdsDynamicActionAreaVariant.values,
    initialOption: WdsDynamicActionAreaVariant.product,
    labelBuilder: (v) => v.name,
  );

  final labelPrimary =
      context.knobs.string(label: 'cta label', initialValue: '메인액션');

  final area = WdsDynamicActionArea(
    variant: variant,
    cta: WdsButton(
      onTap: () => print('cta'),
      size: WdsButtonSize.xlarge,
      child: Text(labelPrimary),
    ),
  );

  return WidgetbookPlayground(
    info: const [
      'padding: 16 all',
      'top border: 1px alternative',
      'cta: xlarge stretch',
    ],
    child: SizedBox(
      height: 160,
      child: Align(alignment: Alignment.bottomCenter, child: area),
    ),
  );
}

Widget _buildDynamicDemonstration(BuildContext context) {
  WdsButton cta(String label) => WdsButton(
        onTap: () {},
        size: WdsButtonSize.xlarge,
        child: Text(label),
      );

  return WidgetbookSection(
    title: 'Variants',
    children: [
      WidgetbookSubsection(
        title: 'product / discount / checkbox',
        labels: const ['product', 'discount', 'checkbox'],
        content: Column(
          spacing: 16,
          children: [
            WdsDynamicActionArea(
              variant: WdsDynamicActionAreaVariant.product,
              cta: cta('메인액션'),
            ),
            WdsDynamicActionArea(
              variant: WdsDynamicActionAreaVariant.discount,
              cta: cta('메인액션'),
            ),
            WdsDynamicActionArea(
              variant: WdsDynamicActionAreaVariant.checkbox,
              cta: cta('메인액션'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'summary / chips',
        labels: const ['summary', 'chips'],
        content: Column(
          spacing: 16,
          children: [
            WdsDynamicActionArea(
              variant: WdsDynamicActionAreaVariant.summary,
              cta: cta('메인액션'),
            ),
            WdsDynamicActionArea(
              variant: WdsDynamicActionAreaVariant.chips,
              cta: cta('메인액션'),
            ),
          ],
        ),
      ),
    ],
  );
}
