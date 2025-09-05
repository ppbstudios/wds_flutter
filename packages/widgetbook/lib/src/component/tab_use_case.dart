import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Tabs',
  type: Tabs,
  path: '[component]/',
)
Widget buildWdsTabsUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Tabs',
    description: '선택하여 목적에 따라 구분된 선택지로 이동할 수 있습니다.',
    children: [
      _buildTextTabsPlayground(context),
      _buildLineTabsPlayground(context),
      const SizedBox(height: 32),
      _buildTextTabsDemonstrationSection(context),
      _buildLineTabsDemonstrationSection(context),
    ],
  );
}

Widget _buildTextTabsPlayground(BuildContext context) {
  return const _TextTabsPlayground();
}

Widget _buildLineTabsPlayground(BuildContext context) {
  return const _LineTabsPlayground();
}

Widget _buildTextTabsDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'TextTabs',
    children: [
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'focused', 'featured'],
        content: Column(
          spacing: 8,
          children: [
            WdsTextTabs(
              tabs: [
                WdsTextTab(label: '추천'),
                WdsTextTab(label: '매장 단독 혜택'),
                WdsTextTab(label: '신상'),
                WdsTextTab(label: '할인'),
              ],
            ),
            WdsTextTabs(
              tabs: [
                WdsTextTab(label: '추천'),
                WdsTextTab(
                  label: '매장 단독 혜택',
                  featuredColor: WdsColors.primary,
                ),
                WdsTextTab(label: '신상'),
                WdsTextTab(label: '할인'),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildLineTabsDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'LineTabs',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: const ['length == 2', 'length == 3'],
        content: Column(
          spacing: 24,
          children: [
            WdsLineTabs(
              tabs: const ['텍스트', '텍스트'],
              controller: WdsTextTabsController(length: 2),
            ),
            WdsLineTabs(
              tabs: const ['텍스트', '텍스트'],
              controller: WdsTextTabsController(length: 2, initialIndex: 1),
            ),
            WdsLineTabs(
              tabs: const ['텍스트', '텍스트', '텍스트'],
              controller: WdsTextTabsController(length: 3, initialIndex: 1),
            ),
          ],
        ),
      ),
    ],
  );
}

class _TextTabsPlayground extends StatefulWidget {
  const _TextTabsPlayground();

  @override
  State<_TextTabsPlayground> createState() => _TextTabsPlaygroundState();
}

class _TextTabsPlaygroundState extends State<_TextTabsPlayground> {
  late WdsTextTabsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WdsTextTabsController(length: 6, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    final int count = context.knobs.int.slider(
      label: '첫번째 Playground: TextTabs',
      description:
          '탭의 개수를 조절할 수 있어요.\n\u2022 DotBadge: 1번째\n\u2022 featured: 3번째, 5번째',
      initialValue: 3,
      min: 2,
      max: 6,
    );

    if (_controller.length != count) {
      _controller = WdsTextTabsController(length: count, initialIndex: 1);
    }

    final List<String> tabs = List.generate(count, (i) => '추천 ${i + 1}');
    final List<Color?> featuredColors = [
      null,
      null,
      WdsColors.primary,
      null,
      WdsColors.secondary,
      null,
    ];

    return WidgetbookPlayground(
      backgroundColor: WdsColors.coolNeutral50,
      info: [
        'count: $count',
        'currentIndex: ${_controller.index}',
        'spacing: start=16, between=24, vertical=8',
        'featured: index=2 .primary fixed',
      ],
      child: WdsTextTabs(
        tabs: [
          for (int i = 0; i < tabs.length; i++)
            WdsTextTab(
              label: tabs[i],
              featuredColor: featuredColors[i],
              badgeAlignment: i == 0 ? Alignment.topRight : null,
            ),
        ],
        controller: _controller,
        onTap: (i) => _controller.setIndex(i),
      ),
    );
  }
}

class _LineTabsPlayground extends StatefulWidget {
  const _LineTabsPlayground();

  @override
  State<_LineTabsPlayground> createState() => _LineTabsPlaygroundState();
}

class _LineTabsPlaygroundState extends State<_LineTabsPlayground> {
  late WdsTextTabsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WdsTextTabsController(length: 2);
  }

  @override
  Widget build(BuildContext context) {
    final int count = context.knobs.object.dropdown<int>(
      label: '두번째 Playground: LineTabs',
      description: '탭의 개수를 조절할 수 있어요.',
      options: const [2, 3],
      initialOption: 2,
    );

    if (_controller.length != count) {
      _controller = WdsTextTabsController(length: count);
    }

    final List<String> tabs =
        count == 2 ? const ['첫번째', '두번째'] : const ['첫번째', '두번째', '세번째'];

    return WidgetbookPlayground(
      info: [
        'count: $count',
        'currentIndex: ${_controller.index}',
        'selected: typography .body15ReadingBold, color .normal',
        'unselected: typography .body15ReadingMedium, color .neutral',
        'underline: selected=2px black, others=1px alternative',
      ],
      child: WdsLineTabs(
        tabs: tabs,
        controller: _controller,
        onTap: (i) => _controller.setIndex(i),
      ),
    );
  }
}
