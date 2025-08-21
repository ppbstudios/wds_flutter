import 'package:flutter/material.dart';
import 'package:wds_tokens/semantic/semantic.dart';
import 'package:wds_tokens/wds_tokens.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Typography',
  type: TextStyle,
  path: 'typography/typography',
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
      label: 'fontSize',
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
      label: 'letterSpacing',
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
      height: 200,
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
        _Heading18Row(previewText: _previewText),
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
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            _HeaderCell('명칭'),
            _HeaderCell('크기'),
            _HeaderCell('행간'),
            _HeaderCell('자간'),
            _HeaderCell('미리보기'),
          ],
        ),
      ],
    );
  }
}

class _Heading18Row extends StatelessWidget {
  const _Heading18Row({required this.previewText});
  final String previewText;

  @override
  Widget build(BuildContext context) {
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Heading 18'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('18px'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('26px (1.44)'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('-0.02em'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        previewText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            WdsSemanticTypography.heading18Extrabold.copyWith(
                          height: WdsFontLineheight.v26 / WdsFontSize.v18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        previewText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: WdsSemanticTypography.heading18Bold.copyWith(
                          height: WdsFontLineheight.v26 / WdsFontSize.v18,
                        ),
                      ),
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
