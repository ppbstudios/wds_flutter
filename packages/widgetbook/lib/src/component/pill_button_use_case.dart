import 'package:flutter/material.dart';
import 'package:wds_components/wds_components.dart';
import 'package:wds_tokens/wds_tokens.dart';
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_page_layout.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'default',
  type: WdsPillButton,
)
Widget buildWdsPillButtonUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Pill Button',
    description: '사용자가 원하는 동작을 수행할 수 있도록 돕습니다.',
    children: [
      _PlaygroundSection(),
      const SizedBox(height: 32),
      _DemonstrationSection(),
      const SizedBox(height: 32),
      _ResourceSection(),
    ],
  );
}

class _PlaygroundSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final type = context.knobs.list<String>(
      label: 'Type',
      options: ['Cta', 'Primary', 'Secondary', 'Custom'],
      initialOption: 'Cta',
    );

    final size = context.knobs.list<String>(
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
      final child = Text(text);
      final onTap = () => print('PillButton pressed: $type $size');
      
      switch (type) {
        case 'Cta':
          switch (size) {
            case 'XLarge': return WdsPillButton.xlCta(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Large': return WdsPillButton.lCta(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Medium': return WdsPillButton.mCta(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Small': return WdsPillButton.sCta(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Tiny': return WdsPillButton.tyCta(onTap: onTap, child: child, isEnabled: isEnabled);
          }
        case 'Primary':
          switch (size) {
            case 'XLarge': return WdsPillButton.xlPrimary(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Large': return WdsPillButton.lPrimary(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Medium': return WdsPillButton.mPrimary(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Small': return WdsPillButton.sPrimary(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Tiny': return WdsPillButton.tyPrimary(onTap: onTap, child: child, isEnabled: isEnabled);
          }
        case 'Secondary':
          switch (size) {
            case 'XLarge': return WdsPillButton.xlSecondary(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Large': return WdsPillButton.lSecondary(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Medium': return WdsPillButton.mSecondary(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Small': return WdsPillButton.sSecondary(onTap: onTap, child: child, isEnabled: isEnabled);
            case 'Tiny': return WdsPillButton.tySecondary(onTap: onTap, child: child, isEnabled: isEnabled);
          }
        case 'Custom':
          switch (size) {
            case 'XLarge': return WdsPillButton.xlCustom(onTap: onTap, child: child, backgroundColor: customBackgroundColor!, color: customTextColor!, isEnabled: isEnabled);
            case 'Large': return WdsPillButton.lCustom(onTap: onTap, child: child, backgroundColor: customBackgroundColor!, color: customTextColor!, isEnabled: isEnabled);
            case 'Medium': return WdsPillButton.mCustom(onTap: onTap, child: child, backgroundColor: customBackgroundColor!, color: customTextColor!, isEnabled: isEnabled);
            case 'Small': return WdsPillButton.sCustom(onTap: onTap, child: child, backgroundColor: customBackgroundColor!, color: customTextColor!, isEnabled: isEnabled);
            case 'Tiny': return WdsPillButton.tyCustom(onTap: onTap, child: child, backgroundColor: customBackgroundColor!, color: customTextColor!, isEnabled: isEnabled);
          }
      }
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: WdsColorNeutral.v50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WdsColorNeutral.v200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Playground',
            style: WdsSemanticTypography.title20Bold.copyWith(color: WdsColorBlue.v500),
          ),
          const SizedBox(height: 24),
          Center(child: buildButton()),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip('Type: $type'),
              _InfoChip('Size: $size'),
              _InfoChip('State: ${isEnabled ? 'Enabled' : 'Disabled'}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DemonstrationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Button',
          style: WdsSemanticTypography.title20Bold,
        ),
        const SizedBox(height: 24),
        _TypeSection(),
        const SizedBox(height: 32),
        _SizeSection(),
        const SizedBox(height: 32),
        _StatesSection(),
      ],
    );
  }
}

class _TypeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Type = ', style: WdsSemanticTypography.heading17Bold),
            _TypeLabel('Cta'),
            const SizedBox(width: 12),
            _TypeLabel('Primary'),
            const SizedBox(width: 12),
            _TypeLabel('Secondary'),
            const SizedBox(width: 12),
            _TypeLabel('Custom'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: WdsColorNeutral.v100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              WdsPillButton.mCta(onTap: () => print('CTA pressed'), child: const Text('텍스트')),
              const SizedBox(width: 16),
              WdsPillButton.mPrimary(onTap: () => print('Primary pressed'), child: const Text('텍스트')),
              const SizedBox(width: 16),
              WdsPillButton.mSecondary(onTap: () => print('Secondary pressed'), child: const Text('텍스트')),
              const SizedBox(width: 16),
              WdsPillButton.mCustom(onTap: () => print('Custom pressed'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500),
            ],
          ),
        ),
      ],
    );
  }
}

