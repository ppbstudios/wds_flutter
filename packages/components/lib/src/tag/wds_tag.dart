part of '../../wds_components.dart';

/// Tag 역할 enum
///
/// 역할만 정하면 색이 결정된다. 문구가 아니라 상태로 판단한다:
/// 다음 단계가 남았으면 [progress], 더 할 일이 없으면 [completed].
enum WdsTagRole {
  /// 서비스 속성: 선택하면 받는 방식이 달라지는 서비스 (바로드림)
  service,

  /// 진행: 다음 단계가 남은 상태 (예약신청 · 예약완료 · 준비완료 · 교환 진행중)
  progress,

  /// 종료⋅완료: 정상 종료, 더 할 일 없음 (구매완료 · 교환완료 · 품절 · 판매중지)
  completed,

  /// 종료⋅실패/취소: 종료됐지만 결과가 부정적 (예약취소 · 노쇼 · 예약거절 · 취소완료)
  failed,

  /// 정보 속성: 상품·매장의 고정된 특징 (무료검안 · 토요일 배송 · 하루용)
  info,
}

class WdsTag extends StatelessWidget {
  /// 색을 직접 지정한다.
  ///
  /// 역할 5종([WdsTagRole])에 해당하는 Tag 는 역할 생성자를 쓴다.
  /// 이 생성자는 이벤트 오버레이처럼 역할 밖의 Tag 에만 쓴다.
  const WdsTag({
    required this.label,
    this.backgroundColor = WdsColors.neutral50,
    this.color = WdsColors.textNeutral,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : role = null,
       borderColor = null;

  /// 서비스 속성: blue/500 채움 + white 글자
  const WdsTag.service({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : role = WdsTagRole.service,
       backgroundColor = WdsColors.blue500,
       color = WdsColors.white,
       borderColor = null;

  /// 진행: neutral/50 배경 + blue/500 글자
  const WdsTag.progress({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : role = WdsTagRole.progress,
       backgroundColor = WdsColors.neutral50,
       color = WdsColors.blue500,
       borderColor = null;

  /// 종료⋅완료: neutral/50 배경 + text/neutral 글자
  const WdsTag.completed({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : role = WdsTagRole.completed,
       backgroundColor = WdsColors.neutral50,
       color = WdsColors.textNeutral,
       borderColor = null;

  /// 종료⋅실패/취소: neutral/50 배경 + orange/700 글자
  const WdsTag.failed({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : role = WdsTagRole.failed,
       backgroundColor = WdsColors.neutral50,
       color = WdsColors.orange700,
       borderColor = null;

  /// 정보 속성: white 배경 + border/neutral 테두리 + text/neutral 글자
  const WdsTag.info({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : role = WdsTagRole.info,
       backgroundColor = WdsColors.white,
       color = WdsColors.textNeutral,
       borderColor = WdsColors.borderNeutral;

  @Deprecated('역할 생성자를 쓴다. 상태면 WdsTag.completed, 상품·매장 정보면 WdsTag.info')
  const WdsTag.normal({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : role = null,
       backgroundColor = WdsColors.neutral50,
       color = WdsColors.textNeutral,
       borderColor = null;

  @Deprecated('역할 생성자를 쓴다. 서비스 속성이면 WdsTag.service')
  const WdsTag.filled({
    required this.label,
    this.hasRadius = true,
    this.leadingIcon,
    super.key,
  }) : role = null,
       backgroundColor = WdsColors.primary,
       color = WdsColors.white,
       borderColor = null;

  /// 자주쓰이는 컴포넌트: NEW
  const WdsTag.$new({super.key})
    : label = 'NEW',
      color = WdsColors.white,
      backgroundColor = WdsColors.coolNeutral700,
      hasRadius = false,
      leadingIcon = null,
      role = null,
      borderColor = null;

  const WdsTag.$sale({super.key})
    : label = 'SALE',
      color = WdsColors.white,
      backgroundColor = WdsColors.secondary,
      hasRadius = false,
      leadingIcon = null,
      role = null,
      borderColor = null;

  const WdsTag.$best({super.key})
    : label = 'BEST',
      color = WdsColors.white,
      backgroundColor = WdsColors.coolNeutral700,
      hasRadius = false,
      leadingIcon = null,
      role = null,
      borderColor = null;

  const WdsTag.$coupon({super.key})
    : label = '쿠폰사용가능',
      color = WdsColors.white,
      backgroundColor = WdsColors.secondary,
      hasRadius = false,
      leadingIcon = null,
      role = null,
      borderColor = null;

  /// 종료⋅완료 역할
  const WdsTag.$soldOut({super.key})
    : label = '일시품절',
      role = WdsTagRole.completed,
      color = WdsColors.textNeutral,
      backgroundColor = WdsColors.neutral50,
      borderColor = null,
      hasRadius = true,
      leadingIcon = null;

  /// 정보 속성 역할
  const WdsTag.$myPower({super.key})
    : label = '내 도수보유',
      role = WdsTagRole.info,
      color = WdsColors.textNeutral,
      backgroundColor = WdsColors.white,
      borderColor = WdsColors.borderNeutral,
      hasRadius = true,
      leadingIcon = null;

  /// 서비스 속성 역할
  const WdsTag.$barodrim({super.key})
    : label = '바로드림',
      role = WdsTagRole.service,
      color = WdsColors.white,
      backgroundColor = WdsColors.blue500,
      borderColor = null,
      hasRadius = true,
      leadingIcon = null;

  /// 정보 속성 역할
  const WdsTag.$upto2days({super.key})
    : label = '1~2일예상',
      role = WdsTagRole.info,
      color = WdsColors.textNeutral,
      backgroundColor = WdsColors.white,
      borderColor = WdsColors.borderNeutral,
      hasRadius = true,
      leadingIcon = null;

  static const double fixedHeight = 18;

  static const EdgeInsets fixedPadding = EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 2,
  );

  static const TextStyle fixedTypography = WdsTypography.caption10Medium;

  static const BorderRadius fixedBorderRadius = BorderRadius.all(
    Radius.circular(WdsRadius.radius4),
  );

  /// 역할 생성자로 만들었으면 그 역할, 색을 직접 지정했으면 `null`
  final WdsTagRole? role;

  final Color backgroundColor;

  final Color color;

  /// [WdsTagRole.info] 만 테두리를 그린다.
  final Color? borderColor;

  final String label;

  final bool hasRadius;

  final WdsIcon? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      this.label,
      style: fixedTypography.copyWith(color: color),
      textAlign: TextAlign.center,
    );

    final Widget child;
    if (leadingIcon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 1,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.5),
            child: SizedBox.square(
              dimension: 12,
              child: leadingIcon!.build(),
            ),
          ),
          label,
        ],
      );
    } else {
      child = label;
    }

    return Semantics(
      label: this.label,
      child: SizedBox(
      height: fixedHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: hasRadius ? fixedBorderRadius : null,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Padding(
          padding: fixedPadding,
          child: child,
        ),
      ),
    ),
    );
  }
}
