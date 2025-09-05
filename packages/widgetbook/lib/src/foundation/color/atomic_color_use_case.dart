import 'package:wds_tokens/wds_tokens.dart' as tokens;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../widgetbook_components/widgetbook_components.dart';

@widgetbook.UseCase(
  name: 'Atomic',
  type: Color,
  path: '[foundation]/',
)
Widget buildWdsAtomicColorsUseCase(BuildContext context) {
  return const _AtomicColorShowcase();
}

class _AtomicColorShowcase extends StatelessWidget {
  const _AtomicColorShowcase();

  @override
  Widget build(BuildContext context) {
    final List<_Section> sections = [
      _buildCommonSection(),
      _buildNeutralSection(),
      _buildCoolNeutralSection(),
      _buildPaletteSection(
        'Pink',
        _shadesFrom([
          tokens.WdsAtomicColorPink.v100,
          tokens.WdsAtomicColorPink.v200,
          tokens.WdsAtomicColorPink.v300,
          tokens.WdsAtomicColorPink.v400,
          tokens.WdsAtomicColorPink.v500,
          tokens.WdsAtomicColorPink.v600,
          tokens.WdsAtomicColorPink.v700,
          tokens.WdsAtomicColorPink.v800,
          tokens.WdsAtomicColorPink.v900,
        ]),
      ),
      _buildPaletteSection(
        'Orange',
        _shadesFrom([
          tokens.WdsAtomicColorOrange.v100,
          tokens.WdsAtomicColorOrange.v200,
          tokens.WdsAtomicColorOrange.v300,
          tokens.WdsAtomicColorOrange.v400,
          tokens.WdsAtomicColorOrange.v500,
          tokens.WdsAtomicColorOrange.v600,
          tokens.WdsAtomicColorOrange.v700,
          tokens.WdsAtomicColorOrange.v800,
          tokens.WdsAtomicColorOrange.v900,
        ]),
      ),
      _buildPaletteSection(
        'Yellow',
        _shadesFrom([
          tokens.WdsAtomicColorYellow.v100,
          tokens.WdsAtomicColorYellow.v200,
          tokens.WdsAtomicColorYellow.v300,
          tokens.WdsAtomicColorYellow.v400,
          tokens.WdsAtomicColorYellow.v500,
          tokens.WdsAtomicColorYellow.v600,
          tokens.WdsAtomicColorYellow.v700,
          tokens.WdsAtomicColorYellow.v800,
          tokens.WdsAtomicColorYellow.v900,
        ]),
      ),
      _buildPaletteSection(
        'Blue',
        _shadesFrom([
          tokens.WdsAtomicColorBlue.v100,
          tokens.WdsAtomicColorBlue.v200,
          tokens.WdsAtomicColorBlue.v300,
          tokens.WdsAtomicColorBlue.v400,
          tokens.WdsAtomicColorBlue.v500,
          tokens.WdsAtomicColorBlue.v600,
          tokens.WdsAtomicColorBlue.v700,
          tokens.WdsAtomicColorBlue.v800,
          tokens.WdsAtomicColorBlue.v900,
        ]),
      ),
      _buildPaletteSection(
        'Sky',
        _shadesFrom([
          tokens.WdsAtomicColorSky.v100,
          tokens.WdsAtomicColorSky.v200,
          tokens.WdsAtomicColorSky.v300,
          tokens.WdsAtomicColorSky.v400,
          tokens.WdsAtomicColorSky.v500,
          tokens.WdsAtomicColorSky.v600,
          tokens.WdsAtomicColorSky.v700,
          tokens.WdsAtomicColorSky.v800,
          tokens.WdsAtomicColorSky.v900,
        ]),
      ),
      _buildBrandSection(),
      _buildOpacitySection(),
    ];

    return WidgetbookPageLayout(
      title: 'WINC Colors',
      description:
          '컬러는 WINC 브랜드의 아이덴티티를 표현하는 중요한 요소입니다. 지정된 색상과 사용 규정을 숙지하여 브랜드 아이덴티티의 일관성을 유지할 수 있도록 합니다.',
      children: [
        for (final section in sections) ...[
          _SectionHeader(title: section.title),
          const SizedBox(height: 12),
          section.body,
          const SizedBox(height: 32),
        ],
      ],
    );
  }

  static _Section _buildCommonSection() {
    final items = <_ColorItem>[
      const _ColorItem(label: 'White', color: tokens.$white),
      const _ColorItem(label: 'Black', color: tokens.$black),
    ];
    return _Section(
      title: 'Common',
      body: _SwatchRow(items: items),
    );
  }

