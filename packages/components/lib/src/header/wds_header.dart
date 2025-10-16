part of '../../wds_components.dart';

/// 앱 상단에 위치하는 헤더. `PreferredSizeWidget` 구현으로 AppBar 대체 가능
class WdsHeader extends StatelessWidget implements PreferredSizeWidget {
  // 공통 생성자 (private), named constructors 로만 생성
  const WdsHeader._({
    required this.leading,
    required this.title,
    required this.actions,
    required this.hasCenterTitle,
    required this.isLogo,
    required this.isSearch,
    required this.safeArea,
    super.key,
  });

  /// 로고 헤더: leading 은 WINC 로고, 가운데 정렬 아님, title 없음
  WdsHeader.logo({
    List<Widget> actions = const [],
    bool safeArea = true,
    Key? key,
  }) : this._(
          leading: null,
          title: WdsIcon.wincLogo.build(width: 62, height: 17),
          actions: actions,
          hasCenterTitle: false,
          isLogo: true,
          isSearch: false,
          safeArea: safeArea,
          key: key,
        );

  /// 타이틀 헤더: title 필수, leading 유무에 따라 가운데 정렬 여부 결정
  const WdsHeader.title({
    required Widget title,
    Widget? leading,
    List<Widget> actions = const [],
    bool safeArea = true,
    Key? key,
  }) : this._(
          leading: leading,
          title: title,
          actions: actions,
          hasCenterTitle: true,
          isLogo: false,
          isSearch: false,
          safeArea: safeArea,
          key: key,
        );

  /// 검색 헤더: title 자리에 SearchField 등, 가운데 정렬, actions 최대 1개
  factory WdsHeader.search({
    required Widget title,
    Widget? leading,
    List<Widget> actions = const [],
    bool safeArea = true,
    Key? key,
  }) {
    assert(actions.length <= 1, 'actions 는 최대 1개만 추가할 수 있습니다.');
    return WdsHeader._(
      leading: leading,
      title: title,
      actions: actions,
      hasCenterTitle: true,
      isLogo: false,
      isSearch: true,
      safeArea: safeArea,
      key: key,
    );
  }
  // 고정 스펙
  static const Size fixedSize = Size(double.infinity, 50);
  static const EdgeInsets fixedPadding = EdgeInsets.fromLTRB(16, 5, 8, 5);
  static const TextStyle fixedTypography = WdsTypography.heading17Bold;
  static const Color fixedBackground = WdsColors.backgroundNormal;

  final Widget? leading;
  final Widget title;
  final List<Widget> actions;
  final bool hasCenterTitle;
  final bool isLogo;
  final bool isSearch;
  final bool safeArea;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight =
        safeArea ? MediaQuery.of(context).padding.top : 0.0;

    // Text 타입 title 에 고정 타이포 적용
    Widget titleWidget = title;
    if (titleWidget is Text) {
      final Text t = titleWidget;
      final TextStyle merged =
          t.style?.merge(fixedTypography) ?? fixedTypography;
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
        style: fixedTypography,
        child: titleWidget,
      );
    }

    // leading 은 전달된 값 사용. logo 변형이 아닌 경우 최소 40x40 영역 보장
    final Widget? leadingWidget = isLogo ? null : leading;

    // actions: 오른쪽 정렬, 최대 3개 권장. 빈 리스트면 표시 안 함
    final Widget actionsArea = actions.isEmpty
        ? const SizedBox.square(dimension: 40)
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: actions
                .map((w) => SizedBox.square(dimension: 40, child: w))
                .toList(),
          );

    // 레이아웃: padding 내에서 leading - title - actions 배치
    final Widget content = SizedBox(
      height: preferredSize.height,
      child: Padding(
        padding: fixedPadding,
        child: Stack(
          children: [
            // Leading 영역: logo 변형이면 표시하지 않음, 그 외 최소 40x40 확보
            if (!isLogo)
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox.square(
                  dimension: 40,
                  child: leadingWidget ?? const SizedBox.shrink(),
                ),
              ),

            // Title: 항상 전체 헤더 영역 기준으로 가운데 또는 좌측 정렬
            Align(
              alignment:
                  hasCenterTitle ? Alignment.center : Alignment.centerLeft,
              child: isSearch
                  ? FractionallySizedBox(
                      widthFactor: 0.567,
                      child: titleWidget,
                    )
                  : titleWidget,
            ),

            // Actions 영역: 비어있어도 최소 40x40 확보, 우측 정렬
            Align(
              alignment: Alignment.centerRight,
              child: actionsArea,
            ),
          ],
        ),
      ),
    );

    return ColoredBox(
      color: fixedBackground,
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: content,
      ),
    );
  }
}
