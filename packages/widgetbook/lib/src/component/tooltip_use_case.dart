import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Tooltip',
  type: Tooltip,
  path: '[component]/',
)
Widget buildWdsTooltipUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Tooltip',
    description: '설명적 내용이 필요한 경우에 사용하는 툴팁 컴포넌트입니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final message = context.knobs.string(
    label: 'message',
    description: '툴팁에 표시될 메시지를 입력해 주세요',
    initialValue: '툴팁 메시지입니다.',
  );

  final hasArrow = context.knobs.boolean(
    label: 'hasArrow',
    description: '화살표 표시 여부',
  );

  final hasCloseButton = context.knobs.boolean(
    label: 'hasCloseButton',
    description: '닫기 버튼 표시 여부',
  );

  final alignment = context.knobs.object.dropdown<WdsTooltipAlignment>(
    label: 'alignment',
    description: '툴팁 위치를 선택해 보세요',
    options: WdsTooltipAlignment.values,
    initialOption: WdsTooltipAlignment.topCenter,
    labelBuilder: (v) => v.name,
  );

  return WidgetbookPlayground(
    info: [
      'message: "$message"',
      'hasArrow: $hasArrow',
      'hasCloseButton: $hasCloseButton',
      'alignment: ${alignment.name}',
      'backgroundColor: cta (#121212)',
      'borderRadius: sm (8px)',
      'textStyle: body14NormalMedium',
      'textColor: white (#FFFFFF)',
      'minWidth: 64px',
      'padding: 10px 8px 10px 8px',
      'layout: hug content (MainAxisSize.min)',
      if (hasArrow) 'arrowSize: 24x8px',
      if (hasCloseButton) 'closeIcon: WdsIcon.close @fixed',
      if (hasCloseButton) 'closeButtonSize: 20x20px',
    ],
    child: SizedBox(
      height: 200,
      child: Center(
        child: WdsTooltip(
          message: Text(message),
          hasArrow: hasArrow,
          hasCloseButton: hasCloseButton,
          alignment: alignment,
          onClose: hasCloseButton ? () {} : null,
        ),
      ),
    ),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Tooltip',
    children: [
      const WidgetbookSubsection(
        title: 'hasArrow',
        labels: ['true', 'false'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            WdsTooltip(
              message: Text('화살표가 있는 툴팁'),
            ),
            WdsTooltip(
              message: Text('화살표가 없는 툴팁'),
              hasArrow: false,
            ),
          ],
        ),
      ),
      const SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'hasCloseButton',
        labels: const ['true', 'false'],
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            WdsTooltip(
              message: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '화살표가 있고 '),
                    TextSpan(
                      text: '닫기 버튼이',
                      style: TextStyle(color: WdsColors.primary),
                    ),
                    TextSpan(text: ' 있는 툴팁'),
                  ],
                ),
              ),
              hasCloseButton: true,
              onClose: () {},
            ),
            const WdsTooltip(
              message: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '화살표가 있고 '),
                    TextSpan(
                      text: '닫기 버튼이',
                      style: TextStyle(color: WdsColors.primary),
                    ),
                    TextSpan(text: ' 있는 툴팁'),
                  ],
                ),
              ),
            ),
            WdsTooltip(
              message: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '화살표가 있고 '),
                    TextSpan(
                      text: '닫기 버튼이',
                      style: TextStyle(color: WdsColors.primary),
                    ),
                    TextSpan(text: ' 있는 툴팁'),
                  ],
                ),
              ),
              hasCloseButton: true,
              onClose: () {},
              hasArrow: false,
            ),
            const WdsTooltip(
              message: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '화살표가 있고 '),
                    TextSpan(
                      text: '닫기 버튼이',
                      style: TextStyle(color: WdsColors.primary),
                    ),
                    TextSpan(text: ' 있는 툴팁'),
                  ],
                ),
              ),
              hasArrow: false,
            ),
          ],
        ),
      ),
      const SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'alignment',
        labels: [
          'topLeft',
          'topCenter',
          'topRight',
          'rightTop',
          'rightCenter',
          'rightBottom',
          'bottomLeft',
          'bottomCenter',
          'bottomRight',
          'leftTop',
          'leftCenter',
          'leftBottom',
        ],
        content: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: 400,
              child: Stack(
                children: [
                  Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: WdsColors.neutral50,
                        border: Border.all(color: WdsColors.borderNeutral),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(WdsRadius.radius4),
                        ),
                      ),
                      child: SizedBox(
                        width: constraints.maxWidth * 0.7,
                        height: 144,
                      ),
                    ),
                  ),
                  const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 24,
                      children: [
                        // Top alignments
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WdsTooltip(
                              message: Text('topLeft'),
                              alignment: WdsTooltipAlignment.topLeft,
                            ),
                            WdsTooltip(message: Text('topCenter')),
                            WdsTooltip(
                              message: Text('topRight'),
                              alignment: WdsTooltipAlignment.topRight,
                            ),
                          ],
                        ),
                        // Middle: left/right around the target square in center
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 16,
                              children: [
                                WdsTooltip(
                                  message: Text('leftTop'),
                                  alignment: WdsTooltipAlignment.leftTop,
                                ),
                                WdsTooltip(
                                  message: Text('leftCenter'),
                                  alignment: WdsTooltipAlignment.leftCenter,
                                ),
                                WdsTooltip(
                                  message: Text('leftBottom'),
                                  alignment: WdsTooltipAlignment.leftBottom,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 16,
                              children: [
                                WdsTooltip(
                                  message: Text('rightTop'),
                                  alignment: WdsTooltipAlignment.rightTop,
                                ),
                                WdsTooltip(
                                  message: Text('rightCenter'),
                                  alignment: WdsTooltipAlignment.rightCenter,
                                ),
                                WdsTooltip(
                                  message: Text('rightBottom'),
                                  alignment: WdsTooltipAlignment.rightBottom,
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Bottom alignments
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WdsTooltip(
                              message: Text('bottomLeft'),
                              alignment: WdsTooltipAlignment.bottomLeft,
                            ),
                            WdsTooltip(
                              message: Text('bottomCenter'),
                              alignment: WdsTooltipAlignment.bottomCenter,
                            ),
                            WdsTooltip(
                              message: Text('bottomRight'),
                              alignment: WdsTooltipAlignment.bottomRight,
                            ),
                          ],
                        ),
                      ],
                    ),
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
