part of '../../wds_components.dart';

enum WdsDividerVariant { normal, thick }

/// 시각적 구분을 위한 선(line) 컴포넌트
/// - color: WdsColors.borderAlternative (고정)
/// - 가로(normal/thick), 세로(normal 고정)
class WdsDivider extends StatelessWidget {
  const WdsDivider({
    this.variant = WdsDividerVariant.normal,
    super.key,
  }) : isVertical = false;

  const WdsDivider.vertical({
    this.variant = WdsDividerVariant.normal,
    super.key,
  })  : isVertical = true,
        assert(
          variant == WdsDividerVariant.normal,
          '세로 Divider는 normal variant만 지원합니다.',
        );

  final WdsDividerVariant variant;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      // 세로: width 1px, height 32px (고정)
      return const SizedBox(
        width: 1,
        height: 32,
        child: DecoratedBox(
          decoration: BoxDecoration(color: WdsColors.borderAlternative),
        ),
      );
    }

    // 가로: width infinity, height variant 에 따라 1px | 6px
    final double height = switch (variant) {
      WdsDividerVariant.normal => 1,
      WdsDividerVariant.thick => 6,
    };

    return SizedBox(
      width: double.infinity,
      height: height,
      child: const DecoratedBox(
        decoration: BoxDecoration(color: WdsColors.borderAlternative),
      ),
    );
  }
}
