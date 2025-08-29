part of '../../wds_components.dart';

enum WdsSelectVariant { normal, blocked }

/// 드롭다운 Select
/// - padding: EdgeInsets.fromLTRB(16, 12, 16, 12)
/// - radius: WdsAtomicRadius.v8
/// - border: 1px solid WdsSemanticColorBorder.alternative
/// - hintText padding: 상하 2px, 확장 상태와 무관
/// - 아이콘: 닫힘 chevronDown, 열림 chevronUp (텍스트와 10px 간격)
class WdsSelect extends StatefulWidget {
  const WdsSelect({
    required this.selected,
    required this.hintText,
    this.title,
    this.isEnabled = true,
    this.isExpanded = false,
    this.onTap,
    this.variant = WdsSelectVariant.normal,
    Key? key,
  }) : super(key: key);

  const WdsSelect.blocked({
    required this.selected,
    required this.hintText,
    this.title,
    this.isEnabled = true,
    this.isExpanded = false,
    this.onTap,
    Key? key,
  })  : variant = WdsSelectVariant.blocked,
        super(key: key);

  /// 좌측 상단 "주제"
  ///
  /// null이거나 빈 문자열인 경우 표시되지 않음
  final String? title;

  /// 선택된 값 표기
  final String? selected;

  /// 선택 값 미지정 시 노출 텍스트
  final String hintText;

  final bool isEnabled;

  /// 목록 펼침 상태(아이콘 전환용)
  final bool isExpanded;

  /// 셀 탭 콜백
  final VoidCallback? onTap;

  final WdsSelectVariant variant;

  @override
  State<WdsSelect> createState() => _WdsSelectState();
}

class _WdsSelectState extends State<WdsSelect> {
  @override
  Widget build(BuildContext context) {
    final titleStyle = WdsSemanticTypography.body14NormalRegular.copyWith(
      color: _titleColor(),
    );

    final optionStyle = WdsSemanticTypography.body14NormalRegular.copyWith(
      color: _textColor(),
    );

    final decoration = ShapeDecoration(
      color: _backgroundColor(),
      shape: RoundedRectangleBorder(
        borderRadius:
            const BorderRadius.all(Radius.circular(WdsAtomicRadius.v8)),
        side: _borderSide(),
      ),
    );

    const contentPadding = EdgeInsets.fromLTRB(16, 12, 16, 12);

    final arrowIcon =
        (widget.isExpanded ? WdsIcon.chevronUp : WdsIcon.chevronDown).build(
      color: WdsColorNeutral.v500,
    );

    final field = Padding(
      padding: contentPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                widget.selected ?? widget.hintText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: optionStyle,
              ),
            ),
          ),
          arrowIcon,
        ],
      ),
    );

    final core = DecoratedBox(
      decoration: decoration,
      child: field,
    );

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        if (widget.title?.isNotEmpty == true)
          Text(widget.title!, style: titleStyle),
        core,
      ],
    );

    final result = IgnorePointer(
      ignoring: !widget.isEnabled,
      child: GestureDetector(onTap: widget.onTap, child: column),
    );

    return result;
  }

  Color _titleColor() {
    return (!widget.isEnabled && widget.variant == WdsSelectVariant.blocked)
        ? WdsSemanticColorText.disable
        : WdsSemanticColorText.normal;
  }

  Color _textColor() {
    if (!widget.isEnabled) {
      return WdsSemanticColorText.disable;
    }

    if (widget.variant == WdsSelectVariant.blocked) {
      return WdsSemanticColorText.alternative;
    }

    return WdsSemanticColorText.normal;
  }

  Color _backgroundColor() {
    return switch (widget.variant) {
      WdsSelectVariant.normal => WdsColorCommon.white,
      WdsSelectVariant.blocked => WdsColorNeutral.v50,
    };
  }

  BorderSide _borderSide() {
    return switch (widget.variant) {
      WdsSelectVariant.normal => const BorderSide(color: primary),
      WdsSelectVariant.blocked =>
        const BorderSide(color: WdsSemanticColorBorder.alternative),
    };
  }
}
