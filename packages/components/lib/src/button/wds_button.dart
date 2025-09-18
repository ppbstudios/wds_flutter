part of '../../wds_components.dart';

enum WdsButtonVariant { cta, primary, secondary }

enum WdsButtonSize { xlarge, large, medium, small, tiny }

class _ButtonPaddingBySize {
  const _ButtonPaddingBySize._();

  static EdgeInsets of(WdsButtonSize size) {
    // 문서 기준: xL(16,13), L(16,11), M(16,10), S(16,7), TY(16,6)
    return switch (size) {
      WdsButtonSize.xlarge => const EdgeInsets.fromLTRB(16, 13, 16, 13),
      WdsButtonSize.large => const EdgeInsets.fromLTRB(16, 11, 16, 11),
      WdsButtonSize.medium => const EdgeInsets.fromLTRB(16, 9, 16, 9),
      WdsButtonSize.small => const EdgeInsets.fromLTRB(12, 7, 12, 7),
      WdsButtonSize.tiny => const EdgeInsets.fromLTRB(12, 6, 12, 6),
    };
  }

  static EdgeInsets ofLoading(WdsButtonSize size) {
    return switch (size) {
      WdsButtonSize.xlarge => const EdgeInsets.fromLTRB(11, 2, 11, 2),
      WdsButtonSize.large => const EdgeInsets.fromLTRB(11, 2, 11, 2),
      WdsButtonSize.medium => const EdgeInsets.fromLTRB(12, 1, 12, 1),
      WdsButtonSize.small => const EdgeInsets.fromLTRB(13, 1, 13, 1),
      WdsButtonSize.tiny => const EdgeInsets.fromLTRB(14, 2, 14, 2),
    };
  }
}

class _ButtonHeightBySize {
  const _ButtonHeightBySize._();

  static double of(WdsButtonSize size) {
    return switch (size) {
      WdsButtonSize.xlarge => 48,
      WdsButtonSize.large => 44,
      WdsButtonSize.medium => 38,
      WdsButtonSize.small => 30,
      WdsButtonSize.tiny => 28,
    };
  }
}

class _ButtonTypographyBySize {
  const _ButtonTypographyBySize._();

  static TextStyle of(WdsButtonSize size) {
    return switch (size) {
      WdsButtonSize.xlarge => WdsTypography.body15NormalBold,
      WdsButtonSize.large => WdsTypography.body15NormalBold,
      WdsButtonSize.medium => WdsTypography.body13NormalMedium,
      WdsButtonSize.small => WdsTypography.caption12NormalMedium,
      WdsButtonSize.tiny => WdsTypography.caption12NormalMedium,
    };
  }
}

class _ButtonStyleByVariant {
  const _ButtonStyleByVariant._();

  static ({
    Color background,
    Color foreground,
    double radius,
    BorderSide? border
  }) of(
    WdsButtonVariant variant,
  ) {
    return switch (variant) {
      WdsButtonVariant.cta => (
          background: WdsColors.cta,
          foreground: WdsColors.white,
          radius: WdsRadius.full,
          border: null,
        ),
      WdsButtonVariant.primary => (
          background: WdsColors.primary,
          foreground: WdsColors.white,
          radius: WdsRadius.full,
          border: null,
        ),
      WdsButtonVariant.secondary => (
          background: WdsColors.white,
          foreground: WdsColors.textNormal,
          radius: WdsRadius.full,
          border: const BorderSide(color: WdsColors.borderNeutral),
        ),
    };
  }
}

/// 디자인 시스템 규칙을 따르는 버튼
class WdsButton extends StatefulWidget {
  const WdsButton({
    required this.onTap,
    required this.child,
    this.isEnabled = true,
    this.variant = WdsButtonVariant.cta,
    this.size = WdsButtonSize.medium,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool isEnabled;
  final WdsButtonVariant variant;
  final WdsButtonSize size;
  final bool isLoading;

  @override
  State<WdsButton> createState() => _WdsButtonState();
}

class _WdsButtonState extends State<WdsButton>
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

  // Colors
  Color _overlayTargetColor() {
    // Base token overlay color for feedback
    final Color base = WdsColors.materialPressed; // semi-transparent black
    if (_isPressed || _isHovered) {
      return base;
    }
    return const Color(0x00000000);
  }

  @override
  Widget build(BuildContext context) {
    final style = _ButtonStyleByVariant.of(widget.variant);
    final double height = _ButtonHeightBySize.of(widget.size);
    final EdgeInsets padding = _ButtonPaddingBySize.of(widget.size);
    final TextStyle fixedTypography = _ButtonTypographyBySize.of(widget.size)
        .copyWith(color: style.foreground);
    final borderRadius = BorderRadius.all(Radius.circular(style.radius));

    Widget content = IconTheme(
      data: IconThemeData(color: style.foreground),
      child: Padding(
        padding: padding,
        child: widget.child,
      ),
    );

    if (widget.isLoading) {
      content = Padding(
        padding: padding + _ButtonPaddingBySize.ofLoading(widget.size),
        child: WdsCircular(
          size: switch (widget.size) {
            WdsButtonSize.xlarge => 18,
            WdsButtonSize.large => 18,
            WdsButtonSize.medium => 16,
            WdsButtonSize.small => 14,
            WdsButtonSize.tiny => 12,
          },
          color: switch (widget.variant) {
            WdsButtonVariant.secondary => WdsColors.primary,
            _ => WdsColors.white,
          },
        ),
      );
    }

    /// Text 자식일 경우 강제 타이포그래피 적용
    else if (widget.child is Text) {
      final Text childText = widget.child as Text;
      final TextStyle merged =
          childText.style?.merge(fixedTypography) ?? fixedTypography;
      content = IconTheme(
        data: IconThemeData(color: style.foreground),
        child: Padding(
          padding: padding,
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
            textScaler: childText.textScaler,
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

    // Gestures and hover (MouseRegion only on web)
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 배경 + 선택적 테두리 (컨텐츠 폭 기준)
              Positioned.fill(
                child: RepaintBoundary(
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: style.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadius,
                        side: style.border ?? BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              // 버튼 높이를 유지하되, 폭은 컨텐츠 폭에 맞춤
              SizedBox(height: height),
              // 컨텐츠 폭을 채우는 오버레이 (텍스트 아래 레이어)
              Positioned.fill(
                child: IgnorePointer(
                  child: RepaintBoundary(child: overlay),
                ),
              ),
              // 최상단 컨텐츠(텍스트/아이콘 등)
              RepaintBoundary(child: content),
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
      return Opacity(opacity: 0.4, child: result);
    }
    return result;
  }
}
