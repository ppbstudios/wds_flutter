part of '../../wds_components.dart';

enum WdsDividerVariant { normal, thick }

/// 시각적 구분을 위한 선(line) 컴포넌트
///
/// 반드시 부모 위젯에서 크기가 결정된 상태여야 합니다.
class WdsDivider extends StatelessWidget {
  const WdsDivider({
    this.variant = WdsDividerVariant.normal,
    super.key,
  }) : isVertical = false;

  const WdsDivider.vertical({
    this.variant = WdsDividerVariant.normal,
    super.key,
  }) : isVertical = true,
       assert(
         variant == WdsDividerVariant.normal,
         '세로 Divider는 normal variant만 지원합니다.',
       );

  final WdsDividerVariant variant;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return const SizedBox(
        width: 1,
        height: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(color: WdsColors.borderAlternative),
        ),
      );
    }

    return switch (variant) {
      WdsDividerVariant.normal => const SizedBox(
        width: double.infinity,
        height: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(color: WdsColors.borderAlternative),
        ),
      ),
      WdsDividerVariant.thick => const SizedBox(
        width: double.infinity,
        height: 6,
        child: DecoratedBox(
          decoration: BoxDecoration(color: WdsColors.backgroundAlternative),
        ),
      ),
    };
  }
}
