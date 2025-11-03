part of '../../wds_components.dart';

/// SectionMessage variant enum
enum WdsSectionMessageVariant {
  /// 기본 정보 전달 형태
  normal,

  /// 긍정적인 정보나 성공 상태 표시
  highlight,

  /// 주의가 필요한 정보나 경고 상태 표시
  warning,
}

class _SectionMessageStyleByVariant {
  const _SectionMessageStyleByVariant._();

  static ({Color background, Color text, Color icon}) of(
    WdsSectionMessageVariant variant,
  ) {
    return switch (variant) {
      WdsSectionMessageVariant.normal => (
        background: WdsColors.backgroundAlternative,
        text: WdsColors.textNeutral,
        icon: WdsColors.neutral500,
      ),
      WdsSectionMessageVariant.highlight => (
        background: WdsColors.blue50,
        text: WdsColors.statusPositive,
        icon: WdsColors.primary,
      ),
      WdsSectionMessageVariant.warning => (
        background: WdsColors.orange50,
        text: WdsColors.statusCautionaty,
        icon: WdsColors.statusCautionaty,
      ),
    };
  }
}

/// 특정 섹션이나 영역 내에서 중요한 정보나 피드백을 전달하는 메시지 컴포넌트
///
/// 사용자가 필요한 행동을 취할 수 있도록 돕습니다.
class WdsSectionMessage extends StatelessWidget {
  /// 기본 정보 메시지
  const WdsSectionMessage.normal({
    required this.message,
    super.key,
  }) : variant = WdsSectionMessageVariant.normal,
       leadingIcon = WdsIcon.info;

  /// 긍정적 메시지
  const WdsSectionMessage.highlight({
    required this.message,
    super.key,
  }) : variant = WdsSectionMessageVariant.highlight,
       leadingIcon = WdsIcon.info;

  /// 경고 메시지
  const WdsSectionMessage.warning({
    required this.message,
    super.key,
  }) : variant = WdsSectionMessageVariant.warning,
       leadingIcon = WdsIcon.info;

  /// 메시지에 표시될 텍스트 내용
  final String message;

  /// 선택사항인 앞쪽 아이콘
  final WdsIcon leadingIcon;

  /// SectionMessage variant
  final WdsSectionMessageVariant variant;

  @override
  Widget build(BuildContext context) {
    final style = _SectionMessageStyleByVariant.of(variant);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            leadingIcon.build(
              width: 16, // 16x16 고정
              height: 16,
              color: style.icon,
            ),
            Text(
              message,
              style: WdsTypography.caption12ReadingRegular.copyWith(
                color: style.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
