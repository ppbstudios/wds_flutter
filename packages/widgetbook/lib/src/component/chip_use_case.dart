import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _icon = WdsIcon.blank;

@widgetbook.UseCase(
  name: 'Chip',
  type: Chip,
  path: '[component]/',
)
Widget buildChipUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Chip',
    description: '정보를 카테고리화하거나 필터링에 사용되는 소형 컴포넌트',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final label = context.knobs.string(
    label: 'label',
    initialValue: '태그',
  );

  final shape = context.knobs.object.dropdown<WdsChipShape>(
    label: 'shape',
    options: WdsChipShape.values,
    initialOption: WdsChipShape.pill,
    labelBuilder: (value) => value.name,
  );

  final variant = context.knobs.object.dropdown<WdsChipVariant>(
    label: 'variant',
    options: WdsChipVariant.values,
    initialOption: WdsChipVariant.outline,
    labelBuilder: (value) => value.name,
  );

  final size = context.knobs.object.dropdown<WdsChipSize>(
    label: 'size',
    options: WdsChipSize.values,
    initialOption: WdsChipSize.medium,
    labelBuilder: (value) => value.name,
  );

  final isEnabled = context.knobs.boolean(
    label: 'isEnabled',
    initialValue: true,
    description: '선택될 수 있는 지 설정해요',
  );

  final hasLeading = context.knobs.boolean(
    label: 'hasLeading',
    description: '좌측에 아이콘을 표시해요',
  );

  final hasTrailing = context.knobs.boolean(
    label: 'hasTrailing',
    description: '우측에 아이콘을 표시해요',
  );

  return WidgetbookPlayground(
    info: [
      'label: $label',
      'shape: $shape',
      'variant: $variant',
      'size: $size',
      'isEnabled: $isEnabled',
      'hasLeading: $hasLeading',
      'hasTrailing: $hasTrailing',
    ],
    child: shape == WdsChipShape.pill
        ? WdsChip.pill(
            label: label,
            size: size,
            isEnabled: isEnabled,
            variant: variant,
            leading: hasLeading ? _icon : null,
            trailing: hasTrailing ? _icon : null,
            onTap: () => debugPrint('Chip tapped: $label'),
          )
        : WdsChip.square(
            label: label,
            size: size,
            isEnabled: isEnabled,
            variant: variant,
            leading: hasLeading ? _icon : null,
            trailing: hasTrailing ? _icon : null,
            onTap: () => debugPrint('Chip tapped: $label'),
          ),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Chip',
    children: [
      _buildShapeSection(),
      const SizedBox(height: 32),
      _buildVariantSection(),
      const SizedBox(height: 32),
      _buildSizeSection(),
      const SizedBox(height: 32),
      _buildStateSection(),
    ],
  );
}

Widget _buildShapeSection() {
  return WidgetbookSubsection(
    title: 'shape',
    labels: ['pill', 'square'],
    content: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        WdsChip.pill(
          label: '텍스트',
          onTap: () => debugPrint('Pill chip tapped'),
        ),
        const SizedBox(width: 16),
        WdsChip.square(
          label: '텍스트',
          onTap: () => debugPrint('Square chip tapped'),
        ),
      ],
    ),
  );
}

Widget _buildVariantSection() {
  return WidgetbookSubsection(
    title: 'variant',
    labels: ['outline', 'solid'],
    content: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        WdsChip.pill(
          label: '텍스트',
          onTap: () => debugPrint('Outline chip tapped'),
        ),
        const SizedBox(width: 16),
        WdsChip.pill(
          label: '텍스트',
          variant: WdsChipVariant.solid,
          onTap: () => debugPrint('Solid chip tapped'),
        ),
      ],
    ),
  );
}

Widget _buildSizeSection() {
  return WidgetbookSubsection(
    title: 'size',
    labels: ['xsmall', 'small', 'medium', 'large'],
    content: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        WdsChip.pill(
          label: '텍스트',
          size: WdsChipSize.xsmall,
          onTap: () => debugPrint('XSmall chip tapped'),
        ),
        WdsChip.pill(
          label: '텍스트',
          size: WdsChipSize.small,
          onTap: () => debugPrint('Small chip tapped'),
        ),
        WdsChip.pill(
          label: '텍스트',
          onTap: () => debugPrint('Medium chip tapped'),
        ),
        WdsChip.pill(
          label: '텍스트',
          size: WdsChipSize.large,
          onTap: () => debugPrint('Large chip tapped'),
        ),
      ],
    ),
  );
}

Widget _buildStateSection() {
  return WidgetbookSubsection(
    title: 'state',
    labels: ['enabled', 'disabled', 'focused (click to toggle)'],
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        // Outline variant states
        const Text(
          'Outline Variant:',
          style: WdsSemanticTypography.caption12Medium,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsChip.pill(
              label: '일반',
              onTap: () => debugPrint('Enabled outline chip'),
            ),
            WdsChip.pill(
              label: '비활성',
              isEnabled: false,
              onTap: () => debugPrint('Disabled outline chip'),
            ),
            WdsChip.pill(
              label: '클릭해보세요',
              onTap: () =>
                  debugPrint('Interactive outline chip - focus toggles'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Solid variant states
        const Text(
          'Solid Variant:',
          style: WdsSemanticTypography.caption12Medium,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsChip.pill(
              label: '일반',
              variant: WdsChipVariant.solid,
              onTap: () => debugPrint('Enabled solid chip'),
            ),
            WdsChip.pill(
              label: '비활성',
              variant: WdsChipVariant.solid,
              isEnabled: false,
              onTap: () => debugPrint('Disabled solid chip'),
            ),
            WdsChip.pill(
              label: '클릭해보세요',
              variant: WdsChipVariant.solid,
              onTap: () => debugPrint('Interactive solid chip - focus toggles'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // With icons demonstration
        const Text('With Icons:', style: WdsSemanticTypography.caption12Medium),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsChip.pill(
              label: '아이콘',
              leading: _icon,
              trailing: _icon,
              onTap: () => debugPrint('Outline chip with icons'),
            ),
            WdsChip.pill(
              label: '아이콘',
              variant: WdsChipVariant.solid,
              leading: _icon,
              trailing: _icon,
              onTap: () => debugPrint('Solid chip with icons'),
            ),
          ],
        ),
      ],
    ),
  );
}
