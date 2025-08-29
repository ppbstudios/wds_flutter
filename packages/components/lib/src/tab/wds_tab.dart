part of '../../wds_components.dart';

enum WdsTextTabState { enabled, focused, featured }

/// 가로 스크롤 가능한 텍스트 탭
class WdsTextTabs extends StatelessWidget {
  const WdsTextTabs({
    required this.tabs,
    required this.currentIndex,
    this.featuredColors = const {},
    this.onTap,
    super.key,
  });

  final List<String> tabs;

  final int currentIndex;

  final ValueChanged<int>? onTap;

  final Map<int, Color> featuredColors;

  TextStyle _styleFor(WdsTextTabState state, int index) {
    return switch (state) {
      WdsTextTabState.enabled =>
        WdsSemanticTypography.body15NormalMedium.copyWith(
          color: WdsSemanticColorText.alternative,
        ),
      WdsTextTabState.focused ||
      WdsTextTabState.featured =>
        WdsSemanticTypography.body15NormalBold.copyWith(
          color: featuredColors[index] ?? WdsSemanticColorText.normal,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isFocused = index == currentIndex;
          final state =
              isFocused ? WdsTextTabState.focused : WdsTextTabState.enabled;
          final style = _styleFor(state, index);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap?.call(index),
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Text(
                tabs[index],
                style: style,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 균등 너비 + 선택 탭에 언더라인이 표시되는 탭
class WdsLineTabs extends StatelessWidget {
  const WdsLineTabs({
    required this.tabs,
    required this.currentIndex,
    this.onTap,
    super.key,
  }) : assert(tabs.length == 2 || tabs.length == 3);

  final List<String> tabs;

  final int currentIndex;

  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44 + 2, // 최대 인디케이터 두께 고려
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < tabs.length; i++) _buildItem(i),
        ],
      ),
    );
  }

  Expanded _buildItem(int index) {
    final isSelected = index == currentIndex;

    final labelStyle = isSelected
        ? WdsSemanticTypography.body15ReadingBold.copyWith(
            color: WdsSemanticColorText.normal,
          )
        : WdsSemanticTypography.body15ReadingMedium.copyWith(
            color: WdsSemanticColorText.neutral,
          );

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap?.call(index),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 기본 언더라인(모든 탭)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 1,
              child: ColoredBox(color: WdsSemanticColorBorder.alternative),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 11, 16, 10),
                child: Text(tabs[index], style: labelStyle),
              ),
            ),
            if (isSelected)
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 2,
                  child: ColoredBox(color: WdsColorCommon.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
