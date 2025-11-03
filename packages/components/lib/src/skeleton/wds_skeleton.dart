part of '../../wds_components.dart';

/// 스켈레톤 로딩 인디케이터를 표시하는 위젯입니다.
///
/// 이 위젯은 사용자에게 로딩 상태를 알리는 데 사용됩니다. 특정 크기로 렌더링되거나
/// 텍스트와 같은 스켈레톤으로 렌더링될 수 있습니다. 쉬머 애니메이션은 [RepaintBoundary]로
/// 최적화되어 있습니다.
class WdsSkeleton extends StatefulWidget {
  /// 특정 크기의 스켈레톤을 생성합니다.
  const WdsSkeleton({
    super.key,
    this.width,
    this.height,
  }) : _padding = EdgeInsets.zero;

  /// 세로 패딩이 있는 텍스트용 스켈레톤을 생성합니다.
  const WdsSkeleton.text({
    super.key,
    this.width,
    this.height,
  }) : _padding = const EdgeInsets.symmetric(vertical: 2);

  /// 스켈레톤의 너비입니다.
  final double? width;

  /// 스켈레톤의 높이입니다.
  final double? height;

  /// 스켈레톤 주위에 적용할 패딩입니다.
  final EdgeInsetsGeometry _padding;

  @override
  State<WdsSkeleton> createState() => _WdsSkeletonState();
}

class _WdsSkeletonState extends State<WdsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1500));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary는 쉬머 애니메이션을 분리하여 부모 위젯의 리페인트를 방지하는 데
    // 사용됩니다.
    return RepaintBoundary(
      child: Padding(
        padding: widget._padding,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) {
                return _ShimmerGradient(
                  controllerValue: _shimmerController.value,
                ).createShader(bounds);
              },
              child: child,
            );
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: WdsColors.coolNeutral100,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

/// 쉬머 효과를 만드는 커스텀 그라데이션입니다.
///
/// 이 그라데이션은 제공된 컨트롤러의 값을 기반으로 위치가 계산됩니다.
class _ShimmerGradient extends LinearGradient {
  _ShimmerGradient({required this.controllerValue})
    : super(
        colors: const [
          Color(0x00FFFFFF),
          Color(0x80FFFFFF), // 50% opacity white
          Color(0x00FFFFFF),
        ],
        stops: const [
          0.0,
          0.5,
          1.0,
        ],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        transform: _ShimmerGradientTransform(controllerValue),
      );
  final double controllerValue;
}

/// 그라데이션의 위치를 계산하는 Transform 클래스입니다.
class _ShimmerGradientTransform extends GradientTransform {
  const _ShimmerGradientTransform(this.value);
  final double value;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final shimmerWidth = bounds.width * 1.5;
    final dx = value * shimmerWidth - (shimmerWidth / 2);
    return Matrix4.translationValues(dx, 0, 0);
  }
}
