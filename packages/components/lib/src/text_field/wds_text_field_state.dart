part of '../../wds_components.dart';

/// WdsTextField 컴포넌트의 상태
enum WdsTextFieldState {
  /// 기본 비활성 상태 (포커스 없음, 값 없음)
  inactive(
    labelColor: WdsColors.textAlternative,
    hintColor: WdsColors.textAlternative,
    borderColor: WdsColors.borderAlternative,
    helperColor: WdsColors.textAlternative,
    inputColor: WdsColors.textNormal,
    inputTextStyle: WdsTypography.body15NormalRegular,
  ),

  /// 포커스 상태
  focused(
    labelColor: WdsColors.textAlternative,
    hintColor: WdsColors.textNormal,
    borderColor: WdsColors.statusPositive,
    helperColor: WdsColors.textAlternative,
    inputColor: WdsColors.textNormal,
    inputTextStyle: WdsTypography.body15NormalMedium,
  ),

  /// 활성 상태 (포커스 없음, 값 있음)
  active(
    labelColor: WdsColors.textAlternative,
    hintColor: WdsColors.textNormal,
    borderColor: WdsColors.borderAlternative,
    helperColor: WdsColors.textAlternative,
    inputColor: WdsColors.textNormal,
    inputTextStyle: WdsTypography.body15NormalMedium,
  ),

  /// 에러 상태
  error(
    labelColor: WdsColors.textAlternative,
    hintColor: WdsColors.textNormal,
    borderColor: WdsColors.statusDestructive,
    helperColor: WdsColors.statusDestructive,
    inputColor: WdsColors.textNormal,
    inputTextStyle: WdsTypography.body15NormalMedium,
  ),

  /// 비활성화 상태 (사용 불가)
  disabled(
    labelColor: WdsColors.textDisable,
    hintColor: WdsColors.textDisable,
    borderColor: WdsColors.borderAlternative,
    helperColor: WdsColors.textDisable,
    inputColor: WdsColors.textDisable,
    inputTextStyle: WdsTypography.body15NormalRegular,
  )
  ;

  const WdsTextFieldState({
    required this.labelColor,
    required this.hintColor,
    required this.borderColor,
    required this.helperColor,
    required this.inputColor,
    required this.inputTextStyle,
  });

  final Color labelColor;
  final Color hintColor;
  final Color borderColor;
  final Color helperColor;
  final Color inputColor;
  final TextStyle inputTextStyle;
}
