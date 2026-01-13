import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Select',
  type: Select,
  path: '[component]/',
)
Widget buildWdsSelectUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Select',
    description: '영역을 누르면 요소가 호출되고 이를 수정 또는 선택할 수 있습니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final title = context.knobs.string(
    label: 'title',
    initialValue: '주제',
    description: '좌측 상단에 표기될 텍스트를 작성해 주세요',
  );

  final selected = context.knobs.string(
    label: 'selected',
    initialValue: '선택된 옵션',
    description: '선택된 옵션을 입력해 주세요',
  );

  final hint = context.knobs.string(
    label: 'hintText',
    initialValue: '텍스트를 입력해주세요.',
  );

  final state = context.knobs.list<WdsSelectState>(
    label: 'state',
    options: WdsSelectState.values,
    initialOption: WdsSelectState.active,
    description: '컴포넌트의 상태를 선택해 주세요',
  );

  final select = WdsSelect(
    selected: selected.isEmpty ? null : selected,
    title: title.isEmpty ? null : title,
    hintText: hint,
    state: state,
    onTap: () => debugPrint('Select tapped'),
  );

  return WidgetbookPlayground(
    info: const [
      'padding: 16,12,16,12',
      'radius: v8',
      'height: 48px',
      'icon spacing: 10px',
      'hint vertical padding: 2px',
    ],
    child: ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 250, maxWidth: 360),
      child: select,
    ),
  );
}

typedef _SelectState = (String? selected, WdsSelectState state, String? title);

Widget _buildDemonstrationSection(BuildContext context) {
  List<_SelectState> states = [
    (null, WdsSelectState.inactive, null), // inactive
    ('-0.50', WdsSelectState.active, null), // active
    ('-0.50', WdsSelectState.selected, null), // selected
    (null, WdsSelectState.disabled, null), // disabled
    (null, WdsSelectState.inactive, '옵션 선택'), // inactive
    ('-0.50', WdsSelectState.active, '옵션 선택'), // active
    ('-0.50', WdsSelectState.selected, '옵션 선택'), // selected
    (null, WdsSelectState.disabled, '옵션 선택'), // disabled
  ];

  return WidgetbookSection(
    title: 'Select',
    children: [
      WidgetbookSubsection(
        title: 'state',
        labels: ['inactive', 'active', 'selected', 'disabled'],
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: states
              .map(
                (state) => ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 250,
                    maxWidth: 320,
                  ),
                  child: WdsSelect(
                    selected: state.$1,
                    state: state.$2,
                    title: state.$3,
                    hintText: '옵션을 선택해 주세요',
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ],
  );
}
