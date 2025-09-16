part of '../../wds_components.dart';

class WdsCircular extends StatelessWidget {
  const WdsCircular({
    this.size = 28,
    this.color,
    super.key,
  });

  /// 원형 로더의 크기
  final double size;

  /// 로더의 색상
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final strokeWidth = size * (3.0 / 28.0);

    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        strokeCap: StrokeCap.round,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? WdsColors.borderNeutral,
        ),
      ),
    );
  }
}
