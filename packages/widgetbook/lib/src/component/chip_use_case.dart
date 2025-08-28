import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _icon = WdsIcon.blank.build();

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
    initialValue: false,
    description: '좌측에 아이콘을 표시해요',
  );

  final hasTrailing = context.knobs.boolean(
    label: 'hasTrailing',
    initialValue: false,
    description: '우측에 아이콘을 표시해요',
  );

  return WidgetbookPlayground(
    height: 210,
    child: shape == WdsChipShape.pill
        ? WdsChip.pill(
            label: label,
            size: size,
            isEnabled: isEnabled,
            variant: variant,
            leading: hasLeading ? _icon : null,
            trailing: hasTrailing ? _icon : null,
            onTap: () => print('Chip tapped: $label'),
          )
        : WdsChip.square(
            label: label,
            size: size,
            isEnabled: isEnabled,
            variant: variant,
            leading: hasLeading ? _icon : null,
            trailing: hasTrailing ? _icon : null,
            onTap: () => print('Chip tapped: $label'),
          ),
    info: [
      'label: $label',
      'shape: $shape',
      'variant: $variant',
      'size: $size',
      'isEnabled: $isEnabled',
      'hasLeading: $hasLeading',
      'hasTrailing: $hasTrailing',
    ],
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
          onTap: () => print('Pill chip tapped'),
        ),
        const SizedBox(width: 16),
        WdsChip.square(
          label: '텍스트',
          onTap: () => print('Square chip tapped'),
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
          variant: WdsChipVariant.outline,
          onTap: () => print('Outline chip tapped'),
        ),
        const SizedBox(width: 16),
        WdsChip.pill(
          label: '텍스트',
          variant: WdsChipVariant.solid,
          onTap: () => print('Solid chip tapped'),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        WdsChip.pill(
          label: '텍스트',
          size: WdsChipSize.xsmall,
          onTap: () => print('XSmall chip tapped'),
        ),
        WdsChip.pill(
          label: '텍스트',
          size: WdsChipSize.small,
          onTap: () => print('Small chip tapped'),
        ),
        WdsChip.pill(
          label: '텍스트',
          size: WdsChipSize.medium,
          onTap: () => print('Medium chip tapped'),
        ),
        WdsChip.pill(
          label: '텍스트',
          size: WdsChipSize.large,
          onTap: () => print('Large chip tapped'),
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
        Text('Outline Variant:', style: WdsSemanticTypography.caption12Medium),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsChip.pill(
              label: '일반',
              variant: WdsChipVariant.outline,
              isEnabled: true,
              onTap: () => print('Enabled outline chip'),
            ),
            WdsChip.pill(
              label: '비활성',
              variant: WdsChipVariant.outline,
              isEnabled: false,
              onTap: () => print('Disabled outline chip'),
            ),
            WdsChip.pill(
              label: '클릭해보세요',
              variant: WdsChipVariant.outline,
              onTap: () => print('Interactive outline chip - focus toggles'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Solid variant states
        Text('Solid Variant:', style: WdsSemanticTypography.caption12Medium),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsChip.pill(
              label: '일반',
              variant: WdsChipVariant.solid,
              isEnabled: true,
              onTap: () => print('Enabled solid chip'),
            ),
            WdsChip.pill(
              label: '비활성',
              variant: WdsChipVariant.solid,
              isEnabled: false,
              onTap: () => print('Disabled solid chip'),
            ),
            WdsChip.pill(
              label: '클릭해보세요',
              variant: WdsChipVariant.solid,
              onTap: () => print('Interactive solid chip - focus toggles'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // With icons demonstration
        Text('With Icons:', style: WdsSemanticTypography.caption12Medium),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsChip.pill(
              label: '아이콘',
              variant: WdsChipVariant.outline,
              leading: _icon,
              trailing: _icon,
              onTap: () => print('Outline chip with icons'),
            ),
            WdsChip.pill(
              label: '아이콘',
              variant: WdsChipVariant.solid,
              leading: _icon,
              trailing: _icon,
              onTap: () => print('Solid chip with icons'),
            ),
          ],
        ),
      ],
    ),
  );
}
