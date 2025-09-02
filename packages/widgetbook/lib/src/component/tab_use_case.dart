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
              tabs: ['추천', '매장 단독 혜택', '신상', '할인'],
              currentIndex: 0,
            ),
            WdsTextTabs(
              tabs: ['추천', '매장 단독 혜택', '신상', '할인'],
              currentIndex: 2,
              featuredColors: {2: WdsColors.primary},
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
            WdsLineTabs(tabs: const ['텍스트', '텍스트'], currentIndex: 0),
            WdsLineTabs(tabs: const ['텍스트', '텍스트'], currentIndex: 1),
            WdsLineTabs(tabs: const ['텍스트', '텍스트', '텍스트'], currentIndex: 1),
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
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final int count = context.knobs.int.slider(
      label: 'count (TextTabs)',
      initialValue: 6,
      min: 2,
      max: 8,
    );

    if (_currentIndex >= count) {
      _currentIndex = count - 1;
    }

    final List<String> tabs = List.generate(count, (i) => '추천 ${i + 1}');

    return WidgetbookPlayground(
      backgroundColor: WdsColors.coolNeutral50,
      info: [
        'count: $count',
        'currentIndex: $_currentIndex',
        'spacing: start=16, between=24, vertical=8',
      ],
      child: WdsTextTabs(
        tabs: tabs,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final int count = context.knobs.object.dropdown<int>(
      label: 'count (LineTabs)',
      options: const [2, 3],
      initialOption: 2,
    );

    if (_currentIndex >= count) {
      _currentIndex = count - 1;
    }

    final List<String> tabs =
        count == 2 ? const ['첫번째', '두번째'] : const ['첫번째', '두번째', '세번째'];

    return WidgetbookPlayground(
      info: [
        'count: $count',
        'currentIndex: $_currentIndex',
        'selected: typography .body15ReadingBold, color .normal',
        'unselected: typography .body15ReadingMedium, color .neutral',
        'underline: selected=2px black, others=1px alternative',
      ],
      child: WdsLineTabs(
        tabs: tabs,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
