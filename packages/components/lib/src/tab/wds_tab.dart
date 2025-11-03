part of '../../wds_components.dart';

/// 탭의 기본 variant (enabled/featured)
enum WdsTextTabVariant {
  /// 기본 상태 - 비선택시: Medium + textAlternative, 선택시: Bold + textNormal
  enabled,

  /// 강조된 상태 - 비선택시: Bold + textNormal, 선택시: Bold + textNormal
  featured,
}

/// WdsTextTabs & WdsLineTabs의 컨트롤러
class WdsTabsController extends ChangeNotifier {
  WdsTabsController({
    required this.length,
    this.initialIndex = 0,
  }) : assert(length > 0),
       assert(initialIndex >= 0 && initialIndex < length);

  /// 탭의 개수
  final int length;

  /// 초기 선택된 인덱스
  final int initialIndex;

  int _index = 0;

  /// 현재 선택된 탭의 인덱스
  int get index => _index;

  /// 탭 인덱스 변경
  void setIndex(int newIndex) {
    assert(newIndex >= 0 && newIndex < length);
    if (_index != newIndex) {
      _index = newIndex;
      notifyListeners();
    }
  }
}

/// WdsTextTab의 테마 데이터 - variant와 선택 상태에 따른 스타일 정의
class WdsTextTabThemeData {
  const WdsTextTabThemeData({
    this.selectedIndex,
    this.currentTabIndex,
  });

  /// 현재 선택된 탭의 인덱스
  final int? selectedIndex;

  /// 현재 처리 중인 탭의 인덱스 (WdsTextTabs에서 설정)
  final int? currentTabIndex;

  /// 기본 스타일 가져오기
  static TextStyle getDefaultStyle(
    WdsTextTabVariant variant,
    bool isSelected,
  ) => switch ((variant, isSelected)) {
    (WdsTextTabVariant.enabled, false) =>
      WdsTypography.body15NormalMedium.copyWith(
        color: WdsColors.textAlternative,
      ),
    (WdsTextTabVariant.enabled, true) =>
      WdsTypography.body15NormalBold.copyWith(
        color: WdsColors.textNormal,
      ),
    (WdsTextTabVariant.featured, false) =>
      WdsTypography.body15NormalBold.copyWith(
        color: WdsColors.textNormal,
      ),
    (WdsTextTabVariant.featured, true) =>
      WdsTypography.body15NormalBold.copyWith(
        color: WdsColors.textNormal,
      ),
  };

  /// variant와 선택 상태에 따른 최종 스타일 계산
  TextStyle getStyle(
    WdsTextTabVariant variant,
    bool isSelected,
    Color? featuredColor,
  ) {
    final TextStyle baseStyle = getDefaultStyle(variant, isSelected);

    // featured variant이고 featuredColor가 있을 때만 색상 변경
    if (variant == WdsTextTabVariant.featured && featuredColor != null) {
      if (isSelected) {
        // 선택된 featured 탭은 focused 스타일 (Bold + textNormal)
        return baseStyle.copyWith(color: WdsColors.textNormal);
      } else {
        // 선택되지 않은 featured 탭은 featuredColor 적용
        return baseStyle.copyWith(color: featuredColor);
      }
    }

    return baseStyle;
  }

  WdsTextTabThemeData copyWith({
    int? selectedIndex,
    int? currentTabIndex,
  }) {
    return WdsTextTabThemeData(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WdsTextTabThemeData &&
        other.selectedIndex == selectedIndex &&
        other.currentTabIndex == currentTabIndex;
  }

  @override
  int get hashCode {
    return Object.hash(selectedIndex, currentTabIndex);
  }
}

/// WdsTextTab을 위한 InheritedTheme
class WdsTextTabTheme extends InheritedTheme {
  const WdsTextTabTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final WdsTextTabThemeData data;

  /// 현재 context에서 WdsTextTabTheme 가져오기
  static WdsTextTabThemeData of(BuildContext context) {
    final WdsTextTabTheme? theme = context
        .dependOnInheritedWidgetOfExactType<WdsTextTabTheme>();
    return theme?.data ?? const WdsTextTabThemeData();
  }

  @override
  bool updateShouldNotify(WdsTextTabTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return WdsTextTabTheme(data: data, child: child);
  }
}

/// WdsTextTab의 스타일을 처리하는 위젯 (Material의 _TabStyle과 유사)
class WdsTextTabStyle extends StatelessWidget {
  const WdsTextTabStyle({
    required this.variant,
    required this.isSelected,
    required this.featuredColor,
    required this.child,
    super.key,
  });

  final WdsTextTabVariant variant;
  final bool isSelected;
  final Color? featuredColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final WdsTextTabThemeData theme = WdsTextTabTheme.of(context);

    // 테마에서 최종 스타일 계산
    final TextStyle style = theme.getStyle(variant, isSelected, featuredColor);

    // DefaultTextStyle.merge를 사용하여 상위 스타일과 병합
    return DefaultTextStyle.merge(
      style: style,
      child: child,
    );
  }
}

/// WdsBadgeMixin을 사용하여 배지 기능을 추가한 텍스트 탭
/// InheritedTheme을 통해 variant와 선택 상태에 따른 스타일 적용
class WdsTextTab extends StatelessWidget with WdsBadgeMixin {
  const WdsTextTab({
    required this.label,
    this.featuredColor,
    this.badgeAlignment,
    super.key,
  }) : variant = featuredColor != null
           ? WdsTextTabVariant.featured
           : WdsTextTabVariant.enabled;

