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
    description: '상호작용을 통해 정보를 분류하거나, 상태를 표시할 때 사용됩니다.',
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

  final String value = 'test';
  final Set<String> groupValues = {};

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
            value: value,
            groupValues: groupValues,
            size: size,
            isEnabled: isEnabled,
            variant: variant,
            leading: hasLeading ? _icon.build() : null,
            trailing: hasTrailing ? _icon : null,
            onTap: () {
              debugPrint('Chip tapped: $label');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                __onTap(groupValues, value);
              });
            },
          )
        : WdsChip.square(
            label: label,
            value: value,
            groupValues: groupValues,
            size: size,
            isEnabled: isEnabled,
            variant: variant,
            leading: hasLeading ? _icon.build() : null,
            trailing: hasTrailing ? _icon : null,
            onTap: () {
              debugPrint('Chip tapped: $label');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                __onTap(groupValues, value);
              });
            },
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
  final groupValues = <int>{};

  return WidgetbookSubsection(
    title: 'shape',
    labels: ['pill', 'square'],
    content: StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsChip.pill(
              label: '텍스트',
              value: 0,
              groupValues: groupValues,
              onTap: () {
                debugPrint('Pill chip tapped');
                setState(() => __onTap(groupValues, 0));
              },
            ),
            const SizedBox(width: 16),
            WdsChip.square(
              label: '텍스트',
              value: 1,
              groupValues: groupValues,
              onTap: () {
                debugPrint('Square chip tapped');
                setState(() => __onTap(groupValues, 1));
              },
            ),
          ],
        );
      },
    ),
  );
}

Widget _buildVariantSection() {
  final groupValues = <int>{};

  return WidgetbookSubsection(
    title: 'variant',
    labels: ['outline', 'solid'],
    content: StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsChip.pill(
              label: '텍스트',
              value: 0,
              groupValues: groupValues,
              onTap: () {
                debugPrint('Outline chip tapped');
                setState(() => __onTap(groupValues, 0));
              },
            ),
            const SizedBox(width: 16),
            WdsChip.pill(
              label: '텍스트',
              variant: WdsChipVariant.solid,
              value: 1,
              groupValues: groupValues,
              onTap: () {
                debugPrint('Solid chip tapped');
                setState(() => __onTap(groupValues, 1));
              },
            ),
          ],
        );
      },
    ),
  );
}

Widget _buildSizeSection() {
  final groupValues = <int>{};

  return WidgetbookSubsection(
    title: 'size',
    labels: ['xsmall', 'small', 'medium', 'large'],
    content: StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsChip.pill(
              label: '텍스트',
              size: WdsChipSize.xsmall,
              value: 0,
              groupValues: groupValues,
              onTap: () {
                debugPrint('XSmall chip tapped');
                setState(() => __onTap(groupValues, 0));
              },
            ),
            WdsChip.pill(
              label: '텍스트',
              size: WdsChipSize.small,
              value: 1,
              groupValues: groupValues,
              onTap: () {
                debugPrint('Small chip tapped');
                setState(() => __onTap(groupValues, 1));
              },
            ),
            WdsChip.pill(
              label: '텍스트',
              value: 2,
              groupValues: groupValues,
              onTap: () {
                debugPrint('Medium chip tapped');
                setState(() => __onTap(groupValues, 2));
              },
            ),
            WdsChip.pill(
              label: '텍스트',
              size: WdsChipSize.large,
              value: 3,
              groupValues: groupValues,
              onTap: () {
                debugPrint('Large chip tapped');
                setState(() => __onTap(groupValues, 3));
              },
            ),
          ],
        );
      },
    ),
  );
}

Widget _buildStateSection() {
  final groupValues = <int>{};

  return StatefulBuilder(
    builder: (context, setState) {
      return WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'disabled', 'focused'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            // Outline variant states
            const Text(
              'Outline',
              style: WdsTypography.caption12NormalMedium,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                WdsChip.pill(
                  label: '일반',
                  value: 0,
                  groupValues: groupValues,
                  onTap: () {
                    debugPrint('Enabled outline chip');
                    setState(() => __onTap(groupValues, 0));
                  },
                ),
                WdsChip.pill(
                  label: '비활성',
                  value: 1,
                  groupValues: groupValues,
                  isEnabled: false,
                  onTap: () {
                    debugPrint('Disabled outline chip');
                    setState(() => __onTap(groupValues, 1));
                  },
                ),
                WdsChip.pill(
                  label: '클릭해보세요',
                  value: 2,
                  groupValues: groupValues,
                  onTap: () {
                    debugPrint('Interactive outline chip - focus toggles');
                    setState(() => __onTap(groupValues, 2));
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Solid variant states
            const Text(
              'Solid',
              style: WdsTypography.caption12NormalMedium,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                WdsChip.pill(
                  label: '일반',
                  variant: WdsChipVariant.solid,
                  value: 3,
                  groupValues: groupValues,
                  onTap: () {
                    debugPrint('Enabled solid chip');
                    setState(() => __onTap(groupValues, 3));
                  },
                ),
                WdsChip.pill(
                  label: '비활성',
                  variant: WdsChipVariant.solid,
                  value: 4,
                  groupValues: groupValues,
                  isEnabled: false,
                  onTap: () {
                    debugPrint('Disabled solid chip');
                    setState(() => __onTap(groupValues, 4));
                  },
                ),
                WdsChip.pill(
                  label: '클릭해보세요',
                  variant: WdsChipVariant.solid,
                  value: 5,
                  groupValues: groupValues,
                  onTap: () {
                    debugPrint('Interactive solid chip - focus toggles');
                    setState(() => __onTap(groupValues, 5));
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // With icons demonstration
            const Text('Icon', style: WdsTypography.caption12NormalMedium),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                WdsChip.pill(
                  label: '아이콘',
                  value: 6,
                  groupValues: groupValues,
                  leading: _icon.build(),
                  trailing: _icon,
                  onTap: () {
                    debugPrint('Outline chip with icons');
                    setState(() => __onTap(groupValues, 6));
                  },
                ),
                WdsChip.pill(
                  label: '아이콘',
                  variant: WdsChipVariant.solid,
                  leading: _icon.build(),
                  trailing: _icon,
                  value: 7,
                  groupValues: groupValues,
                  onTap: () {
                    debugPrint('Solid chip with icons');
                    setState(() => __onTap(groupValues, 7));
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void __onTap<T>(Set<T> groupValues, T value) {
  debugPrint('onTap: $groupValues, $value');
  if (groupValues.contains(value)) {
    groupValues.remove(value);
  } else {
    groupValues.add(value);
  }
}
