part of '../../wds_components.dart';

/// Toast variant enum
enum WdsToastVariant {
  /// 텍스트만 표시하는 기본 형태
  text,

  /// 아이콘과 텍스트를 함께 표시하는 형태
  icon,
}

/// 화면에 잠시 나타났다 사라지는 짧은 알림 메시지 컴포넌트
///
/// 사용자가 수행한 작업에 대한 피드백을 제공합니다.
class WdsToast extends StatelessWidget {
  /// 텍스트만 표시하는 토스트
  const WdsToast.text({
    required this.message,
    super.key,
  })  : leadingIcon = null,
        variant = WdsToastVariant.text;

  /// 아이콘과 텍스트를 함께 표시하는 토스트
  const WdsToast.icon({
    required this.message,
    required this.leadingIcon,
    super.key,
  }) : variant = WdsToastVariant.icon;

  /// 토스트에 표시될 메시지
  final String message;

  /// 선택사항인 앞쪽 아이콘 (icon variant에서만 사용)
  final WdsIcon? leadingIcon;

  /// Toast variant
  final WdsToastVariant variant;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: WdsColors.cta,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final text = Text(
      message,
      style: WdsTypography.body14NormalMedium.copyWith(
        color: WdsColors.white,
      ),
    );

    if (variant == WdsToastVariant.text || leadingIcon == null) {
      // text variant: DecoratedBox > Padding > Text
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: text,
      );
    }

    // icon variant: DecoratedBox > Padding > Row: (Padding > WdsIcon + Padding > Text)
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: leadingIcon!.build(
            width: 24,
            height: 24,
            color: WdsColors.white,
          ),
        ),
        const SizedBox(width: 6), // 6px spacing between icon and text
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: text,
        ),
      ],
    );
  }
}