  /// 탭에 표시할 텍스트
  final String label;

  /// 탭의 기본 variant (enabled/featured)
  final WdsTextTabVariant variant;

  /// featured variant일 때 사용할 커스텀 색상 (비선택/선택 모두 적용)
  final Color? featuredColor;

  /// 탭 기준 배지의 정렬 위치
  final Alignment? badgeAlignment;

  @override
  Widget build(BuildContext context) {
    // InheritedTheme에서 테마 데이터 가져오기
    final WdsTextTabThemeData theme = WdsTextTabTheme.of(context);

    // 현재 탭이 선택되었는지 확인 (controller에서 관리)
    final bool isSelected =
        theme.selectedIndex != null &&
        theme.selectedIndex == theme.currentTabIndex;

    // WdsTextTabStyle을 사용하여 스타일 처리
    Widget textWidget = WdsTextTabStyle(
      variant: variant,
      isSelected: isSelected,
      featuredColor: featuredColor,
      child: Text(label),
    );

    // WdsBadgeMixin의 addDotBadge 메서드로 배지 기능 추가
    return buildWidgetWithDotBadge(
      child: textWidget,
      alignment: badgeAlignment,
    );
  }
}

/// 가로 스크롤 가능한 텍스트 탭 - InheritedTheme을 통한 선택 상태 관리
/// WdsTextTabTheme을 제공하여 enabled 탭들은 고정 스타일 사용
/// featured 탭들은 각자 개별적으로 featuredColor를 가질 수 있음
class WdsTextTabs extends StatefulWidget {
  const WdsTextTabs({
    required this.tabs,
    this.controller,
    this.onTap,
    super.key,
  });

  /// 표시할 탭들의 리스트
  final List<WdsTextTab> tabs;

  /// 탭 컨트롤러 (선택사항)
  final WdsTabsController? controller;

  /// 탭 선택 시 호출되는 콜백
  final ValueChanged<int>? onTap;

  @override
  State<WdsTextTabs> createState() => _WdsTextTabsState();
}

class _WdsTextTabsState extends State<WdsTextTabs> {
  late WdsTabsController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        WdsTabsController(
          length: widget.tabs.length,
        );
  }

  @override
  void didUpdateWidget(WdsTextTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller =
          widget.controller ??
          WdsTabsController(
            length: widget.tabs.length,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // WdsTextTabTheme 생성 - 선택된 인덱스와 현재 탭 인덱스 포함
        final WdsTextTabThemeData themeData = WdsTextTabThemeData(
          selectedIndex: _controller.index,
        );

        return WdsTextTabTheme(
          data: themeData,
          child: SizedBox(
            height: 38,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.tabs.length,
              itemBuilder: (context, index) {
                final WdsTextTab tab = widget.tabs[index];

                return WdsTextTabTheme(
                  data: themeData.copyWith(currentTabIndex: index),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _controller.setIndex(index);
                      widget.onTap?.call(index);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 16 : 10,
                        right: index == widget.tabs.length - 1 ? 16 : 10,
                      ),
                      child: tab,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// WdsLineTabs에서 사용할 개별 탭 데이터 클래스
class WdsLineTab {
  const WdsLineTab({
    required this.title,
    this.count,
  });

  /// 탭에 표시할 제목
  final String title;

  /// 탭에 표시할 카운트 (선택사항)
  final int? count;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WdsLineTab && other.title == title && other.count == count;
  }

  @override
  int get hashCode => Object.hash(title, count);
}

/// 균등 너비 + 선택 탭에 언더라인이 표시되는 탭
class WdsLineTabs extends StatefulWidget {
  const WdsLineTabs({
    required this.tabs,
    this.controller,
    this.onTap,
    super.key,
  });

  /// 표시할 탭들의 리스트
  final List<WdsLineTab> tabs;

  /// 탭 컨트롤러 (선택사항)
  final WdsTabsController? controller;

  /// 탭 선택 시 호출되는 콜백
  final ValueChanged<int>? onTap;

  @override
  State<WdsLineTabs> createState() => _WdsLineTabsState();
}

class _WdsLineTabsState extends State<WdsLineTabs> {
  late WdsTabsController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        WdsTabsController(
          length: widget.tabs.length,
        );
  }

  @override
  void didUpdateWidget(WdsLineTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller =
          widget.controller ??
          WdsTabsController(
            length: widget.tabs.length,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: 44 + 2, // 최대 인디케이터 두께 고려
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < widget.tabs.length; i++) _buildItem(i),
            ],
          ),
        );
      },
    );
  }

  Expanded _buildItem(int index) {
    final isSelected = index == _controller.index;
    final tab = widget.tabs[index];

    final labelStyle = isSelected
        ? WdsTypography.body15ReadingBold.copyWith(
            color: WdsColors.textNormal,
          )
        : WdsTypography.body15ReadingMedium.copyWith(
            color: WdsColors.textNeutral,
          );

    /// 최종 표시할 텍스트
    final displayText = tab.count != null
        ? '${tab.title}(${tab.count!.toFormat()})'
        : tab.title;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _controller.setIndex(index);
          widget.onTap?.call(index);
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 기본 언더라인(모든 탭)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 1,
              child: ColoredBox(color: WdsColors.borderAlternative),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 11, 0, 10),
                child: Text(displayText, style: labelStyle),
              ),
            ),
            if (isSelected)
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 2,
                  child: ColoredBox(color: WdsColors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
