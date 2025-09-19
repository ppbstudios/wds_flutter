part of '../../wds_components.dart';

enum WdsSquareButtonVariant { normal, step }

/// 고정 규격과 스타일을 갖는 사각형 버튼 (SquareButton)
class WdsSquareButton extends StatefulWidget {
  const WdsSquareButton.normal({
    required this.child,
    required this.onTap,
    this.isEnabled = true,
    super.key,
  })  : variant = WdsSquareButtonVariant.normal,
        leadingButton = null,
        trailingButton = null;

  const WdsSquareButton.step({
    required this.child,
    required this.leadingButton,
    required this.trailingButton,
    this.isEnabled = true,
    super.key,
  })  : variant = WdsSquareButtonVariant.step,
        onTap = null;

  final WdsSquareButtonVariant variant;

  final VoidCallback? onTap;

  /// step variant의 왼쪽 버튼 (WdsIconButton)
  final Widget? leadingButton;

  /// step variant의 오른쪽 버튼 (WdsIconButton)
  final Widget? trailingButton;

  /// 라벨 위젯 (일반적으로 Text)
  final Widget child;

  /// 활성/비활성 상태
  final bool isEnabled;

  @override
  State<WdsSquareButton> createState() => _WdsSquareButtonState();
}

class _WdsSquareButtonState extends State<WdsSquareButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  static const Duration _hoverAnimationDuration = Duration(milliseconds: 150);

  // Interaction handlers (WdsButton 과 동일 메커니즘)
  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    if (!mounted) return;
    if (!_isPressed) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) return;
    if (!mounted) return;
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) return;
    if (!mounted) return;
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  Color _overlayTargetColor() {
    // hover/pressed 를 동일한 오버레이로 처리
    final Color base = WdsColors.materialPressed;
    if (_isPressed || _isHovered) return base;
    return const Color(0x00000000);
  }

  @override
  Widget build(BuildContext context) {
    const double height = 32;

    final BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(WdsRadius.radius4));

    // variant에 따라 content만 다르게 생성
    final Widget content = _buildContent();

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
      onTap: widget.isEnabled
          ? switch (widget.variant) {
              WdsSquareButtonVariant.normal => widget.onTap,
              WdsSquareButtonVariant.step => null,
            }
          : null,
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
                  // 배경 + 테두리 (컨텐츠 폭 기준)
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: WdsColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: borderRadius,
                            side: const BorderSide(
                              color: WdsColors.borderAlternative,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 높이 유지, 폭은 컨텐츠 폭 기준
                  const SizedBox(height: height),
                  // 오버레이 (컨텐츠 폭 기준)
                  if (widget.onTap != null)
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

  Widget _buildContent() {
    final TextStyle typography = WdsTypography.caption12NormalMedium.copyWith(
      color: WdsColors.textNormal,
    );

    // 자식이 Text 인 경우 강제 타이포그래피 적용, 그 외에는 DefaultTextStyle.merge
    Widget content = widget.child;
    if (widget.child is Text) {
      final Text childText = widget.child as Text;
      final TextStyle merged = childText.style?.merge(typography) ?? typography;
      content = Text(
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
        maxLines: 1,
        semanticsLabel: childText.semanticsLabel,
        textWidthBasis: childText.textWidthBasis,
        textHeightBehavior: childText.textHeightBehavior,
        selectionColor: childText.selectionColor,
      );
    } else {
      content = DefaultTextStyle.merge(style: typography, child: content);
    }

    return switch (widget.variant) {
      WdsSquareButtonVariant.normal => () {
          const EdgeInsets padding = EdgeInsets.fromLTRB(17, 8, 17, 8);

          return Padding(
            padding: padding,
            child: content,
          );
        }(),
      WdsSquareButtonVariant.step => () {
          const EdgeInsets padding = EdgeInsets.fromLTRB(16, 8, 16, 8);

          return Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                widget.leadingButton!,
                content,
                widget.trailingButton!,
              ],
            ),
          );
        }(),
    };
  }
}
