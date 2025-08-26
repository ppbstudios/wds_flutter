import 'package:flutter/material.dart';
import 'package:wds_components/wds_components.dart';
import 'package:wds_tokens/wds_tokens.dart';
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const Map<String, TextStyle> _styleBySize = {
  'XLarge': WdsSemanticTypography.body15NormalBold,
  'Large': WdsSemanticTypography.body15NormalBold,
  'Medium': WdsSemanticTypography.body13NormalMedium,
  'Small': WdsSemanticTypography.caption12Medium,
  'Tiny': WdsSemanticTypography.caption12Medium,
};

TextStyle _textStyleFor(String size) {
  return _styleBySize[size] ?? WdsSemanticTypography.body13NormalMedium;
}

@widgetbook.UseCase(
  name: 'Pill Button',
  type: WdsPillButton,
  path: 'component/button/',
)
Widget buildWdsPillButtonUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Pill Button',
    description: '사용자가 원하는 동작을 수행할 수 있도록 돕습니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final backgroundColor = context.knobs.object.dropdown<String>(
    label: 'backgroundColor',
    options: ['cta', 'primary', 'secondary', 'custom'],
    initialOption: 'cta',
    description: '버튼의 배경 색상을 정의해요',
  );

  final size = context.knobs.object.dropdown<String>(
    label: 'size',
    options: ['XLarge', 'Large', 'Medium', 'Small', 'Tiny'],
    initialOption: 'Medium',
  );

  final isEnabled = context.knobs.boolean(
    label: 'isEnabled',
    initialValue: true,
  );

  final text = context.knobs.string(
    label: 'label',
    initialValue: '텍스트',
  );

  Color? customBackgroundColor;
  Color? customTextColor;
  if (backgroundColor == 'custom') {
    customBackgroundColor = context.knobs.color(
      label: 'Background Color',
      initialValue: WdsColorPink.v500,
    );
    customTextColor = context.knobs.color(
      label: 'Text Color',
      initialValue: WdsColorCommon.white,
    );
  }

  final styleBySize = <String, TextStyle>{
    'XLarge': WdsSemanticTypography.body15NormalBold,
    'Large': WdsSemanticTypography.body15NormalBold,
    'Medium': WdsSemanticTypography.body13NormalMedium,
    'Small': WdsSemanticTypography.caption12Medium,
    'Tiny': WdsSemanticTypography.caption12Medium,
  };

  final child = Text(text, style: styleBySize[size]!);
  final onTap = () => print('PillButton pressed: $backgroundColor $size');

  final button = switch (backgroundColor) {
    'cta' => switch (size) {
        'XLarge' =>
          WdsPillButton.xlCta(onTap: onTap, child: child, isEnabled: isEnabled),
        'Large' =>
          WdsPillButton.lCta(onTap: onTap, child: child, isEnabled: isEnabled),
        'Medium' =>
          WdsPillButton.mCta(onTap: onTap, child: child, isEnabled: isEnabled),
        'Small' =>
          WdsPillButton.sCta(onTap: onTap, child: child, isEnabled: isEnabled),
        'Tiny' =>
          WdsPillButton.tyCta(onTap: onTap, child: child, isEnabled: isEnabled),
        _ => const SizedBox.shrink(),
      },
    'primary' => switch (size) {
        'XLarge' => WdsPillButton.xlPrimary(
            onTap: onTap, child: child, isEnabled: isEnabled),
        'Large' => WdsPillButton.lPrimary(
            onTap: onTap, child: child, isEnabled: isEnabled),
        'Medium' => WdsPillButton.mPrimary(
            onTap: onTap, child: child, isEnabled: isEnabled),
        'Small' => WdsPillButton.sPrimary(
            onTap: onTap, child: child, isEnabled: isEnabled),
        'Tiny' => WdsPillButton.tyPrimary(
            onTap: onTap, child: child, isEnabled: isEnabled),
        _ => const SizedBox.shrink(),
      },
    'secondary' => switch (size) {
        'XLarge' => WdsPillButton.xlSecondary(
            onTap: onTap, child: child, isEnabled: isEnabled),
        'Large' => WdsPillButton.lSecondary(
            onTap: onTap, child: child, isEnabled: isEnabled),
        'Medium' => WdsPillButton.mSecondary(
            onTap: onTap, child: child, isEnabled: isEnabled),
        'Small' => WdsPillButton.sSecondary(
            onTap: onTap, child: child, isEnabled: isEnabled),
        'Tiny' => WdsPillButton.tySecondary(
            onTap: onTap, child: child, isEnabled: isEnabled),
        _ => const SizedBox.shrink(),
      },
    'custom' => switch (size) {
        'XLarge' => WdsPillButton.xlCustom(
            onTap: onTap,
            child: child,
            backgroundColor: customBackgroundColor!,
            color: customTextColor!,
            isEnabled: isEnabled,
          ),
        'Large' => WdsPillButton.lCustom(
            onTap: onTap,
            child: child,
            backgroundColor: customBackgroundColor!,
            color: customTextColor!,
            isEnabled: isEnabled,
          ),
        'Medium' => WdsPillButton.mCustom(
            onTap: onTap,
            child: child,
            backgroundColor: customBackgroundColor!,
            color: customTextColor!,
            isEnabled: isEnabled,
          ),
        'Small' => WdsPillButton.sCustom(
            onTap: onTap,
            child: child,
            backgroundColor: customBackgroundColor!,
            color: customTextColor!,
            isEnabled: isEnabled,
          ),
        'Tiny' => WdsPillButton.tyCustom(
            onTap: onTap,
            child: child,
            backgroundColor: customBackgroundColor!,
            color: customTextColor!,
            isEnabled: isEnabled,
          ),
        _ => const SizedBox.shrink(),
      },
    _ => const SizedBox.shrink(),
  };

  return WidgetbookPlayground(
    height: 200,
    child: button,
    info: [
      'Type: $backgroundColor',
      'Size: $size',
      'State: ${isEnabled ? 'Enabled' : 'Disabled'}',
    ],
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Button',
    children: [
      WidgetbookSubsection(
        title: 'Type',
        labels: ['Cta', 'Primary', 'Secondary', 'Custom'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsPillButton.mCta(
                onTap: () => print('CTA pressed'),
                child: Text('텍스트', style: _textStyleFor('Medium'))),
            const SizedBox(width: 16),
            WdsPillButton.mPrimary(
                onTap: () => print('Primary pressed'),
                child: Text('텍스트', style: _textStyleFor('Medium'))),
            const SizedBox(width: 16),
            WdsPillButton.mSecondary(
                onTap: () => print('Secondary pressed'),
                child: Text('텍스트', style: _textStyleFor('Medium'))),
            const SizedBox(width: 16),
            WdsPillButton.mCustom(
                onTap: () => print('Custom pressed'),
                child: Text('텍스트', style: _textStyleFor('Medium')),
                backgroundColor: WdsColorPink.v500),
          ],
        ),
      ),
      const SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'Size',
        labels: ['XLarge', 'Large', 'Medium', 'Small', 'Tiny'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsPillButton.xlCta(
                onTap: () => print('XL pressed'),
                child: Text('텍스트', style: _textStyleFor('XLarge'))),
            const SizedBox(width: 16),
            WdsPillButton.lCta(
                onTap: () => print('L pressed'),
                child: Text('텍스트', style: _textStyleFor('Large'))),
            const SizedBox(width: 16),
            WdsPillButton.mCta(
                onTap: () => print('M pressed'),
                child: Text('텍스트', style: _textStyleFor('Medium'))),
            const SizedBox(width: 16),
            WdsPillButton.sCta(
                onTap: () => print('S pressed'),
                child: Text('텍스트', style: _textStyleFor('Small'))),
            const SizedBox(width: 16),
            WdsPillButton.tyCta(
                onTap: () => print('TY pressed'),
                child: Text('텍스트', style: _textStyleFor('Tiny'))),
          ],
        ),
      ),
      const SizedBox(height: 32),
      WidgetbookSubsection(
        title: 'States',
        labels: ['Default', 'Pressed', 'Disabled'],
        content: Column(
          spacing: 12,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WdsPillButton.mCta(
                    onTap: () => print('CTA default'),
                    child: Text('텍스트', style: _textStyleFor('Medium'))),
                const SizedBox(width: 16),
                WdsPillButton.mPrimary(
                    onTap: () => print('Primary default'),
                    child: Text('텍스트', style: _textStyleFor('Medium'))),
                const SizedBox(width: 16),
                WdsPillButton.mSecondary(
                    onTap: () => print('Secondary default'),
                    child: Text('텍스트', style: _textStyleFor('Medium'))),
                const SizedBox(width: 16),
                WdsPillButton.mCustom(
                    onTap: () => print('Custom default'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    backgroundColor: WdsColorPink.v500),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WdsPillButton.mCta(
                    onTap: () => print('CTA pressed'),
                    child: Text('텍스트', style: _textStyleFor('Medium'))),
                const SizedBox(width: 16),
                WdsPillButton.mPrimary(
                    onTap: () => print('Primary pressed'),
                    child: Text('텍스트', style: _textStyleFor('Medium'))),
                const SizedBox(width: 16),
                WdsPillButton.mSecondary(
                    onTap: () => print('Secondary pressed'),
                    child: Text('텍스트', style: _textStyleFor('Medium'))),
                const SizedBox(width: 16),
                WdsPillButton.mCustom(
                    onTap: () => print('Custom pressed'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    backgroundColor: WdsColorPink.v500),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WdsPillButton.mCta(
                    onTap: () => print('CTA disabled'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    isEnabled: false),
                const SizedBox(width: 16),
                WdsPillButton.mPrimary(
                    onTap: () => print('Primary disabled'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    isEnabled: false),
                const SizedBox(width: 16),
                WdsPillButton.mSecondary(
                    onTap: () => print('Secondary disabled'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    isEnabled: false),
                const SizedBox(width: 16),
                WdsPillButton.mCustom(
                    onTap: () => print('Custom disabled'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    backgroundColor: WdsColorPink.v500,
                    isEnabled: false),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
