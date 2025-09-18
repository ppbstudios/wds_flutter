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

  final isLoading = context.knobs.boolean(
    label: 'isLoading',
    description: '버튼의 로딩 상태를 정의해요',
  );

  final iconType = context.knobs.object.dropdown<String>(
    label: 'icon',
    options: [
      'none',
      'plus',
      'minus',
      'search',
      'settings',
      'close',
      'info',
      'download',
      'share',
      'cart',
      'call',
      'camera',
      'clock',
      'star_filled',
      'chevron_right',
      'chevron_left',
      'chevron_up',
      'chevron_down',
    ],
    initialOption: 'none',
    description: '표시할 아이콘을 선택해요',
  );

  final styleBySize = <String, TextStyle>{
    'xlarge': WdsTypography.body15NormalBold,
    'large': WdsTypography.body15NormalBold,
    'medium': WdsTypography.body13NormalMedium,
    'small': WdsTypography.caption12Medium,
    'tiny': WdsTypography.caption12Medium,
  };

  final child = Text(text, style: styleBySize[size]!);
  void onTap() => debugPrint('Button pressed: $variant $size');

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

  final icon = switch (iconType) {
    'plus' => WdsIcon.plus,
    'minus' => WdsIcon.minus,
    'search' => WdsIcon.search,
    'settings' => WdsIcon.settings,
    'close' => WdsIcon.close,
    'info' => WdsIcon.info,
    'download' => WdsIcon.download,
    'share' => WdsIcon.share,
    'cart' => WdsIcon.cart,
    'call' => WdsIcon.call,
    'camera' => WdsIcon.camera,
    'clock' => WdsIcon.clock,
    'star_filled' => WdsIcon.starFilled,
    'chevron_right' => WdsIcon.chevronRight,
    'chevron_left' => WdsIcon.chevronLeft,
    'chevron_up' => WdsIcon.chevronUp,
    'chevron_down' => WdsIcon.chevronDown,
    'none' || _ => null,
  };

  final button = WdsButton(
    onTap: onTap,
    isEnabled: isEnabled,
    variant: variantValue,
    size: sizeValue,
    isLoading: isLoading,
    icon: icon,
    child: child,
  );

  return WidgetbookPlayground(
    info: [
      'variant: $variant',
      'size: $size',
      'state: ${isEnabled ? 'enabled' : 'disabled'}',
      'loading: $isLoading',
      'icon: $iconType',
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
              onTap: () => debugPrint('CTA pressed'),
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('Primary pressed'),
              variant: WdsButtonVariant.primary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('Secondary pressed'),
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
              onTap: () => debugPrint('XL pressed'),
              size: WdsButtonSize.xlarge,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('L pressed'),
              size: WdsButtonSize.large,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('M pressed'),
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('S pressed'),
              size: WdsButtonSize.small,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('TY pressed'),
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
                  onTap: () => debugPrint('CTA default'),
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => debugPrint('Primary default'),
                  variant: WdsButtonVariant.primary,
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => debugPrint('Secondary default'),
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
                  onTap: () => debugPrint('CTA pressed'),
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => debugPrint('Primary pressed'),
                  variant: WdsButtonVariant.primary,
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => debugPrint('Secondary pressed'),
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
                  onTap: () => debugPrint('CTA disabled'),
                  isEnabled: false,
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => debugPrint('Primary disabled'),
                  variant: WdsButtonVariant.primary,
                  isEnabled: false,
                  child: const Text('텍스트'),
                ),
                WdsButton(
                  onTap: () => debugPrint('Secondary disabled'),
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
      WidgetbookSubsection(
        title: 'loading',
        labels: ['xlarge', 'large', 'medium', 'small', 'tiny'],
        content: Wrap(
          runSpacing: 24,
          spacing: 24,
          children: [
            WdsButton(
              onTap: () => debugPrint('XL pressed'),
              size: WdsButtonSize.xlarge,
              isLoading: true,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('L pressed'),
              size: WdsButtonSize.large,
              isLoading: true,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('M pressed'),
              isLoading: true,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('S pressed'),
              size: WdsButtonSize.small,
              isLoading: true,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('TY pressed'),
              size: WdsButtonSize.tiny,
              isLoading: true,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('XL pressed'),
              size: WdsButtonSize.xlarge,
              isLoading: true,
              variant: WdsButtonVariant.primary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('L pressed'),
              size: WdsButtonSize.large,
              isLoading: true,
              variant: WdsButtonVariant.primary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('M pressed'),
              isLoading: true,
              variant: WdsButtonVariant.primary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('S pressed'),
              size: WdsButtonSize.small,
              isLoading: true,
              variant: WdsButtonVariant.primary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('TY pressed'),
              size: WdsButtonSize.tiny,
              isLoading: true,
              variant: WdsButtonVariant.primary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('XL pressed'),
              size: WdsButtonSize.xlarge,
              isLoading: true,
              variant: WdsButtonVariant.secondary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('L pressed'),
              size: WdsButtonSize.large,
              isLoading: true,
              variant: WdsButtonVariant.secondary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('M pressed'),
              isLoading: true,
              variant: WdsButtonVariant.secondary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('S pressed'),
              size: WdsButtonSize.small,
              isLoading: true,
              variant: WdsButtonVariant.secondary,
              child: const Text('텍스트'),
            ),
            WdsButton(
              onTap: () => debugPrint('TY pressed'),
              size: WdsButtonSize.tiny,
              isLoading: true,
              variant: WdsButtonVariant.secondary,
              child: const Text('텍스트'),
            ),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'icon',
        labels: ['xlarge', 'large', 'medium', 'small', 'tiny'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            WdsButton(
              onTap: () => debugPrint('xlarge icon pressed'),
              icon: WdsIcon.blank,
              size: WdsButtonSize.xlarge,
              child: const Text('추가'),
            ),
            WdsButton(
              onTap: () => debugPrint('large icon pressed'),
              icon: WdsIcon.blank,
              size: WdsButtonSize.large,
              child: const Text('검색'),
            ),
            WdsButton(
              onTap: () => debugPrint('medium icon pressed'),
              icon: WdsIcon.blank,
              child: const Text('설정'),
            ),
            WdsButton(
              onTap: () => debugPrint('small icon pressed'),
              icon: WdsIcon.blank,
              size: WdsButtonSize.small,
              child: const Text('장바구니'),
            ),
            WdsButton(
              onTap: () => debugPrint('tiny icon pressed'),
              icon: WdsIcon.blank,
              size: WdsButtonSize.tiny,
              child: const Text('장바구니'),
            ),
          ],
        ),
      ),
    ],
  );
}
