part of '../../wds_components.dart';

/// 앱 상단에 위치하는 헤더. `PreferredSizeWidget` 구현으로 AppBar 대체 가능
class WdsHeader extends StatelessWidget implements PreferredSizeWidget {
  // 고정 스펙
  static const Size fixedSize = Size(double.infinity, 50);
  static const EdgeInsets fixedPadding = EdgeInsets.fromLTRB(16, 5, 16, 5);
  static const TextStyle fixedTypography = WdsSemanticTypography.heading17Bold;
  static const Color fixedBackground = WdsSemanticColorBackgroud.normal;

  // 공통 생성자 (private), named constructors 로만 생성
  const WdsHeader._({
    required this.leading,
    required this.title,
    required this.actions,
    required this.hasCenterTitle,
    Key? key,
  }) : super(key: key);

  /// 로고 헤더: leading 은 WINC 로고, 가운데 정렬 아님, title 없음
  WdsHeader.logo({
    List<Widget> actions = const [],
    Key? key,
  }) : this._(
          leading: WdsIcon.wincLogo.build(width: 24, height: 24),
          title: null,
          actions: actions,
          hasCenterTitle: false,
          key: key,
        );

  /// 타이틀 헤더: title 필수, leading 유무에 따라 가운데 정렬 여부 결정
  WdsHeader.title({
    required Widget title,
    Widget? leading,
    List<Widget> actions = const [],
    Key? key,
  }) : this._(
          leading: leading,
          title: title,
          actions: actions,
          hasCenterTitle: leading == null,
          key: key,
        );

  /// 검색 헤더: title 자리에 SearchField 등, 가운데 정렬, actions 최대 1개
  factory WdsHeader.search({
    required Widget title,
    Widget? leading,
    List<Widget> actions = const [],
    Key? key,
  }) {
    assert(actions.length <= 1, 'actions 는 최대 1개만 추가할 수 있습니다.');
    return WdsHeader._(
      leading: leading,
      title: title,
      actions: actions,
      hasCenterTitle: leading == null,
      key: key,
    );
  }

  final Widget? leading;
  final Widget? title;
  final List<Widget> actions;
  final bool hasCenterTitle;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    // Text 타입 title 에 고정 타이포 적용
    Widget? titleWidget = title;
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
        textScaleFactor: t.textScaleFactor,
        maxLines: 1,
        semanticsLabel: t.semanticsLabel,
        textWidthBasis: t.textWidthBasis,
        textHeightBehavior: t.textHeightBehavior,
        selectionColor: t.selectionColor,
      );
    } else if (titleWidget != null) {
      titleWidget = DefaultTextStyle.merge(
        style: fixedTypography,
        child: titleWidget,
      );
    }

    // leading 은 전달된 값 사용. hasCenterTitle 은 생성자에서 leading 유무로 결정
    final Widget? leadingWidget = leading;

    // actions: 오른쪽 정렬, 최대 3개 권장. 빈 리스트면 표시 안 함
    final Widget? actionsRow = actions.isEmpty
        ? null
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: actions,
          );

    // 레이아웃: padding 내에서 leading - title - actions 배치
    final Widget content = SizedBox(
      height: preferredSize.height,
      child: Padding(
        padding: fixedPadding,
        child: Stack(
          children: [
            if (leadingWidget != null)
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: leadingWidget,
                ),
              ),
            if (titleWidget != null)
              Align(
                alignment:
                    hasCenterTitle ? Alignment.center : Alignment.centerLeft,
                child: titleWidget,
              ),
            if (actionsRow != null)
              Align(
                alignment: Alignment.centerRight,
                child: actionsRow,
              ),
          ],
        ),
      ),
    );

    return ColoredBox(
      color: fixedBackground,
      child: content,
    );
  }
}
