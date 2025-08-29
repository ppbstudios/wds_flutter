import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'TextField',
  type: TextField,
  path: '[component]/',
)
Widget buildWdsTextFieldUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'TextField',
    description: '일반 텍스트 입력 필드. outlined/box variant를 지원합니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
      _buildVerifiedSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final variant = context.knobs.object.dropdown<WdsTextFieldVariant>(
    label: 'variant',
    options: WdsTextFieldVariant.values,
    initialOption: WdsTextFieldVariant.outlined,
    description: '텍스트 입력란의 모양을 선택해 주세요',
    labelBuilder: (value) => value.name,
  );

  final enabled = context.knobs.boolean(
    label: 'enabled',
    initialValue: true,
  );

  final label = context.knobs.string(
    label: 'label (outlined 만 지원)',
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
    initialValue: '',
    description: '텍스트 입력란 아래에 표시될 에러 텍스트를 입력해 주세요. 작성하면 error 상태로 바뀝니다.',
  );

  final text = context.knobs.string(
    label: 'initial text',
    initialValue: '',
    description: '텍스트 입력란에 초기 값을 입력해 주세요',
  );

  final controller = TextEditingController(text: text);

  final WdsTextField field;
  if (variant == WdsTextFieldVariant.outlined) {
    field = WdsTextField.outlined(
      isEnabled: enabled,
      controller: controller,
      label: label,
      hintText: hint,
      helperText: helper.isEmpty ? null : helper,
      errorText: error.isEmpty ? null : error,
    );
  } else {
    field = WdsTextField.box(
      isEnabled: enabled,
      controller: controller,
      label: label,
      hintText: hint,
      helperText: helper.isEmpty ? null : helper,
      errorText: error.isEmpty ? null : error,
    );
  }

  return WidgetbookPlayground(
    layout: PlaygroundLayout.center,
    child: SizedBox(width: 360, child: field),
    info: [
      'variant: ${variant.name}',
      'state: ${enabled ? 'enabled' : 'disabled'}',
      'label: $label',
      'hint: $hint',
      if (helper.isNotEmpty) 'helper: $helper',
      if (error.isNotEmpty) 'error: $error',
    ],
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'TextField',
    spacing: 32,
    children: [
      WidgetbookSubsection(
        title: 'outlined',
        labels: const ['enabled', 'focused', 'active', 'error', 'disabled'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            /// enabled
            const SizedBox(
              width: 320,
              child: WdsTextField.outlined(
                label: '주제',
                hintText: '힌트',
              ),
            ),

            /// focused
            const SizedBox(
              width: 320,
              child: _FocusWrapper(
                child: WdsTextField.outlined(
                  label: '주제',
                  hintText: '힌트',
                ),
              ),
            ),

            /// active
            SizedBox(
              width: 320,
              child: _ActiveWrapper(
                child: const WdsTextField.outlined(
                  label: '주제',
                  hintText: '힌트',
                ),
              ),
            ),

            /// error
            const SizedBox(
              width: 320,
              child: WdsTextField.outlined(
                label: '주제',
                hintText: '힌트',
                errorText: '오류 메시지',
              ),
            ),

            /// disabled
            const SizedBox(
              width: 320,
              child: WdsTextField.outlined(
                label: '주제',
                hintText: '힌트',
                helperText: '헬퍼',
                errorText: null,
                isEnabled: false,
              ),
            ),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'box',
        labels: const ['enabled', 'focused', 'active', 'error', 'disabled'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            const SizedBox(
              width: 320,
              child: WdsTextField.box(
                hintText: '힌트',
              ),
            ),
            const SizedBox(
              width: 320,
              child: _FocusWrapper(
                child: WdsTextField.box(
                  hintText: '힌트',
                ),
              ),
            ),
            SizedBox(
              width: 320,
              child: _ActiveWrapper(
                child: const WdsTextField.box(
                  hintText: '힌트',
                ),
              ),
            ),
            const SizedBox(
              width: 320,
              child: WdsTextField.box(
                hintText: '힌트',
                errorText: '오류 메시지',
              ),
            ),
            const SizedBox(
              width: 320,
              child: WdsTextField.box(
                hintText: '힌트',
                isEnabled: false,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

/// 인증/버튼 결합 패턴 예시 (outlined 전용)
Widget _buildVerifiedSection(BuildContext context) {
  return WidgetbookSection(
    title: 'verified (outlined + button)',
    spacing: 16,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          const Expanded(
            child: WdsTextField.outlined(
              label: '휴대폰 번호',
              hintText: '입력',
            ),
          ),
          WdsButton(
            onTap: () => print('인증!'),
            size: WdsButtonSize.small,
            variant: WdsButtonVariant.secondary,
            child: const Text('인증'),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          const Expanded(
            child: WdsTextField.outlined(
              label: '주제',
              hintText: '텍스트를 입력해주세요.',
            ),
          ),
          WdsButton(
            onTap: () => print('CTA'),
            size: WdsButtonSize.small,
            variant: WdsButtonVariant.cta,
            child: const Text('텍스트'),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          const Expanded(
            child: WdsTextField.outlined(
              label: '주제',
              hintText: '텍스트를 입력해주세요.',
            ),
          ),
          WdsButton(
            onTap: () => print('PRIMARY'),
            size: WdsButtonSize.small,
            variant: WdsButtonVariant.primary,
            child: const Text('텍스트'),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          const Expanded(
            child: WdsTextField.outlined(
              label: '주제',
              hintText: '텍스트를 입력해주세요.',
            ),
          ),
          WdsButton(
            onTap: null,
            isEnabled: false,
            size: WdsButtonSize.small,
            variant: WdsButtonVariant.secondary,
            child: const Text('텍스트'),
          ),
        ],
      ),
    ],
  );
}

// Helper wrappers for demonstration
class _FocusWrapper extends StatefulWidget {
  const _FocusWrapper({required this.child});
  final WdsTextField child;
  @override
  State<_FocusWrapper> createState() => _FocusWrapperState();
}

class _FocusWrapperState extends State<_FocusWrapper> {
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child.variant == WdsTextFieldVariant.outlined) {
      return WdsTextField.outlined(
        label: widget.child.label,
        hintText: widget.child.hintText,
        helperText: widget.child.helperText,
        errorText: widget.child.errorText,
        isEnabled: widget.child.isEnabled,
        focusNode: _focusNode,
      );
    }

    return WdsTextField.box(
      label: widget.child.label,
      hintText: widget.child.hintText,
      helperText: widget.child.helperText,
      errorText: widget.child.errorText,
      isEnabled: widget.child.isEnabled,
      focusNode: _focusNode,
    );
  }
}

class _ActiveWrapper extends StatefulWidget {
  const _ActiveWrapper({required this.child});
  final WdsTextField child;
  @override
  State<_ActiveWrapper> createState() => _ActiveWrapperState();
}

class _ActiveWrapperState extends State<_ActiveWrapper> {
  late final TextEditingController _controller =
      TextEditingController(text: '값');
  @override
  Widget build(BuildContext context) {
    if (widget.child.variant == WdsTextFieldVariant.outlined) {
      return WdsTextField.outlined(
        label: widget.child.label,
        hintText: widget.child.hintText,
        helperText: widget.child.helperText,
        errorText: widget.child.errorText,
        isEnabled: widget.child.isEnabled,
        controller: _controller,
      );
    }

    return WdsTextField.box(
      label: widget.child.label,
      hintText: widget.child.hintText,
      helperText: widget.child.helperText,
      errorText: widget.child.errorText,
      isEnabled: widget.child.isEnabled,
      controller: _controller,
    );
  }
}
