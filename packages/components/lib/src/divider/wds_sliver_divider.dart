part of '../../wds_components.dart';

/// 시각적 구분을 위한 선(line) 컴포넌트
/// [SliverToBoxAdapter]를 상속하여 일반 [Divider]를 Sliver 형태로 감싼 구조입니다.
///
/// 반드시 부모 위젯에서 크기가 결정된 상태여야 합니다.
class WdsSliverDivider extends StatelessWidget {
  const WdsSliverDivider({
    this.variant = WdsDividerVariant.normal,
    super.key,
  }) : isVertical = false;

  const WdsSliverDivider.vertical({
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
      return const SliverToBoxAdapter(
        child: WdsDivider.vertical(),
      );
    }

    return switch (variant) {
      WdsDividerVariant.normal => const SliverToBoxAdapter(
        child: WdsDivider(),
      ),
      WdsDividerVariant.thick => const SliverToBoxAdapter(
        child: WdsDivider(variant: WdsDividerVariant.thick),
      ),
    };
  }
}
