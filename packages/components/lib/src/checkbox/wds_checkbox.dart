part of '../../wds_components.dart';

enum WdsCheckboxSize {
  small(spec: Size(20, 20), margin: EdgeInsets.all(2)),
  large(spec: Size(24, 24), margin: EdgeInsets.all(3));

  const WdsCheckboxSize({
    required this.spec,
    required this.margin,
  });

  final Size spec;
  final EdgeInsets margin;
}

class WdsCheckbox extends StatefulWidget {
  const WdsCheckbox.small({
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
    super.key,
  }) : size = WdsCheckboxSize.small;

  const WdsCheckbox.large({
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
    super.key,
  }) : size = WdsCheckboxSize.large;

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;
  final WdsCheckboxSize size;

  @override
  State<WdsCheckbox> createState() => _WdsCheckboxState();
}

class _WdsCheckboxState extends State<WdsCheckbox>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration.zero;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
  );

  @override
  void initState() {
    super.initState();
    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant WdsCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _toggle() {
    if (!widget.isEnabled) return;
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final Size boxSize = widget.size.spec;
    final BorderRadius radius =
        const BorderRadius.all(Radius.circular(WdsRadius.xs));
    final EdgeInsets outerMargin = widget.size.margin;
    final Size innerSize = Size(
      boxSize.width - outerMargin.left - outerMargin.right,
      boxSize.height - outerMargin.top - outerMargin.bottom,
    );

    Widget paint = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final double t = Curves.easeIn.transform(_controller.value);
        return CustomPaint(
          size: innerSize,
          painter: _CheckboxPainter(
            animationValue: t,
            isChecked: widget.value,
            isEnabled: widget.isEnabled,
          ),
        );
      },
    );

    Widget box = SizedBox.fromSize(
      size: boxSize,
      child: Padding(
        padding: outerMargin,
        child: ClipRRect(
          borderRadius: radius,
          child: SizedBox.fromSize(size: innerSize, child: paint),
        ),
      ),
    );

    box = GestureDetector(
      onTap: widget.isEnabled ? _toggle : null,
      behavior: HitTestBehavior.opaque,
      child: box,
    );

    if (!widget.isEnabled) {
      return Opacity(opacity: 0.4, child: box);
    }
    return box;
  }
}

class _CheckboxPainter extends CustomPainter {
  _CheckboxPainter({
    required this.animationValue, // 0.0..1.0
    required this.isChecked,
    required this.isEnabled,
  });

  final double animationValue;
  final bool isChecked;
  final bool isEnabled;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect outer = Offset.zero & size;
    final RRect rrect = RRect.fromRectAndRadius(
      outer,
      const Radius.circular(WdsRadius.xs),
    );

    // Background/border (no animation for background)
    if (isChecked) {
      final Paint fill = Paint()
        ..color = (isEnabled ? WdsColors.cta : WdsColors.cta.withAlpha(40));
      canvas.drawRRect(rrect, fill);
    } else {
      const double strokeWidth = 1.5;
      final Paint border = Paint()
        ..color = WdsColors.borderNeutral
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      final RRect inside = rrect.deflate(strokeWidth / 2);
      canvas.drawRRect(inside, border);
    }

    // Check mark
    if (isChecked) {
      final double scale = size.width / 20.0; // 20단위 좌표계를 비례 스케일

      const markPath = [
        Offset(4.75, 9.75),
        Offset(8.5, 13.5),
        Offset(15.5, 6.5),
      ];

      Path mark = Path();
      Offset p(Offset offset) => Offset(
            offset.dx * scale,
            offset.dy * scale,
          );
      mark.moveTo(p(markPath[0]).dx, p(markPath[0]).dy);
      mark.lineTo(p(markPath[1]).dx, p(markPath[1]).dy);
      mark.lineTo(p(markPath[2]).dx, p(markPath[2]).dy);

      final metrics = mark.computeMetrics();
      final Paint stroke = Paint()
        ..color = WdsColors.white
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square
        ..strokeJoin = StrokeJoin.miter
        ..strokeWidth = 2.0;

      for (final m in metrics) {
        final double len = m.length * Curves.easeIn.transform(animationValue);
        final Path partial = m.extractPath(0, len);
        canvas.drawPath(partial, stroke);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CheckboxPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
        isChecked != oldDelegate.isChecked ||
        isEnabled != oldDelegate.isEnabled;
  }
}