class _SizeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Size = ', style: WdsSemanticTypography.heading17Bold),
            _TypeLabel('XLarge'),
            const SizedBox(width: 12),
            _TypeLabel('Large'),
            const SizedBox(width: 12),
            _TypeLabel('Medium'),
            const SizedBox(width: 12),
            _TypeLabel('Small'),
            const SizedBox(width: 12),
            _TypeLabel('Tiny'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: WdsColorNeutral.v100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              WdsPillButton.xlCta(onTap: () => print('XL pressed'), child: const Text('텍스트')),
              const SizedBox(width: 16),
              WdsPillButton.lCta(onTap: () => print('L pressed'), child: const Text('텍스트')),
              const SizedBox(width: 16),
              WdsPillButton.mCta(onTap: () => print('M pressed'), child: const Text('텍스트')),
              const SizedBox(width: 16),
              WdsPillButton.sCta(onTap: () => print('S pressed'), child: const Text('텍스트')),
              const SizedBox(width: 16),
              WdsPillButton.tyCta(onTap: () => print('TY pressed'), child: const Text('텍스트')),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('States = ', style: WdsSemanticTypography.heading17Bold),
            _TypeLabel('Default'),
            const SizedBox(width: 12),
            _TypeLabel('Pressed'),
            const SizedBox(width: 12),
            _TypeLabel('Disabled'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: WdsColorNeutral.v100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WdsPillButton.mCta(onTap: () => print('CTA default'), child: const Text('텍스트')),
                  const SizedBox(width: 16),
                  WdsPillButton.mPrimary(onTap: () => print('Primary default'), child: const Text('텍스트')),
                  const SizedBox(width: 16),
                  WdsPillButton.mSecondary(onTap: () => print('Secondary default'), child: const Text('텍스트')),
                  const SizedBox(width: 16),
                  WdsPillButton.mCustom(onTap: () => print('Custom default'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WdsPillButton.mCta(onTap: () => print('CTA pressed'), child: const Text('텍스트')),
                  const SizedBox(width: 16),
                  WdsPillButton.mPrimary(onTap: () => print('Primary pressed'), child: const Text('텍스트')),
                  const SizedBox(width: 16),
                  WdsPillButton.mSecondary(onTap: () => print('Secondary pressed'), child: const Text('텍스트')),
                  const SizedBox(width: 16),
                  WdsPillButton.mCustom(onTap: () => print('Custom pressed'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WdsPillButton.mCta(onTap: () => print('CTA disabled'), child: const Text('텍스트'), isEnabled: false),
                  const SizedBox(width: 16),
                  WdsPillButton.mPrimary(onTap: () => print('Primary disabled'), child: const Text('텍스트'), isEnabled: false),
                  const SizedBox(width: 16),
                  WdsPillButton.mSecondary(onTap: () => print('Secondary disabled'), child: const Text('텍스트'), isEnabled: false),
                  const SizedBox(width: 16),
                  WdsPillButton.mCustom(onTap: () => print('Custom disabled'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500, isEnabled: false),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResourceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resource',
          style: WdsSemanticTypography.title20Bold,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: WdsColorBlue.v300, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _ResourceGrid(),
        ),
      ],
    );
  }
}

class _ResourceGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WdsPillButton.xlCta(onTap: () => print('XL CTA'), child: const Text('텍스트')),
            WdsPillButton.lCta(onTap: () => print('L CTA'), child: const Text('텍스트')),
            WdsPillButton.mCta(onTap: () => print('M CTA'), child: const Text('텍스트')),
            WdsPillButton.sCta(onTap: () => print('S CTA'), child: const Text('텍스트')),
            WdsPillButton.tyCta(onTap: () => print('TY CTA'), child: const Text('텍스트')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WdsPillButton.xlPrimary(onTap: () => print('XL Primary'), child: const Text('텍스트')),
            WdsPillButton.lPrimary(onTap: () => print('L Primary'), child: const Text('텍스트')),
            WdsPillButton.mPrimary(onTap: () => print('M Primary'), child: const Text('텍스트')),
            WdsPillButton.sPrimary(onTap: () => print('S Primary'), child: const Text('텍스트')),
            WdsPillButton.tyPrimary(onTap: () => print('TY Primary'), child: const Text('텍스트')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WdsPillButton.xlSecondary(onTap: () => print('XL Secondary'), child: const Text('텍스트')),
            WdsPillButton.lSecondary(onTap: () => print('L Secondary'), child: const Text('텍스트')),
            WdsPillButton.mSecondary(onTap: () => print('M Secondary'), child: const Text('텍스트')),
            WdsPillButton.sSecondary(onTap: () => print('S Secondary'), child: const Text('텍스트')),
            WdsPillButton.tySecondary(onTap: () => print('TY Secondary'), child: const Text('텍스트')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WdsPillButton.xlCustom(onTap: () => print('XL Custom'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500),
            WdsPillButton.lCustom(onTap: () => print('L Custom'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500),
            WdsPillButton.mCustom(onTap: () => print('M Custom'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500),
            WdsPillButton.sCustom(onTap: () => print('S Custom'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500),
            WdsPillButton.tyCustom(onTap: () => print('TY Custom'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WdsPillButton.xlCta(onTap: () => print('XL CTA disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.lCta(onTap: () => print('L CTA disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.mCta(onTap: () => print('M CTA disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.sCta(onTap: () => print('S CTA disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.tyCta(onTap: () => print('TY CTA disabled'), child: const Text('텍스트'), isEnabled: false),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WdsPillButton.xlPrimary(onTap: () => print('XL Primary disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.lPrimary(onTap: () => print('L Primary disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.mPrimary(onTap: () => print('M Primary disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.sPrimary(onTap: () => print('S Primary disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.tyPrimary(onTap: () => print('TY Primary disabled'), child: const Text('텍스트'), isEnabled: false),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WdsPillButton.xlSecondary(onTap: () => print('XL Secondary disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.lSecondary(onTap: () => print('L Secondary disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.mSecondary(onTap: () => print('M Secondary disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.sSecondary(onTap: () => print('S Secondary disabled'), child: const Text('텍스트'), isEnabled: false),
            WdsPillButton.tySecondary(onTap: () => print('TY Secondary disabled'), child: const Text('텍스트'), isEnabled: false),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WdsPillButton.xlCustom(onTap: () => print('XL Custom disabled'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500, isEnabled: false),
            WdsPillButton.lCustom(onTap: () => print('L Custom disabled'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500, isEnabled: false),
            WdsPillButton.mCustom(onTap: () => print('M Custom disabled'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500, isEnabled: false),
            WdsPillButton.sCustom(onTap: () => print('S Custom disabled'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500, isEnabled: false),
            WdsPillButton.tyCustom(onTap: () => print('TY Custom disabled'), child: const Text('텍스트'), backgroundColor: WdsColorPink.v500, isEnabled: false),
          ],
        ),
      ],
    );
  }
}

class _TypeLabel extends StatelessWidget {
  const _TypeLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: WdsColorNeutral.v200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: WdsSemanticTypography.caption11Bold,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: WdsColorBlue.v100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: WdsSemanticTypography.caption11Bold.copyWith(
          color: WdsColorBlue.v700,
        ),
      ),
    );
  }
}