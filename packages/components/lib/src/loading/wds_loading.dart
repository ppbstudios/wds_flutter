part of '../../wds_components.dart';

enum WdsLoadingSize { small, medium }

class _LoadingDotSizeBySize {
  const _LoadingDotSizeBySize._();

  static double of(WdsLoadingSize size) {
    return switch (size) {
      WdsLoadingSize.small => 8,
      WdsLoadingSize.medium => 18,
    };
  }
}

class _LoadingSpacingBySize {
  const _LoadingSpacingBySize._();

  static double of(WdsLoadingSize size) {
    return switch (size) {
      WdsLoadingSize.small => WdsSpacing.md2,
      WdsLoadingSize.medium => WdsSpacing.md5,
    };
  }
}

enum WdsLoadingColor {
  /// 기본 색상 (primary)
  normal,

  /// 흰색
  white;

  Color get backgroundColor {
    switch (this) {
      case WdsLoadingColor.normal:
        return WdsColors.primary;
      case WdsLoadingColor.white:
        return WdsColors.white;
    }
  }
}

/// 로딩 컴포넌트는 사용자가 처리 진행 상태를 인지할 수 있도록 안내하는 시각적 피드백 요소입니다.
///
/// 3개의 원형(dot)이 파동(wave) 형태로 확장/축소되는 애니메이션을 표현하며,
/// 로드 시간이 짧은 일반적인 상황에서 사용합니다.
class WdsLoading extends StatefulWidget {
  const WdsLoading.small({
    this.color = WdsLoadingColor.normal,
    super.key,
  }) : size = WdsLoadingSize.small;

  const WdsLoading.medium({
    this.color = WdsLoadingColor.normal,
    super.key,
  }) : size = WdsLoadingSize.medium;

  /// 로딩 dot의 색상
  final WdsLoadingColor color;

  /// 로딩 컴포넌트의 크기
  final WdsLoadingSize size;

  @override
  State<WdsLoading> createState() => _WdsLoadingState();
}

class _WdsLoadingState extends State<WdsLoading> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double dotSize = _LoadingDotSizeBySize.of(widget.size);
    final double spacing = _LoadingSpacingBySize.of(widget.size);

    return RepaintBoundary(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            child: _LoadingDot(
              controller: _controller,
              index: index,
              color: widget.color.backgroundColor,
              size: dotSize,
            ),
          );
        }),
      ),
    );
  }
}

class _LoadingDot extends StatelessWidget {
  const _LoadingDot({
    required this.controller,
    required this.index,
    required this.color,
    required this.size,
  });

  final AnimationController controller;
  final int index;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double phaseShift = index * 1.2;
        final double wave =
            math.sin(2 * math.pi * controller.value - phaseShift);
        final double scale = 1.0 + (wave + 1) * 0.25;

        return Transform.scale(
          scale: scale,
          child: SizedBox.square(
            dimension: size,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
