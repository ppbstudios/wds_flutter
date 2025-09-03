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
  ArrowDirection get arrowDirection {
    switch (this) {
      case topLeft:
      case topCenter:
      case topRight:
        return ArrowDirection.bottom;
      case rightTop:
      case rightCenter:
      case rightBottom:
        return ArrowDirection.left;
      case bottomLeft:
      case bottomCenter:
      case bottomRight:
        return ArrowDirection.top;
      case leftTop:
      case leftCenter:
      case leftBottom:
        return ArrowDirection.right;
    }
  }
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
  final String message;

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
          borderRadius: const BorderRadius.all(Radius.circular(WdsRadius.sm)),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
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
        style: const TextStyle(color: WdsColors.white),
        child: Text(
          message,
          style: WdsTypography.body14NormalMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
              style: const TextStyle(color: WdsColors.white),
              child: Text(
                message,
                style: WdsTypography.body14NormalMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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

    late Path path;

    // alignment 별 세분화된 9개 위치(각 side의 3 분할)를 지원
    switch (alignment) {
      // Top group → 툴팁이 대상 위에 있으므로 화살표는 컨테이너의 하단에 표시
      case WdsTooltipAlignment.topLeft:
        path = _createBottomLeftArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case WdsTooltipAlignment.topCenter:
        path = _createBottomCenterArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case WdsTooltipAlignment.topRight:
        path = _createBottomRightArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;

      // Right group → 툴팁이 대상의 오른쪽에 있으므로 화살표는 컨테이너의 왼쪽에 표시
      case WdsTooltipAlignment.rightTop:
        path = _createLeftTopArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case WdsTooltipAlignment.rightCenter:
        path = _createLeftCenterArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case WdsTooltipAlignment.rightBottom:
        path = _createLeftBottomArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;

      // Bottom group → 툴팁이 대상 아래에 있으므로 화살표는 컨테이너의 상단에 표시
      case WdsTooltipAlignment.bottomLeft:
        path = _createTopLeftArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case WdsTooltipAlignment.bottomCenter:
        path = _createTopCenterArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case WdsTooltipAlignment.bottomRight:
        path = _createTopRightArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;

      // Left group → 툴팁이 대상의 왼쪽에 있으므로 화살표는 컨테이너의 오른쪽에 표시
      case WdsTooltipAlignment.leftTop:
        path = _createRightTopArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case WdsTooltipAlignment.leftCenter:
        path = _createRightCenterArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case WdsTooltipAlignment.leftBottom:
        path = _createRightBottomArrow(
          size,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
    }

    canvas.drawPath(path, paint);
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

  // Edge 별 위치 지정 버전(가변 center)
  Path _createTopArrowAt(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
    double fractionX,
  ) {
    final path = Path();
    final centerX =
        _calculateSlotX(size, triangleWidth, sidePadding, fractionX);
    final top = -arrowHeight;
    const overlap = 1.0;

    path.moveTo(centerX - triangleWidth / 2, overlap);
    path.lineTo(centerX, top + tipPadding);
    path.lineTo(centerX + triangleWidth / 2, overlap);
    path.close();

    return path;
  }

  Path _createBottomArrowAt(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
    double fractionX,
  ) {
    final path = Path();
    final centerX =
        _calculateSlotX(size, triangleWidth, sidePadding, fractionX);
    final bottom = size.height + arrowHeight;
    const overlap = 1.0;

    path.moveTo(centerX - triangleWidth / 2, size.height - overlap);
    path.lineTo(centerX, bottom - tipPadding);
    path.lineTo(centerX + triangleWidth / 2, size.height - overlap);
    path.close();

    return path;
  }

  Path _createLeftArrowAt(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
    double fractionY,
  ) {
    final path = Path();
    final centerY =
        _calculateSlotY(size, triangleWidth, sidePadding, fractionY);
    final left = -arrowHeight;
    const overlap = 1.0;

    path.moveTo(overlap, centerY - triangleWidth / 2);
    path.lineTo(left + tipPadding, centerY);
    path.lineTo(overlap, centerY + triangleWidth / 2);
    path.close();

    return path;
  }

  Path _createRightArrowAt(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
    double fractionY,
  ) {
    final path = Path();
    final centerY =
        _calculateSlotY(size, triangleWidth, sidePadding, fractionY);
    final right = size.width + arrowHeight;
    const overlap = 1.0;

    path.moveTo(size.width - overlap, centerY - triangleWidth / 2);
    path.lineTo(right - tipPadding, centerY);
    path.lineTo(size.width - overlap, centerY + triangleWidth / 2);
    path.close();

    return path;
  }

  // ── 12개 위치 Wrapper (상/하/좌/우 × 좌/중/우 또는 상/중/하) ─────────────
  // Top edge
  Path _createTopLeftArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createTopArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0,
      );

  Path _createTopCenterArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createTopArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0.5,
      );

  Path _createTopRightArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createTopArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        1,
      );

  // Bottom edge
  Path _createBottomLeftArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createBottomArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0,
      );

  Path _createBottomCenterArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createBottomArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0.5,
      );

  Path _createBottomRightArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createBottomArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0,
      );

  // Left edge
  Path _createLeftTopArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createLeftArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0.5,
      );

  Path _createLeftCenterArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createLeftArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0.5,
      );

  Path _createLeftBottomArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createLeftArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0.5,
      );

  // Right edge
  Path _createRightTopArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createRightArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0.5,
      );

  Path _createRightCenterArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createRightArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0.5,
      );

  Path _createRightBottomArrow(
    Size size,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) =>
      _createRightArrowAt(
        size,
        arrowHeight,
        sidePadding,
        triangleWidth,
        tipPadding,
        0.5,
      );

  @override
  bool shouldRepaint(covariant _TooltipPainter oldDelegate) {
    return hasArrow != oldDelegate.hasArrow ||
        alignment != oldDelegate.alignment;
  }
}
