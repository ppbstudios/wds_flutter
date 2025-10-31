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
  });

  const WdsTag.normal({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  })  : backgroundColor = WdsColors.neutral50,
        color = WdsColors.textNeutral;

  const WdsTag.filled({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  })  : backgroundColor = WdsColors.primary,
        color = WdsColors.white;

  /// 자주쓰이는 컴포넌트: NEW
  const WdsTag.$new({super.key})
      : label = 'NEW',
        color = WdsColors.white,
        backgroundColor = WdsColors.primary,
        hasRadius = false,
        leadingIcon = null;

  const WdsTag.$sale({super.key})
      : label = 'SALE',
        color = WdsColors.white,
        backgroundColor = WdsColors.secondary,
        hasRadius = false,
        leadingIcon = null;

  const WdsTag.$best({super.key})
      : label = 'BEST',
        color = WdsColors.white,
        backgroundColor = WdsColors.coolNeutral700,
        hasRadius = false,
        leadingIcon = null;

  const WdsTag.$coupon({super.key})
      : label = '쿠폰사용가능',
        color = WdsColors.white,
        backgroundColor = WdsColors.secondary,
        hasRadius = false,
        leadingIcon = null;

  const WdsTag.$soldOut({super.key})
      : label = '일시품절',
        color = WdsColors.white,
        backgroundColor = WdsColors.coolNeutral300,
        hasRadius = true,
        leadingIcon = null;

  const WdsTag.$myPower({super.key})
      : label = '내 도수',
        color = WdsColors.textNeutral,
        backgroundColor = WdsColors.neutral50,
        hasRadius = true,
        leadingIcon = null;

  const WdsTag.$barodrim({super.key})
      : label = '바로드림',
        color = WdsColors.statusPositive,
        backgroundColor = WdsColors.neutral50,
        hasRadius = true,
        leadingIcon = null;

  const WdsTag.$upto2days({super.key})
      : label = '1~2일예상',
        color = WdsColors.textNeutral,
        backgroundColor = WdsColors.neutral50,
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

    return SizedBox(
      height: fixedHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: hasRadius ? fixedBorderRadius : null,
        ),
        child: Padding(
          padding: fixedPadding,
          child: child,
        ),
      ),
    );
  }
}
