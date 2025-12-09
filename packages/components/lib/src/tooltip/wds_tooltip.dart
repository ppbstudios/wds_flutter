part of '../../wds_components.dart';

/// Tooltip alignment enum - 툴팁의 위치를 결정하는 열거형
enum WdsTooltipAlignment {
  /// 대상의 왼쪽 위에 위치, 화살표는 아래쪽 왼쪽을 향함
  topLeft,

  /// 대상의 중앙 위에 위치, 화살표는 아래쪽 중앙을 향함
  topCenter,

  /// 대상의 오른쪽 위에 위치, 화살표는 아래쪽 오른쪽을 향함
  topRight,

  /// 대상의 오른쪽 위에 위치, 화살표는 왼쪽 위를 향함
  rightTop,

  /// 대상의 오른쪽 중앙에 위치, 화살표는 왼쪽 중앙을 향함
  rightCenter,

  /// 대상의 오른쪽 아래에 위치, 화살표는 왼쪽 아래를 향함
  rightBottom,

  /// 대상의 왼쪽 아래에 위치, 화살표는 위쪽 왼쪽을 향함
  bottomLeft,

  /// 대상의 중앙 아래에 위치, 화살표는 위쪽 중앙을 향함
  bottomCenter,

  /// 대상의 오른쪽 아래에 위치, 화살표는 위쪽 오른쪽을 향함
  bottomRight,

  /// 대상의 왼쪽 위에 위치, 화살표는 오른쪽 위를 향함
  leftTop,

  /// 대상의 왼쪽 중앙에 위치, 화살표는 오른쪽 중앙을 향함
  leftCenter,

  /// 대상의 왼쪽 아래에 위치, 화살표는 오른쪽 아래를 향함
  leftBottom;

  /// 화살표가 위치할 방향을 반환
  ArrowDirection get arrowDirection => switch (this) {
    topLeft || topCenter || topRight => ArrowDirection.bottom,
    rightTop || rightCenter || rightBottom => ArrowDirection.left,
    bottomLeft || bottomCenter || bottomRight => ArrowDirection.top,
    leftTop || leftCenter || leftBottom => ArrowDirection.right,
  };

  /// - 0: 왼쪽(상)에 위치
  /// - 0.5: 중앙(중)에 위치
  /// - 1: 오른쪽(하)에 위치
  double get arrowFraction => switch (this) {
    topLeft || bottomLeft || leftTop || rightTop => 0,
    topCenter || bottomCenter || leftCenter || rightCenter => 0.5,
    topRight || bottomRight || leftBottom || rightBottom => 1,
  };
}

/// 화살표 방향 - 내부적으로 사용되는 enum
enum ArrowDirection { top, right, bottom, left }

/// 설명적 내용이 필요한 경우에 사용하는 툴팁 컴포넌트
///
/// 툴팁에 표시될 메시지와 화살표, 닫기 버튼 등을 설정할 수 있습니다.
class WdsTooltip extends StatelessWidget {
  /// 기본 툴팁 생성자
  const WdsTooltip({
    required this.message,
    this.hasArrow = true,
    this.hasCloseButton = false,
    this.alignment = WdsTooltipAlignment.topCenter,
    this.onClose,
    super.key,
  }) : assert(
         !hasCloseButton || onClose != null,
         '닫기 버튼이 활성화된 경우 onClose 콜백이 필요합니다.',
       );

  static const Color backgroundColor = WdsColors.cta;

  /// 툴팁에 표시될 메시지
  final Text message;

  /// 화살표 표시 여부
  final bool hasArrow;

  /// 닫기 버튼 표시 여부
  final bool hasCloseButton;

  /// 툴팁 위치 설정
  final WdsTooltipAlignment alignment;

