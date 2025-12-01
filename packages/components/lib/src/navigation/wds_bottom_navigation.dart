part of '../../wds_components.dart';

class WdsBottomNavigationItem {
  const WdsBottomNavigationItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });

  final WdsIcon activeIcon;
  final WdsIcon inactiveIcon;
  final String label;
}

/// 화면 하단 내비게이션. 높이 총 48 (상/하 패딩 1 + 아이템 45 + 상단 보더 1)
class WdsBottomNavigation extends StatelessWidget {
  const WdsBottomNavigation({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  }) : assert(items.length >= 2, '최소 2개 이상의 아이템이 필요합니다.');

  final List<WdsBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final int count = items.length;

    return SizedBox(
      height: 48,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: WdsColors.white,
          border: Border(
            top: BorderSide(color: WdsColors.borderAlternative),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(count, (index) {
              final item = items[index];
              final bool isActive = index == currentIndex;
              return Expanded(
                child: _BottomNavigationItemWidget(
                  item: item,
                  isActive: isActive,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationItemWidget extends StatelessWidget {
  const _BottomNavigationItemWidget({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final WdsBottomNavigationItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const inactiveTextStyle = WdsTypography.caption10Medium;

    final activeTextStyle = WdsTypography.caption10Bold.copyWith(
      color: WdsColors.cta,
    );

    final icon = isActive ? item.activeIcon : item.inactiveIcon;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 26,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            icon.build(width: 24, height: 24),
            Text(
              item.label,
              style: isActive ? activeTextStyle : inactiveTextStyle,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
