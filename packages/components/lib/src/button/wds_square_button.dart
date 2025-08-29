part of '../../wds_components.dart';

/// 고정 규격과 스타일을 갖는 사각형 버튼 (SquareButton)
class WdsSquareButton extends StatefulWidget {
  const WdsSquareButton({
    required this.onTap,
    required this.child,
    this.isEnabled = true,
    Key? key,
  }) : super(key: key);

  /// 버튼 탭 콜백 (비활성 시 무시)
  final VoidCallback? onTap;

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
    final Color base = WdsSemanticColorMaterial.pressed;
    if (_isPressed || _isHovered) return base;
    return const Color(0x00000000);
  }

  @override
  Widget build(BuildContext context) {
    // 문서 명세 (docs/wds_component_guide.md):
    // size: Size(double.infinity, 32)
    // typography: WdsSemanticTypography.caption12Medium
    // padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8)
    // state: enabled/disabled 동일 배경/테두리, disabled 는 opacity 로 표현
    const double height = 32;
    const EdgeInsets padding = EdgeInsets.fromLTRB(17, 8, 17, 8);
    final TextStyle typography = WdsSemanticTypography.caption12Medium.copyWith(
      color: WdsSemanticColorText.neutral,
    );
    final BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(WdsAtomicRadius.v4));

    // 자식이 Text 인 경우 강제 타이포그래피 적용, 그 외에는 DefaultTextStyle.merge
    Widget content = Padding(padding: padding, child: widget.child);
    if (widget.child is Text) {
      final Text childText = widget.child as Text;
      final TextStyle? merged =
          childText.style?.merge(typography) ?? typography;
      content = Padding(
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
          maxLines: 1,
          semanticsLabel: childText.semanticsLabel,
          textWidthBasis: childText.textWidthBasis,
          textHeightBehavior: childText.textHeightBehavior,
          selectionColor: childText.selectionColor,
        ),
      );
    } else {
      content = DefaultTextStyle.merge(style: typography, child: content);
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
                  // 배경 + 테두리 (컨텐츠 폭 기준)
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: WdsColorCommon.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: borderRadius,
                            side: const BorderSide(
                              color: WdsSemanticColorBorder.alternative,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 높이 유지, 폭은 컨텐츠 폭 기준
                  const SizedBox(height: height),
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
