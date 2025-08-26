part of 'widgetbook_components.dart';

class WidgetbookPlayground extends StatelessWidget {
  const WidgetbookPlayground({
    required this.child,
    this.info = const [],
    this.height = 280,
    this.padding = const EdgeInsets.all(24),
    super.key,
  });

  final Widget child;
  final List<String> info;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WdsColorNeutral.v200),
      ),
      child: Padding(
        padding: padding,
        child: LimitedBox(
          maxHeight: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              Text(
                'Playground',
                style: WdsSemanticTypography.title20Bold.copyWith(
                  color: WdsColorBlue.v500,
                ),
              ),
              UnconstrainedBox(
                alignment: Alignment.center,
                constrainedAxis: Axis.vertical,
                child: child,
              ),
              if (info.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: info.map((text) => _InfoChip(text)).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: WdsColorBlue.v100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: WdsSemanticTypography.caption11Bold.copyWith(
          color: WdsColorBlue.v700,
        ),
      ),
    );
  }
}
