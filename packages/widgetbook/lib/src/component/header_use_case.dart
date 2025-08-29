import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final Widget _icon = WdsIcon.blank.build(width: 24, height: 24);

@widgetbook.UseCase(
  name: 'Header',
  type: Header,
  path: '[component]/',
)
Widget buildWdsHeaderUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Header',
    description: '상단 내비게이션 영역으로 leading/title/actions로 구성돼요.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final type = context.knobs.object.dropdown<String>(
    label: 'variant',
    options: ['logo', 'title', 'search'],
    initialOption: 'title',
    description: '3가지 유형이 있어요',
  );
  final titleText = context.knobs.string(
    label: 'title',
    initialValue: '텍스트',
    description: 'variant가 title일 때 표기되는 텍스트예요',
  );
  final enableLeading = context.knobs.boolean(
    label: 'leading',
    description: 'variant가 logo일 때는 사용할 수 없어요',
  );
  final actionsCount = context.knobs.int.slider(
    label: 'actions',
    initialValue: 1,
    max: 3,
    divisions: 3,
    description: '오른쪽에 위치하는 아이콘의 개수를 조절할 수 있어요',
  );

  final List<Widget> actions = List.generate(actionsCount, (i) {
    return WdsIconButton(
      onTap: () => print('action $i'),
      icon: _icon,
    );
  });

  // leading 위젯 샘플
  Widget? leadingWidget;
  if (enableLeading) {
    leadingWidget = WdsIconButton(
      onTap: () => print('leading'),
      icon: _icon,
    );
  }

  if (type == 'logo' && enableLeading) {
    // logo 변형에서는 leading 강제 off + 스낵바 알림
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetbookState.maybeOf(context)?.updateQueryField(
        group: 'knobs',
        field: 'leading',
        value: 'false',
      );
    });
  }

  Widget header = switch (type) {
    'logo' => WdsHeader.logo(actions: actions),
    'title' => WdsHeader.title(
        title: Text(titleText),
        leading: type == 'logo' ? null : leadingWidget,
        actions: actions,
      ),
    'search' => WdsHeader.search(
        title: const WdsSearchField(hintText: '검색어를 입력해주세요'),
        leading: type == 'logo' ? null : leadingWidget,
        actions: actions.isEmpty ? actions : actions.sublist(0, 1),
      ),
    _ => WdsHeader.title(
        title: Text(titleText),
        leading: type == 'logo' ? null : leadingWidget,
        actions: actions,
      ),
  };

  return WidgetbookPlayground(
    layout: PlaygroundLayout.stretch,
    backgroundColor: WdsColorCoolNeutral.v50,
    info: [
      'layout: stretch',
      'variant: $type',
      'actions: ${actions.length}',
      'leading: ${enableLeading && type != 'logo'}',
    ],
    child: header,
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Header',
    spacing: 32,
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['logo', 'title', 'search'],
        content: Column(
          spacing: 16,
          children: [
            WdsHeader.logo(),
            WdsHeader.title(
              title: const Text('텍스트'),
              actions: [
                WdsIconButton(
                  onTap: () => print('search'),
                  icon: _icon,
                ),
                WdsIconButton(
                  onTap: () => print('more'),
                  icon: _icon,
                ),
              ],
            ),
            WdsHeader.search(
              title: const WdsSearchField(hintText: '검색어를 입력해주세요'),
              actions: [
                WdsIconButton(
                  onTap: () => print('submit'),
                  icon: _icon,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
