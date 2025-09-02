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

  final enabled = context.knobs.boolean(
    label: 'isEnabled',
    initialValue: true,
    description: '누를 수 있는 지 여부를 결정해요',
  );

  final expanded = context.knobs.boolean(
    label: 'isExpanded',
    description: '오른쪽 아이콘이 바뀌어요',
  );

  final variant = context.knobs.object.dropdown<WdsSelectVariant>(
    label: 'variant',
    options: WdsSelectVariant.values,
    initialOption: WdsSelectVariant.normal,
    labelBuilder: (v) => v.name,
  );

  final select = WdsSelect(
    selected: selected.isEmpty ? null : selected,
    title: title.isEmpty ? null : title,
    hintText: hint,
    isEnabled: enabled,
    isExpanded: expanded,
    variant: variant,
    onTap: () => debugPrint('Select tapped'),
  );

  return WidgetbookPlayground(
    info: const [
      'padding: 16,12,16,12',
      'radius: v8',
      'border: 1px alternative',
      'icon spacing: 10px',
      'hint vertical padding: 2px',
    ],
    child: ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 250, maxWidth: 360),
      child: select,
    ),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Select',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['normal', 'blocked'],
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _SelectDemo(variant: WdsSelectVariant.normal, enabled: true),
            _SelectDemo(variant: WdsSelectVariant.blocked, enabled: true),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'disabled'],
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _SelectDemo(
              variant: WdsSelectVariant.normal,
              enabled: true,
            ),
            _SelectDemo(
              variant: WdsSelectVariant.blocked,
              enabled: true,
            ),
            _SelectDemo(
              variant: WdsSelectVariant.normal,
              enabled: false,
            ),
            _SelectDemo(
              variant: WdsSelectVariant.blocked,
              enabled: false,
            ),
            _SelectDemo(
              variant: WdsSelectVariant.normal,
              enabled: true,
              title: '주제',
            ),
            _SelectDemo(
              variant: WdsSelectVariant.blocked,
              enabled: true,
              title: '주제',
            ),
            _SelectDemo(
              variant: WdsSelectVariant.normal,
              enabled: false,
              title: '주제',
            ),
            _SelectDemo(
              variant: WdsSelectVariant.blocked,
              enabled: false,
              title: '주제',
            ),
          ],
        ),
      ),
    ],
  );
}

class _SelectDemo extends StatelessWidget {
  const _SelectDemo({
    required this.variant,
    required this.enabled,
    this.title,
  });

  final WdsSelectVariant variant;

  final bool enabled;

  final String? title;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 250, maxWidth: 320),
      child: WdsSelect(
        title: title,
        selected: null,
        hintText: '옵션을 선택해 주세요',
        isEnabled: enabled,
        variant: variant,
      ),
    );
  }
}
