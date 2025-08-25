import 'package:flutter/material.dart';
import 'package:wds_tokens/wds_tokens.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Typography',
  type: TextStyle,
  path: 'typography/',
  designLink:
      'https://www.figma.com/design/jZaYUOtWAtNGDL9h6dTjK6/WDS--WINC-Design-System-?node-id=2-24',
)
Widget buildWdsTypographyUseCase(BuildContext context) {
  return const _TypographyShowcase();
}

class _TypographyShowcase extends StatelessWidget {
  const _TypographyShowcase();

  @override
  Widget build(BuildContext context) {
    // 상단: 제목 + Divider
    final title = Text(
      'Typography',
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.w700),
    );

    // 상단: Knobs 플레이그라운드
    final playground = _TypographyPlayground();

    // 하단: 스타일 표 (현재는 Heading 18의 Extrabold/Bold만 제공)
    final stylesTable = _StylesSection();

    return Material(
      child: SafeArea(
        child: InteractiveViewer(
          maxScale: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                title,
                const Divider(
                  height: 1,
                  thickness: 8,
                ),
                playground,
                stylesTable,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypographyPlayground extends StatelessWidget {
  _TypographyPlayground();

  final String _defaultText = '모든 국민은 소급입법에 의하여 참정권을 제한받지 아니한다. '
      '이 헌법에 의한 최종의 대법원 재판을 받기 전에는 유죄로 인정되지 아니한다.';

  @override
  Widget build(BuildContext context) {
    final sampleText = context.knobs.string(
      label: 'text',
      initialValue: _defaultText,
      maxLines: 2,
    );

    final fontSize = context.knobs.double.slider(
      label: 'fontSize(px)',
      initialValue: 18,
      min: 10,
      max: 48,
      divisions: 38,
    );

    final lineHeight = context.knobs.double.slider(
      label: 'lineHeight(px)',
      initialValue: 26,
      min: 12,
      max: 56,
      divisions: 44,
    );

    final letterSpacing = context.knobs.double.slider(
      label: 'letterSpacing(= em * fontSize)',
      initialValue: -0.02,
      min: -0.1,
      max: 0.1,
      divisions: 40,
    );

    final weight = context.knobs.object.dropdown<FontWeight>(
      label: 'fontWeight',
      initialOption: WdsFontWeight.extrabold,
      options: const [
        WdsFontWeight.extrabold,
        WdsFontWeight.bold,
        WdsFontWeight.medium,
        WdsFontWeight.regular,
      ],
      labelBuilder: (w) {
        if (w == WdsFontWeight.extrabold) return 'extrabold';
        if (w == WdsFontWeight.bold) return 'bold';
        if (w == WdsFontWeight.medium) return 'medium';
        return 'regular';
      },
    );

    final color = context.knobs.color(
      label: 'color',
      initialValue: Colors.black,
    );

    final style = TextStyle(
      fontFamily: WdsFontFamily.pretendard,
      fontWeight: weight,
      fontSize: fontSize,
      height: lineHeight / fontSize,
      letterSpacing: letterSpacing,
      color: color,
    );

    return SizedBox(
      height: 280,
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text(
                'Playground',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                sampleText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: style,
              ),
              Spacer(),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _Chip('size: ${fontSize.toStringAsFixed(0)}'),
                  _Chip('lineHeight: ${lineHeight.toStringAsFixed(0)}'),
                  _Chip('letterSpacing: ${letterSpacing.toStringAsFixed(2)}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StylesSection extends StatelessWidget {
  _StylesSection();

  final String _previewText = '모든 국민은 소급입법에 의하여 참정권을 제한받지 아니한다. '
      '이 헌법에 의한 최종의 대법원 재판을 받기 전에는 유죄로 인정되지 아니한다.';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '스타일',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _StyleTableHeader(),
        const Divider(height: 1),
        // Title 32
        _TypographyRow(
          label: 'Title 32',
          fontSize: WdsFontSize.v32,
          lineHeightPx: WdsFontLineheight.v42,
          styles: const [
            WdsSemanticTypography.title32Medium,
            WdsSemanticTypography.title32Bold,
            WdsSemanticTypography.title32Regular,
          ],
          previewText: _previewText,
        ),
        // Title 22
        _TypographyRow(
          label: 'Title 22',
          fontSize: WdsFontSize.v22,
          lineHeightPx: WdsFontLineheight.v30,
          styles: const [
            WdsSemanticTypography.title22Bold,
            WdsSemanticTypography.title22Medium,
            WdsSemanticTypography.title22Regular,
          ],
          previewText: _previewText,
        ),
        // Title 20
        _TypographyRow(
          label: 'Title 20',
          fontSize: WdsFontSize.v20,
          lineHeightPx: WdsFontLineheight.v28,
          styles: const [
            WdsSemanticTypography.title20Bold,
            WdsSemanticTypography.title20Medium,
            WdsSemanticTypography.title20Regular,
          ],
          previewText: _previewText,
        ),
        // Heading 18
        _TypographyRow(
          label: 'Heading 18',
          fontSize: WdsFontSize.v18,
          lineHeightPx: WdsFontLineheight.v26,
          styles: const [
            WdsSemanticTypography.heading18Extrabold,
            WdsSemanticTypography.heading18Bold,
            WdsSemanticTypography.heading18Medium,
            WdsSemanticTypography.heading18Regular,
          ],
          previewText: _previewText,
        ),
        // Heading 17
        _TypographyRow(
          label: 'Heading 17',
          fontSize: WdsFontSize.v17,
          lineHeightPx: WdsFontLineheight.v24,
          styles: const [
            WdsSemanticTypography.heading17Extrabold,
            WdsSemanticTypography.heading17Bold,
            WdsSemanticTypography.heading17Medium,
            WdsSemanticTypography.heading17Regular,
          ],
          previewText: _previewText,
        ),
        // Heading 16
        _TypographyRow(
          label: 'Heading 16',
          fontSize: WdsFontSize.v16,
          lineHeightPx: WdsFontLineheight.v24,
          styles: const [
            WdsSemanticTypography.heading16Extrabold,
            WdsSemanticTypography.heading16Bold,
            WdsSemanticTypography.heading16Medium,
            WdsSemanticTypography.heading16Regular,
          ],
          previewText: _previewText,
        ),
        // Body 15 Normal
        _TypographyRow(
          label: 'Body 15 Normal',
          fontSize: WdsFontSize.v15,
          lineHeightPx: WdsFontLineheight.v22,
          styles: const [
            WdsSemanticTypography.body15NormalBold,
            WdsSemanticTypography.body15NormalMedium,
            WdsSemanticTypography.body15NormalRegular,
          ],
          previewText: _previewText,
        ),
        // Body 15 Reading
        _TypographyRow(
          label: 'Body 15 Reading',
          fontSize: WdsFontSize.v15,
          lineHeightPx: WdsFontLineheight.v24,
          styles: const [
            WdsSemanticTypography.body15ReadingBold,
            WdsSemanticTypography.body15ReadingMedium,
            WdsSemanticTypography.body15ReadingRegular,
          ],
          previewText: _previewText,
        ),
        // Body 14 Normal
        _TypographyRow(
          label: 'Body 14 Normal',
          fontSize: WdsFontSize.v14,
          lineHeightPx: WdsFontLineheight.v20,
          styles: const [
            WdsSemanticTypography.body14NormalBold,
            WdsSemanticTypography.body14NormalMedium,
            WdsSemanticTypography.body14NormalRegular,
          ],
          previewText: _previewText,
        ),
        // Body 14 Reading
        _TypographyRow(
          label: 'Body 14 Reading',
          fontSize: WdsFontSize.v14,
          lineHeightPx: WdsFontLineheight.v22,
          styles: const [
            WdsSemanticTypography.body14ReadingBold,
            WdsSemanticTypography.body14ReadingMedium,
            WdsSemanticTypography.body14ReadingRegular,
          ],
          previewText: _previewText,
        ),
      ],
    );
  }
}

class _StyleTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(140), // 명칭
        1: FixedColumnWidth(60), // 크기
        2: FixedColumnWidth(80), // 행간
        3: FixedColumnWidth(80), // 자간
        4: FlexColumnWidth(), // 미리보기
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(
          children: [
            _HeaderCell('명칭'),
            _HeaderCell('크기'),
            _HeaderCell('행간'),
            _HeaderCell('자간'),
            _PreviewHeaderCell(),
          ],
        ),
      ],
    );
  }
}

