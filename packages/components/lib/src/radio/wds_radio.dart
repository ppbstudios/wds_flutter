part of '../../wds_components.dart';

enum WdsRadioSize {
  small(spec: Size(20, 20), margin: EdgeInsets.all(1.67), innerCircle: 6.67),
  large(spec: Size(24, 24), margin: EdgeInsets.all(2), innerCircle: 10);

  const WdsRadioSize({
    required this.spec,
    required this.margin,
    required this.innerCircle,
  });

  final Size spec;
  final EdgeInsets margin;
  final double innerCircle;
}

/// 사용자가 여러 옵션 중에서 하나만 선택할 수 있도록 돕는 Radio 컴포넌트
///
/// Checkbox와 달리 그룹 내에서 오직 하나의 항목만 선택 가능하며,
/// `groupValue`와 개별 `value`를 비교하여 선택 여부를 판단합니다.
class WdsRadio<T> extends StatefulWidget {
  const WdsRadio.small({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.isEnabled = true,
    super.key,
  }) : size = WdsRadioSize.small;

  const WdsRadio.large({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.isEnabled = true,
    super.key,
  }) : size = WdsRadioSize.large;

  /// 해당 Radio가 갖는 고유 값
  final T value;

  /// 현재 선택된 그룹 값
  final T? groupValue;

  /// 선택 시 호출되는 콜백
  final ValueChanged<T?>? onChanged;

  /// Radio 활성화 여부 (false 시 'disabled' 상태)
  final bool isEnabled;

  final WdsRadioSize size;

  /// 현재 이 Radio가 선택된 상태인지 확인
  bool get isSelected => value == groupValue;

  @override
  State<WdsRadio<T>> createState() => _WdsRadioState<T>();
}

class _WdsRadioState<T> extends State<WdsRadio<T>> {
  void _handleTap() {
    if (!widget.isEnabled) return;
    widget.onChanged?.call(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final Size boxSize = widget.size.spec;
    final EdgeInsets outerMargin = widget.size.margin;
    final Size innerSize = Size(
      boxSize.width - outerMargin.left - outerMargin.right,
      boxSize.height - outerMargin.top - outerMargin.bottom,
    );

    Widget painted = CustomPaint(
      size: innerSize,
      painter: _RadioPainter(
        sizeSpec: widget.size,
        isSelected: widget.isSelected,
        isEnabled: widget.isEnabled,
      ),
    );

    Widget radio = SizedBox.fromSize(
      size: boxSize,
      child: Padding(
        padding: outerMargin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerSize.width / 2),
          child: SizedBox.fromSize(size: innerSize, child: painted),
        ),
      ),
    );

    radio = GestureDetector(
      onTap: widget.isEnabled ? _handleTap : null,
      behavior: HitTestBehavior.opaque,
      child: radio,
    );

    if (!widget.isEnabled) {
      return Opacity(opacity: 0.4, child: radio);
    }

    return radio;
  }
}

class _RadioPainter extends CustomPainter {
  _RadioPainter({
    required this.sizeSpec,
    required this.isSelected,
    required this.isEnabled,
  });

  final WdsRadioSize sizeSpec;
  final bool isSelected;
  final bool isEnabled;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect outer = Offset.zero & size;
    final Offset center = outer.center;
    final double radius = outer.width / 2;

    if (isSelected) {
      // Selected state: 2px border with statusPositive, white background, inner circle with primary
      final Paint backgroundPaint = Paint()
        ..color = WdsColors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, backgroundPaint);

      final Paint borderPaint = Paint()
        ..color = WdsColors.statusPositive
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(center, radius - 1, borderPaint); // Inside border

      // Inner circle
      final Paint innerPaint = Paint()
        ..color = WdsColors.primary
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, sizeSpec.innerCircle / 2, innerPaint);
    } else {
      // Unselected state: border only with borderNeutral
      final double borderWidth = sizeSpec == WdsRadioSize.small ? 1.25 : 1.5;

      final Paint borderPaint = Paint()
        ..color = WdsColors.borderNeutral
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;
      canvas.drawCircle(
        center,
        radius - borderWidth / 2,
        borderPaint,
      ); // Inside border
    }
  }

  @override
  bool shouldRepaint(covariant _RadioPainter oldDelegate) {
    return sizeSpec != oldDelegate.sizeSpec ||
        isSelected != oldDelegate.isSelected ||
        isEnabled != oldDelegate.isEnabled;
  }
}
