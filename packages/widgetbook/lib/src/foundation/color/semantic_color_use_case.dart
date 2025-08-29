import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../widgetbook_components/widgetbook_components.dart';

@widgetbook.UseCase(
  name: 'Semantic',
  type: Color,
  path: '[foundation]/',
)
Widget buildWdsSemanticColorUseCase(BuildContext context) {
  return const _SemanticColorShowcase();
}

class _SemanticColorShowcase extends StatelessWidget {
  const _SemanticColorShowcase();

  @override
  Widget build(BuildContext context) {
    return WidgetbookPageLayout(
      title: 'Semantic Color',
      description: '색상 규칙을 안내합니다.',
      children: [
        _StyleIntroSection(),
        const SizedBox(height: 24),
        const _SectionTitle('Color'),
        const _SwatchGroup(
          label: 'cta',
          items: [
            _SwatchItem('Normal', cta),
          ],
        ),
        const _SwatchGroup(
          label: 'primary',
          items: [
            _SwatchItem('Normal', primary),
          ],
        ),
        const _SwatchGroup(
          label: 'secondary',
          items: [
            _SwatchItem('Normal', secondary),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Text: WdsSemanticColorText'),
        const _SwatchGroup(
          items: [
            _SwatchItem('Normal', WdsSemanticColorText.normal),
            _SwatchItem('Strong', WdsSemanticColorText.strong),
            _SwatchItem('Neutral', WdsSemanticColorText.neutral),
            _SwatchItem('Alternative', WdsSemanticColorText.alternative),
            _SwatchItem('Assistive', WdsSemanticColorText.assistive),
            _SwatchItem('Disable', WdsSemanticColorText.disable),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Background: WdsSemanticColorBackgroud'),
        const _SwatchGroup(
          items: [
            _SwatchItem('Normal', WdsSemanticColorBackgroud.normal),
            _SwatchItem('Alternative', WdsSemanticColorBackgroud.alternative),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Border: WdsSemanticColorBorder'),
        const _SwatchGroup(
          items: [
            _SwatchItem('Neutral', WdsSemanticColorBorder.neutral),
            _SwatchItem('Alternative', WdsSemanticColorBorder.alternative),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Status: WdsSemanticColorStatus'),
        const _SwatchGroup(
          items: [
            _SwatchItem('Positive', WdsSemanticColorStatus.positive),
            _SwatchItem('Cautionary', WdsSemanticColorStatus.cautionaty),
            _SwatchItem('Destructive', WdsSemanticColorStatus.destructive),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Material: WdsSemanticColorMaterial'),
        const _SwatchGroup(
          items: [
            _SwatchItem('Dimmer', WdsSemanticColorMaterial.dimmer),
            _SwatchItem('Pressed', WdsSemanticColorMaterial.pressed),
          ],
        ),
      ],
    );
  }
}

class _StyleIntroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          '스타일',
          style: WdsSemanticTypography.title20Bold,
        ),
        Text(
          '위의 색상 구성은 다음과 같이 구성되어 있습니다.\n보다 자세한 설명과 예시는 다음 예시 섹션에서 확인할 수 있습니다.',
          style: WdsSemanticTypography.heading16Regular,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        label,
        style: WdsSemanticTypography.title20Bold,
      ),
    );
  }
}

class _SwatchGroup extends StatelessWidget {
  const _SwatchGroup({
    required this.items,
    this.label,
  });

  final String? label;
  final List<_SwatchItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (label != null)
          Text(label!, style: WdsSemanticTypography.heading17Bold),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final item in items)
              _Swatch(label: item.label, color: item.color),
          ],
        ),
      ],
    );
  }
}

class _SwatchItem {
  const _SwatchItem(this.label, this.color);
  final String label;
  final Color color;
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: WdsSemanticTypography.caption11Bold,
          ),
        ],
      ),
    );
  }
}
