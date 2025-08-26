part of '../../wds_components.dart';

class _WdsPillButtonPadding {
  const _WdsPillButtonPadding._();

  static const EdgeInsets xLarge = EdgeInsets.fromLTRB(16, 13, 16, 13);
  static const EdgeInsets large = EdgeInsets.fromLTRB(16, 11, 16, 11);
  static const EdgeInsets medium = EdgeInsets.fromLTRB(16, 10, 16, 10);
  static const EdgeInsets small = EdgeInsets.fromLTRB(16, 7, 16, 7);
  static const EdgeInsets tiny = EdgeInsets.fromLTRB(12, 6, 12, 6);
}

class _WdsPillButtonHeight {
  const _WdsPillButtonHeight._();

  static const double xLarge = 48;
  static const double large = 40;
  static const double medium = 36;
  static const double small = 30;
  static const double tiny = 28;
}

class _WdsPillButtonTypography {
  const _WdsPillButtonTypography._();

  static TextStyle forHeight(double height) {
    // 크기별 고정 타이포그래피 적용
    return switch (height) {
      _WdsPillButtonHeight.xLarge => WdsSemanticTypography.body15NormalBold,
      _WdsPillButtonHeight.large => WdsSemanticTypography.body15NormalBold,
      _WdsPillButtonHeight.medium => WdsSemanticTypography.body13NormalMedium,
      _WdsPillButtonHeight.small => WdsSemanticTypography.caption12Medium,
      _ => WdsSemanticTypography.caption12Medium,
    };
  }
}