class _TypographyRow extends StatelessWidget {
  const _TypographyRow({
    required this.label,
    required this.fontSize,
    required this.lineHeightPx,
    required this.styles,
    required this.previewText,
  });

  final String label;
  final double fontSize;
  final double lineHeightPx;
  final List<TextStyle> styles;
  final String previewText;

  String _formatLetterSpacing(double valuePx) {
    final em = valuePx / fontSize;
    return '${em.toStringAsFixed(4)}em';
  }

  double _normalizedLetterSpacingPx(double? valuePx) {
    if (valuePx == null) return 0.0;
    final em = valuePx / fontSize;
    final num clampedEm = em.clamp(-0.05, 0.05);
    return (clampedEm as double) * fontSize;
  }

  @override
  Widget build(BuildContext context) {
    final ratio = lineHeightPx / fontSize;

    final uniqueSpacings = styles
        .map((s) => s.letterSpacing ?? 0.0)
        .toSet()
        .toList(growable: false);
    final letterSpacingLabel = uniqueSpacings.length == 1
        ? _formatLetterSpacing(uniqueSpacings.first)
        : '다수';

    final Map<FontWeight, TextStyle> _styleByWeight = {
      for (final s in styles)
        if (s.fontWeight != null) s.fontWeight!: s,
    };

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(140),
        1: FixedColumnWidth(60),
        2: FixedColumnWidth(80),
        3: FixedColumnWidth(80),
        4: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(label),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('${fontSize.toStringAsFixed(0)}px'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '${lineHeightPx.toStringAsFixed(0)}px (${ratio.toStringAsFixed(2)})',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(letterSpacingLabel),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _styleByWeight[WdsFontWeight.extrabold] != null
                          ? Text(
                              previewText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: _styleByWeight[WdsFontWeight.extrabold]!
                                  .copyWith(
                                height: ratio,
                                letterSpacing: _normalizedLetterSpacingPx(
                                  _styleByWeight[WdsFontWeight.extrabold]!
                                      .letterSpacing,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _styleByWeight[WdsFontWeight.bold] != null
                          ? Text(
                              previewText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  _styleByWeight[WdsFontWeight.bold]!.copyWith(
                                height: ratio,
                                letterSpacing: _normalizedLetterSpacingPx(
                                  _styleByWeight[WdsFontWeight.bold]!
                                      .letterSpacing,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _styleByWeight[WdsFontWeight.medium] != null
                          ? Text(
                              previewText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: _styleByWeight[WdsFontWeight.medium]!
                                  .copyWith(
                                height: ratio,
                                letterSpacing: _normalizedLetterSpacingPx(
                                  _styleByWeight[WdsFontWeight.medium]!
                                      .letterSpacing,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _styleByWeight[WdsFontWeight.regular] != null
                          ? Text(
                              previewText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: _styleByWeight[WdsFontWeight.regular]!
                                  .copyWith(
                                height: ratio,
                                letterSpacing: _normalizedLetterSpacingPx(
                                  _styleByWeight[WdsFontWeight.regular]!
                                      .letterSpacing,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class _PreviewHeaderCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '미리보기',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'ExtraBold',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Bold',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Medium',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Regular',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
