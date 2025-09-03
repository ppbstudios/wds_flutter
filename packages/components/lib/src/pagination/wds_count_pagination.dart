part of '../../wds_components.dart';

/// 페이지 번호를 숫자 형태로 표시하는 페이지네이션 컴포넌트입니다.
///
/// 현재 페이지와 전체 페이지를 "현재/전체" 형태로 표시하며,
/// pill 형태의 배경에 흰색 텍스트로 렌더링됩니다.
class WdsCountPagination extends StatelessWidget {
  const WdsCountPagination({
    required this.currentPage,
    required this.totalPage,
    super.key,
  })  : assert(currentPage > 0, 'currentPage는 1보다 커야 합니다'),
        assert(totalPage > 0, 'totalPage는 1보다 커야 합니다'),
        assert(
          currentPage <= totalPage,
          'currentPage는 totalPage보다 작거나 같아야 합니다',
        );

  /// 현재 페이지 번호 (1부터 시작)
  final int currentPage;

  /// 전체 페이지 수
  final int totalPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      decoration: BoxDecoration(
        color: WdsColors.cta.withAlpha(WdsOpacity.opacity80.toAlpha()),
        borderRadius: BorderRadius.circular(WdsRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 현재 페이지 텍스트
          Text(
            currentPage.toString(),
            style: WdsTypography.caption11Regular.copyWith(
              color: WdsColors.white.withAlpha(WdsOpacity.opacity80.toAlpha()),
            ),
          ),
          // 구분자
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              '/',
              style: WdsTypography.caption11Regular.copyWith(
                color: WdsColors.textAlternative,
              ),
            ),
          ),
          // 전체 페이지 텍스트
          Text(
            totalPage.toString(),
            style: WdsTypography.caption11Regular.copyWith(
              color: WdsColors.textAssistive
                  .withAlpha(WdsOpacity.opacity80.toAlpha()),
            ),
          ),
        ],
      ),
    );
  }
}
