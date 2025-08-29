part of '../../wds_components.dart';

enum WdsFixedActionAreaVariant { normal, filter, division }

/// 하단 고정 액션 영역
/// - height: 81
/// - padding: EdgeInsets.all(16)
/// - border(top): 1px alternative
/// - background: white
class WdsFixedActionArea extends StatelessWidget {
  WdsFixedActionArea.normal({
    required this.primary,
    super.key,
  })  : variant = WdsFixedActionAreaVariant.normal,
        secondary = null,
        assert(
          primary.size == WdsButtonSize.xlarge,
          'primary 버튼은 size xlarge 여야 합니다.',
        );

  WdsFixedActionArea.filter({
    required this.secondary,
    required this.primary,
    super.key,
  })  : variant = WdsFixedActionAreaVariant.filter,
        assert(secondary != null),
        assert(
          secondary!.variant == WdsButtonVariant.secondary,
          'filter 변형의 좌측 버튼은 secondary 여야 합니다.',
        ),
        assert(
          secondary!.size == WdsButtonSize.xlarge,
          '좌측 secondary 버튼은 size xlarge 여야 합니다.',
        ),
        assert(
          primary.size == WdsButtonSize.xlarge,
          'primary 버튼은 size xlarge 여야 합니다.',
        );

  WdsFixedActionArea.division({
    required this.secondary,
    required this.primary,
    super.key,
  })  : variant = WdsFixedActionAreaVariant.division,
        assert(secondary != null),
        assert(
          secondary!.variant == WdsButtonVariant.secondary,
          'division 변형의 좌측 버튼은 secondary 여야 합니다.',
        ),
        assert(
          secondary!.size == WdsButtonSize.xlarge,
          '좌측 secondary 버튼은 size xlarge 여야 합니다.',
        ),
        assert(
          primary.size == WdsButtonSize.xlarge,
          'primary 버튼은 size xlarge 여야 합니다.',
        );

  /// 좌측 보조 버튼 (.secondary, xlarge)
  final WdsButton? secondary;

  /// 우측 메인 CTA (xlarge)
  final WdsButton primary;

  final WdsFixedActionAreaVariant variant;

  @override
  Widget build(BuildContext context) {
    final Widget content = switch (variant) {
      WdsFixedActionAreaVariant.normal => _buildNormal(),
      WdsFixedActionAreaVariant.filter => _buildFilter(),
      WdsFixedActionAreaVariant.division => _buildDivision(),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: 81,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: WdsColorCommon.white,
              border: Border(
                top: BorderSide(color: WdsSemanticColorBorder.alternative),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNormal() {
    return primary;
  }

  Widget _buildFilter() {
    return Row(
      spacing: 12,
      children: [
        SizedBox(width: 110, child: secondary!),
        Expanded(child: primary),
      ],
    );
  }

  Widget _buildDivision() {
    return Row(
      spacing: 12,
      children: [
        Expanded(child: secondary!),
        Expanded(child: primary),
      ],
    );
  }
}
