import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'BottomNavigation',
  type: BottomNavigation,
  path: '[component]/',
)
Widget buildWdsBottomNavigationUseCase(BuildContext context) {
  final items = [
    const WdsBottomNavigationItem(
      activeIcon: WdsIcon.homeFilled,
      inactiveIcon: WdsIcon.home,
      label: '홈',
    ),
    const WdsBottomNavigationItem(
      activeIcon: WdsIcon.storeFilled,
      inactiveIcon: WdsIcon.store,
      label: '내 예약매장',
    ),
    const WdsBottomNavigationItem(
      activeIcon: WdsIcon.categoryFilled,
      inactiveIcon: WdsIcon.category,
      label: '카테고리',
    ),
    const WdsBottomNavigationItem(
      activeIcon: WdsIcon.likeFilled,
      inactiveIcon: WdsIcon.like,
      label: '좋아요',
    ),
    const WdsBottomNavigationItem(
      activeIcon: WdsIcon.myFilled,
      inactiveIcon: WdsIcon.my,
      label: '마이윙크',
    ),
  ];

  return WidgetbookPageLayout(
    title: 'BottomNavigation',
    description: '화면 하단에 위치한 내비게이션입니다.',
    children: [
      LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          return SizedBox(
            width: width,
            child: WidgetbookSubsection(
              title: 'active',
              labels: ['true', 'false'],
              content: _BottomNavigationDemo(items: items),
            ),
          );
        },
      ),
    ],
  );
}

class _BottomNavigationDemo extends StatefulWidget {
  const _BottomNavigationDemo({required this.items});

  final List<WdsBottomNavigationItem> items;

  @override
  State<_BottomNavigationDemo> createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<_BottomNavigationDemo> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WdsBottomNavigation(
      items: widget.items,
      currentIndex: _currentIndex,
      onTap: (i) {
        setState(() => _currentIndex = i);
        debugPrint('tap index: $i');
      },
    );
  }
}
