import 'package:flutter/material.dart';
import 'package:wds_tokens/wds_tokens.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Atomic Color',
  type: Color,
  path: 'color/colors',
  designLink:
      'https://www.figma.com/design/jZaYUOtWAtNGDL9h6dTjK6/WDS--WINC-Design-System-?node-id=2-24',
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
            WdsColorPink.v100,
            WdsColorPink.v200,
            WdsColorPink.v300,
            WdsColorPink.v400,
            WdsColorPink.v500,
            WdsColorPink.v600,
            WdsColorPink.v700,
            WdsColorPink.v800,
            WdsColorPink.v900,
          ])),
      _buildPaletteSection(
          'Orange',
          _shadesFrom([
            WdsColorOrange.v100,
            WdsColorOrange.v200,
            WdsColorOrange.v300,
            WdsColorOrange.v400,
            WdsColorOrange.v500,
            WdsColorOrange.v600,
            WdsColorOrange.v700,
            WdsColorOrange.v800,
            WdsColorOrange.v900,
          ])),
      _buildPaletteSection(
          'Yellow',
          _shadesFrom([
            WdsColorYellow.v100,
            WdsColorYellow.v200,
            WdsColorYellow.v300,
            WdsColorYellow.v400,
            WdsColorYellow.v500,
            WdsColorYellow.v600,
            WdsColorYellow.v700,
            WdsColorYellow.v800,
            WdsColorYellow.v900,
          ])),
      _buildPaletteSection(
          'Blue',
          _shadesFrom([
            WdsColorBlue.v100,
            WdsColorBlue.v200,
            WdsColorBlue.v300,
            WdsColorBlue.v400,
            WdsColorBlue.v500,
            WdsColorBlue.v600,
            WdsColorBlue.v700,
            WdsColorBlue.v800,
            WdsColorBlue.v900,
          ])),
      _buildPaletteSection(
          'Sky',
          _shadesFrom([
            WdsColorSky.v100,
            WdsColorSky.v200,
            WdsColorSky.v300,
            WdsColorSky.v400,
            WdsColorSky.v500,
            WdsColorSky.v600,
            WdsColorSky.v700,
            WdsColorSky.v800,
            WdsColorSky.v900,
          ])),
      _buildBrandSection(),
      _buildOpacitySection(),
    ];

    return Material(
      child: SafeArea(
        child: InteractiveViewer(
          maxScale: 10,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final section in sections) ...[
                    _SectionHeader(title: section.title),
                    const SizedBox(height: 12),
                    section.body,
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static _Section _buildCommonSection() {
    final items = <_ColorItem>[
      _ColorItem(label: 'White', color: WdsColorCommon.white),
      _ColorItem(label: 'Black', color: WdsColorCommon.black),
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
          WdsColorNeutral.v100,
          WdsColorNeutral.v200,
          WdsColorNeutral.v300,
          WdsColorNeutral.v400,
          WdsColorNeutral.v500,
          WdsColorNeutral.v600,
          WdsColorNeutral.v700,
          WdsColorNeutral.v800,
          WdsColorNeutral.v900,
        ]));
  }

  static _Section _buildCoolNeutralSection() {
    // Approximated with Indigo shades to resemble cool neutral tones.
    return _buildPaletteSection(
        'Cool Neutral',
        _shadesFrom([
          WdsColorCoolNeutral.v100,
          WdsColorCoolNeutral.v200,
          WdsColorCoolNeutral.v300,
          WdsColorCoolNeutral.v400,
          WdsColorCoolNeutral.v500,
          WdsColorCoolNeutral.v600,
          WdsColorCoolNeutral.v700,
          WdsColorCoolNeutral.v800,
          WdsColorCoolNeutral.v900,
        ]));
  }

  static _Section _buildBrandSection() {
    // Placeholder brand trio using token colors. Replace with brand tokens when available.
    final items = <_ColorItem>[
      _ColorItem(label: 'Hapa Kristin', color: WdsColorBrand.hapakristin),
      _ColorItem(label: 'Chuu', color: WdsColorBrand.chuu),
      _ColorItem(label: 'Gemhour', color: WdsColorBrand.gemhour),
    ];
    return _Section(title: 'Brand', body: _SwatchRow(items: items));
  }

  static _Section _buildOpacitySection() {
    final opacities = [
      WdsAtomicOpacity.v5,
      WdsAtomicOpacity.v10,
      WdsAtomicOpacity.v20,
      WdsAtomicOpacity.v30,
      WdsAtomicOpacity.v40,
      WdsAtomicOpacity.v50,
      WdsAtomicOpacity.v60,
      WdsAtomicOpacity.v70,
      WdsAtomicOpacity.v80,
      WdsAtomicOpacity.v90,
    ];

    final items = <_ColorItem>[];
    for (final opacity in opacities) {
      items.add(_ColorItem(
          label: '$opacity',
          color: WdsColorCommon.black.withValues(alpha: opacity)));
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
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _SwatchRow extends StatelessWidget {
  const _SwatchRow(
      {required this.items, this.showHex = true, this.valueSuffix});

  final List<_ColorItem> items;
  final bool showHex;
  final String? valueSuffix;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
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
  const _ColorSwatch(
      {required this.item, required this.showHex, required this.valueSuffix});

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
        crossAxisAlignment: CrossAxisAlignment.center,
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
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (showHex)
            Text(
              valueText,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.black54),
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
    '900'
  ];
  return List<_ColorItem>.generate(
    colors.length,
    (index) => _ColorItem(label: labels[index], color: colors[index]),
    growable: false,
  );
}
