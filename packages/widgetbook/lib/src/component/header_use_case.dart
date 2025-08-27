import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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
  );
  final titleText = context.knobs.string(label: 'title', initialValue: '타이틀');
  final enableLeading = context.knobs.boolean(
    label: 'leading',
    initialValue: false,
    description: 'leading 영역 on/off',
  );
  final actionsCount = context.knobs.int.slider(
    label: 'actions',
    initialValue: 1,
    min: 0,
    max: 3,
    divisions: 3,
  );

  final List<Widget> actions = List.generate(actionsCount, (i) {
    return WdsIconButton(
      onTap: () => print('action $i'),
      icon: WdsIcon.chevronRight.build(width: 24, height: 24),
    );
  });

  // leading 위젯 샘플
  final Widget? leadingWidget = enableLeading
      ? WdsIconButton(
          onTap: () => print('leading'),
          icon: WdsIcon.chevronRight.build(width: 24, height: 24),
        )
      : null;

  if (type == 'logo' && enableLeading) {
    // logo 변형에서는 leading 강제 off + 스낵바 알림
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        const SnackBar(content: Text('logo variant에서는 leading을 사용할 수 없어요.')),
      );
    });
  }

  Widget header = switch (type) {
    'logo' => WdsHeader.logo(actions: actions),
    'title' => WdsHeader.title(
        title: Text(titleText),
        leading: type == 'logo' ? null : leadingWidget,
        actions: actions),
    'search' => WdsHeader.search(
        title: Text('준비중이에요..🧑‍💻'),
        leading: type == 'logo' ? null : leadingWidget,
        actions: actions.isEmpty ? actions : actions.sublist(0, 1)),
    _ => WdsHeader.title(
        title: Text(titleText),
        leading: type == 'logo' ? null : leadingWidget,
        actions: actions),
  };

  return WidgetbookPlayground(
    height: 160,
    layout: PlaygroundLayout.stretch,
    backgroundColor: WdsColorCoolNeutral.v50,
    child: header,
    info: [
      'layout: stretch',
      'variant: $type',
      'actions: ${actions.length}',
      'leading: ${enableLeading && type != 'logo'}',
    ],
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
            WdsHeader.logo(actions: const []),
            WdsHeader.title(
              title: const Text('타이틀'),
              actions: [
                WdsIconButton(
                  onTap: () => print('search'),
                  icon: WdsIcon.chevronRight.build(width: 24, height: 24),
                ),
                WdsIconButton(
                  onTap: () => print('more'),
                  icon: WdsIcon.chevronRight.build(width: 24, height: 24),
                ),
              ],
            ),
            WdsHeader.search(
              title: const Text('검색'),
              actions: [
                WdsIconButton(
                  onTap: () => print('submit'),
                  icon: WdsIcon.chevronRight.build(width: 24, height: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
