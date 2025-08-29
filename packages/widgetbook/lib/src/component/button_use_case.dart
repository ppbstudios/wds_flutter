import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Button',
  type: Button,
  path: '[component]/',
)
Widget buildWdsButtonUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Button',
    description: '사용자가 원하는 동작을 수행할 수 있도록 돕습니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final variant = context.knobs.object.dropdown<String>(
    label: 'variant',
    options: ['cta', 'primary', 'secondary'],
    initialOption: 'cta',
    description: '버튼의 성격을 정의해요',
  );

  final size = context.knobs.object.dropdown<String>(
    label: 'size',
    options: ['xlarge', 'large', 'medium', 'small', 'tiny'],
    initialOption: 'medium',
    description: '버튼의 크기(size, padding, typography)를 정의해요',
  );

  final isEnabled = context.knobs.boolean(
    label: 'isEnabled',
    initialValue: true,
    description: '버튼의 활성화 상태를 정의해요',
  );

  final text = context.knobs.string(
    label: 'text',
    initialValue: '텍스트',
    description: '버튼의 텍스트를 정의해요',
  );

  final styleBySize = <String, TextStyle>{
    'xlarge': WdsSemanticTypography.body15NormalBold,
    'large': WdsSemanticTypography.body15NormalBold,
    'medium': WdsSemanticTypography.body13NormalMedium,
    'small': WdsSemanticTypography.caption12Medium,
    'tiny': WdsSemanticTypography.caption12Medium,
  };

  final child = Text(text, style: styleBySize[size]!);
  void onTap() => print('Button pressed: $variant $size');

  final sizeValue = switch (size) {
    'xlarge' => WdsButtonSize.xlarge,
    'large' => WdsButtonSize.large,
    'medium' => WdsButtonSize.medium,
    'small' => WdsButtonSize.small,
    'tiny' => WdsButtonSize.tiny,
    _ => WdsButtonSize.medium,
  };

  final variantValue = switch (variant) {
    'cta' => WdsButtonVariant.cta,
    'primary' => WdsButtonVariant.primary,
    'secondary' => WdsButtonVariant.secondary,
    _ => WdsButtonVariant.cta,
  };

  final button = WdsButton(
    onTap: onTap,
    isEnabled: isEnabled,
    variant: variantValue,
    size: sizeValue,
    child: child,
  );

  return WidgetbookPlayground(
    info: [
      'variant: $variant',
      'size: $size',
      'state: ${isEnabled ? 'enabled' : 'disabled'}',
    ],
    child: button,
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Button',
    spacing: 32,
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['cta', 'primary', 'secondary'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsButton(
              onTap: () => print('CTA pressed'),
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => print('Primary pressed'),
              variant: WdsButtonVariant.primary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => print('Secondary pressed'),
              variant: WdsButtonVariant.secondary,
              child: const Text('텍스트'),
            ),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'size',
        labels: ['xlarge', 'large', 'medium', 'small', 'tiny'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsButton(
              onTap: () => print('XL pressed'),
              size: WdsButtonSize.xlarge,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => print('L pressed'),
              size: WdsButtonSize.large,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => print('M pressed'),
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => print('S pressed'),
              size: WdsButtonSize.small,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => print('TY pressed'),
              size: WdsButtonSize.tiny,
              child: const Text('텍스트'),
            ),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'pressed', 'disabled'],
        content: Column(
          spacing: 12,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                WdsButton(
                  onTap: () => print('CTA default'),
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => print('Primary default'),
                  variant: WdsButtonVariant.primary,
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => print('Secondary default'),
                  variant: WdsButtonVariant.secondary,
                  child: const Text('텍스트'),
                ),
                // Square 는 별도 SquareButton 컴포넌트로 분리됨
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                WdsButton(
                  onTap: () => print('CTA pressed'),
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => print('Primary pressed'),
                  variant: WdsButtonVariant.primary,
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => print('Secondary pressed'),
                  variant: WdsButtonVariant.secondary,
                  child: const Text('텍스트'),
                ),
                // Square 는 별도 SquareButton 컴포넌트로 분리됨
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                WdsButton(
                  onTap: () => print('CTA disabled'),
                  isEnabled: false,
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => print('Primary disabled'),
                  variant: WdsButtonVariant.primary,
                  isEnabled: false,
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => print('Secondary disabled'),
                  variant: WdsButtonVariant.secondary,
                  isEnabled: false,
                  child: const Text('텍스트'),
                ),
                // Square 는 별도 SquareButton 컴포넌트로 분리됨
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
