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
              color: WdsColors.cta,
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
        SizedBox.square(
          dimension: 20,
          child: IconTheme(
            data: const IconThemeData(color: WdsColors.white, size: 20),
            child: GestureDetector(
              onTap: onClose,
              child: WdsIcon.close.build(
                width: 20,
                height: 20,
                color: WdsColors.white,
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
      ..color = WdsColors.cta
      ..style = PaintingStyle.fill;

    _drawArrow(canvas, size, paint);
  }

  void _drawArrow(Canvas canvas, Size size, Paint paint) {
    const arrowWidth = 24.0;
    const arrowHeight = 8.0;
    const sidePadding = 6.0;
    const tipPadding = 1.54;
    const triangleWidth = arrowWidth - sidePadding * 2; // 12px

    final direction = alignment.arrowDirection;
    late Path path;

    switch (direction) {
      case ArrowDirection.top:
        // 위쪽을 향하는 화살표 (bottom aligned tooltip)
        path = _createTopArrow(
          size,
          arrowWidth,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case ArrowDirection.right:
        // 오른쪽을 향하는 화살표 (left aligned tooltip)
        path = _createRightArrow(
          size,
          arrowWidth,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case ArrowDirection.bottom:
        // 아래쪽을 향하는 화살표 (top aligned tooltip)
        path = _createBottomArrow(
          size,
          arrowWidth,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
      case ArrowDirection.left:
        // 왼쪽을 향하는 화살표 (right aligned tooltip)
        path = _createLeftArrow(
          size,
          arrowWidth,
          arrowHeight,
          sidePadding,
          triangleWidth,
          tipPadding,
        );
        break;
    }

    canvas.drawPath(path, paint);
  }

  Path _createTopArrow(
    Size size,
    double arrowWidth,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) {
    final path = Path();
    final centerX = size.width / 2;
    final top = -arrowHeight;
    const overlap = 1.0; // 1px overlap to eliminate seam

    // 삼각형 그리기 (위쪽을 향함) - 컨테이너와 overlap
    path.moveTo(centerX - triangleWidth / 2, overlap); // 왼쪽 하단 (overlap)
    path.lineTo(centerX, top + tipPadding); // 위쪽 꼭지점
    path.lineTo(centerX + triangleWidth / 2, overlap); // 오른쪽 하단 (overlap)
    path.close();

    return path;
  }

  Path _createRightArrow(
    Size size,
    double arrowWidth,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) {
    final path = Path();
    final centerY = size.height / 2;
    final right = size.width + arrowHeight;
    const overlap = 1.0; // 1px overlap to eliminate seam

    // 삼각형 그리기 (오른쪽을 향함) - 컨테이너와 overlap
    path.moveTo(size.width - overlap, centerY - triangleWidth / 2); // 위쪽 좌단 (overlap)
    path.lineTo(right - tipPadding, centerY); // 오른쪽 꼭지점
    path.lineTo(size.width - overlap, centerY + triangleWidth / 2); // 아래쪽 좌단 (overlap)
    path.close();

    return path;
  }

  Path _createBottomArrow(
    Size size,
    double arrowWidth,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) {
    final path = Path();
    final centerX = size.width / 2;
    final bottom = size.height + arrowHeight;
    const overlap = 1.0; // 1px overlap to eliminate seam

    // 삼각형 그리기 (아래쪽을 향함) - 컨테이너와 overlap
    path.moveTo(centerX - triangleWidth / 2, size.height - overlap); // 왼쪽 상단 (overlap)
    path.lineTo(centerX, bottom - tipPadding); // 아래쪽 꼭지점
    path.lineTo(centerX + triangleWidth / 2, size.height - overlap); // 오른쪽 상단 (overlap)
    path.close();

    return path;
  }

  Path _createLeftArrow(
    Size size,
    double arrowWidth,
    double arrowHeight,
    double sidePadding,
    double triangleWidth,
    double tipPadding,
  ) {
    final path = Path();
    final centerY = size.height / 2;
    final left = -arrowHeight;
    const overlap = 1.0; // 1px overlap to eliminate seam

    // 삼각형 그리기 (왼쪽을 향함) - 컨테이너와 overlap
    path.moveTo(overlap, centerY - triangleWidth / 2); // 위쪽 우단 (overlap)
    path.lineTo(left + tipPadding, centerY); // 왼쪽 꼭지점
    path.lineTo(overlap, centerY + triangleWidth / 2); // 아래쪽 우단 (overlap)
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant _TooltipPainter oldDelegate) {
    return hasArrow != oldDelegate.hasArrow ||
        alignment != oldDelegate.alignment;
  }
}
