part of '../../wds_components.dart';

class WdsTag extends StatelessWidget {
  /// 기본값은 `normal`
  const WdsTag({
    required this.label,
    this.backgroundColor = WdsColors.neutral50,
    this.color = WdsColors.textNeutral,
    this.hasRadius = true,
    super.key,
  });

  const WdsTag.normal({
    required this.label,
    this.hasRadius = true,
    super.key,
  })  : backgroundColor = WdsColors.neutral50,
        color = WdsColors.textNeutral;

  const WdsTag.filled({
    required this.label,
    this.hasRadius = true,
    super.key,
  })  : backgroundColor = WdsColors.primary,
        color = WdsColors.white;

  /// 자주쓰이는 컴포넌트: NEW
  const WdsTag.$new({super.key})
      : label = 'NEW',
        color = WdsColors.white,
        backgroundColor = WdsColors.primary,
        hasRadius = false;

  const WdsTag.$sale({super.key})
      : label = 'SALE',
        color = WdsColors.white,
        backgroundColor = WdsColors.secondary,
        hasRadius = false;

  const WdsTag.$best({super.key})
      : label = 'BEST',
        color = WdsColors.white,
        backgroundColor = WdsColors.coolNeutral700,
        hasRadius = false;

  const WdsTag.$coupon({super.key})
      : label = '쿠폰사용가능',
        color = WdsColors.white,
        backgroundColor = WdsColors.secondary,
        hasRadius = false;

  static const double fixedHeight = 18;

  static const EdgeInsets fixedPadding = EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 3,
  );

  static const TextStyle fixedTypography = WdsTypography.caption10Medium;

  static const BorderRadius fixedBorderRadius = BorderRadius.all(
    Radius.circular(WdsRadius.xs),
  );

  final Color backgroundColor;

  final Color color;

  final String label;

  final bool hasRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fixedHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: hasRadius ? fixedBorderRadius : null,
        ),
        child: Padding(
          padding: fixedPadding,
          child: Text(
            label,
            style: fixedTypography.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
