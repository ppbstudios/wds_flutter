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

  final helper = context.knobs.string(
    label: 'helper',
    initialValue: '비밀번호는 8~16자 이내로 입력해 주세요',
    description: '텍스트 입력란 아래에 표시될 헬퍼 텍스트를 입력해 주세요',
  );

  final error = context.knobs.string(
    label: 'error',
    description: '텍스트 입력란 아래에 표시될 에러 텍스트를 입력해 주세요. 작성하면 error 상태로 바뀝니다.',
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
    helperText: helper,
    errorText: error,
    controller: controller,
  );

  return WidgetbookPlayground(
    info: [
      'state: ${enabled ? 'inactive(아무것도 입력되지 않은 상태)' : 'disabled'}',
      'label: $label',
      'hint: $hint',
      if (helper.isNotEmpty) 'helper: $helper',
      if (error.isNotEmpty) 'error: $error',
    ],
    child: SizedBox(width: 360, child: area),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  final activeController = TextEditingController(text: '입력된 내용');
  final errorController = TextEditingController(text: '에러가 발생할 내용');

  return WidgetbookSection(
    title: 'TextArea',
    spacing: 32,
    children: [
      WidgetbookSubsection(
        title: 'state',
        labels: ['inactive', 'active', 'focused', 'error', 'disabled'],
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
                controller: errorController,
                validator: (_) => '에러는 이렇게 발생해요',
              ),
            ),
            SizedBox(
              width: 320,
              child: WdsTextArea(
                label: '주제',
                hintText: '텍스트를 입력해 주세요',
                helperText: '설명',
                controller: activeController,
                isEnabled: false,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
