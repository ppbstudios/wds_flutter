import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'SearchField',
  type: SearchField,
  path: '[component]/',
)
Widget buildWdsSearchFieldUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'SearchField',
    description: '콘텐츠를 검색할때 사용합니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final size = context.knobs.object.dropdown(
    label: 'size',
    options: [
      WdsSearchFieldSize.small,
      WdsSearchFieldSize.medium,
    ],
    labelBuilder: (value) => value.name,
  );

  final enabled = context.knobs.boolean(
    label: 'isEnabled',
    initialValue: true,
  );

  final hint = context.knobs.string(
    label: 'hint',
    initialValue: '검색어를 입력하세요',
    description: '아무것도 입력되지 않을 때 보여질 텍스트를 입력해 주세요',
  );

  final widget = WdsSearchField(
    size: size,
    hintText: hint,
    enabled: enabled,
  );

  return WidgetbookPlayground(
    info: [
      'size: ${size.name}',
      'state: ${enabled ? 'enabled' : 'disabled'}',
      'hint: $hint',
    ],
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: widget,
    ),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'SearchField',
    children: [
      WidgetbookSubsection(
        title: 'size',
        labels: ['small', 'medium'],
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 280,
              child: WdsSearchField(
                hintText: '검색어를 입력하세요',
              ),
            ),
            SizedBox(
              width: 280,
              child: WdsSearchField(
                hintText: '검색어를 입력하세요',
                size: WdsSearchFieldSize.medium,
              ),
            ),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'disabled'],
        content: Wrap(
          spacing: 16,
          children: [
            SizedBox(
              width: 280,
              child: WdsSearchField(hintText: '검색어를 입력하세요'),
            ),
            SizedBox(
              width: 280,
              child: WdsSearchField(hintText: '비활성', enabled: false),
            ),
          ],
        ),
      ),
    ],
  );
}
