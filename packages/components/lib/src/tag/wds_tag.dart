part of '../../wds_components.dart';

class WdsTag extends StatelessWidget {
  /// 기본값은 `normal`
  const WdsTag({
    required this.label,
    this.backgroundColor = WdsColors.neutral50,
    this.color = WdsColors.textNeutral,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : borderColor = null;

  const WdsTag.normal({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : backgroundColor = WdsColors.neutral50,
       color = WdsColors.textNeutral,
       borderColor = null;

  const WdsTag.filled({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : backgroundColor = WdsColors.primary,
       color = WdsColors.white,
       borderColor = null;

  /// 자주쓰이는 컴포넌트: NEW
  const WdsTag.$new({super.key})
    : label = 'NEW',
      borderColor = null,
      color = WdsColors.white,
      backgroundColor = WdsColors.coolNeutral700,
      hasRadius = false,
      leadingIcon = null;

  const WdsTag.$sale({super.key})
    : label = 'SALE',
      borderColor = null,
      color = WdsColors.white,
      backgroundColor = WdsColors.secondary,
      hasRadius = false,
      leadingIcon = null;

  const WdsTag.$best({super.key})
    : label = 'BEST',
      borderColor = null,
      color = WdsColors.white,
      backgroundColor = WdsColors.coolNeutral700,
      hasRadius = false,
      leadingIcon = null;

  const WdsTag.$coupon({super.key})
    : label = '쿠폰사용가능',
      borderColor = null,
      color = WdsColors.white,
      backgroundColor = WdsColors.secondary,
      hasRadius = false,
      leadingIcon = null;

  /// 종료⋅완료: neutral/50 배경 + text/neutral 글자
  const WdsTag.$soldOut({super.key})
    : label = '일시품절',
      color = WdsColors.textNeutral,
      backgroundColor = WdsColors.neutral50,
      borderColor = null,
      hasRadius = true,
      leadingIcon = null;

  /// 정보 속성: white 배경 + border/neutral 테두리 + text/neutral 글자
  const WdsTag.$myPower({super.key})
    : label = '내 도수보유',
      color = WdsColors.textNeutral,
      backgroundColor = WdsColors.white,
      borderColor = WdsColors.borderNeutral,
      hasRadius = true,
      leadingIcon = null;

  /// 서비스 속성: 윙크 primary(blue/400) 채움 + white 글자
  const WdsTag.$barodrim({super.key})
    : label = '바로드림',
      borderColor = null,
      color = WdsColors.white,
      backgroundColor = WdsColors.primary,
      hasRadius = true,
      leadingIcon = null;

  /// 정보 속성: white 배경 + border/neutral 테두리 + text/neutral 글자
  const WdsTag.$upto2days({super.key})
    : label = '1~2일예상',
      color = WdsColors.textNeutral,
      backgroundColor = WdsColors.white,
      borderColor = WdsColors.borderNeutral,
      hasRadius = true,
      leadingIcon = null;

  static const double fixedHeight = 18;

  static const EdgeInsets fixedPadding = EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 2,
  );

  static const TextStyle fixedTypography = WdsTypography.caption10Medium;

  static const BorderRadius fixedBorderRadius = BorderRadius.all(
    Radius.circular(WdsRadius.radius4),
  );

  final Color backgroundColor;

  final Color color;

  /// 정보 속성 고정 Tag(`$myPower` · `$upto2days`)만 테두리를 그린다.
  final Color? borderColor;

  final String label;

  final bool hasRadius;

  final WdsIcon? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      this.label,
      style: fixedTypography.copyWith(color: color),
      textAlign: TextAlign.center,
    );

    final Widget child;
    if (leadingIcon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 1,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.5),
            child: SizedBox.square(
              dimension: 12,
              child: leadingIcon!.build(),
            ),
          ),
          label,
        ],
      );
    } else {
      child = label;
    }

    return Semantics(
      label: this.label,
      child: SizedBox(
      height: fixedHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: hasRadius ? fixedBorderRadius : null,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Padding(
          padding: fixedPadding,
          child: child,
        ),
      ),
    ),
    );
  }
}
