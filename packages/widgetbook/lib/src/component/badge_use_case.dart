import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Badge',
  type: Badge,
  path: '[component]/',
)
Widget buildWdsBadgeUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Badge',
    description:
        '정보의 개수를 강조하기 위해 사용합니다. 장바구니 아이템, 알림 등 개수에 대한 표기가 필요한 경우에 활용합니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final count = context.knobs.int.input(
    label: 'count',
    description: 'Badge에 표기할 개수를 입력해 주세요.\n\u2022 \'0\'은 표기되지 않아요',
    initialValue: 6,
  );

  final icon = context.knobs.object.dropdown<WdsIcon>(
    label: 'icon',
    description: 'Badge가 붙을 아이콘을 선택하세요',
    initialOption: WdsIcon.cart,
    options: WdsIcon.values,
    labelBuilder: (v) => v.name,
  );

  return WidgetbookPlayground(
    child: icon.build().addBadge(count: count),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Badge',
    children: [
      WidgetbookSubsection(
        title: 'range',
        labels: ['0', '1-9', '10-99', '100+'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsIcon.cart.build().addBadge(count: 0),
            const SizedBox(width: 16),
            WdsIcon.cart.build().addBadge(count: 3),
            const SizedBox(width: 16),
            WdsIcon.cart.build().addBadge(count: 99),
            const SizedBox(width: 16),
            WdsIcon.cart.build().addBadge(count: 150),
          ],
        ),
      ),
      const SizedBox(height: 32),
      const WidgetbookSubsection(
        title: 'count',
        labels: ['1', '99', '99+'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsBadge(count: 1),
            SizedBox(width: 16),
            WdsBadge(count: 99),
            SizedBox(width: 16),
            WdsBadge(count: 150),
          ],
        ),
      ),
    ],
  );
}
