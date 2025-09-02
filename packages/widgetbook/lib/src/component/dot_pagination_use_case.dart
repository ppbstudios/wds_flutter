import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'PaginationDot',
  type: PaginationDot,
  path: '[component]/',
)
Widget buildWdsDotPaginationUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'PaginationDot',
    description:
        '페이지를 작은 점(dot) 형태로 표시하여 사용자가 현재 페이지와 다른 페이지로 쉽게 이동할 수 있도록 돕습니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final totalDots = context.knobs.int.slider(
    label: 'Total',
    description: '전체 \'dot\' 개수를 정의해요',
    min: 2,
    max: 10,
    initialValue: 5,
  );

  final activeIndex1Based = context.knobs.int.slider(
    label: 'Active',
    description: '활성 \'dot\'을 정의해요',
    min: 1,
    max: totalDots,
    initialValue: 2,
  );

  final int activeIndex = activeIndex1Based - 1;

  final dots = Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 8,
    children: List.generate(totalDots, (index) {
      return WdsDotPagination(isActive: index == activeIndex);
    }),
  );

  return WidgetbookPlayground(
    info: [
      'Total Dots: $totalDots',
      'Active Index : $activeIndex1Based',
      'Active Dot: $activeIndex1Based번째',
    ],
    child: dots,
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'PaginationDot',
    spacing: 32,
    children: [
      WidgetbookSubsection(
        title: 'state',
        labels: ['active', 'inactive'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            WdsDotPagination(isActive: true),
            WdsDotPagination(isActive: false),
          ],
        ),
      ),
    ],
  );
}
