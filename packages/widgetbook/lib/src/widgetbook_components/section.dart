part of 'widgetbook_components.dart';

class WidgetbookSection extends StatelessWidget {
  const WidgetbookSection({
    required this.title,
    required this.children,
    this.spacing = 16,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: [
        Text(
          title,
          style: WdsSemanticTypography.title20Bold,
        ),
        ...children,
      ],
    );
  }
}

class WidgetbookSubsection extends StatelessWidget {
  const WidgetbookSubsection({
    required this.title,
    required this.labels,
    required this.content,
    this.spacing = 16,
    super.key,
  });

  final String title;
  final List<String> labels;
  final Widget content;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing,
      children: [
        SizedBox(
          height: 28,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text('$title = ', style: WdsSemanticTypography.heading17Bold),
                ...labels
                    .expand(
                      (label) => [
                        _TypeLabel(label),
                        const SizedBox(width: 12),
                      ],
                    )
                    .take(labels.length * 2 - 1),
              ],
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.hardEdge,
          child: CustomPaint(
            painter: const _DiagonalHatchPainter(
              background: Colors.white,
              hatchColor: WdsColorNeutral.v100,
              hatchSpacing: 16,
              hatchStrokeWidth: 1,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: content,
            ),
          ),
        ),
      ],
    );
  }
}

class _TypeLabel extends StatelessWidget {
  const _TypeLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: WdsColorNeutral.v100,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: WdsSemanticTypography.caption11Bold,
        ),
      ),
    );
  }
}

class _DiagonalHatchPainter extends CustomPainter {
  const _DiagonalHatchPainter({
    required this.background,
    required this.hatchColor,
    this.hatchSpacing = 10,
    this.hatchStrokeWidth = 0.125,
  });

  final Color background;
  final Color hatchColor;
  final double hatchSpacing;
  final double hatchStrokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bg = Paint()..color = background;
    canvas.drawRect(Offset.zero & size, bg);

    final Paint line = Paint()
      ..color = hatchColor
      ..strokeWidth = hatchStrokeWidth;

    // 정확한 '/' 방향 45도 빗금: 캔버스를 -45도 회전시키고 수평선 반복
    canvas.save();
    canvas.rotate(-math.pi / 4);
    final double width = size.width;
    final double height = size.height;
    final double diag = math.sqrt(width * width + height * height);
    for (double y = -diag; y <= diag; y += hatchSpacing) {
      final Offset p1 = Offset(-diag, y);
      final Offset p2 = Offset(diag, y);
      canvas.drawLine(p1, p2, line);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DiagonalHatchPainter oldDelegate) {
    return background != oldDelegate.background ||
        hatchColor != oldDelegate.hatchColor ||
        hatchSpacing != oldDelegate.hatchSpacing ||
        hatchStrokeWidth != oldDelegate.hatchStrokeWidth;
  }
}
