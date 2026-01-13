part of '../../wds_components.dart';

/// WdsSelect 컴포넌트의 상태
enum WdsSelectState {
  /// 기본 비활성 상태 (포커스 없음)
  inactive(
    titleColor: WdsColors.textAlternative,
    textColor: WdsColors.textAlternative,
    iconColor: WdsColors.neutral600,
    backgroundColor: WdsColors.white,
    borderSide: BorderSide(color: WdsColors.borderAlternative),
  ),

  /// 포커스 또는 호버 상태
  active(
    titleColor: WdsColors.textNormal,
    textColor: WdsColors.textNormal,
    iconColor: WdsColors.neutral600,
    backgroundColor: WdsColors.white,
    borderSide: BorderSide(color: WdsColors.primary),
  ),

  /// 드롭다운이 펼쳐진 상태 (active + isExpanded)
  selected(
    titleColor: WdsColors.textNormal,
    textColor: WdsColors.textNormal,
    iconColor: WdsColors.neutral600,
    backgroundColor: WdsColors.white,
    borderSide: BorderSide(color: WdsColors.primary),
  ),

  /// 비활성화 상태 (사용 불가)
  disabled(
    titleColor: WdsColors.textDisable,
    textColor: WdsColors.textDisable,
    iconColor: WdsColors.neutral100,
    backgroundColor: WdsColors.neutral50,
    borderSide: BorderSide(color: WdsColors.borderAlternative),
  )
  ;

  const WdsSelectState({
    required this.titleColor,
    required this.textColor,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderSide,
  });

  final Color titleColor;
  final Color textColor;
  final Color iconColor;
  final Color backgroundColor;
  final BorderSide borderSide;
}
