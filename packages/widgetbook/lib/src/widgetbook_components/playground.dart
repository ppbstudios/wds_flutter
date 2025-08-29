part of 'widgetbook_components.dart';

enum PlaygroundLayout { center, stretch }

class WidgetbookPlayground extends StatelessWidget {
  const WidgetbookPlayground({
    required this.child,
    this.info = const [],
    this.padding = const EdgeInsets.all(24),
    this.layout = PlaygroundLayout.center,
    this.backgroundColor = WdsColorCommon.white,
    super.key,
  });

  final Widget child;
  final List<String> info;
  final EdgeInsetsGeometry padding;
  final PlaygroundLayout layout;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content = child;

        if (child is Text) {
          final t = child as Text;
          if (t.data != null) {
            content = Text(
              t.data!,
              key: t.key,
              style: t.style,
              strutStyle: t.strutStyle,
              textAlign: t.textAlign,
              textDirection: t.textDirection,
              locale: t.locale,
              softWrap: t.softWrap ?? true,
              textScaler: t.textScaler,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: t.semanticsLabel,
              textWidthBasis: t.textWidthBasis,
              textHeightBehavior: t.textHeightBehavior,
            );
          } else if (t.textSpan != null) {
            content = Text.rich(
              t.textSpan!,
              key: t.key,
              style: t.style,
              strutStyle: t.strutStyle,
              textAlign: t.textAlign,
              textDirection: t.textDirection,
              locale: t.locale,
              softWrap: t.softWrap ?? true,
              textScaler: t.textScaler,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: t.semanticsLabel,
              textWidthBasis: t.textWidthBasis,
              textHeightBehavior: t.textHeightBehavior,
            );
          }
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: WdsColorNeutral.v200),
          ),
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: 32,
              children: [
                Text(
                  'Playground',
                  style: WdsSemanticTypography.title20Bold.copyWith(
                    color: WdsColorBlue.v500,
                  ),
                ),
                switch (layout) {
                  PlaygroundLayout.stretch => SizedBox(
                      width: double.infinity,
                      child: content,
                    ),
                  PlaygroundLayout.center => SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth,
                          ),
                          child: content,
                        ),
                      ),
                    ),
                },
                if (info.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: info.map((text) => _InfoChip(text)).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final isFixed = label.contains('fixed');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isFixed ? WdsColorNeutral.v100 : WdsColorBlue.v100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        isFixed ? label.replaceAll('fixed', '') : label,
        style: WdsSemanticTypography.caption11Bold.copyWith(
          color: isFixed ? WdsColorNeutral.v900 : WdsColorBlue.v700,
        ),
      ),
    );
  }
}