  /// 닫기 버튼이 눌렸을 때 콜백
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TooltipPainter(
        hasArrow: hasArrow,
        alignment: alignment,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 64),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(WdsRadius.radius8),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: hasCloseButton
                  ? _buildContentWithCloseButton()
                  : _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  /// 텍스트만 있는 콘텐츠
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: DefaultTextStyle.merge(
        style: WdsTypography.body14ReadingRegular.copyWith(
          color: WdsColors.white,
        ),
        child: message,
      ),
    );
  }

  /// 닫기 버튼이 있는 콘텐츠
  Widget _buildContentWithCloseButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: DefaultTextStyle.merge(
              style: WdsTypography.body14ReadingRegular.copyWith(
                color: WdsColors.white,
              ),
              child: message,
            ),
          ),
        ),
        GestureDetector(
          onTap: onClose,
          child: SizedBox.square(
            dimension: 20,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: WdsIcon.close.build(
                color: WdsColors.neutral200,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 툴팁의 말풍선과 화살표를 그리는 CustomPainter
class _TooltipPainter extends CustomPainter {
  const _TooltipPainter({
    required this.hasArrow,
    required this.alignment,
  });

  final bool hasArrow;
  final WdsTooltipAlignment alignment;

  @override
  void paint(Canvas canvas, Size size) {
    if (!hasArrow) return;

    final paint = Paint()
      ..color = WdsTooltip.backgroundColor
      ..style = PaintingStyle.fill;

    _drawArrow(canvas, size, paint);
  }

  void _drawArrow(Canvas canvas, Size size, Paint paint) {
    const arrowHeight = 8.0;
    const sidePadding = 6.0;
    const tipPadding = 1.54;
    const triangleWidth = 12.0;

    // switch 문을 switch-expression으로 변환
    final Path path = _createArrowWithRoundedTip(
      size,
      alignment.arrowDirection,
      arrowHeight,
      sidePadding,
      triangleWidth,
      tipPadding,
      alignment.arrowFraction,
    );

    return canvas.drawPath(path, paint);
  }

  // 위치 보조 계산 함수
  double _calculateSlotX(
    Size size,
    double triangleWidth,
    double sidePadding,
    double fraction,
  ) {
    final minX = sidePadding + triangleWidth / 2;
    final maxX = size.width - (sidePadding + triangleWidth / 2);
    return minX + (maxX - minX) * fraction.clamp(0.0, 1.0);
  }

  double _calculateSlotY(
    Size size,
    double triangleWidth,
    double sidePadding,
    double fraction,
  ) {
    final minY = sidePadding + triangleWidth / 2;
    final maxY = size.height - (sidePadding + triangleWidth / 2);
    return minY + (maxY - minY) * fraction.clamp(0.0, 1.0);
  }

  // 공통: 방향만 다른 곡률 팁 화살표 생성기
  Path _createArrowWithRoundedTip(
    Size size,
    ArrowDirection direction,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
    double fraction,
  ) {
    const overlap = 1.0;

    final double center;
    if (direction == ArrowDirection.top || direction == ArrowDirection.bottom) {
      center = _calculateSlotX(size, triangleWidth, sidePadding, fraction);
    } else {
      center = _calculateSlotY(size, triangleWidth, sidePadding, fraction);
    }

    final (Offset baseStart, Offset baseEnd, Offset tip) = switch (direction) {
      ArrowDirection.top => (
        Offset(center - triangleWidth / 2, overlap),
        Offset(center + triangleWidth / 2, overlap),
        Offset(center, -arrowHeight + tipPadding),
      ),
      ArrowDirection.bottom => (
        Offset(center - triangleWidth / 2, size.height - overlap),
        Offset(center + triangleWidth / 2, size.height - overlap),
        Offset(center, size.height + arrowHeight - tipPadding),
      ),
      ArrowDirection.left => (
        Offset(overlap, center - triangleWidth / 2),
        Offset(overlap, center + triangleWidth / 2),
        Offset(-arrowHeight + tipPadding, center),
      ),
      ArrowDirection.right => (
        Offset(size.width - overlap, center - triangleWidth / 2),
        Offset(size.width - overlap, center + triangleWidth / 2),
        Offset(size.width + arrowHeight - tipPadding, center),
      ),
    };

    const tipRoundT = 0.8;

    final nearStart = Offset(
      baseStart.dx + (tip.dx - baseStart.dx) * tipRoundT,
      baseStart.dy + (tip.dy - baseStart.dy) * tipRoundT,
    );
    final nearEnd = Offset(
      baseEnd.dx + (tip.dx - baseEnd.dx) * tipRoundT,
      baseEnd.dy + (tip.dy - baseEnd.dy) * tipRoundT,
    );

    final path = Path()
      ..moveTo(baseStart.dx, baseStart.dy)
      ..lineTo(nearStart.dx, nearStart.dy)
      ..quadraticBezierTo(tip.dx, tip.dy, nearEnd.dx, nearEnd.dy)
      ..lineTo(baseEnd.dx, baseEnd.dy)
      ..close();

    return path;
  }

  @override
  bool shouldRepaint(covariant _TooltipPainter oldDelegate) {
    return hasArrow != oldDelegate.hasArrow ||
        alignment != oldDelegate.alignment;
  }
}
