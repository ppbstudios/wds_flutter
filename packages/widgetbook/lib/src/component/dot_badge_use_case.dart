import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'DotBadge',
  type: DotBadge,
  path: '[component]/',
)
Widget buildWdsDotBadgeUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'DotBadge',
    description:
        '알림을 표시하는 작은 아이콘이나 배지로, 사용자가 특정 항목이나 상태에 대해 새로운 정보나 업데이트가 있음을 시각적으로 알려주는 요소입니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final alignment = context.knobs.object.dropdown<Alignment?>(
    label: 'alignment',
    options: [
      null,
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight,
    ],
    initialOption: Alignment.topRight,
    description: '배지의 위치를 정의해요',
    labelBuilder: (alignment) {
      if (alignment == null) return '숨김';
      if (alignment == Alignment.topLeft) return 'topLeft';
      if (alignment == Alignment.topCenter) return 'topCenter';
      if (alignment == Alignment.topRight) return 'topRight';
      if (alignment == Alignment.centerLeft) return 'centerLeft';
      if (alignment == Alignment.center) return 'center';
      if (alignment == Alignment.centerRight) return 'centerRight';
      if (alignment == Alignment.bottomLeft) return 'bottomLeft';
      if (alignment == Alignment.bottomCenter) return 'bottomCenter';
      if (alignment == Alignment.bottomRight) return 'bottomRight';
      return 'unknown';
    },
  );

  final color = context.knobs.object.dropdown<Color>(
    label: 'color',
    options: [
      WdsColors.orange600,
      WdsColors.pink500,
      WdsColors.blue500,
      WdsColors.sky500,
      WdsColors.yellow500,
    ],
    description: '배지의 색상을 정의해요',
    labelBuilder: (color) {
      if (color == WdsColors.orange600) return 'orange600';
      if (color == WdsColors.pink500) return 'pink500';
      if (color == WdsColors.blue500) return 'blue500';
      if (color == WdsColors.sky500) return 'sky500';
      if (color == WdsColors.yellow500) return 'yellow500';
      return 'unknown';
    },
  );

  final childType = context.knobs.object.dropdown<String>(
    label: 'child',
    options: ['icon', 'tab', 'button', 'text'],
    initialOption: 'icon',
    description: '배지가 적용될 자식 위젯을 정의해요',
  );

  Widget child = switch (childType) {
    'icon' => WdsIcon.ask.build(),
    'tab' => const WdsTextTab(
        label: '매장할인혜택',
      ),
    'button' => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: WdsColors.blue400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          '버튼',
          style: TextStyle(
            color: WdsColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    'text' => const Text('텍스트'),
    _ => WdsIcon.ask.build(),
  };

  return WidgetbookPlayground(
    child: WdsDotBadge(
      alignment: alignment,
      color: color,
      child: child,
    ),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'DotBadge',
    spacing: 32,
    children: [
      // 위치 변형
      WidgetbookSubsection(
        title: 'position',
        labels: [
          'topLeft',
          'topCenter',
          'topRight',
          'centerLeft',
          'center',
          'centerRight',
          'bottomLeft',
          'bottomCenter',
          'bottomRight',
        ],
        content: Builder(
          builder: (context) {
            const double size = 144;

            return const SizedBox(
              width: size * 1.5,
              height: size * 1.5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ColoredBox(
                    color: WdsColors.backgroundAlternative,
                    child: SizedBox.square(
                      dimension: size,
                    ),
                  ),
                  // 9개 위치에 배지 배치
                  WdsDotBadge(
                    alignment: Alignment.topLeft,
                    child: SizedBox.square(dimension: size),
                  ),
                  WdsDotBadge(
                    alignment: Alignment.topCenter,
                    child: SizedBox.square(dimension: size),
                  ),
                  WdsDotBadge(
                    alignment: Alignment.topRight,
                    child: SizedBox.square(dimension: size),
                  ),
                  WdsDotBadge(
                    alignment: Alignment.centerLeft,
                    child: SizedBox.square(dimension: size),
                  ),
                  WdsDotBadge(
                    alignment: Alignment.center,
                    child: SizedBox.square(dimension: size),
                  ),
                  WdsDotBadge(
                    alignment: Alignment.centerRight,
                    child: SizedBox.square(dimension: size),
                  ),
                  WdsDotBadge(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox.square(dimension: size),
                  ),
                  WdsDotBadge(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox.square(dimension: size),
                  ),
                  WdsDotBadge(
                    alignment: Alignment.bottomRight,
                    child: SizedBox.square(dimension: size),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}
