part of '../../wds_components.dart';

class WdsCircular extends StatelessWidget {
  const WdsCircular({
    this.size = 28,
    this.color,
    super.key,
  });

  /// 원형 로더의 크기
  final int size;

  /// 로더의 색상
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.toDouble(),
      height: size.toDouble(),
      child: CircularProgressIndicator(
        strokeWidth: 3,
        strokeCap: StrokeCap.round,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? WdsColors.borderNeutral,
        ),
      ),
    );
  }
}