  static _Section _buildNeutralSection() {
    return _buildPaletteSection(
      'Neutral',
      _shadesFrom([
        tokens.WdsAtomicColorNeutral.v100,
        tokens.WdsAtomicColorNeutral.v200,
        tokens.WdsAtomicColorNeutral.v300,
        tokens.WdsAtomicColorNeutral.v400,
        tokens.WdsAtomicColorNeutral.v500,
        tokens.WdsAtomicColorNeutral.v600,
        tokens.WdsAtomicColorNeutral.v700,
        tokens.WdsAtomicColorNeutral.v800,
        tokens.WdsAtomicColorNeutral.v900,
      ]),
    );
  }

  static _Section _buildCoolNeutralSection() {
    // Approximated with Indigo shades to resemble cool neutral tones.
    return _buildPaletteSection(
      'Cool Neutral',
      _shadesFrom([
        tokens.WdsAtomicColorCoolNeutral.v100,
        tokens.WdsAtomicColorCoolNeutral.v200,
        tokens.WdsAtomicColorCoolNeutral.v300,
        tokens.WdsAtomicColorCoolNeutral.v400,
        tokens.WdsAtomicColorCoolNeutral.v500,
        tokens.WdsAtomicColorCoolNeutral.v600,
        tokens.WdsAtomicColorCoolNeutral.v700,
        tokens.WdsAtomicColorCoolNeutral.v800,
        tokens.WdsAtomicColorCoolNeutral.v900,
      ]),
    );
  }

  static _Section _buildBrandSection() {
    return const _Section(
      title: 'Brand',
      body: _SwatchRow(
        items: <_ColorItem>[
          _ColorItem(
            label: 'Hapa Kristin',
            color: tokens.WdsAtomicColorBrand.hapakristin,
          ),
          _ColorItem(label: 'Chuu', color: tokens.WdsAtomicColorBrand.chuu),
          _ColorItem(
            label: 'Gemhour',
            color: tokens.WdsAtomicColorBrand.gemhour,
          ),
        ],
      ),
    );
  }

  static _Section _buildOpacitySection() {
    final opacities = [
      tokens.WdsAtomicOpacity.v5,
      tokens.WdsAtomicOpacity.v10,
      tokens.WdsAtomicOpacity.v20,
      tokens.WdsAtomicOpacity.v30,
      tokens.WdsAtomicOpacity.v40,
      tokens.WdsAtomicOpacity.v50,
      tokens.WdsAtomicOpacity.v60,
      tokens.WdsAtomicOpacity.v70,
      tokens.WdsAtomicOpacity.v80,
      tokens.WdsAtomicOpacity.v90,
    ];

    final items = <_ColorItem>[];
    for (final opacity in opacities) {
      final percentLabel = (opacity * 100).toStringAsFixed(0);
      items.add(
        _ColorItem(
          label: percentLabel,
          color: tokens.$black.withAlpha(opacity.toAlpha()),
        ),
      );
    }
    return _Section(
      title: 'Opacity',
      body: _SwatchRow(items: items, showHex: false, valueSuffix: '%'),
    );
  }

  static _Section _buildPaletteSection(String title, List<_ColorItem> items) {
    return _Section(title: title, body: _SwatchRow(items: items));
  }
}

class _Section {
  const _Section({required this.title, required this.body});
  final String title;
  final Widget body;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: WdsTypography.title20Bold,
    );
  }
}

class _SwatchRow extends StatelessWidget {
  const _SwatchRow({
    required this.items,
    this.showHex = true,
    this.valueSuffix,
  });

  final List<_ColorItem> items;
  final bool showHex;
  final String? valueSuffix;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 12,
      children: [
        for (final item in items)
          _ColorSwatch(
            item: item,
            showHex: showHex,
            valueSuffix: valueSuffix,
          ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.item,
    required this.showHex,
    required this.valueSuffix,
  });

  final _ColorItem item;
  final bool showHex;
  final String? valueSuffix;

  @override
  Widget build(BuildContext context) {
    final hex =
        '#${item.color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    final valueText =
        showHex ? hex.substring(2) : '${item.label}${valueSuffix ?? ''}';

    return SizedBox(
      width: 96,
      child: Column(
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: item.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: WdsTypography.caption11Bold,
          ),
          if (showHex)
            Text(
              valueText,
              style: WdsTypography.caption11Bold,
            ),
        ],
      ),
    );
  }
}

class _ColorItem {
  const _ColorItem({required this.label, required this.color});
  final String label;
  final Color color;
}

List<_ColorItem> _shadesFrom(List<Color> colors) {
  final labels = [
    '100',
    '200',
    '300',
    '400',
    '500',
    '600',
    '700',
    '800',
    '900',
  ];
  return List<_ColorItem>.generate(
    colors.length,
    (index) => _ColorItem(label: labels[index], color: colors[index]),
    growable: false,
  );
}
