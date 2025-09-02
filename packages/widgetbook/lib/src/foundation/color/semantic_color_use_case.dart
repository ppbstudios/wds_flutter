import 'package:wds_tokens/semantic/semantic.dart';
import 'package:wds_tokens/wds_tokens.dart' as tokens;
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
            _SwatchItem(
              label: 'Normal',
              color: tokens.$cta,
            ),
          ],
        ),
        const _SwatchGroup(
          label: 'primary',
          items: [
            _SwatchItem(
              label: 'Normal',
              color: tokens.$primary,
            ),
          ],
        ),
        const _SwatchGroup(
          label: 'secondary',
          items: [
            _SwatchItem(
              label: 'Normal',
              color: tokens.$secondary,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Text'),
        const _SwatchGroup(
          items: [
            _SwatchItem(
              label: 'Normal',
              color: tokens.WdsSemanticColorText.normal,
            ),
            _SwatchItem(
              label: 'Strong',
              color: tokens.WdsSemanticColorText.strong,
            ),
            _SwatchItem(
              label: 'Neutral',
              color: tokens.WdsSemanticColorText.neutral,
            ),
            _SwatchItem(
              label: 'Alternative',
              color: tokens.WdsSemanticColorText.alternative,
            ),
            _SwatchItem(
              label: 'Assistive',
              color: tokens.WdsSemanticColorText.assistive,
            ),
            _SwatchItem(
              label: 'Disable',
              color: tokens.WdsSemanticColorText.disable,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Background'),
        const _SwatchGroup(
          items: [
            _SwatchItem(
              label: 'Normal',
              color: tokens.WdsSemanticColorBackgroud.normal,
            ),
            _SwatchItem(
              label: 'Alternative',
              color: tokens.WdsSemanticColorBackgroud.alternative,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Border'),
        const _SwatchGroup(
          items: [
            _SwatchItem(
              label: 'Neutral',
              color: tokens.WdsSemanticColorBorder.neutral,
            ),
            _SwatchItem(
              label: 'Alternative',
              color: tokens.WdsSemanticColorBorder.alternative,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Status'),
        const _SwatchGroup(
          items: [
            _SwatchItem(
              label: 'Positive',
              color: tokens.WdsSemanticColorStatus.positive,
            ),
            _SwatchItem(
              label: 'Cautionary',
              color: tokens.WdsSemanticColorStatus.cautionaty,
            ),
            _SwatchItem(
              label: 'Destructive',
              color: tokens.WdsSemanticColorStatus.destructive,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Material'),
        const _SwatchGroup(
          items: [
            _SwatchItem(
              label: 'Dimmer',
              color: tokens.WdsSemanticColorMaterial.dimmer,
            ),
            _SwatchItem(
              label: 'Pressed',
              color: tokens.WdsSemanticColorMaterial.pressed,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _SectionTitle('Elevation'),
        Text(
          'Neutral',
          textAlign: TextAlign.center,
          style: WdsTypography.caption12Bold.copyWith(
            color: WdsColors.textStrong,
          ),
        ),
        const _SwatchGroup(
          items: [
            _SwatchItem(label: 'Normal', shadows: <BoxShadow>[]),
          ],
        ),
        Text(
          'Cool Neutral',
          textAlign: TextAlign.center,
          style: WdsTypography.caption12Bold.copyWith(
            color: WdsColors.textStrong,
          ),
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
          style: WdsTypography.title20Bold,
        ),
        Text(
          '위의 색상 구성은 다음과 같이 구성되어 있습니다.\n보다 자세한 설명과 예시는 다음 예시 섹션에서 확인할 수 있습니다.',
          style: WdsTypography.heading16Regular,
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
        style: WdsTypography.title20Bold,
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
        if (label != null) Text(label!, style: WdsTypography.heading17Bold),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final item in items)
              _Swatch(
                label: item.label,
                color: item.color,
                shadows: item.shadows,
              ),
          ],
        ),
      ],
    );
  }
}

class _SwatchItem {
  const _SwatchItem({
    required this.label,
    this.color,
    this.shadows,
  }) : assert(
          color != null || shadows != null,
          'Either color or shadows must be provided',
        );

  final String label;
  final Color? color;
  final List<BoxShadow>? shadows;
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.label,
    this.color,
    this.shadows,
  });
  final String label;
  final Color? color;
  final List<BoxShadow>? shadows;

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
              color: color ?? WdsSemanticColorBackgroud.normal,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12),
              boxShadow: shadows,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: WdsTypography.caption11Bold,
          ),
        ],
      ),
    );
  }
}

// (removed) _ElevationSwatchItem: 기능이 _SwatchItem + _Swatch로 대체되었습니다.
