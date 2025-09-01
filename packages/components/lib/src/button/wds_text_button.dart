part of '../../wds_components.dart';

enum WdsTextButtonVariant { text, underline, icon }

enum WdsTextButtonSize { medium, small }

class _TextButtonHeightBySize {
  const _TextButtonHeightBySize._();

  static double of(WdsTextButtonSize size) {
    return switch (size) {
      WdsTextButtonSize.medium => 30,
      WdsTextButtonSize.small => 28,
    };
  }
}

class _TextButtonPaddingBySize {
  const _TextButtonPaddingBySize._();

  static EdgeInsets of(WdsTextButtonSize size) {
    return switch (size) {
      WdsTextButtonSize.medium => const EdgeInsets.symmetric(vertical: 4),
      WdsTextButtonSize.small => const EdgeInsets.symmetric(vertical: 5),
    };
  }
}

class _TextButtonTypographyBySize {
  const _TextButtonTypographyBySize._();

  static TextStyle of(WdsTextButtonSize size) {
    return switch (size) {
      WdsTextButtonSize.medium => WdsSemanticTypography.body15NormalMedium,
      WdsTextButtonSize.small => WdsSemanticTypography.body13NormalMedium,
    };
  }
}

class _TextButtonIconSizeBySize {
  const _TextButtonIconSizeBySize._();

  static (double width, double height) of(WdsTextButtonSize size) {
    return switch (size) {
      WdsTextButtonSize.medium => (20, 20),
      WdsTextButtonSize.small => (16, 16),
    };
  }
}

/// 배경/테두리 없이 텍스트만으로 구성된 버튼
class WdsTextButton extends StatefulWidget {
  const WdsTextButton({
    required this.onTap,
    required this.child,
    this.isEnabled = true,
    this.variant = WdsTextButtonVariant.text,
    this.size = WdsTextButtonSize.medium,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool isEnabled;
  final WdsTextButtonVariant variant;
  final WdsTextButtonSize size;

  @override
  State<WdsTextButton> createState() => _WdsTextButtonState();
}

class _WdsTextButtonState extends State<WdsTextButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  static const Duration _hoverAnimationDuration = Duration(milliseconds: 150);

  // Interaction handlers
  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    if (!mounted) return;
    if (!_isPressed) {
      setState(() {
        _isPressed = true;
      });
    }
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

  Color _overlayTargetColor() {
    final Color base = WdsSemanticColorMaterial.pressed;
    if (_isPressed || _isHovered) return base;
    return const Color(0x00000000);
  }

  @override
  Widget build(BuildContext context) {
    final double height = _TextButtonHeightBySize.of(widget.size);
    final EdgeInsets padding = _TextButtonPaddingBySize.of(widget.size);
    final TextStyle baseTypography =
        _TextButtonTypographyBySize.of(widget.size).copyWith(
      color: widget.isEnabled
          ? WdsSemanticColorText.neutral
          : WdsSemanticColorText.disable,
    );
    final BorderRadius borderRadius = BorderRadius.circular(WdsAtomicRadius.xs);

    // Compose child: force typography for Text
    Widget content = Padding(padding: padding, child: widget.child);

    if (widget.child is Text) {
      final Text childText = widget.child as Text;
      final TextStyle merged =
          childText.style?.merge(baseTypography) ?? baseTypography;

      TextDecoration? decoration;
      Color? decorationColor;
      if (widget.variant == WdsTextButtonVariant.underline) {
        decoration = TextDecoration.underline;
        decorationColor = widget.isEnabled
            ? WdsSemanticColorText.neutral
            : WdsSemanticColorText.disable;
      }

      content = Padding(
        padding: padding,
        child: Text(
          childText.data ?? '',
          key: childText.key,
          style: merged.copyWith(
            decoration: decoration,
            decorationColor: decorationColor,
          ),
          strutStyle: childText.strutStyle,
          textAlign: childText.textAlign,
          textDirection: childText.textDirection,
          locale: childText.locale,
          softWrap: childText.softWrap,
          overflow: childText.overflow,
          textScaler: childText.textScaler,
          maxLines: 1,
          semanticsLabel: childText.semanticsLabel,
          textWidthBasis: childText.textWidthBasis,
          textHeightBehavior: childText.textHeightBehavior,
          selectionColor: childText.selectionColor,
        ),
      );
    } else {
      content = DefaultTextStyle.merge(
        style: baseTypography,
        child: content,
      );
    }

    // trailing icon for icon variant
    if (widget.variant == WdsTextButtonVariant.icon) {
      final (double w, double h) = _TextButtonIconSizeBySize.of(widget.size);
      final Color iconColor = widget.isEnabled
          ? WdsSemanticColorText.neutral
          : WdsSemanticColorText.disable;
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: WdsIcon.chevronRight.build(
              color: iconColor,
              width: w,
              height: h,
            ),
          ),
        ],
      );
    }

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

    final coreGesture = GestureDetector(
      onTapDown: widget.isEnabled ? _handleTapDown : null,
      onTapUp: widget.isEnabled ? _handleTapUp : null,
      onTapCancel: widget.isEnabled ? _handleTapCancel : null,
      onTap: widget.isEnabled ? widget.onTap : null,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
          height: height,
          child: Center(
            child: Align(
              widthFactor: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 높이 유지, 폭은 컨텐츠 폭 기준
                  SizedBox(height: height),
                  // 오버레이 (컨텐츠 폭 기준)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: RepaintBoundary(child: overlay),
                    ),
                  ),
                  // 컨텐츠
                  RepaintBoundary(child: content),
                ],
              ),
            ),
          ),
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

    final Widget result = IgnorePointer(
      ignoring: !widget.isEnabled,
      child: gestureChild,
    );

    if (!widget.isEnabled) {
      return result; // 색상으로 비활성 표현, 투명도 변경 없음
    }
    return result;
  }
}
