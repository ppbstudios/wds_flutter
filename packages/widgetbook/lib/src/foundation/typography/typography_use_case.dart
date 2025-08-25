import 'package:flutter/material.dart';
import 'package:wds_tokens/wds_tokens.dart';
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_page_layout.dart';
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

const String kDefaultTypographyText = '모든 국민은 소급입법에 의하여 참정권을 제한받지 아니한다. '
    '이 헌법에 의한 최종의 대법원 재판을 받기 전에는 유죄로 인정되지 아니한다.';

class _TypographyShowcase extends StatelessWidget {
  const _TypographyShowcase();

  @override
  Widget build(BuildContext context) {
    return WidgetbookPageLayout(
      title: 'Typography',
      children: [
        _TypographyPlayground(),
        SizedBox(height: 32),
        _StylesSection(),
      ],
    );
  }
}

class _TypographyPlayground extends StatelessWidget {
  const _TypographyPlayground();

  @override
  Widget build(BuildContext context) {
    final sampleText = context.knobs.string(
      label: 'text',
      initialValue: kDefaultTypographyText,
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
                style: WdsSemanticTypography.title20Bold
                    .copyWith(color: WdsColorBlue.v400),
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
  const _StylesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '스타일',
          style: WdsSemanticTypography.title20Bold,
        ),
        const SizedBox(height: 12),
        _StyleTableHeader(),
        const Divider(height: 1),
        // Title 32
        _TypographyRow(
          label: 'Title 32',
          fontSize: WdsFontSize.v32,
          lineHeightPx: WdsFontLineHeight.v42,
          styles: const [
            WdsSemanticTypography.title32Medium,
            WdsSemanticTypography.title32Bold,
            WdsSemanticTypography.title32Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Title 22
        _TypographyRow(
          label: 'Title 22',
          fontSize: WdsFontSize.v22,
          lineHeightPx: WdsFontLineHeight.v30,
          styles: const [
            WdsSemanticTypography.title22Bold,
            WdsSemanticTypography.title22Medium,
            WdsSemanticTypography.title22Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Title 20
        _TypographyRow(
          label: 'Title 20',
          fontSize: WdsFontSize.v20,
          lineHeightPx: WdsFontLineHeight.v28,
          styles: const [
            WdsSemanticTypography.title20Bold,
            WdsSemanticTypography.title20Medium,
            WdsSemanticTypography.title20Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Heading 18
        _TypographyRow(
          label: 'Heading 18',
          fontSize: WdsFontSize.v18,
          lineHeightPx: WdsFontLineHeight.v26,
          styles: const [
            WdsSemanticTypography.heading18ExtraBold,
            WdsSemanticTypography.heading18Bold,
            WdsSemanticTypography.heading18Medium,
            WdsSemanticTypography.heading18Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Heading 17
        _TypographyRow(
          label: 'Heading 17',
          fontSize: WdsFontSize.v17,
          lineHeightPx: WdsFontLineHeight.v24,
          styles: const [
            WdsSemanticTypography.heading17ExtraBold,
            WdsSemanticTypography.heading17Bold,
            WdsSemanticTypography.heading17Medium,
            WdsSemanticTypography.heading17Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Heading 16
        _TypographyRow(
          label: 'Heading 16',
          fontSize: WdsFontSize.v16,
          lineHeightPx: WdsFontLineHeight.v24,
          styles: const [
            WdsSemanticTypography.heading16ExtraBold,
            WdsSemanticTypography.heading16Bold,
            WdsSemanticTypography.heading16Medium,
            WdsSemanticTypography.heading16Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 15 Normal
        _TypographyRow(
          label: 'Body 15 Normal',
          fontSize: WdsFontSize.v15,
          lineHeightPx: WdsFontLineHeight.v22,
          styles: const [
            WdsSemanticTypography.body15NormalBold,
            WdsSemanticTypography.body15NormalMedium,
            WdsSemanticTypography.body15NormalRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 15 Reading
        _TypographyRow(
          label: 'Body 15 Reading',
          fontSize: WdsFontSize.v15,
          lineHeightPx: WdsFontLineHeight.v24,
          styles: const [
            WdsSemanticTypography.body15ReadingBold,
            WdsSemanticTypography.body15ReadingMedium,
            WdsSemanticTypography.body15ReadingRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 14 Normal
        _TypographyRow(
          label: 'Body 14 Normal',
          fontSize: WdsFontSize.v14,
          lineHeightPx: WdsFontLineHeight.v20,
          styles: const [
            WdsSemanticTypography.body14NormalBold,
            WdsSemanticTypography.body14NormalMedium,
            WdsSemanticTypography.body14NormalRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 14 Reading
        _TypographyRow(
          label: 'Body 14 Reading',
          fontSize: WdsFontSize.v14,
          lineHeightPx: WdsFontLineHeight.v22,
          styles: const [
            WdsSemanticTypography.body14ReadingBold,
            WdsSemanticTypography.body14ReadingMedium,
            WdsSemanticTypography.body14ReadingRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 13 Normal
        _TypographyRow(
          label: 'Body 13 Normal',
          fontSize: WdsFontSize.v13,
          lineHeightPx: WdsFontLineHeight.v18,
          styles: const [
            WdsSemanticTypography.body13NormalBold,
            WdsSemanticTypography.body13NormalMedium,
            WdsSemanticTypography.body13NormalRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 13 Reading
        _TypographyRow(
          label: 'Body 13 Reading',
          fontSize: WdsFontSize.v13,
          lineHeightPx: WdsFontLineHeight.v20,
          styles: const [
            WdsSemanticTypography.body13ReadingBold,
            WdsSemanticTypography.body13ReadingMedium,
            WdsSemanticTypography.body13ReadingRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Caption 12
        _TypographyRow(
          label: 'Caption 12',
          fontSize: WdsFontSize.v12,
          lineHeightPx: WdsFontLineHeight.v16,
          styles: const [
            WdsSemanticTypography.caption12Bold,
            WdsSemanticTypography.caption12Medium,
            WdsSemanticTypography.caption12Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Caption 11
        _TypographyRow(
          label: 'Caption 11',
          fontSize: WdsFontSize.v11,
          lineHeightPx: WdsFontLineHeight.v14,
          styles: const [
            WdsSemanticTypography.caption11Bold,
            WdsSemanticTypography.caption11Medium,
            WdsSemanticTypography.caption11Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Caption 10
        _TypographyRow(
          label: 'Caption 10',
          fontSize: WdsFontSize.v10,
          lineHeightPx: WdsFontLineHeight.v13,
          styles: const [
            WdsSemanticTypography.caption10Bold,
            WdsSemanticTypography.caption10Medium,
            WdsSemanticTypography.caption10Regular,
          ],
          previewText: kDefaultTypographyText,
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
        0: FixedColumnWidth(120), // 명칭
        1: FixedColumnWidth(100), // 크기
        2: FixedColumnWidth(100), // 행간
        3: FixedColumnWidth(100), // 자간
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
    return '${(valuePx * 0.01).toStringAsFixed(4).replaceFirst(RegExp(r'([.]*0+)(?!.*\d)'), '')}em';
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
        0: FixedColumnWidth(120),
        1: FixedColumnWidth(100),
        2: FixedColumnWidth(100),
        3: FixedColumnWidth(100),
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
                '${lineHeightPx.toStringAsFixed(0)}px(${ratio.toStringAsFixed(2)}%)',
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
                              style: _styleByWeight[WdsFontWeight.extrabold]!,
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
                              style: _styleByWeight[WdsFontWeight.bold]!,
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
                              style: _styleByWeight[WdsFontWeight.medium]!,
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
                              style: _styleByWeight[WdsFontWeight.regular]!,
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
        style: WdsSemanticTypography.heading17Bold,
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
        color: WdsColorCommon.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: WdsSemanticTypography.caption11Bold),
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
            style: WdsSemanticTypography.heading17Bold,
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'ExtraBold (800)',
                  style: WdsSemanticTypography.caption11Bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Bold (600)',
                  style: WdsSemanticTypography.caption11Bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Medium (500)',
                  style: WdsSemanticTypography.caption11Bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Regular (400)',
                  style: WdsSemanticTypography.caption11Bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
