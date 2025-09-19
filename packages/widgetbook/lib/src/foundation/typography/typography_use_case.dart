import 'package:wds_tokens/wds_tokens.dart' as tokens;
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../widgetbook_components/widgetbook_components.dart';

@widgetbook.UseCase(
  name: 'Typography',
  type: Typography,
  path: '[foundation]/',
)
Widget buildWdsTypographyUseCase(BuildContext context) {
  return const _TypographyShowcase();
}

const String kDefaultTypographyText = '모든 국민은 소급입법에 의하여 참정권을 제한받지 아니한다. '
    '이 헌법에 의한 최종의 대법원 재판을 받기 전에는 유죄로 인정되지 아니한다.';

const _tableDimensions = {
  0: FixedColumnWidth(240),
  1: FixedColumnWidth(84),
  2: FixedColumnWidth(84),
  3: FixedColumnWidth(84),
  4: FlexColumnWidth(),
};

class _TypographyShowcase extends StatelessWidget {
  const _TypographyShowcase();

  @override
  Widget build(BuildContext context) {
    return WidgetbookPageLayout(
      title: 'Typography',
      children: [
        _buildTypographyPlayground(context),
        const SizedBox(height: 32),
        const _StylesSection(),
      ],
    );
  }
}

Widget _buildTypographyPlayground(BuildContext context) {
  final sampleText = context.knobs.string(
    label: 'text',
    initialValue: kDefaultTypographyText,
    maxLines: 2,
  );

  final fontSize = context.knobs.double.slider(
    label: 'fontSize(px)',
    initialValue: tokens.WdsAtomicFontSize.v18,
    min: tokens.WdsAtomicFontSize.v10,
    max: tokens.WdsAtomicFontSize.v32,
    divisions: 11,
  );

  final lineHeight = context.knobs.double.slider(
    label: 'lineHeight(px)',
    initialValue: tokens.WdsAtomicFontLineHeight.v30,
    min: 12,
    max: 56,
    divisions: 44,
  );

  final letterSpacing = context.knobs.double.slider(
    label: 'letterSpacing',
    min: -0.2,
    max: 0.1,
    divisions: 40,
  );

  final weight = context.knobs.object.dropdown<FontWeight>(
    label: 'fontWeight',
    initialOption: tokens.WdsAtomicFontWeight.v800,
    options: const [
      tokens.WdsAtomicFontWeight.v800,
      tokens.WdsAtomicFontWeight.v600,
      tokens.WdsAtomicFontWeight.v500,
      tokens.WdsAtomicFontWeight.v400,
    ],
    labelBuilder: (w) {
      if (w == tokens.WdsAtomicFontWeight.v800) return 'extraBold';
      if (w == tokens.WdsAtomicFontWeight.v600) return 'bold';
      if (w == tokens.WdsAtomicFontWeight.v500) return 'medium';
      return 'regular';
    },
  );

  final color = context.knobs.color(
    label: 'color',
    initialValue: Colors.black,
  );

  final style = TextStyle(
    fontFamily: tokens.WdsAtomicFontFamily.pretendard,
    fontWeight: weight,
    fontSize: fontSize,
    height: lineHeight / fontSize,
    letterSpacing: letterSpacing,
    color: color,
  );

  return WidgetbookPlayground(
    info: [
      'size: ${fontSize.toStringAsFixed(0)}px',
      'lineHeight: ${lineHeight.toStringAsFixed(0)}px',
      'letterSpacing: ${letterSpacing.toStringAsFixed(2)}',
      'weight: ${_getWeightLabel(weight)}',
    ],
    child: Text(
      sampleText,
      maxLines: 2,
      style: style,
      textAlign: TextAlign.start,
    ),
  );
}

String _getWeightLabel(FontWeight weight) {
  if (weight == tokens.WdsAtomicFontWeight.v800) return 'extraBold';
  if (weight == tokens.WdsAtomicFontWeight.v600) return 'bold';
  if (weight == tokens.WdsAtomicFontWeight.v500) return 'medium';
  return 'regular';
}

class _StylesSection extends StatelessWidget {
  const _StylesSection();

