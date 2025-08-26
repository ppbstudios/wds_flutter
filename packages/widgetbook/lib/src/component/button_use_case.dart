import 'package:flutter/material.dart';
import 'package:wds_components/wds_components.dart';
import 'package:wds_tokens/wds_tokens.dart';
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Button',
  type: WdsButton,
  path: 'component/button/',
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
    options: ['cta', 'primary', 'secondary', 'square'],
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
  final onTap = () => print('Button pressed: $variant $size');

  final sizeValue = switch (size) {
    'XLarge' => WdsButtonSize.xlarge,
    'Large' => WdsButtonSize.large,
    'Medium' => WdsButtonSize.medium,
    'Small' => WdsButtonSize.small,
    'Tiny' => WdsButtonSize.tiny,
    _ => WdsButtonSize.medium,
  };

  final variantValue = switch (variant) {
    'cta' => WdsButtonVariant.cta,
    'primary' => WdsButtonVariant.primary,
    'secondary' => WdsButtonVariant.secondary,
    'square' => WdsButtonVariant.square,
    _ => WdsButtonVariant.cta,
  };

  final button = WdsButton(
    onTap: onTap,
    child: child,
    isEnabled: isEnabled,
    variant: variantValue,
    size: sizeValue,
  );

  return WidgetbookPlayground(
    height: 200,
    child: button,
    info: [
      'variant: $variant',
      'size: $size',
      'state: ${isEnabled ? 'enabled' : 'disabled'}',
    ],
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Button',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['cta', 'primary', 'secondary', 'square'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsButton(
                onTap: () => print('CTA pressed'),
                variant: WdsButtonVariant.cta,
                size: WdsButtonSize.medium,
                child: Text('텍스트')),
            const SizedBox(width: 16),
            WdsButton(
                onTap: () => print('Primary pressed'),
                variant: WdsButtonVariant.primary,
                size: WdsButtonSize.medium,
                child: Text('텍스트')),
            const SizedBox(width: 16),
            WdsButton(
                onTap: () => print('Secondary pressed'),
                variant: WdsButtonVariant.secondary,
                size: WdsButtonSize.medium,
                child: Text('텍스트')),
            const SizedBox(width: 16),
            WdsButton(
                onTap: () => print('Square pressed'),
                variant: WdsButtonVariant.square,
                size: WdsButtonSize.medium,
                child: Text('텍스트')),
          ],
        ),
      ),
      const SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'size',
        labels: ['xlarge', 'large', 'medium', 'small', 'tiny'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsButton(
                onTap: () => print('XL pressed'),
                variant: WdsButtonVariant.cta,
                size: WdsButtonSize.xlarge,
                child: Text('텍스트')),
            const SizedBox(width: 16),
            WdsButton(
                onTap: () => print('L pressed'),
                variant: WdsButtonVariant.cta,
                size: WdsButtonSize.large,
                child: Text('텍스트')),
            const SizedBox(width: 16),
            WdsButton(
                onTap: () => print('M pressed'),
                variant: WdsButtonVariant.cta,
                size: WdsButtonSize.medium,
                child: Text('텍스트')),
            const SizedBox(width: 16),
            WdsButton(
                onTap: () => print('S pressed'),
                variant: WdsButtonVariant.cta,
                size: WdsButtonSize.small,
                child: Text('텍스트')),
            const SizedBox(width: 16),
            WdsButton(
                onTap: () => print('TY pressed'),
                variant: WdsButtonVariant.cta,
                size: WdsButtonSize.tiny,
                child: Text('텍스트')),
          ],
        ),
      ),
      const SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'pressed', 'disabled'],
        content: Column(
          spacing: 12,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WdsButton(
                    onTap: () => print('CTA default'),
                    variant: WdsButtonVariant.cta,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트')),
                const SizedBox(width: 16),
                WdsButton(
                    onTap: () => print('Primary default'),
                    variant: WdsButtonVariant.primary,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트')),
                const SizedBox(width: 16),
                WdsButton(
                    onTap: () => print('Secondary default'),
                    variant: WdsButtonVariant.secondary,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트')),
                const SizedBox(width: 16),
                WdsButton(
                    onTap: () => print('Square default'),
                    variant: WdsButtonVariant.square,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트')),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WdsButton(
                    onTap: () => print('CTA pressed'),
                    variant: WdsButtonVariant.cta,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트')),
                const SizedBox(width: 16),
                WdsButton(
                    onTap: () => print('Primary pressed'),
                    variant: WdsButtonVariant.primary,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트')),
                const SizedBox(width: 16),
                WdsButton(
                    onTap: () => print('Secondary pressed'),
                    variant: WdsButtonVariant.secondary,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트')),
                const SizedBox(width: 16),
                WdsButton(
                    onTap: () => print('Square pressed'),
                    variant: WdsButtonVariant.square,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트')),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WdsButton(
                    onTap: () => print('CTA disabled'),
                    variant: WdsButtonVariant.cta,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트'),
                    isEnabled: false),
                const SizedBox(width: 16),
                WdsButton(
                    onTap: () => print('Primary disabled'),
                    variant: WdsButtonVariant.primary,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트'),
                    isEnabled: false),
                const SizedBox(width: 16),
                WdsButton(
                    onTap: () => print('Secondary disabled'),
                    variant: WdsButtonVariant.secondary,
                    size: WdsButtonSize.medium,
                    child: Text('텍스트'),
                    isEnabled: false),
                const SizedBox(width: 16),
                WdsButton(
                  onTap: () => print('Square disabled'),
                  variant: WdsButtonVariant.square,
                  size: WdsButtonSize.medium,
                  child: Text('텍스트'),
                  isEnabled: false,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
