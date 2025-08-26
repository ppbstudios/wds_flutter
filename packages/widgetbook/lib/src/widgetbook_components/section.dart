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
      children: [
        Text(
          title,
          style: WdsSemanticTypography.title20Bold,
        ),
        SizedBox(height: spacing),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$title = ', style: WdsSemanticTypography.heading17Bold),
            ...labels
                .expand((label) => [
                      _TypeLabel(label),
                      const SizedBox(width: 12),
                    ])
                .take(labels.length * 2 - 1),
          ],
        ),
        SizedBox(height: spacing),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: WdsColorNeutral.v100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: content,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: WdsColorNeutral.v200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: WdsSemanticTypography.caption11Bold,
      ),
    );
  }
}
