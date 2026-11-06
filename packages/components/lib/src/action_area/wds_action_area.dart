part of '../../wds_components.dart';

enum WdsActionAreaVariant { normal, filter, division }

/// 하단 고정 액션 영역
/// - height: 81
/// - padding: EdgeInsets.fromLTRB(16, 8, 16, 16) (padding 으로 변경 가능)
/// - border(top): 1px alternative
/// - background: white
class WdsActionArea extends StatelessWidget {
  WdsActionArea.normal({
    required this.primary,
    this.showBorder = true,
    this.padding = _defaultPadding,
    this.semanticLabel,
    super.key,
  }) : variant = WdsActionAreaVariant.normal,
       secondary = null,
       assert(
         primary.size == WdsButtonSize.xlarge,
         'primary 버튼은 size xlarge 여야 합니다.',
       );

  WdsActionArea.filter({
    required this.secondary,
    required this.primary,
    this.showBorder = true,
    this.padding = _defaultPadding,
    this.semanticLabel,
    super.key,
  }) : variant = WdsActionAreaVariant.filter,
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

  WdsActionArea.division({
    required this.secondary,
    required this.primary,
    this.showBorder = true,
    this.padding = _defaultPadding,
    this.semanticLabel,
    super.key,
  }) : variant = WdsActionAreaVariant.division,
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

  final WdsActionAreaVariant variant;

  /// 상단 경계선 표시 여부
  final bool showBorder;

  /// 버튼 영역 여백 (하단 SafeArea 안쪽)
  ///
  /// 기본값은 WDS Action 과 같은 `EdgeInsets.fromLTRB(16, 8, 16, 16)`.
  /// Figma 인스턴스에서 Action 패딩을 바꾼 화면만 지정한다.
  final EdgeInsetsGeometry padding;

  static const EdgeInsets _defaultPadding = EdgeInsets.fromLTRB(16, 8, 16, 16);

  /// 접근성을 위한 시맨틱 라벨
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Widget content = switch (variant) {
      WdsActionAreaVariant.normal => _buildNormal(),
      WdsActionAreaVariant.filter => _buildFilter(),
      WdsActionAreaVariant.division => _buildDivision(),
    };

    return Semantics(
      container: true,
      label: semanticLabel,
      child: LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: WdsColors.white,
              border: showBorder
                  ? const Border(
                      top: BorderSide(color: WdsColors.borderAlternative),
                    )
                  : null,
            ),
            child: SafeArea(
              child: Padding(
                padding: padding,
                child: content,
              ),
            ),
          ),
        );
      },
    ),
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
