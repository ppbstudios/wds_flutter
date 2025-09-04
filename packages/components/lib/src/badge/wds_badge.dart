part of '../../wds_components.dart';

/// 정보의 개수를 강조하기 위해 사용하는 Badge 컴포넌트
///
/// 장바구니 아이템, 알림 등 개수에 대한 표기가 필요한 경우에 활용합니다.
class WdsBadge extends StatelessWidget {
  const WdsBadge({
    required this.count,
    super.key,
  });

  /// 표시할 개수 (0은 표시하지 않음)
  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    final displayText = _getDisplayText(count);

    final text = Text(
      displayText,
      style: const TextStyle(
        color: WdsColors.white,
        letterSpacing: 0.03,
        height: 1.28, // 128%
        fontWeight: FontWeight.w600,
        fontFamily: WdsTypography.fontFamily,
        fontSize: 9,
      ),
      textAlign: TextAlign.center,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: WdsColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(WdsRadius.full)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
        child: Builder(
          builder: (context) {
            if (displayText.length == 1) {
              if (count == 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: text,
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: text,
              );
            }

            return text;
          },
        ),
      ),
    );
  }

  String _getDisplayText(int count) {
    if (count <= 99) return count.toString();
    return '99+';
  }
}

/// Widget에 Badge를 추가하는 Extension
extension WdsBadgeExtension on Widget {
  /// 아이콘에 Badge를 추가합니다
  Widget addBadge({
    required int count,
  }) {
    if (count <= 0) {
      return this;
    }

    int digitCount = count.toString().length;
    if (digitCount > 2) {
      digitCount = 2;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 원본 위젯 그대로 유지 (24x24)
        this,

        /// Badge 위치 조정 - 아이콘 기준 오른쪽 아래 중앙
        Positioned(
          left: 12 - ((digitCount - 1) * 5),
          top: 12,
          child: WdsBadge(count: count),
        ),
      ],
    );
  }
}
