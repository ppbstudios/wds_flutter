part of '../../wds_components.dart';

class WdsMaterialTabController extends TabController {
  WdsMaterialTabController({required super.length, required super.vsync});
}

/// Material TabBar styled like WdsTextTabs
/// - Horizontal scrolling
/// - Custom padding between tabs
/// - Uses WdsTextTab styling (enabled variant)
///
/// You can use either:
/// - Tab(text: 'label') for simple text tabs
/// - WdsTextTab(label: 'label') for tabs with badge support
class WdsMaterialTextTabBar extends TabBar {
  WdsMaterialTextTabBar({
    required TabController super.controller,
    required super.tabs,
    super.onTap,
    super.key,
  }) : super(
         isScrollable: true,
         tabAlignment: TabAlignment.start,
         padding: const EdgeInsets.symmetric(vertical: 8),
         indicatorColor: Colors.transparent,
         dividerColor: Colors.transparent,
         overlayColor: WidgetStateProperty.all(Colors.transparent),
         splashFactory: NoSplash.splashFactory,
         labelPadding: EdgeInsets.zero,
         labelStyle: WdsTypography.body15NormalBold.copyWith(
           color: WdsColors.textNormal,
         ),
         unselectedLabelStyle: WdsTypography.body15NormalMedium.copyWith(
           color: WdsColors.textAlternative,
         ),
       );

  @override
  State<WdsMaterialTextTabBar> createState() => _WdsMaterialTextTabBarState();
}

class _WdsMaterialTextTabBarState extends State<WdsMaterialTextTabBar> {
  @override
  Widget build(BuildContext context) {
    final tabs = widget.tabs;
    final controller = widget.controller!;

    return SizedBox(
      height: 38,
      child: TabBar(
        controller: controller,
        tabs: [
          for (var i = 0; i < tabs.length; i++)
            Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? 16 : 10,
                right: i == tabs.length - 1 ? 16 : 10,
              ),
              child: tabs[i],
            ),
        ],
        onTap: widget.onTap,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(vertical: 8),
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        labelPadding: EdgeInsets.zero,
        labelStyle: WdsTypography.body15NormalBold.copyWith(
          color: WdsColors.textNormal,
        ),
        unselectedLabelStyle: WdsTypography.body15NormalMedium.copyWith(
          color: WdsColors.textAlternative,
        ),
      ),
    );
  }
}

/// Material TabBar styled like WdsLineTabs
/// - Equal width tabs
/// - Underline indicator on selected tab
/// - Bottom border on all tabs
class WdsMaterialLineTabBar extends TabBar {
  WdsMaterialLineTabBar({
    required TabController super.controller,
    required super.tabs,
    super.onTap,
    super.key,
  }) : super(
         isScrollable: false,
         indicatorColor: WdsColors.black,
         indicatorWeight: 2,
         indicatorSize: TabBarIndicatorSize.tab,
         dividerColor: WdsColors.borderAlternative,
         dividerHeight: 1,
         overlayColor: WidgetStateProperty.all(Colors.transparent),
         splashFactory: NoSplash.splashFactory,
         labelPadding: const EdgeInsets.fromLTRB(0, 11, 0, 10),
         labelStyle: WdsTypography.body15ReadingBold.copyWith(
           color: WdsColors.textNormal,
         ),
         unselectedLabelStyle: WdsTypography.body15ReadingMedium.copyWith(
           color: WdsColors.textNeutral,
         ),
       );
}
