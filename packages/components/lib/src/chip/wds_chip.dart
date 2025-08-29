part of '../../wds_components.dart';

enum WdsChipShape {
  pill(radius: WdsAtomicRadius.full),
  square(radius: WdsAtomicRadius.v8);

  const WdsChipShape({required this.radius});

  final double radius;
}

enum WdsChipVariant {
  outline(
    background: Color(0x00000000), // null/transparent
    foreground: WdsSemanticColorText.neutral,
    border: BorderSide(color: WdsSemanticColorBorder.alternative),
  ),
  solid(
    background: WdsSemanticColorBackgroud.alternative,
    foreground: WdsSemanticColorText.normal,
    border: null,
  );

  const WdsChipVariant({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final BorderSide? border;
}

enum WdsChipSize {
  xsmall(
    height: 28,
    outlinePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    solidPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    outlineTypography: WdsSemanticTypography.caption12Regular,
    solidTypography: WdsSemanticTypography.caption12Medium,
  ),
  small(
    height: 30,
    outlinePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    solidPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    outlineTypography: WdsSemanticTypography.body13NormalRegular,
    solidTypography: WdsSemanticTypography.body13NormalMedium,
  ),
  medium(
    height: 34,
    outlinePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    solidPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    outlineTypography: WdsSemanticTypography.body13NormalRegular,
    solidTypography: WdsSemanticTypography.body13NormalMedium,
  ),
  large(
    height: 38,
    outlinePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    solidPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    outlineTypography: WdsSemanticTypography.body13NormalRegular,
    solidTypography: WdsSemanticTypography.body13NormalMedium,
  );

  const WdsChipSize({
    required this.height,
    required this.outlinePadding,
    required this.solidPadding,
    required this.outlineTypography,
    required this.solidTypography,
  });

  final double height;
  final EdgeInsets outlinePadding;
  final EdgeInsets solidPadding;
  final TextStyle outlineTypography;
  final TextStyle solidTypography;

  // Helper methods to get variant-specific properties
  EdgeInsets paddingFor(WdsChipVariant variant) {
    return variant == WdsChipVariant.outline ? outlinePadding : solidPadding;
  }

  TextStyle typographyFor(WdsChipVariant variant) {
    return variant == WdsChipVariant.outline
        ? outlineTypography
        : solidTypography;
  }
}

/// 정보를 카테고리화하거나 필터링에 사용되는 소형 컴포넌트
class WdsChip extends StatefulWidget {
  const WdsChip.pill({
    required this.label,
    this.leading,
    this.trailing,
    this.onTap,
    this.isEnabled = true,
    this.variant = WdsChipVariant.outline,
    this.size = WdsChipSize.medium,
    Key? key,
  })  : shape = WdsChipShape.pill,
        super(key: key);

  const WdsChip.square({
    required this.label,
    this.leading,
    this.trailing,
    this.onTap,
    this.isEnabled = true,
    this.variant = WdsChipVariant.outline,
    this.size = WdsChipSize.medium,
    Key? key,
  })  : shape = WdsChipShape.square,
        super(key: key);

  final String label;

  final WdsIcon? leading;

  final WdsIcon? trailing;

  final VoidCallback? onTap;

  final bool isEnabled;

  final WdsChipShape shape;

  final WdsChipVariant variant;

  final WdsChipSize size;

  @override
  State<WdsChip> createState() => _WdsChipState();
}

class _WdsChipState extends State<WdsChip> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  static const Duration _hoverAnimationDuration = Duration(milliseconds: 150);

  // Cache expensive computations
  late final TextStyle _typography;
  late final TextStyle _focusedTypography;
  late final Color _normalBackground;
  late final Color _focusedBackground;

  @override
  void initState() {
    super.initState();
    _precomputeExpensiveValues();
  }

  void _precomputeExpensiveValues() {
    // Cache typography with color applied (variant-specific)
    _typography = widget.size
        .typographyFor(widget.variant)
        .copyWith(color: widget.variant.foreground);

    // focused state uses white text for proper contrast with cta background
    _focusedTypography = widget.size
        .typographyFor(widget.variant)
        .copyWith(color: WdsColorCommon.white);

    // Cache background colors
    _normalBackground = widget.variant.background;
    // focused state uses cta color for both outline and solid variants
    _focusedBackground = cta;

    // Pre-build content children list (we'll build the row dynamically for text color changes)
  }

  // Interaction handlers
  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled || !mounted || _isPressed) return;
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled || !mounted || !_isPressed) return;
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    if (!widget.isEnabled || !mounted || !_isPressed) return;
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTap() {
    if (!widget.isEnabled) return;
    if (!mounted) return;

    // Toggle focused state when tapped (for filter chips)
    setState(() {
      _isFocused = !_isFocused;
    });

    widget.onTap?.call();
  }

  // Colors
  Color _overlayTargetColor() {
    // Focused 상태에서는 overlay를 적용하지 않습니다.
    if (_isFocused) {
      return const Color(0x00000000);
    }
    final Color base = WdsSemanticColorMaterial.pressed;
    if (_isPressed || _isHovered) {
      return base;
    }
    return const Color(0x00000000);
  }

  Color _getBackgroundColor() {
    return _isFocused ? _focusedBackground : _normalBackground;
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.size.height;
    final EdgeInsets padding = widget.size.paddingFor(widget.variant);
    final double radius = widget.shape.radius;
    final borderRadius = BorderRadius.all(Radius.circular(radius));
    final backgroundColor = _getBackgroundColor();

    // Get current text style and icon color based on focus state
    final currentTypography = _isFocused ? _focusedTypography : _typography;
    final currentIconColor =
        _isFocused ? WdsColorCommon.white : widget.variant.foreground;

    // Build content row with current text style
    final List<Widget> contentChildren = [];

    if (widget.leading != null) {
      contentChildren.add(
        widget.leading!.build(
          color: currentIconColor,
          width: 16,
          height: 16,
        ),
      );
    }

    contentChildren.add(
      Text(
        widget.label,
        style: currentTypography,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (widget.trailing != null) {
      contentChildren.add(
        widget.trailing!.build(
          color: currentIconColor,
          width: 16,
          height: 16,
        ),
      );
    }

    final contentRow = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: contentChildren.toList(),
    );

    Widget content = Padding(
      padding: padding,
      child: contentRow,
    );

    // Overlay animation
    final overlay = TweenAnimationBuilder<Color?>(
      duration: _hoverAnimationDuration,
      tween: ColorTween(end: _overlayTargetColor()),
      curve: Curves.easeInOut,
      builder: (context, color, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
        );
      },
    );

    // Core gesture
    final coreGesture = GestureDetector(
      onTapDown: widget.isEnabled ? _handleTapDown : null,
      onTapUp: widget.isEnabled ? _handleTapUp : null,
      onTapCancel: widget.isEnabled ? _handleTapCancel : null,
      onTap: widget.isEnabled ? _handleTap : null,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
          height: height,
          child: IntrinsicWidth(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background + border
                Positioned.fill(
                  child: RepaintBoundary(
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: borderRadius,
                          // focused 상태에서는 border를 제거합니다 (outline에서도 표시하지 않음)
                          side: _isFocused
                              ? BorderSide.none
                              : (widget.variant.border ?? BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                ),
                // Overlay
                Positioned.fill(
                  child: IgnorePointer(
                    child: RepaintBoundary(child: overlay),
                  ),
                ),
                // Content
                RepaintBoundary(child: content),
              ],
            ),
          ),
        ),
      ),
    );

    final gestureChild = kIsWeb
        ? MouseRegion(
            onEnter: (_) {
              if (!widget.isEnabled || !mounted || _isHovered) return;
              setState(() => _isHovered = true);
            },
            onExit: (_) {
              if (!widget.isEnabled || !mounted || !_isHovered) return;
              setState(() => _isHovered = false);
            },
            child: coreGesture,
          )
        : coreGesture;

    final Widget result = IgnorePointer(
      ignoring: !widget.isEnabled,
      child: gestureChild,
    );

    return result;
  }
}
