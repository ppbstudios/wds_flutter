import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Loading',
  type: WdsLoading,
  path: '[component]/',
)
Widget buildLoadingUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Loading',
    description: '로딩 컴포넌트는 사용자가 처리 진행 상태를 인지할 수 있도록 안내하는 시각적 피드백 요소입니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final color = context.knobs.object.dropdown<String>(
    label: 'color',
    options: ['normal', 'white'],
    initialOption: 'normal',
    description: 'dot 색상을 정의해요',
  );

  final size = context.knobs.object.dropdown<String>(
    label: 'size',
    options: ['small', 'medium'],
    initialOption: 'small',
    description: '크기를 선택할 수 있어요',
  );

  final colorValue = switch (color) {
    'normal' => WdsLoadingColor.normal,
    'white' => WdsLoadingColor.white,
    _ => WdsLoadingColor.normal,
  };

  final sizeValue = switch (size) {
    'small' => WdsLoadingSize.small,
    'medium' => WdsLoadingSize.medium,
    _ => WdsLoadingSize.small,
  };

  final double dotSize = sizeValue == WdsLoadingSize.small ? 8 : 18;
  final double spacing =
      sizeValue == WdsLoadingSize.small ? WdsSpacing.md2 : WdsSpacing.md5;

  final loadingWidget = sizeValue == WdsLoadingSize.small
      ? WdsLoading.small(color: colorValue)
      : WdsLoading.medium(color: colorValue);

  return WidgetbookPlayground(
    info: [
      'color: $color',
      'size: $size',
      'dot size: ${dotSize}px',
      'spacing: ${spacing}px',
    ],
    child: colorValue == WdsLoadingColor.white
        ? Container(
            color: WdsColors.coolNeutral400,
            padding: const EdgeInsets.all(16),
            child: loadingWidget,
          )
        : loadingWidget,
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Loading',
    spacing: 32,
    children: [
      const WidgetbookSubsection(
        title: 'size',
        labels: ['small', 'medium'],
        content: Row(
          spacing: 50,
          children: [
            WdsLoading.small(),
            WdsLoading.medium(),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'color',
        labels: ['normal', 'white'],
        content: Row(
          spacing: 50,
          children: [
            const WdsLoading.small(),
            Container(
              color: WdsColors.coolNeutral400,
              padding: const EdgeInsets.all(16),
              child: const WdsLoading.small(
                color: WdsLoadingColor.white,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
