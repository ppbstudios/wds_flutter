import 'package:flutter/material.dart';
import 'package:wds_tokens/wds_tokens.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Atomic Colors', type: WdsAtomicColors)
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
            Pink.s100,
            Pink.s200,
            Pink.s300,
            Pink.s400,
            Pink.s500,
            Pink.s600,
            Pink.s700,
            Pink.s800,
            Pink.s900,
          ])),
      _buildPaletteSection(
          'Orange',
          _shadesFrom([
            Orange.s100,
            Orange.s200,
            Orange.s300,
            Orange.s400,
            Orange.s500,
            Orange.s600,
            Orange.s700,
            Orange.s800,
            Orange.s900,
          ])),
      _buildPaletteSection(
          'Yellow',
          _shadesFrom([
            Yellow.s100,
            Yellow.s200,
            Yellow.s300,
            Yellow.s400,
            Yellow.s500,
            Yellow.s600,
            Yellow.s700,
            Yellow.s800,
            Yellow.s900,
          ])),
      _buildPaletteSection(
          'Blue',
          _shadesFrom([
            Blue.s100,
            Blue.s200,
            Blue.s300,
            Blue.s400,
            Blue.s500,
            Blue.s600,
            Blue.s700,
            Blue.s800,
            Blue.s900,
          ])),
      _buildPaletteSection(
          'Sky',
          _shadesFrom([
            Indigo.s100,
            Indigo.s200,
            Indigo.s300,
            Indigo.s400,
            Indigo.s500,
            Indigo.s600,
            Indigo.s700,
            Indigo.s800,
            Indigo.s900,
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
      _ColorItem(label: 'White', color: WdsAtomicColors.white),
      _ColorItem(label: 'Black', color: WdsAtomicColors.black),
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
          Gray.s100,
          Gray.s200,
          Gray.s300,
          Gray.s400,
          Gray.s500,
          Gray.s600,
          Gray.s700,
          Gray.s800,
          Gray.s900,
        ]));
  }

  static _Section _buildCoolNeutralSection() {
    // Approximated with Indigo shades to resemble cool neutral tones.
    return _buildPaletteSection(
        'Cool Neutral',
        _shadesFrom([
          Indigo.s100,
          Indigo.s200,
          Indigo.s300,
          Indigo.s400,
          Indigo.s500,
          Indigo.s600,
          Indigo.s700,
          Indigo.s800,
          Indigo.s900,
        ]));
  }

  static _Section _buildBrandSection() {
    // Placeholder brand trio using token colors. Replace with brand tokens when available.
    final items = <_ColorItem>[
      _ColorItem(label: 'Brand A', color: Pink.s500),
      _ColorItem(label: 'Brand B', color: Pink.s400),
      _ColorItem(label: 'Brand C', color: Purple.s900),
    ];
    return _Section(title: 'Brand', body: _SwatchRow(items: items));
  }

  static _Section _buildOpacitySection() {
    final items = <_ColorItem>[];
    for (int percent = 5; percent <= 90; percent += 5) {
      final opacity = percent / 100.0;
      items.add(_ColorItem(
          label: '$percent', color: Colors.black.withOpacity(opacity)));
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
        '#${item.color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    final valueText =
        showHex ? hex.substring(2) : '${item.label}${valueSuffix ?? ''}';

    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black12),
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