  @override
  Widget build(BuildContext context) {
    return WidgetbookSection(
      title: '스타일',
      spacing: 12,
      children: [
        _StyleTableHeader(),
        const WdsDivider(),
        // Title 32
        const _TypographyRow(
          label: 'Title 32',
          tokenName: 'WdsTypography.title32Medium',
          fontSize: tokens.WdsAtomicFontSize.v32,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v42,
          styles: [
            tokens.WdsSemanticTypography.title32Medium,
            tokens.WdsSemanticTypography.title32Bold,
            tokens.WdsSemanticTypography.title32Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Title 22
        const _TypographyRow(
          label: 'Title 22',
          tokenName: 'WdsTypography.title22Medium',
          fontSize: tokens.WdsAtomicFontSize.v22,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v30,
          styles: [
            tokens.WdsSemanticTypography.title22Bold,
            tokens.WdsSemanticTypography.title22Medium,
            tokens.WdsSemanticTypography.title22Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Title 20
        const _TypographyRow(
          label: 'Title 20',
          tokenName: 'WdsTypography.title20Medium',
          fontSize: tokens.WdsAtomicFontSize.v20,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v28,
          styles: [
            tokens.WdsSemanticTypography.title20Bold,
            tokens.WdsSemanticTypography.title20Medium,
            tokens.WdsSemanticTypography.title20Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Heading 18
        const _TypographyRow(
          label: 'Heading 18',
          tokenName: 'WdsTypography.heading18Medium',
          fontSize: tokens.WdsAtomicFontSize.v18,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v26,
          styles: [
            tokens.WdsSemanticTypography.heading18ExtraBold,
            tokens.WdsSemanticTypography.heading18Bold,
            tokens.WdsSemanticTypography.heading18Medium,
            tokens.WdsSemanticTypography.heading18Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Heading 17
        const _TypographyRow(
          label: 'Heading 17',
          tokenName: 'WdsTypography.heading17Medium',
          fontSize: tokens.WdsAtomicFontSize.v17,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v24,
          styles: [
            tokens.WdsSemanticTypography.heading17ExtraBold,
            tokens.WdsSemanticTypography.heading17Bold,
            tokens.WdsSemanticTypography.heading17Medium,
            tokens.WdsSemanticTypography.heading17Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Heading 16
        const _TypographyRow(
          label: 'Heading 16',
          tokenName: 'WdsTypography.heading16Medium',
          fontSize: tokens.WdsAtomicFontSize.v16,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v24,
          styles: [
            tokens.WdsSemanticTypography.heading16Bold,
            tokens.WdsSemanticTypography.heading16Medium,
            tokens.WdsSemanticTypography.heading16Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 15 Normal
        const _TypographyRow(
          label: 'Body 15 Normal',
          tokenName: 'WdsTypography.body15NormalMedium',
          fontSize: tokens.WdsAtomicFontSize.v15,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v22,
          styles: [
            tokens.WdsSemanticTypography.body15NormalBold,
            tokens.WdsSemanticTypography.body15NormalMedium,
            tokens.WdsSemanticTypography.body15NormalRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 15 Reading
        const _TypographyRow(
          label: 'Body 15 Reading',
          tokenName: 'WdsTypography.body15ReadingMedium',
          fontSize: tokens.WdsAtomicFontSize.v15,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v24,
          styles: [
            tokens.WdsSemanticTypography.body15ReadingBold,
            tokens.WdsSemanticTypography.body15ReadingMedium,
            tokens.WdsSemanticTypography.body15ReadingRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 14 Normal
        const _TypographyRow(
          label: 'Body 14 Normal',
          tokenName: 'WdsTypography.body14NormalMedium',
          fontSize: tokens.WdsAtomicFontSize.v14,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v20,
          styles: [
            tokens.WdsSemanticTypography.body14NormalBold,
            tokens.WdsSemanticTypography.body14NormalMedium,
            tokens.WdsSemanticTypography.body14NormalRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 14 Reading
        const _TypographyRow(
          label: 'Body 14 Reading',
          tokenName: 'WdsTypography.body14ReadingMedium',
          fontSize: tokens.WdsAtomicFontSize.v14,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v22,
          styles: [
            tokens.WdsSemanticTypography.body14ReadingBold,
            tokens.WdsSemanticTypography.body14ReadingMedium,
            tokens.WdsSemanticTypography.body14ReadingRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 13 Normal
        const _TypographyRow(
          label: 'Body 13 Normal',
          tokenName: 'WdsTypography.body13NormalMedium',
          fontSize: tokens.WdsAtomicFontSize.v13,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v18,
          styles: [
            tokens.WdsSemanticTypography.body13NormalBold,
            tokens.WdsSemanticTypography.body13NormalMedium,
            tokens.WdsSemanticTypography.body13NormalRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Body 13 Reading
        const _TypographyRow(
          label: 'Body 13 Reading',
          tokenName: 'WdsTypography.body13ReadingMedium',
          fontSize: tokens.WdsAtomicFontSize.v13,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v20,
          styles: [
            tokens.WdsSemanticTypography.body13ReadingBold,
            tokens.WdsSemanticTypography.body13ReadingMedium,
            tokens.WdsSemanticTypography.body13ReadingRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Caption 12
        const _TypographyRow(
          label: 'Caption 12 Normal',
          tokenName: 'WdsTypography.caption12NormalMedium',
          fontSize: tokens.WdsAtomicFontSize.v12,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v16,
          styles: [
            tokens.WdsSemanticTypography.caption12NormalBold,
            tokens.WdsSemanticTypography.caption12NormalMedium,
            tokens.WdsSemanticTypography.caption12NormalRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        const _TypographyRow(
          label: 'Caption 12 Reading',
          tokenName: 'WdsSemanticTypography.caption12ReadingMedium',
          fontSize: tokens.WdsAtomicFontSize.v12,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v18,
          styles: [
            tokens.WdsSemanticTypography.caption12ReadingBold,
            tokens.WdsSemanticTypography.caption12ReadingMedium,
            tokens.WdsSemanticTypography.caption12ReadingRegular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Caption 11
        const _TypographyRow(
          label: 'Caption 11',
          tokenName: 'WdsTypography.caption11Medium',
          fontSize: tokens.WdsAtomicFontSize.v11,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v14,
          styles: [
            tokens.WdsSemanticTypography.caption11Bold,
            tokens.WdsSemanticTypography.caption11Medium,
            tokens.WdsSemanticTypography.caption11Regular,
          ],
          previewText: kDefaultTypographyText,
        ),
        // Caption 10
        const _TypographyRow(
          label: 'Caption 10',
          tokenName: 'WdsTypography.caption10Medium',
          fontSize: tokens.WdsAtomicFontSize.v10,
          lineHeightPx: tokens.WdsAtomicFontLineHeight.v13,
          styles: [
            tokens.WdsSemanticTypography.caption10Bold,
            tokens.WdsSemanticTypography.caption10Medium,
            tokens.WdsSemanticTypography.caption10Regular,
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
      columnWidths: _tableDimensions,
      children: [
        TableRow(
          children: [
            const _HeaderCell('명칭'),
            const _HeaderCell('크기'),
            const _HeaderCell('행간'),
            const _HeaderCell('자간'),
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
    required this.tokenName,
    required this.fontSize,
    required this.lineHeightPx,
    required this.styles,
    required this.previewText,
  });

  final String label;
  final String tokenName;
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

    final Map<FontWeight, TextStyle> styleByWeight = {
      for (final s in styles)
        if (s.fontWeight != null) s.fontWeight!: s,
    };

    return Table(
      columnWidths: _tableDimensions,
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label),
                  Text(
                    tokenName,
                    style:
                        tokens.WdsSemanticTypography.caption10Regular.copyWith(
                      color: tokens.WdsAtomicColorNeutral.v300,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('${fontSize.toStringAsFixed(0)}px'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${lineHeightPx.toStringAsFixed(0)}px',
                  ),
                  Text(
                    '(${ratio.toStringAsFixed(2)}%)',
                    style: tokens.WdsSemanticTypography.caption10Regular,
                  ),
                ],
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
                      child:
                          styleByWeight[tokens.WdsAtomicFontWeight.v800] != null
                              ? Text(
                                  previewText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleByWeight[
                                      tokens.WdsAtomicFontWeight.v800]!,
                                )
                              : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child:
                          styleByWeight[tokens.WdsAtomicFontWeight.v600] != null
                              ? Text(
                                  previewText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleByWeight[
                                      tokens.WdsAtomicFontWeight.v600]!,
                                )
                              : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child:
                          styleByWeight[tokens.WdsAtomicFontWeight.v500] != null
                              ? Text(
                                  previewText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleByWeight[
                                      tokens.WdsAtomicFontWeight.v500]!,
                                )
                              : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child:
                          styleByWeight[tokens.WdsAtomicFontWeight.v400] != null
                              ? Text(
                                  previewText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleByWeight[
                                      tokens.WdsAtomicFontWeight.v400]!,
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
        style: WdsTypography.heading17Bold,
      ),
    );
  }
}

class _PreviewHeaderCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '미리보기',
            style: WdsTypography.heading17Bold,
          ),
          SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'ExtraBold (800)',
                  style: WdsTypography.caption11Bold,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Bold (600)',
                  style: WdsTypography.caption11Bold,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Medium (500)',
                  style: WdsTypography.caption11Bold,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Regular (400)',
                  style: WdsTypography.caption11Bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
