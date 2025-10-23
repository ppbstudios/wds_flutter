part of '../../wds_components.dart';

/// 드롭다운 Select
/// - padding: EdgeInsets.fromLTRB(16, 12, 16, 12)
/// - radius: WdsRadius.sm
/// - border: 1px solid WdsColors.borderAlternative
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
    this.borderColor,
    super.key,
  });

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

  /// 테두리 색상
  final Color? borderColor;

  @override
  State<WdsSelect> createState() => _WdsSelectState();
}

class _WdsSelectState extends State<WdsSelect> {
  @override
  Widget build(BuildContext context) {
    final titleStyle = WdsTypography.body14NormalRegular.copyWith(
      color: _titleColor(),
    );

    final optionStyle = WdsTypography.body14NormalRegular.copyWith(
      color: _textColor(),
    );

    final borderSide = _borderSide();
    const radius = Radius.circular(WdsRadius.radius8);

    final decoration = BoxDecoration(
      color: _backgroundColor(),
      border: Border(
        top: borderSide,
        left: borderSide,
        right: borderSide,
        bottom: widget.isExpanded ? BorderSide.none : borderSide,
      ),
      borderRadius: BorderRadius.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: widget.isExpanded ? Radius.zero : radius,
        bottomRight: widget.isExpanded ? Radius.zero : radius,
      ),
    );

    const contentPadding = EdgeInsets.fromLTRB(16, 12, 16, 12);

    final arrowIcon =
        (widget.isExpanded ? WdsIcon.chevronUp : WdsIcon.chevronDown).build(
      color: widget.isEnabled ? WdsColors.neutral600 : WdsColors.neutral100,
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
    if (!widget.isEnabled) {
      return WdsColors.textDisable;
    }

    return WdsColors.textNormal;
  }

  Color _textColor() {
    if (!widget.isEnabled) {
      return WdsColors.textDisable;
    }

    if (widget.selected?.isEmpty ?? true) {
      return WdsColors.textAlternative;
    }

    return WdsColors.textNormal;
  }

  Color _backgroundColor() {
    if (!widget.isEnabled) {
      return WdsColors.neutral50;
    }

    return WdsColors.white;
  }

  BorderSide _borderSide() {
    if (!widget.isEnabled) {
      return const BorderSide(color: WdsColors.borderAlternative);
    }

    return BorderSide(color: widget.borderColor ?? WdsColors.primary);
  }
}
