import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'Skeleton',
  type: Skeleton,
  path: '[component]/',
)
Widget buildSkeletonUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Skeleton',
    description: '컨텐츠가 로드되는 동안 표시되는 스켈레톤 UI입니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final width = context.knobs.int.slider(
    label: 'width',
    initialValue: 100,
    min: 50,
    max: 300,
  );

  final height = context.knobs.int.slider(
    label: 'height',
    initialValue: 100,
    min: 10,
    max: 300,
  );

  final isText = context.knobs.boolean(
    label: 'text',
    description: 'vertical padding: 2px을 가져요.',
  );

  return WidgetbookPlayground(
    info: [
      'width: ${width.toString()}',
      'height: ${height.toString()}',
      'text: $isText',
    ],
    child: isText
        ? WdsSkeleton.text(width: width.toDouble(), height: height.toDouble())
        : WdsSkeleton(width: width.toDouble(), height: height.toDouble()),
  );
}

Widget _buildDemonstrationSection() {
  return const WidgetbookSection(
    title: 'Skeleton',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['rectangle', 'text'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WdsSkeleton(width: 80, height: 80),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WdsSkeleton.text(width: 120, height: 16),
                SizedBox(height: 8),
                WdsSkeleton.text(width: 100, height: 16),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
