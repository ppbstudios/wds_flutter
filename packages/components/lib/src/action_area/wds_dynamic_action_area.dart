part of '../../wds_components.dart';

enum WdsDynamicActionAreaVariant {
  product,
  discount,
  checkbox,
  summary,
  chips,
}

/// 상단 보조 정보/컨트롤 + CTA로 구성되는 동적 액션 영역
/// - padding: EdgeInsets.all(16)
/// - border(top): 1px alternative
/// - background: white
class WdsDynamicActionArea extends StatelessWidget {
  const WdsDynamicActionArea({
    required this.variant,
    required this.cta,
    this.metaBuilder,
    Key? key,
  }) : super(key: key);

  /// variant별 상단 보조 한 줄을 구성하는 빌더
  /// 반환 위젯은 한 줄(Row/Wrap 등)로 구성하는 것을 권장
  final WidgetBuilder? metaBuilder;

  /// 하단 CTA 버튼 (xlarge, stretch)
  final WdsButton cta;

  final WdsDynamicActionAreaVariant variant;

  @override
  Widget build(BuildContext context) {
    final Widget top = metaBuilder?.call(context) ?? _defaultMeta(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: WdsColorCommon.white,
        border: Border(
          top: BorderSide(color: WdsSemanticColorBorder.alternative),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            top,
            Row(children: [Expanded(child: cta)]),
          ],
        ),
      ),
    );
  }

  Widget _defaultMeta(BuildContext context) {
    switch (variant) {
      case WdsDynamicActionAreaVariant.product:
        // 예시: 메타 2블록(좋아요/리뷰) - 실제 데이터는 metaBuilder로 전달 권장
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Row(
              spacing: 6,
              children: [
                WdsIcon.support.build(width: 20, height: 20),
                const Text(
                  '0000',
                  style: WdsSemanticTypography.caption12Regular,
                ),
              ],
            ),
            const Row(
              spacing: 6,
              children: [
                Text('리뷰', style: WdsSemanticTypography.body15NormalMedium),
                Text('0000', style: WdsSemanticTypography.caption12Regular),
              ],
            ),
          ],
        );
      case WdsDynamicActionAreaVariant.discount:
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            WdsIcon.download.build(
              width: 16,
              height: 16,
              color: WdsSemanticColorStatus.positive,
            ),
            const Text(
              '총 5,000원 할인 받았어요',
              style: WdsSemanticTypography.body13NormalRegular,
            ),
          ],
        );
      case WdsDynamicActionAreaVariant.checkbox:
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            _FakeCheckbox(),
            const Text('텍스트', style: WdsSemanticTypography.body15NormalRegular),
          ],
        );
      case WdsDynamicActionAreaVariant.summary:
        return const Row(
          children: [
            Expanded(
              child: Text(
                '요약',
                style: WdsSemanticTypography.body13NormalRegular,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('원', style: WdsSemanticTypography.body15ReadingBold),
          ],
        );
      case WdsDynamicActionAreaVariant.chips:
        return const Wrap(
          spacing: 8,
          children: [
            // 데모용 기본 칩들; 실제 사용 시 metaBuilder로 주입 권장
            _FakeChip('텍스트'),
            _FakeChip('텍스트'),
            _FakeChip('텍스트'),
            _FakeChip('텍스트'),
          ],
        );
    }
  }
}

/// 샘플 렌더링을 위한 간단한 체크박스 표시 (실제 Checkbox 위젯 미사용 규칙을 준수)
class _FakeCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: WdsSemanticColorBorder.alternative),
        borderRadius:
            const BorderRadius.all(Radius.circular(WdsAtomicRadius.v4)),
      ),
      child: const SizedBox(width: 16, height: 16),
    );
  }
}

class _FakeChip extends StatelessWidget {
  const _FakeChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: WdsSemanticColorBackgroud.alternative,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(WdsAtomicRadius.v8)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Text(label, style: WdsSemanticTypography.body13NormalMedium),
      ),
    );
  }
}
