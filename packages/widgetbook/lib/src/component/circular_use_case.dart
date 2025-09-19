import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'Circular',
  type: Circular,
  path: '[component]/',
)
Widget buildCircularUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Circular',
    description: '로드 시간이 적은 일반적인 상황에서 사용합니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildVariantsSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final size = context.knobs.double.input(
    label: 'size',
    initialValue: 28,
  );

  final color = context.knobs.colorOrNull(
    label: 'color',
  );

  return WidgetbookPlayground(
    info: [
      'Size: ${size}px',
      'Color: ${color?.toString() ?? 'WdsColors.borderNeutral'}',
    ],
    child: Center(
      child: WdsCircular(
        size: size,
        color: color,
      ),
    ),
  );
}

Widget _buildVariantsSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Variants',
    children: [
      WidgetbookSubsection(
        title: 'size',
        labels: ['16px', '20px', '24px', '32px', '40px'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsCircular(size: 16),
            SizedBox(width: 16),
            WdsCircular(size: 20),
            SizedBox(width: 16),
            WdsCircular(),
            SizedBox(width: 16),
            WdsCircular(size: 32),
            SizedBox(width: 16),
            WdsCircular(size: 40),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'color',
        labels: ['default', 'primary'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsCircular(),
            SizedBox(width: 16),
            WdsCircular(color: WdsColors.primary),
          ],
        ),
      ),
    ],
  );
}
