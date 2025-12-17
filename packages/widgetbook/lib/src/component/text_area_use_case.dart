import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'TextArea',
  type: TextArea,
  path: '[component]/',
)
Widget buildWdsTextAreaUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'TextArea',
    description: '긴 텍스트를 입력할 때 사용합니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final enabled = context.knobs.boolean(
    label: 'enabled',
    initialValue: true,
  );

  final label = context.knobs.string(
    label: 'label',
    initialValue: '주제',
    description: '텍스트 입력란 위에 표시될 label 텍스트를 입력해 주세요',
  );

  final hint = context.knobs.string(
    label: 'hint',
    initialValue: '이름을 입력해 주세요',
    description: '아무것도 입력되지 않을 때 보여질 텍스트를 입력해 주세요',
  );

  final text = context.knobs.string(
    label: 'initial text',
    description: '텍스트 입력란에 초기 값을 입력해 주세요',
  );

  final controller = TextEditingController(text: text);

  final WdsTextArea area = WdsTextArea(
    isEnabled: enabled,
    label: label,
    hintText: hint,
    controller: controller,
  );

  return WidgetbookPlayground(
    info: [
      'state: ${enabled ? 'inactive(아무것도 입력되지 않은 상태)' : 'disabled'}',
      'label: $label',
      'hint: $hint',
    ],
    child: SizedBox(width: 360, child: area),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  final activeController = TextEditingController(text: '입력된 내용');

  // 최소 높이(60px)를 보여주기 위한 빈 컨트롤러
  final minHeightController = TextEditingController();
  // 최대 높이(320px)를 보여주기 위한 충분히 긴 텍스트
  // 320px 높이에 도달하려면 약 2000자 정도의 텍스트가 필요
  final maxHeightText = List.generate(
    100,
    (_) => '긴 텍스트를 입력하면 높이가 자동으로 확장됩니다. 최대 높이는 320px까지 확장 가능합니다. ',
  ).join();
  final maxHeightController = TextEditingController(text: maxHeightText);

  return WidgetbookSection(
    title: 'TextArea',
    spacing: 32,
    children: [
      WidgetbookSubsection(
        title: 'state',
        labels: ['inactive', 'active', 'focused', 'disabled'],
        content: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            const SizedBox(
              width: 320,
              child: WdsTextArea(label: '주제', hintText: '텍스트를 입력해 주세요'),
            ),
            SizedBox(
              width: 320,
              child: WdsTextArea(
                label: '주제',
                hintText: '텍스트를 입력해 주세요',
                controller: activeController,
              ),
            ),
            SizedBox(
              width: 320,
              child: WdsTextArea(
                label: '주제',
                hintText: '텍스트를 입력해 주세요',
                controller: activeController,
                isEnabled: false,
              ),
            ),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'height',
        labels: ['최소 높이 (60px)', '최대 높이 (320px)'],
        content: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            SizedBox(
              width: 320,
              child: WdsTextArea(
                label: '주제',
                hintText: '텍스트를 입력해 주세요',
                controller: minHeightController,
              ),
            ),
            SizedBox(
              width: 320,
              child: WdsTextArea(
                label: '주제',
                hintText: '텍스트를 입력해 주세요',
                controller: maxHeightController,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
