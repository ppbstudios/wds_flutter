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

  return WidgetbookPlayground(
    info: [
      'label: $label',
      'variant: ${variant == 'normal' ? 'normal' : 'filled'}',
      'backgroundColor: ${backgroundColor.toARGB32().toRadixString(16)}',
      'color: ${textColor.toARGB32().toRadixString(16)}',
      'height: ${WdsTag.fixedHeight}px @fixed',
      'padding: ${WdsTag.fixedPadding.horizontal}px @fixed',
      'typography: ${WdsTag.fixedTypography.fontSize}px @fixed',
    ],
    child: Center(
      child: WdsTag(
        label: label,
        backgroundColor: backgroundColor,
        color: textColor,
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
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsTag.normal(label: '내 도수보유'),
            SizedBox(width: 16),
            WdsTag.filled(label: '바로드림'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'label',
        labels: ['짧은', '긴 텍스트', '숫자'],
        content: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsTag.normal(label: 'NEW'),
            WdsTag.normal(label: '인기 상품'),
            WdsTag.normal(label: '123'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'backgroundColor',
        labels: ['성공', '경고', '오류'],
        content: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsTag(
              label: '성공',
              backgroundColor: WdsColors.statusPositive,
              color: WdsColors.white,
            ),
            WdsTag(
              label: '경고',
              backgroundColor: WdsColors.statusCautionaty,
              color: WdsColors.white,
            ),
            WdsTag(
              label: '오류',
              backgroundColor: WdsColors.statusDestructive,
              color: WdsColors.white,
            ),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'color',
        labels: ['활성', '비활성', '선택됨'],
        content: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsTag.filled(label: '활성'),
            WdsTag(
              label: '비활성',
              backgroundColor: WdsColors.neutral100,
              color: WdsColors.textDisable,
            ),
            WdsTag(
              label: '선택됨',
              backgroundColor: WdsColors.blue100,
              color: WdsColors.primary,
            ),
          ],
        ),
      ),
    ],
  );
}
