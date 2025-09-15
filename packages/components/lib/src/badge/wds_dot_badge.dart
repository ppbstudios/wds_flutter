part of '../../wds_components.dart';

/// 다른 위젯 위에 위치할 수 있는 작은 점 배지 컴포넌트
///
/// 총 9개 위치 지원: topLeft, topCenter, topRight, middleLeft, middleCenter,
/// middleRight, bottomLeft, bottomCenter, bottomRight
/// 기본 점 크기: 4x4px
/// Stack과 Align을 사용하여 자식 위젯 크기에 맞춰 배지 위치 결정
class WdsDotBadge extends StatelessWidget {
  const WdsDotBadge({
    required this.child,
    this.color = WdsColors.orange600,
    this.alignment,
    super.key,
  });

  /// 점 배지의 크기 (기본값: 4.0px)
  static const double size = 4;

  /// 배지가 위치할 자식 위젯
  final Widget child;

  /// 점 배지의 색상 (기본값: WdsColors.orange600)
  final Color? color;

  /// 자식 위젯 기준 배지의 정렬 위치, null이면 미표기
  final Alignment? alignment;

  bool get showBadge => alignment != null;

  @override
  Widget build(BuildContext context) {
    if (!showBadge) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// Figma에서 DotBadge가 위치한 지점은 레이아웃의 꼭지점이라서,
        /// 사각형 내부에 위치하는 Positioned를 사용할 시 반지름만큼의 여유 공간이 있어야 디자인과 일치
        Positioned.fill(
          top: -2,
          right: -2,
          bottom: -2,
          left: -2,
          child: Align(
            alignment: alignment!,
            child: SizedBox.square(
              dimension: size,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: const CircleBorder(),
                  color: color ?? WdsColors.orange600,
                ),
              ),
            ),
          ),
        ),

        child,
      ],
    );
  }
}

/// 모든 위젯에 배지 기능을 제공하는 믹스인
/// StatelessWidget 컴포넌트에서도 배지를 사용할 수 있도록 함
mixin WdsBadgeMixin {
  /// 필요시 위젯을 점 배지로 감싸는 메서드 (모든 옵션 지원)
  Widget buildWidgetWithDotBadge({
    required Widget child,
    Color? color,
    Alignment? alignment,
  }) {
    return WdsDotBadge(
      color: color,
      alignment: alignment,
      child: child,
    );
  }
}

/// 기존 위젯에 배지 기능을 추가하는 확장 메서드
/// 어떤 위젯에든 .addDotBadge() 메서드를 사용할 수 있게 함
extension WdsDotBadgeExtension on Widget {
  /// 모든 위젯에 점 배지를 추가하는 메서드 (모든 옵션 지원)
  Widget addDotBadge({
    Color? color,
    Alignment alignment = Alignment.topRight,
  }) {
    return WdsDotBadge(
      color: color,
      alignment: alignment,
      child: this,
    );
  }
}
