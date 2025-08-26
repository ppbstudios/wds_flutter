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
      const SizedBox(height: 32),
      _buildResourceSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final type = context.knobs.object.dropdown<String>(
    label: 'Type',
    options: ['Cta', 'Primary', 'Secondary', 'Custom'],
    initialOption: 'Cta',
  );

  final size = context.knobs.object.dropdown<String>(
    label: 'Size',
    options: ['XLarge', 'Large', 'Medium', 'Small', 'Tiny'],
    initialOption: 'Medium',
  );

  final isEnabled = context.knobs.boolean(
    label: 'Enabled',
    initialValue: true,
  );

  final text = context.knobs.string(
    label: 'Text',
    initialValue: '텍스트',
  );

  Color? customBackgroundColor;
  Color? customTextColor;
  if (type == 'Custom') {
    customBackgroundColor = context.knobs.color(
      label: 'Background Color',
      initialValue: WdsColorPink.v500,
    );
    customTextColor = context.knobs.color(
      label: 'Text Color',
      initialValue: WdsColorCommon.white,
    );
  }

  Widget buildButton() {
    final styleBySize = <String, TextStyle>{
      'XLarge': WdsSemanticTypography.body15NormalBold,
      'Large': WdsSemanticTypography.body15NormalBold,
      'Medium': WdsSemanticTypography.body13NormalMedium,
      'Small': WdsSemanticTypography.caption12Medium,
      'Tiny': WdsSemanticTypography.caption12Medium,
    };

    final child = Text(text, style: styleBySize[size]!);
    final onTap = () => print('PillButton pressed: $type $size');

    switch (type) {
      case 'Cta':
        switch (size) {
          case 'XLarge':
            return WdsPillButton.xlCta(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Large':
            return WdsPillButton.lCta(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Medium':
            return WdsPillButton.mCta(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Small':
            return WdsPillButton.sCta(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Tiny':
            return WdsPillButton.tyCta(
                onTap: onTap, child: child, isEnabled: isEnabled);
        }
      case 'Primary':
        switch (size) {
          case 'XLarge':
            return WdsPillButton.xlPrimary(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Large':
            return WdsPillButton.lPrimary(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Medium':
            return WdsPillButton.mPrimary(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Small':
            return WdsPillButton.sPrimary(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Tiny':
            return WdsPillButton.tyPrimary(
                onTap: onTap, child: child, isEnabled: isEnabled);
        }
      case 'Secondary':
        switch (size) {
          case 'XLarge':
            return WdsPillButton.xlSecondary(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Large':
            return WdsPillButton.lSecondary(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Medium':
            return WdsPillButton.mSecondary(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Small':
            return WdsPillButton.sSecondary(
                onTap: onTap, child: child, isEnabled: isEnabled);
          case 'Tiny':
            return WdsPillButton.tySecondary(
                onTap: onTap, child: child, isEnabled: isEnabled);
        }
      case 'Custom':
        switch (size) {
          case 'XLarge':
            return WdsPillButton.xlCustom(
                onTap: onTap,
                child: child,
                backgroundColor: customBackgroundColor!,
                color: customTextColor!,
                isEnabled: isEnabled);
          case 'Large':
            return WdsPillButton.lCustom(
                onTap: onTap,
                child: child,
                backgroundColor: customBackgroundColor!,
                color: customTextColor!,
                isEnabled: isEnabled);
          case 'Medium':
            return WdsPillButton.mCustom(
                onTap: onTap,
                child: child,
                backgroundColor: customBackgroundColor!,
                color: customTextColor!,
                isEnabled: isEnabled);
          case 'Small':
            return WdsPillButton.sCustom(
                onTap: onTap,
                child: child,
                backgroundColor: customBackgroundColor!,
                color: customTextColor!,
                isEnabled: isEnabled);
          case 'Tiny':
            return WdsPillButton.tyCustom(
                onTap: onTap,
                child: child,
                backgroundColor: customBackgroundColor!,
                color: customTextColor!,
                isEnabled: isEnabled);
        }
    }
    return const SizedBox.shrink();
  }

  return WidgetbookPlayground(
    height: 200,
    child: buildButton(),
    info: [
      'Type: $type',
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

Widget _buildResourceSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Resource',
    children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: WdsColorBlue.v300, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WdsPillButton.xlCta(
                    onTap: () => print('XL CTA'),
                    child: Text('텍스트', style: _textStyleFor('XLarge'))),
                WdsPillButton.lCta(
                    onTap: () => print('L CTA'),
                    child: Text('텍스트', style: _textStyleFor('Large'))),
                WdsPillButton.mCta(
                    onTap: () => print('M CTA'),
                    child: Text('텍스트', style: _textStyleFor('Medium'))),
                WdsPillButton.sCta(
                    onTap: () => print('S CTA'),
                    child: Text('텍스트', style: _textStyleFor('Small'))),
                WdsPillButton.tyCta(
                    onTap: () => print('TY CTA'),
                    child: Text('텍스트', style: _textStyleFor('Tiny'))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WdsPillButton.xlPrimary(
                    onTap: () => print('XL Primary'),
                    child: Text('텍스트', style: _textStyleFor('XLarge'))),
                WdsPillButton.lPrimary(
                    onTap: () => print('L Primary'),
                    child: Text('텍스트', style: _textStyleFor('Large'))),
                WdsPillButton.mPrimary(
                    onTap: () => print('M Primary'),
                    child: Text('텍스트', style: _textStyleFor('Medium'))),
                WdsPillButton.sPrimary(
                    onTap: () => print('S Primary'),
                    child: Text('텍스트', style: _textStyleFor('Small'))),
                WdsPillButton.tyPrimary(
                    onTap: () => print('TY Primary'),
                    child: Text('텍스트', style: _textStyleFor('Tiny'))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WdsPillButton.xlSecondary(
                    onTap: () => print('XL Secondary'),
                    child: Text('텍스트', style: _textStyleFor('XLarge'))),
                WdsPillButton.lSecondary(
                    onTap: () => print('L Secondary'),
                    child: Text('텍스트', style: _textStyleFor('Large'))),
                WdsPillButton.mSecondary(
                    onTap: () => print('M Secondary'),
                    child: Text('텍스트', style: _textStyleFor('Medium'))),
                WdsPillButton.sSecondary(
                    onTap: () => print('S Secondary'),
                    child: Text('텍스트', style: _textStyleFor('Small'))),
                WdsPillButton.tySecondary(
                    onTap: () => print('TY Secondary'),
                    child: Text('텍스트', style: _textStyleFor('Tiny'))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WdsPillButton.xlCustom(
                    onTap: () => print('XL Custom'),
                    child: Text('텍스트', style: _textStyleFor('XLarge')),
                    backgroundColor: WdsColorPink.v500),
                WdsPillButton.lCustom(
                    onTap: () => print('L Custom'),
                    child: Text('텍스트', style: _textStyleFor('Large')),
                    backgroundColor: WdsColorPink.v500),
                WdsPillButton.mCustom(
                    onTap: () => print('M Custom'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    backgroundColor: WdsColorPink.v500),
                WdsPillButton.sCustom(
                    onTap: () => print('S Custom'),
                    child: Text('텍스트', style: _textStyleFor('Small')),
                    backgroundColor: WdsColorPink.v500),
                WdsPillButton.tyCustom(
                    onTap: () => print('TY Custom'),
                    child: Text('텍스트', style: _textStyleFor('Tiny')),
                    backgroundColor: WdsColorPink.v500),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WdsPillButton.xlCta(
                    onTap: () => print('XL CTA disabled'),
                    child: Text('텍스트', style: _textStyleFor('XLarge')),
                    isEnabled: false),
                WdsPillButton.lCta(
                    onTap: () => print('L CTA disabled'),
                    child: Text('텍스트', style: _textStyleFor('Large')),
                    isEnabled: false),
                WdsPillButton.mCta(
                    onTap: () => print('M CTA disabled'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    isEnabled: false),
                WdsPillButton.sCta(
                    onTap: () => print('S CTA disabled'),
                    child: Text('텍스트', style: _textStyleFor('Small')),
                    isEnabled: false),
                WdsPillButton.tyCta(
                    onTap: () => print('TY CTA disabled'),
                    child: Text('텍스트', style: _textStyleFor('Tiny')),
                    isEnabled: false),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WdsPillButton.xlPrimary(
                    onTap: () => print('XL Primary disabled'),
                    child: Text('텍스트', style: _textStyleFor('XLarge')),
                    isEnabled: false),
                WdsPillButton.lPrimary(
                    onTap: () => print('L Primary disabled'),
                    child: Text('텍스트', style: _textStyleFor('Large')),
                    isEnabled: false),
                WdsPillButton.mPrimary(
                    onTap: () => print('M Primary disabled'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    isEnabled: false),
                WdsPillButton.sPrimary(
                    onTap: () => print('S Primary disabled'),
                    child: Text('텍스트', style: _textStyleFor('Small')),
                    isEnabled: false),
                WdsPillButton.tyPrimary(
                    onTap: () => print('TY Primary disabled'),
                    child: Text('텍스트', style: _textStyleFor('Tiny')),
                    isEnabled: false),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WdsPillButton.xlSecondary(
                    onTap: () => print('XL Secondary disabled'),
                    child: Text('텍스트', style: _textStyleFor('XLarge')),
                    isEnabled: false),
                WdsPillButton.lSecondary(
                    onTap: () => print('L Secondary disabled'),
                    child: Text('텍스트', style: _textStyleFor('Large')),
                    isEnabled: false),
                WdsPillButton.mSecondary(
                    onTap: () => print('M Secondary disabled'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    isEnabled: false),
                WdsPillButton.sSecondary(
                    onTap: () => print('S Secondary disabled'),
                    child: Text('텍스트', style: _textStyleFor('Small')),
                    isEnabled: false),
                WdsPillButton.tySecondary(
                    onTap: () => print('TY Secondary disabled'),
                    child: Text('텍스트', style: _textStyleFor('Tiny')),
                    isEnabled: false),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WdsPillButton.xlCustom(
                    onTap: () => print('XL Custom disabled'),
                    child: Text('텍스트', style: _textStyleFor('XLarge')),
                    backgroundColor: WdsColorPink.v500,
                    isEnabled: false),
                WdsPillButton.lCustom(
                    onTap: () => print('L Custom disabled'),
                    child: Text('텍스트', style: _textStyleFor('Large')),
                    backgroundColor: WdsColorPink.v500,
                    isEnabled: false),
                WdsPillButton.mCustom(
                    onTap: () => print('M Custom disabled'),
                    child: Text('텍스트', style: _textStyleFor('Medium')),
                    backgroundColor: WdsColorPink.v500,
                    isEnabled: false),
                WdsPillButton.sCustom(
                    onTap: () => print('S Custom disabled'),
                    child: Text('텍스트', style: _textStyleFor('Small')),
                    backgroundColor: WdsColorPink.v500,
                    isEnabled: false),
                WdsPillButton.tyCustom(
                    onTap: () => print('TY Custom disabled'),
                    child: Text('텍스트', style: _textStyleFor('Tiny')),
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
