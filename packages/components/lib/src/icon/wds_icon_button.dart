part of '../../wds_components.dart';

/// 아이콘 인터랙션 영역 40x40, 아이콘 24x24를 갖는 아이콘 버튼
class WdsIconButton extends StatefulWidget {
  const WdsIconButton({
    required this.onTap,
    required this.icon,
    this.isEnabled = true,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget icon; // 일반적으로 WdsIcon.xxx.build(width:24,height:24)
  final bool isEnabled;

  @override
  State<WdsIconButton> createState() => _WdsIconButtonState();
}

class _WdsIconButtonState extends State<WdsIconButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  static const Duration _hoverAnimationDuration = Duration(milliseconds: 150);

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    if (!mounted) return;
    if (!_isPressed) setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) return;
    if (!mounted) return;
    if (_isPressed) setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) return;
    if (!mounted) return;
    if (_isPressed) setState(() => _isPressed = false);
  }

  Color _overlayTargetColor() {
    final Color base = WdsSemanticColorMaterial.pressed;
    if (_isPressed || _isHovered) return base;
    return const Color(0x00000000);
  }

  @override
  Widget build(BuildContext context) {
    const double interactionSize = 40;
    const EdgeInsets padding = EdgeInsets.all(8); // 24 icon + 8*2 = 40

    final overlay = TweenAnimationBuilder<Color?>(
      duration: _hoverAnimationDuration,
      tween: ColorTween(end: _overlayTargetColor()),
      curve: Curves.easeInOut,
      builder: (context, color, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        );
      },
    );

    final coreGesture = GestureDetector(
      onTapDown: widget.isEnabled ? _handleTapDown : null,
      onTapUp: widget.isEnabled ? _handleTapUp : null,
      onTapCancel: widget.isEnabled ? _handleTapCancel : null,
      onTap: widget.isEnabled ? widget.onTap : null,
      behavior: HitTestBehavior.opaque,
      child: ClipOval(
        child: SizedBox(
          width: interactionSize,
          height: interactionSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 오버레이
              Positioned.fill(
                child: IgnorePointer(child: RepaintBoundary(child: overlay)),
              ),
              // 아이콘 (24x24 권장), 상하좌우 8px 패딩
              Padding(padding: padding, child: widget.icon),
            ],
          ),
        ),
      ),
    );

    final gestureChild = kIsWeb
        ? MouseRegion(
            onEnter: (_) {
              if (!widget.isEnabled) return;
              if (!mounted) return;
              if (!_isHovered) setState(() => _isHovered = true);
            },
            onExit: (_) {
              if (!widget.isEnabled) return;
              if (!mounted) return;
              if (_isHovered) setState(() => _isHovered = false);
            },
            child: coreGesture,
          )
        : coreGesture;

    final Widget result = IgnorePointer(
      ignoring: !widget.isEnabled,
      child: gestureChild,
    );

    if (!widget.isEnabled) {
      return Opacity(opacity: 0.4, child: result);
    }
    return result;
  }
}
