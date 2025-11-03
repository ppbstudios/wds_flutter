import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'CountPagination',
  type: PaginationCount,
  path: '[component]/',
)
Widget buildCountPaginationUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'PaginationCount',
    description: '페이지 번호를 숫자 형태로 표시하는 페이지네이션 컴포넌트입니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final size = context.knobs.object.dropdown(
    label: 'size',
    options: [
      WdsPaginationCountSize.small,
      WdsPaginationCountSize.medium,
    ],
    labelBuilder: (value) => value.name,
  );

  final currentPage = context.knobs.int.input(
    label: 'Current',
    initialValue: 3,
    description: '현재 페이지 번호',
  );

  final totalPage = context.knobs.int.input(
    label: 'Total',
    initialValue: 10,
    description: '전체 페이지 수',
  );

  return WidgetbookPlayground(
    info: [
      'size: ${size.name}',
      'currentPage: $currentPage',
      'totalPage: $totalPage',
    ],
    child: WdsCountPagination(
      size: size,
      currentPage: currentPage,
      totalPage: totalPage,
    ),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'WdsPaginationCount',
    children: [
      WidgetbookSubsection(
        title: 'size',
        labels: ['small', 'medium'],
        content: Column(
          spacing: 20,
          children: [
            WdsCountPagination(
              currentPage: 1,
              totalPage: 10,
              size: WdsPaginationCountSize.small,
            ),
            WdsCountPagination(
              currentPage: 1,
              totalPage: 100,
            ),
          ],
        ),
      ),
    ],
  );
}
