import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Divider',
  type: Divider,
  path: '[component]/',
)
Widget buildWdsDividerUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Divider',
    description: '요소와 요소 사이를 구분해 시각적 가독성을 높여요.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final isVertical = context.knobs.boolean(
    label: 'isVertical',
    description: '가로/세로 방향을 전환해요',
  );

  final variant = context.knobs.object.dropdown<String>(
    label: 'variant',
    options: ['normal', 'thick'],
    initialOption: 'normal',
    description: '두께를 선택해요 (세로는 normal 고정)',
  );

  final divider = isVertical
      ? const WdsDivider.vertical()
      : WdsDivider(
          variant: variant == 'normal'
              ? WdsDividerVariant.normal
              : WdsDividerVariant.thick,
        );

  return WidgetbookPlayground(
    info: [
      'direction: ${isVertical ? 'vertical' : 'horizontal'}',
      'variant: $variant',
      'color: WdsColors.borderAlternative',
    ],
    child: Align(
      alignment: isVertical ? Alignment.center : Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isVertical
            ? SizedBox(
                height: 24,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 12,
                  children: [
                    const Text('좌측'),
                    divider,
                    const Text('우측'),
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  const Text('위'),
                  divider,
                  const Text('아래'),
                ],
              ),
      ),
    ),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Divider',
    spacing: 24,
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['normal', 'thick'],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            WdsDivider(),
            WdsDivider(variant: WdsDividerVariant.thick),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'isVertical',
        labels: ['true'],
        content: SizedBox(
          height: 24,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 24,
            children: [
              Text('A'),
              WdsDivider.vertical(),
              Text('B'),
            ],
          ),
        ),
      ),
    ],
  );
}
