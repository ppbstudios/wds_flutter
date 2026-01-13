part of '../../wds_components.dart';

/// 드롭다운 Select
/// - padding: EdgeInsets.fromLTRB(16, 12, 16, 12)
/// - radius: WdsRadius.sm
/// - height: 48px 고정
/// - 아이콘: 닫힘 chevronDown, 열림 chevronUp (텍스트와 10px 간격)
class WdsSelect extends StatelessWidget {
  const WdsSelect({
    required this.selected,
    required this.hintText,
    this.title,
    this.state = WdsSelectState.active,
    this.onTap,
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

  /// 컴포넌트 상태
  final WdsSelectState state;

  /// 셀 탭 콜백
  final VoidCallback? onTap;

  bool get _isExpanded => state == WdsSelectState.selected;

  bool get _isEnabled => state != WdsSelectState.disabled;

  @override
  Widget build(BuildContext context) {
    final titleStyle = WdsTypography.body14NormalRegular.copyWith(
      color: state.titleColor,
    );

    final optionStyle = WdsTypography.body14NormalRegular.copyWith(
      color: state.textColor,
    );

    final borderSide = state.borderSide;
    const radius = Radius.circular(WdsRadius.radius8);

    final decoration = BoxDecoration(
      color: state.backgroundColor,
      border: Border(
        top: borderSide,
        left: borderSide,
        right: borderSide,
        bottom: _isExpanded ? BorderSide.none : borderSide,
      ),
      borderRadius: BorderRadius.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: _isExpanded ? Radius.zero : radius,
        bottomRight: _isExpanded ? Radius.zero : radius,
      ),
    );

    final arrowIcon = (_isExpanded ? WdsIcon.chevronUp : WdsIcon.chevronDown)
        .build(
          color: state.iconColor,
        );

    final field = SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  selected ?? hintText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: optionStyle,
                ),
              ),
            ),
            arrowIcon,
          ],
        ),
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
        if (title?.isNotEmpty == true) Text(title!, style: titleStyle),
        core,
      ],
    );

    final result = IgnorePointer(
      ignoring: !_isEnabled,
      child: GestureDetector(onTap: onTap, child: column),
    );

    return result;
  }
}