/// 필 버튼
///
/// WdsPillButton.{size}{type}
///
/// ### 타입
/// - cta
/// - primary
/// - secondary
/// - custom
///
/// ### 크기
/// - XL
/// - L
/// - M
/// - S
/// - TY
class WdsPillButton extends StatefulWidget {
  const WdsPillButton.xlCta({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = cta,
        color = WdsColorCommon.white,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.xLarge,
        height = _WdsPillButtonHeight.xLarge,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.lCta({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = cta,
        color = WdsColorCommon.white,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.large,
        height = _WdsPillButtonHeight.large,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.mCta({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = cta,
        color = WdsColorCommon.white,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.medium,
        height = _WdsPillButtonHeight.medium,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.sCta({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = cta,
        color = WdsColorCommon.white,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.small,
        height = _WdsPillButtonHeight.small,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.tyCta({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = cta,
        color = WdsColorCommon.white,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.tiny,
        height = _WdsPillButtonHeight.tiny,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.xlPrimary({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = primary,
        color = WdsColorCommon.white,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.xLarge,
        height = _WdsPillButtonHeight.xLarge,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.lPrimary({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = primary,
        color = WdsColorCommon.white,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.large,
        height = _WdsPillButtonHeight.large,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.mPrimary({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = primary,
        color = WdsColorCommon.white,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.medium,
        height = _WdsPillButtonHeight.medium,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.sPrimary({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = primary,
        color = WdsColorCommon.white,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.small,
        height = _WdsPillButtonHeight.small,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.tyPrimary({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = primary,
        color = WdsColorCommon.white,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.tiny,
        height = _WdsPillButtonHeight.tiny,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.xlSecondary({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = WdsColorCommon.white,
        color = WdsSemanticColorText.normal,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.xLarge,
        height = _WdsPillButtonHeight.xLarge,
        borderSide = const BorderSide(color: WdsSemanticColorBorder.neutral),
        child = child,
        super(key: key);

  const WdsPillButton.lSecondary({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = WdsColorCommon.white,
        color = WdsSemanticColorText.normal,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.large,
        height = _WdsPillButtonHeight.large,
        borderSide = const BorderSide(color: WdsSemanticColorBorder.neutral),
        child = child,
        super(key: key);

  const WdsPillButton.mSecondary({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = WdsColorCommon.white,
        color = WdsSemanticColorText.normal,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.medium,
        height = _WdsPillButtonHeight.medium,
        borderSide = const BorderSide(color: WdsSemanticColorBorder.neutral),
        child = child,
        super(key: key);

  const WdsPillButton.sSecondary({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = WdsColorCommon.white,
        color = WdsSemanticColorText.normal,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.small,
        height = _WdsPillButtonHeight.small,
        borderSide = const BorderSide(color: WdsSemanticColorBorder.neutral),
        child = child,
        super(key: key);

  const WdsPillButton.tySecondary({
    required VoidCallback onTap,
    required Widget child,
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = WdsColorCommon.white,
        color = WdsSemanticColorText.normal,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.tiny,
        height = _WdsPillButtonHeight.tiny,
        borderSide = const BorderSide(color: WdsSemanticColorBorder.neutral),
        child = child,
        super(key: key);

  const WdsPillButton.xlCustom({
    required VoidCallback onTap,
    required Widget child,
    required Color backgroundColor,
    Color color = const Color(0xFFFFFFFF),
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = backgroundColor,
        color = color,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.xLarge,
        height = _WdsPillButtonHeight.xLarge,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.lCustom({
    required VoidCallback onTap,
    required Widget child,
    required Color backgroundColor,
    Color color = const Color(0xFFFFFFFF),
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = backgroundColor,
        color = color,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.large,
        height = _WdsPillButtonHeight.large,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.mCustom({
    required VoidCallback onTap,
    required Widget child,
    required Color backgroundColor,
    Color color = const Color(0xFFFFFFFF),
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = backgroundColor,
        color = color,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.medium,
        height = _WdsPillButtonHeight.medium,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.sCustom({
    required VoidCallback onTap,
    required Widget child,
    required Color backgroundColor,
    Color color = const Color(0xFFFFFFFF),
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = backgroundColor,
        color = color,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.small,
        height = _WdsPillButtonHeight.small,
        borderSide = null,
        child = child,
        super(key: key);

  const WdsPillButton.tyCustom({
    required VoidCallback onTap,
    required Widget child,
    required Color backgroundColor,
    Color color = const Color(0xFFFFFFFF),
    bool isEnabled = true,
    Key? key,
  })  : onTap = onTap,
        isEnabled = isEnabled,
        backgroundColor = backgroundColor,
        color = color,
        radius = WdsAtomicRadius.full,
        padding = _WdsPillButtonPadding.tiny,
        height = _WdsPillButtonHeight.tiny,
        borderSide = null,
        child = child,
        super(key: key);

  /// 버튼 클릭 이벤트, 버튼 비활성화 시 이벤트 없음
  final VoidCallback? onTap;

  /// 버튼 배경 색상
  final Color backgroundColor;

  /// 텍스트 색상
  final Color color;

  final double radius;

  final BorderSide? borderSide;

  final EdgeInsets padding;

  final double height;

  final bool isEnabled;

  final Widget child;

  @override
  State<WdsPillButton> createState() => _WdsPillButtonState();
}

class _WdsPillButtonState extends State<WdsPillButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  // Ripple
  late final AnimationController _rippleController;
  Offset? _rippleOrigin;

  static const Duration _hoverAnimationDuration = Duration(milliseconds: 150);
  static const Duration _rippleDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: _rippleDuration,
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  // Interaction handlers
  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    if (!mounted) return;
    _rippleOrigin = details.localPosition;
    if (!_isPressed) {
      setState(() {
        _isPressed = true;
      });
    }
    if (!mounted) return;
    _rippleController.forward(from: 0);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) return;
    if (!mounted) return;
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) return;
    if (!mounted) return;
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  // Colors
  Color _overlayTargetColor() {
    // Base token overlay color for feedback
    final Color base =
        WdsSemanticColorMaterial.pressed; // semi-transparent black
    if (_isPressed) {
      return base.withValues(alpha: (base.a * 1.5).clamp(0.0, 1.0));
    }
    if (_isHovered) {
      return base;
    }
    return const Color(0x00000000);
  }

  Color _effectiveBackgroundColor() {
    if (!widget.isEnabled) {
      return widget.backgroundColor.withValues(alpha: 0.4);
    }
    return widget.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(widget.radius));

    // 콘텐츠 (텍스트/아이콘)
    final TextStyle fixedTypography =
        _WdsPillButtonTypography.forHeight(widget.height).copyWith(
      color: widget.color,
    );

    Widget content = IconTheme(
      data: IconThemeData(color: widget.color),
      child: Padding(padding: widget.padding, child: widget.child),
    );

    // Text 자식일 경우 강제 타이포그래피 적용
    if (widget.child is Text) {
      final Text childText = widget.child as Text;
      final TextStyle? merged =
          childText.style?.merge(fixedTypography) ?? fixedTypography;
      content = IconTheme(
        data: IconThemeData(color: widget.color),
        child: Padding(
          padding: widget.padding,
          child: Text(
            childText.data ?? '',
            key: childText.key,
            style: merged,
            strutStyle: childText.strutStyle,
            textAlign: childText.textAlign,
            textDirection: childText.textDirection,
            locale: childText.locale,
            softWrap: childText.softWrap,
            overflow: childText.overflow,
            textScaleFactor: childText.textScaleFactor,
            maxLines: 1, // 스펙: 최대 1줄
            semanticsLabel: childText.semanticsLabel,
            textWidthBasis: childText.textWidthBasis,
            textHeightBehavior: childText.textHeightBehavior,
            selectionColor: childText.selectionColor,
          ),
        ),
      );
    } else {
      content = DefaultTextStyle.merge(
        style: fixedTypography,
        child: content,
      );
    }

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

    // Ripple painter
    final ripple = AnimatedBuilder(
      animation: _rippleController,
      builder: (context, _) {
        return CustomPaint(
          painter: _RipplePainter(
            progress: _rippleController.value,
            origin: _rippleOrigin,
            color: WdsColorCommon.white
                .withValues(alpha: 0.25 * (1 - _rippleController.value)),
            borderRadius: borderRadius,
          ),
        );
      },
    );

    // Gestures and hover (MouseRegion only on web)
    final coreGesture = GestureDetector(
      onTapDown: widget.isEnabled ? _handleTapDown : null,
      onTapUp: widget.isEnabled ? _handleTapUp : null,
      onTapCancel: widget.isEnabled ? _handleTapCancel : null,
      onTap: widget.isEnabled ? widget.onTap : null,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 배경 + 선택적 테두리
            DecoratedBox(
              decoration: ShapeDecoration(
                color: _effectiveBackgroundColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius,
                  side: widget.borderSide ?? BorderSide.none,
                ),
              ),
              child: SizedBox(
                height: widget.height,
                child: Center(child: content),
              ),
            ),
            // 호버/눌림 오버레이 (애니메이션)
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(child: overlay),
              ),
            ),
            // 리플 피드백
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(child: ripple),
              ),
            ),
          ],
        ),
      ),
    );

    final gestureChild = kIsWeb
        ? MouseRegion(
            onEnter: (_) {
              if (!widget.isEnabled) return;
              if (!mounted) return;
              if (!_isHovered) {
                setState(() => _isHovered = true);
              }
            },
            onExit: (_) {
              if (!widget.isEnabled) return;
              if (!mounted) return;
              if (_isHovered) {
                setState(() => _isHovered = false);
              }
            },
            child: coreGesture,
          )
        : coreGesture;

    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: gestureChild,
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress; // 0.0 -> 1.0
  final Offset? origin;
  final Color color;
  final BorderRadius borderRadius;

  _RipplePainter({
    required this.progress,
    required this.origin,
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (origin == null) return;
    if (color.a == 0) return;

    // Clip to rounded rect so ripple doesn't overflow
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
    canvas.save();
    canvas.clipRRect(rrect);

    // Compute max radius to farthest corner
    final corners = <Offset>[
      rect.topLeft,
      rect.topRight,
      rect.bottomLeft,
      rect.bottomRight,
    ];
    final double maxRadius = corners
        .map((c) => (c - origin!).distance)
        .fold<double>(0.0, (prev, d) => d > prev ? d : prev);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = maxRadius * Curves.easeOut.transform(progress);
    canvas.drawCircle(origin!, radius, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.origin != origin ||
        oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}
