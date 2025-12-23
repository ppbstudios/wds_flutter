import 'package:wds/wds.dart';
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'SectionMessage',
  type: SectionMessage,
  path: '[component]/',
)
Widget buildWdsSectionMessageUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'SectionMessage',
    description:
        '특정 섹션이나 영역 내에서 중요한 정보나 피드백을 전달하는 메시지입니다. 사용자가 필요한 행동을 취할 수 있도록 돕습니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final variant = context.knobs.object.dropdown<WdsSectionMessageVariant>(
    label: 'variant',
    description: '메시지의 표시 형태를 선택하세요',
    options: WdsSectionMessageVariant.values,
    initialOption: WdsSectionMessageVariant.normal,
    labelBuilder: (v) => v.name,
  );

  final message = context.knobs.string(
    label: 'message',
    description: 'SectionMessage에 표시될 메시지를 입력해 주세요',
    initialValue: '정보를 확인해주세요',
  );

  return WidgetbookPlayground(
    info: [
      'variant: ${variant.name}',
      'message: "$message"',
      'padding: EdgeInsets.all(16)',
      'iconSize: 16x16',
      'iconSpacing: 4px',
      'textStyle: body14NormalMedium',
      _getVariantInfo(variant),
    ],
    child: _SectionMessagePlaygroundControls(
      variant: variant,
      message: message,
    ),
  );
}

String _getVariantInfo(WdsSectionMessageVariant variant) {
  return switch (variant) {
    WdsSectionMessageVariant.normal =>
      'backgroundColor: backgroundAlternative, textColor: textNeutral, iconColor: neutral500',
    WdsSectionMessageVariant.highlight =>
      'backgroundColor: statusPositive, textColor: statusPositive, iconColor: primary',
    WdsSectionMessageVariant.warning =>
      'backgroundColor: orange50, textColor: statusCautionaty, iconColor: statusCautionaty',
  };
}

class _SectionMessagePlaygroundControls extends StatefulWidget {
  const _SectionMessagePlaygroundControls({
    required this.variant,
    required this.message,
  });

  final WdsSectionMessageVariant variant;
  final String message;

  @override
  State<_SectionMessagePlaygroundControls> createState() =>
      _SectionMessagePlaygroundControlsState();
}

class _SectionMessagePlaygroundControlsState
    extends State<_SectionMessagePlaygroundControls> {
  WdsMessageController? _controller;

  @override
  void dispose() {
    _controller?.dismiss();
    super.dispose();
  }

  void _showSectionMessage() {
    _controller?.dismiss();
    final sectionMessage = _buildSectionMessage(
      variant: widget.variant,
      message: widget.message,
    );
    _controller = context.onMessage(sectionMessage);
    setState(() {});
  }

  Widget _buildSectionMessage({
    required WdsSectionMessageVariant variant,
    required String message,
  }) {
    return switch (variant) {
      WdsSectionMessageVariant.normal => WdsSectionMessage.normal(
          message: message,
        ),
      WdsSectionMessageVariant.highlight => WdsSectionMessage.highlight(
          message: message,
        ),
      WdsSectionMessageVariant.warning => WdsSectionMessage.warning(
          message: message,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        WdsSquareButton.normal(
          onTap: _showSectionMessage,
          child: const Text(
            'SectionMessage 띄우기',
          ),
        ),
      ],
    );
  }
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'SectionMessage',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['normal', 'highlight', 'warning'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsSectionMessage.normal(
              message: '기본 정보를 확인해주세요',
            ),
            SizedBox(height: 16),
            WdsSectionMessage.highlight(
              message: '상품을 게시글에 태그했어요',
            ),
            SizedBox(height: 16),
            WdsSectionMessage.warning(
              message: '장바구니에 상품이 없어요',
            ),
          ],
        ),
      ),
      SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'only message',
        labels: ['normal', 'highlight', 'warning'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsSectionMessage.normal(
              message: '아이콘 없이 표시되는 메시지입니다',
            ),
            WdsSectionMessage.highlight(
              message: '성공 메시지입니다',
            ),
            WdsSectionMessage.warning(
              message: '경고 메시지입니다',
            ),
          ],
        ),
      ),
    ],
  );
}
