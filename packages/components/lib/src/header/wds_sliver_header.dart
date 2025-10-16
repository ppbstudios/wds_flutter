part of '../../wds_components.dart';

/// A sliver app bar that displays a header, designed to be used in a [CustomScrollView].
///
/// This widget is a sliver version of [WdsHeader] and uses [SliverPersistentHeader]
/// to display a header that can be pinned at the top of the viewport.
///
/// By default, it respects the top [SafeArea] by padding its content, while the
/// background color fills the entire space. This behavior can be disabled
/// by setting [safeArea] to `false`.
class WdsSliverHeader extends StatelessWidget {
  const WdsSliverHeader._({
    required this.leading,
    required this.title,
    required this.actions,
    required this.hasCenterTitle,
    required this.isLogo,
    required this.isSearch,
    required this.pinned,
    required this.floating,
    required this.safeArea,
    super.key,
  });

  /// Creates a logo header.
  WdsSliverHeader.logo({
    List<Widget> actions = const [],
    bool pinned = true,
    bool floating = false,
    bool safeArea = true,
    Key? key,
  }) : this._(
          leading: null,
          title: WdsIcon.wincLogo.build(width: 62, height: 17),
          actions: actions,
          hasCenterTitle: false,
          isLogo: true,
          isSearch: false,
          pinned: pinned,
          floating: floating,
          safeArea: safeArea,
          key: key,
        );

  /// Creates a title header.
  const WdsSliverHeader.title({
    required Widget title,
    Widget? leading,
    List<Widget> actions = const [],
    bool pinned = true,
    bool floating = false,
    bool safeArea = true,
    Key? key,
  }) : this._(
          leading: leading,
          title: title,
          actions: actions,
          hasCenterTitle: true,
          isLogo: false,
          isSearch: false,
          pinned: pinned,
          floating: floating,
          safeArea: safeArea,
          key: key,
        );

  /// Creates a search header.
  factory WdsSliverHeader.search({
    required Widget title,
    Widget? leading,
    List<Widget> actions = const [],
    bool pinned = true,
    bool floating = false,
    bool safeArea = true,
    Key? key,
  }) {
    assert(actions.length <= 1, 'actions can have at most 1 item.');
    return WdsSliverHeader._(
      leading: leading,
      title: title,
      actions: actions,
      hasCenterTitle: true,
      isLogo: false,
      isSearch: true,
      pinned: pinned,
      floating: floating,
      safeArea: safeArea,
      key: key,
    );
  }

  final Widget? leading;
  final Widget title;
  final List<Widget> actions;
  final bool hasCenterTitle;
  final bool isLogo;
  final bool isSearch;

  /// Whether the header should remain visible at the start of the scroll view.
  final bool pinned;

  /// Whether the header should immediately appear when scrolling down.
  final bool floating;

  /// Whether to add padding to avoid the top safe area. Defaults to true.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        safeArea ? MediaQuery.of(context).padding.top : 0.0;

    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: _WdsSliverHeaderDelegate(
        leading: leading,
        title: title,
        actions: actions,
        hasCenterTitle: hasCenterTitle,
        isLogo: isLogo,
        isSearch: isSearch,
        statusBarHeight: statusBarHeight,
      ),
    );
  }
}

class _WdsSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _WdsSliverHeaderDelegate({
    required this.leading,
    required this.title,
    required this.actions,
    required this.hasCenterTitle,
    required this.isLogo,
    required this.isSearch,
    required this.statusBarHeight,
  });

  final Widget? leading;
  final Widget title;
  final List<Widget> actions;
  final bool hasCenterTitle;
  final bool isLogo;
  final bool isSearch;
  final double statusBarHeight;

  @override
  double get minExtent => WdsHeader.fixedSize.height + statusBarHeight;

  @override
  double get maxExtent => WdsHeader.fixedSize.height + statusBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    Widget titleWidget = title;
    if (titleWidget is Text) {
      final Text t = titleWidget;
      final TextStyle merged = t.style?.merge(WdsHeader.fixedTypography) ??
          WdsHeader.fixedTypography;
      titleWidget = Text(
        t.data ?? '',
        key: t.key,
        style: merged,
        strutStyle: t.strutStyle,
        textAlign: t.textAlign,
        textDirection: t.textDirection,
        locale: t.locale,
        softWrap: t.softWrap,
        overflow: t.overflow,
        textScaler: t.textScaler,
        maxLines: 1,
        semanticsLabel: t.semanticsLabel,
        textWidthBasis: t.textWidthBasis,
        textHeightBehavior: t.textHeightBehavior,
        selectionColor: t.selectionColor,
      );
    } else {
      titleWidget = DefaultTextStyle.merge(
        style: WdsHeader.fixedTypography,
        child: titleWidget,
      );
    }

    final Widget? leadingWidget = isLogo ? null : leading;

    final Widget actionsArea = actions.isEmpty
        ? const SizedBox.square(dimension: 40)
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: actions
                .map((w) => SizedBox.square(dimension: 40, child: w))
                .toList(),
          );

    final Widget headerContent = SizedBox(
      height: WdsHeader.fixedSize.height,
      child: Padding(
        padding: WdsHeader.fixedPadding,
        child: Stack(
          children: [
            if (!isLogo)
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox.square(
                  dimension: 40,
                  child: leadingWidget ?? const SizedBox.shrink(),
                ),
              ),
            Align(
              alignment:
                  hasCenterTitle ? Alignment.center : Alignment.centerLeft,
              child: switch ((isSearch, isLogo)) {
                (true, _) =>
                  FractionallySizedBox(widthFactor: 0.567, child: titleWidget),
                (false, true) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: titleWidget,
                  ),
                (false, false) => titleWidget,
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: actionsArea,
            ),
          ],
        ),
      ),
    );

    return ColoredBox(
      color: WdsHeader.fixedBackground,
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: headerContent,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _WdsSliverHeaderDelegate oldDelegate) {
    return leading != oldDelegate.leading ||
        title != oldDelegate.title ||
        !listEquals(actions, oldDelegate.actions) ||
        hasCenterTitle != oldDelegate.hasCenterTitle ||
        isLogo != oldDelegate.isLogo ||
        isSearch != oldDelegate.isSearch ||
        statusBarHeight != oldDelegate.statusBarHeight;
  }
}
