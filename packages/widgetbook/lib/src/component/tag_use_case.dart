import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'Tag',
  type: Tag,
  path: '[component]/',
)
Widget buildTagUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Tag',
    description: '텍스트 라벨을 표시하는 작은 컴포넌트로, 상태나 카테고리를 나타내는 데 사용됩니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final label = context.knobs.string(
    label: 'label',
    initialValue: '텍스트',
  );

  final variant = context.knobs.object.dropdown(
    label: 'variant',
    options: ['normal', 'filled'],
    initialOption: 'normal',
  );

  final backgroundColor = context.knobs.color(
    label: 'backgroundColor',
    initialValue: variant == 'normal' ? WdsColors.neutral50 : WdsColors.primary,
  );

  final textColor = context.knobs.color(
    label: 'color',
    description: '텍스트 색상을 정의해요',
    initialValue: variant == 'normal' ? WdsColors.textNeutral : WdsColors.white,
  );

  final leadingIcon = context.knobs.objectOrNull.dropdown<WdsIcon>(
    label: 'leadingIcon',
    options: WdsIcon.values,
    labelBuilder: (v) => v.name,
  );

  return WidgetbookPlayground(
    info: [
      'label: $label',
      'variant: ${variant == 'normal' ? 'normal' : 'filled'}',
      'backgroundColor: ${backgroundColor.toARGB32().toRadixString(16)}',
      'color: ${textColor.toARGB32().toRadixString(16)}',
      'height: ${WdsTag.fixedHeight}px @fixed',
      'padding: ${WdsTag.fixedPadding.horizontal}px @fixed',
      'typography: ${WdsTag.fixedTypography.fontSize}px @fixed',
      'leadingIcon: ${leadingIcon?.name ?? 'null'}',
    ],
    child: Center(
      child: WdsTag(
        label: label,
        backgroundColor: backgroundColor,
        color: textColor,
        leadingIcon: leadingIcon,
      ),
    ),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Tag',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['normal', 'filled'],
        content: Wrap(
          spacing: 12,
          children: [
            WdsTag.normal(label: '내 도수보유'),
            SizedBox(width: 16),
            WdsTag.filled(label: '바로드림'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'radius',
        labels: ['true', 'false'],
        content: Wrap(
          spacing: 12,
          children: [
            WdsTag.normal(label: '텍스트', hasRadius: false),
            WdsTag.normal(label: '텍스트'),
            WdsTag.filled(label: '텍스트', hasRadius: false),
            WdsTag.filled(label: '텍스트'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'icon',
        labels: ['true', 'false'],
        content: Wrap(
          spacing: 12,
          children: [
            WdsTag.normal(label: '텍스트', leadingIcon: WdsIcon.blank),
            WdsTag.normal(label: '텍스트'),
          ],
        ),
      ),
    ],
  );
}
