part of '../../wds_components.dart';

/// SegmentedControl는 상품 상세 페이지에서
/// 렌즈 종류(예: 하루용, 한달용) 와 같이 옵션을 구분할 때 사용됩니다.
class WdsSegmentedControl extends StatefulWidget {
  /// SegmentedControl 생성자
  const WdsSegmentedControl({
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
    this.isEnabled = true,
    super.key,
  });

  /// 선택 가능한 세그먼트 목록
  final List<String> segments;

  /// 현재 선택된 세그먼트 인덱스
  final int selectedIndex;

  /// 선택 변경 시 호출되는 콜백
  final ValueChanged<int>? onChanged;

  /// SegmentedControl 활성화 여부
  final bool isEnabled;

  @override
  State<WdsSegmentedControl> createState() => _WdsSegmentedControlState();
}

class _WdsSegmentedControlState extends State<WdsSegmentedControl> {
  final double _segmentHeight = 28;
  static const double _slidingButtonOverlap = 4;

  @override
  Widget build(BuildContext context) {
    if (widget.segments.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth > 0 ? constraints.maxWidth : 108.0;
        final segmentWidth = width / widget.segments.length;

        return Opacity(
          opacity: widget.isEnabled ? 1.0 : WdsOpacity.opacity40,
          child: Container(
            width: width,
            height: _segmentHeight,
            decoration: const BoxDecoration(
              color: WdsColors.coolNeutral100,
              borderRadius: BorderRadius.all(Radius.circular(WdsRadius.full)),
            ),
            child: Stack(
              children: [
                Row(
                  children: widget.segments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final segment = entry.value;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.isEnabled && index != widget.selectedIndex
                          ? () => widget.onChanged!(index)
                          : null,
                      child: SizedBox(
                        width: segmentWidth,
                        height: _segmentHeight,
                        child: Center(
                          child: Text(
                            segment,
                            style: WdsTypography.body13NormalRegular.copyWith(
                              color: WdsColors.textNormal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // 슬라이딩 버튼
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.decelerate,
                  left: widget.selectedIndex * segmentWidth -
                      (widget.selectedIndex > 0 ? _slidingButtonOverlap : 0),
                  child: Container(
                    width: segmentWidth + _slidingButtonOverlap,
                    height: _segmentHeight,
                    decoration: const BoxDecoration(
                      color: WdsColors.neutral900,
                      borderRadius:
                          BorderRadius.all(Radius.circular(WdsRadius.full)),
                    ),
                    child: Center(
                      child: Text(
                        widget.segments[widget.selectedIndex],
                        style: WdsTypography.body13NormalBold.copyWith(
                          color: WdsColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
