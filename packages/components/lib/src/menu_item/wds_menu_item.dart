part of '../../wds_components.dart';

class WdsMenuItem extends StatefulWidget {
  const WdsMenuItem.text({
    required this.text,
    required this.onTap,
    super.key,
  }) : icon = null;

  const WdsMenuItem.icon({
    required this.text,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String text;

  final WdsIcon? icon;

  final VoidCallback onTap;

  @override
  State<WdsMenuItem> createState() => _WdsMenuItemState();
}

class _WdsMenuItemState extends State<WdsMenuItem> {
  bool _isPressed = false;
  bool _isHovered = false;

  static const Duration _hoverAnimationDuration = Duration(milliseconds: 150);

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  Color _overlayTargetColor() {
    final Color base = WdsColors.cta.withAlpha(WdsOpacity.opacity10.toAlpha());
    if (_isPressed || _isHovered) return base;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final overlay = TweenAnimationBuilder<Color?>(
      duration: _hoverAnimationDuration,
      tween: ColorTween(end: _overlayTargetColor()),
      curve: Curves.easeInOut,
      builder: (context, color, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: color,
          ),
        );
      },
    );

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.text,
              maxLines: 1,
              style: WdsTypography.body15NormalMedium.copyWith(
                color: WdsColors.textNormal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.icon != null) ...[
            const SizedBox(width: 16),
            widget.icon!.build(
              width: 20,
              height: 20,
              color: WdsColors.neutral300,
            ),
          ],
        ],
      ),
    );

    final coreGesture = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: overlay),
          content,
        ],
      ),
    );

    final gestureChild = kIsWeb
        ? MouseRegion(
            onEnter: (_) {
              if (!mounted) return;
              if (!_isHovered) {
                setState(() => _isHovered = true);
              }
            },
            onExit: (_) {
              if (!mounted) return;
              if (_isHovered) {
                setState(() => _isHovered = false);
              }
            },
            child: coreGesture,
          )
        : coreGesture;

    return gestureChild;
  }
}
