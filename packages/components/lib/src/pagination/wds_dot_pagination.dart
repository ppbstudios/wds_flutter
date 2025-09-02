part of '../../wds_components.dart';

/// 페이지네이션을 위한 개별 dot 컴포넌트
///
/// 여러 개의 dot을 조합하여 전체 페이지네이션을 구성합니다.
/// Carousel, 온보딩 화면, 슬라이드 등에서 사용됩니다.
class WdsDotPagination extends StatelessWidget {
  const WdsDotPagination({
    required this.isActive,
    super.key,
  });

  /// 현재 페이지 여부
  ///
  /// - `true`: 현재 페이지 (활성 상태)
  /// - `false`: 비활성 페이지
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isActive ? WdsColors.textNormal : WdsColors.textAssistive;

    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
