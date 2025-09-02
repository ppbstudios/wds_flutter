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
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final currentPage = context.knobs.int.input(
    label: 'currentPage',
    initialValue: 3,
    description: '현재 페이지 번호 (1부터 시작)',
  );

  final totalPage = context.knobs.int.input(
    label: 'totalPage',
    initialValue: 10,
    description: '전체 페이지 수',
  );

  return WidgetbookPlayground(
    info: [
      'currentPage: $currentPage',
      'totalPage: $totalPage',
    ],
    child: WdsCountPagination(
      currentPage: currentPage,
      totalPage: totalPage,
    ),
  );
}
