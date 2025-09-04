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

  final hasIcon = context.knobs.boolean(
    label: 'hasIcon',
    description: '아이콘을 표시할지 선택하세요',
  );

  final icon = context.knobs.object.dropdown<WdsIcon>(
    label: 'icon',
    initialOption: WdsIcon.info,
    options: WdsIcon.values,
    labelBuilder: (v) => v.name,
  );

  return WidgetbookPlayground(
    info: [
      'variant: ${variant.name}',
      'message: "$message"',
      'hasIcon: $hasIcon',
      if (hasIcon) 'icon: ${icon.name}',
      'padding: EdgeInsets.all(16)',
      'iconSize: 16x16',
      'iconSpacing: 4px',
      'textStyle: body14NormalMedium',
      _getVariantInfo(variant),
    ],
    child: _buildSectionMessage(
      variant: variant,
      message: message,
      hasIcon: hasIcon,
      icon: icon,
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

Widget _buildSectionMessage({
  required WdsSectionMessageVariant variant,
  required String message,
  required bool hasIcon,
  required WdsIcon icon,
}) {
  final leadingIcon = hasIcon ? icon : WdsIcon.blank;

  return switch (variant) {
    WdsSectionMessageVariant.normal => WdsSectionMessage.normal(
        message: message,
        leadingIcon: leadingIcon,
      ),
    WdsSectionMessageVariant.highlight => WdsSectionMessage.highlight(
        message: message,
        leadingIcon: leadingIcon,
      ),
    WdsSectionMessageVariant.warning => WdsSectionMessage.warning(
        message: message,
        leadingIcon: leadingIcon,
      ),
  };
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
              leadingIcon: WdsIcon.info,
            ),
            SizedBox(height: 16),
            WdsSectionMessage.highlight(
              message: '상품을 게시글에 태그했어요',
              leadingIcon: WdsIcon.productTag,
            ),
            SizedBox(height: 16),
            WdsSectionMessage.warning(
              message: '장바구니에 상품이 없어요',
              leadingIcon: WdsIcon.cart,
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
              leadingIcon: WdsIcon.blank,
              message: '아이콘 없이 표시되는 메시지입니다',
            ),
            WdsSectionMessage.highlight(
              leadingIcon: WdsIcon.blank,
              message: '성공 메시지입니다',
            ),
            WdsSectionMessage.warning(
              leadingIcon: WdsIcon.blank,
              message: '경고 메시지입니다',
            ),
          ],
        ),
      ),
    ],
  );
}
