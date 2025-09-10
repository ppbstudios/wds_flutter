part of '../../wds_components.dart';

class WdsTag extends StatelessWidget {
  /// 기본값은 `normal`
  const WdsTag({
    required this.label,
    this.backgroundColor = WdsColors.neutral50,
    this.color = WdsColors.textNeutral,
    super.key,
  });

  const WdsTag.normal({
    required this.label,
    super.key,
  })  : backgroundColor = WdsColors.neutral50,
        color = WdsColors.textNeutral;

  const WdsTag.filled({
    required this.label,
    super.key,
  })  : backgroundColor = WdsColors.primary,
        color = WdsColors.white;

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fixedHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: fixedBorderRadius,
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
