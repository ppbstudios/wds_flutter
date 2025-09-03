part of '../../wds_components.dart';

class WdsRangeValues {
  const WdsRangeValues({
    required this.start,
    required this.end,
  });

  final double start;

  final double end;

  @override
  bool operator ==(Object other) {
    return other is WdsRangeValues && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'WdsRangeValues(start: $start, end: $end)';
}

/// Range slider component for selecting values within a specific range
class WdsSlider extends StatefulWidget {
  const WdsSlider({
    required this.minValue,
    required this.maxValue,
    required this.values,
    required this.onChanged,
    this.divisions,
    this.hasTitle = false,
    this.isEnabled = true,
    super.key,
  });

  final double minValue;

  final double maxValue;

  final WdsRangeValues values;

  final ValueChanged<WdsRangeValues>? onChanged;

  final int? divisions;

  final bool hasTitle;

  final bool isEnabled;

  @override
  State<WdsSlider> createState() => _WdsSliderState();
}

class _WdsSliderState extends State<WdsSlider> {
  // Track dimensions
  static const double _trackHeight = 4;
  static const EdgeInsets _trackMargin = EdgeInsets.symmetric(horizontal: 8);

  // Knob dimensions
  static const double _knobSize = 20;
  static const double _knobInteractionSize = 32;
  static const double _knobBorderWidth = 2;

  bool _isDraggingStart = false;
  bool _isDraggingEnd = false;
  bool _isHoveringStart = false;
  bool _isHoveringEnd = false;

  void _handleRangeChanged(WdsRangeValues newValues) {
    if (!widget.isEnabled) return;

    // Clamp values to valid range
    final clampedStart = newValues.start.clamp(widget.minValue, widget.maxValue);
    final clampedEnd = newValues.end.clamp(widget.minValue, widget.maxValue);
    
    // Ensure start <= end (swap if necessary)
    final orderedStart = clampedStart < clampedEnd ? clampedStart : clampedEnd;
    final orderedEnd = clampedStart < clampedEnd ? clampedEnd : clampedStart;
    
    WdsRangeValues adjustedValues = WdsRangeValues(
      start: orderedStart,
      end: orderedEnd,
    );

    // Apply divisions if specified
    if (widget.divisions != null) {
      final step = (widget.maxValue - widget.minValue) / widget.divisions!;
      adjustedValues = WdsRangeValues(
        start: widget.minValue +
            (((adjustedValues.start - widget.minValue) / step).round() * step),
        end: widget.minValue +
            (((adjustedValues.end - widget.minValue) / step).round() * step),
      );
    }

    widget.onChanged?.call(adjustedValues);
  }

  Color _getTrackColor() {
    if (!widget.isEnabled) {
      return WdsColors.borderAlternative;
    }
    return WdsColors.borderAlternative;
  }

  Color _getActiveTrackColor() {
    if (!widget.isEnabled) {
      return WdsColors.borderAlternative;
    }
    return WdsColors.primary;
  }

  Color _getKnobColor() {
    if (!widget.isEnabled) {
      return WdsColors.borderAlternative;
    }
    return WdsColors.primary;
  }

  Color _getKnobBorderColor() {
    return WdsColors.white;
  }

  Color? _getInteractionColor(bool isVisible) {
    if (!isVisible) return null;
    return WdsColors.cta.withAlpha(WdsOpacity.opacity5.toAlpha());
  }

  Widget _buildTitle() {
    if (!widget.hasTitle) return const SizedBox.shrink();

    final titleColor =
        widget.isEnabled ? WdsColors.textNormal : WdsColors.textDisable;

    return Text(
      '${widget.values.start.round()} ~ ${widget.values.end.round()}',
      style: WdsTypography.heading16Bold.copyWith(color: titleColor),
    );
  }

  Widget _buildKnob({
    required double position,
    required bool isDragging,
    required bool isHovering,
    required VoidCallback? onPanStart,
    required ValueChanged<double>? onPanUpdate,
    required VoidCallback? onPanEnd,
  }) {
    final knobColor = _getKnobColor();
    final borderColor = _getKnobBorderColor();
    final interactionColor = _getInteractionColor(isDragging || isHovering);

    Widget knob = CustomPaint(
      size: const Size(_knobSize, _knobSize),
      painter: _KnobPainter(
        knobColor: knobColor,
        borderColor: borderColor,
        borderWidth: _knobBorderWidth,
      ),
    );

    // Interaction area
    Widget interactionArea = SizedBox(
      width: _knobInteractionSize,
      height: _knobInteractionSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (interactionColor != null)
            DecoratedBox(
              decoration: BoxDecoration(
                color: interactionColor,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(
                width: _knobInteractionSize,
                height: _knobInteractionSize,
              ),
            ),
          knob,
        ],
      ),
    );

    return Positioned(
      left: position - (_knobInteractionSize / 2),
      top: 0,
      child: GestureDetector(
        onPanStart: widget.isEnabled ? (_) => onPanStart?.call() : null,
        onPanUpdate: widget.isEnabled
            ? (details) => onPanUpdate?.call(details.localPosition.dx)
            : null,
        onPanEnd: widget.isEnabled ? (_) => onPanEnd?.call() : null,
        child: MouseRegion(
          onEnter: widget.isEnabled
              ? (_) {
                  setState(() {
                    if (onPanStart == () => _isDraggingStart = true) {
                      _isHoveringStart = true;
                    } else {
                      _isHoveringEnd = true;
                    }
                  });
                }
              : null,
          onExit: widget.isEnabled
              ? (_) {
                  setState(() {
                    _isHoveringStart = false;
                    _isHoveringEnd = false;
                  });
                }
              : null,
          child: interactionArea,
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth - _trackMargin.horizontal;
        final range = widget.maxValue - widget.minValue;

        final startPosition = _trackMargin.left +
            ((widget.values.start - widget.minValue) / range) * trackWidth;
        final endPosition = _trackMargin.left +
            ((widget.values.end - widget.minValue) / range) * trackWidth;

        // Determine active track position (always from left to right)
        final activeTrackStart = startPosition < endPosition ? startPosition : endPosition;
        final activeTrackWidth = (startPosition - endPosition).abs();

        return SizedBox(
          height: _knobInteractionSize,
          child: Stack(
            children: [
              // Background track
              Positioned(
                left: _trackMargin.left,
                right: _trackMargin.right,
                top: (_knobInteractionSize - _trackHeight) / 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _getTrackColor(),
                    borderRadius: BorderRadius.circular(_trackHeight / 2),
                  ),
                  child: const SizedBox(
                    height: _trackHeight,
                    width: double.infinity,
                  ),
                ),
              ),

              // Active track
              Positioned(
                left: activeTrackStart,
                width: activeTrackWidth,
                top: (_knobInteractionSize - _trackHeight) / 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _getActiveTrackColor(),
                    borderRadius: BorderRadius.circular(_trackHeight / 2),
                  ),
                  child: const SizedBox(
                    height: _trackHeight,
                  ),
                ),
              ),

              // Tap area for track (to move nearest knob) - above tracks, below knobs
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: widget.isEnabled ? (details) {
                    final tapPosition = details.localPosition.dx;
                    
                    // Only respond to taps within the track area (excluding margins)
                    if (tapPosition < _trackMargin.left || 
                        tapPosition > _trackMargin.left + trackWidth) {
                      return;
                    }
                    
                    // Calculate which knob is closer to the tap position
                    final distanceToStart = (tapPosition - startPosition).abs();
                    final distanceToEnd = (tapPosition - endPosition).abs();
                    
                    // Calculate the new value for the tap position
                    final newValue = widget.minValue +
                        ((tapPosition - _trackMargin.left) / trackWidth) * range;
                    
                    // Move the closer knob to the tap position
                    // In case of equal distance, prefer the knob that would create a smaller range
                    if (distanceToStart < distanceToEnd) {
                      _handleRangeChanged(
                        WdsRangeValues(start: newValue, end: widget.values.end),
                      );
                    } else if (distanceToEnd < distanceToStart) {
                      _handleRangeChanged(
                        WdsRangeValues(start: widget.values.start, end: newValue),
                      );
                    } else {
                      // Equal distance - choose based on which would create smaller range
                      final rangeIfMoveStart = (widget.values.end - newValue).abs();
                      final rangeIfMoveEnd = (newValue - widget.values.start).abs();
                      
                      if (rangeIfMoveStart <= rangeIfMoveEnd) {
                        _handleRangeChanged(
                          WdsRangeValues(start: newValue, end: widget.values.end),
                        );
                      } else {
                        _handleRangeChanged(
                          WdsRangeValues(start: widget.values.start, end: newValue),
                        );
                      }
                    }
                  } : null,
                ),
              ),

              // Start knob
              _buildKnob(
                position: startPosition,
                isDragging: _isDraggingStart,
                isHovering: _isHoveringStart,
                onPanStart: () => setState(() => _isDraggingStart = true),
                onPanUpdate: (dx) {
                  final newPosition =
                      startPosition + dx - (_knobInteractionSize / 2);
                  final clampedPosition = newPosition.clamp(
                    _trackMargin.left,
                    _trackMargin.left + trackWidth,
                  );
                  final newValue = widget.minValue +
                      ((clampedPosition - _trackMargin.left) / trackWidth) *
                          range;
                  _handleRangeChanged(
                    WdsRangeValues(start: newValue, end: widget.values.end),
                  );
                },
                onPanEnd: () => setState(() => _isDraggingStart = false),
              ),

              // End knob
              _buildKnob(
                position: endPosition,
                isDragging: _isDraggingEnd,
                isHovering: _isHoveringEnd,
                onPanStart: () => setState(() => _isDraggingEnd = true),
                onPanUpdate: (dx) {
                  final newPosition =
                      endPosition + dx - (_knobInteractionSize / 2);
                  final clampedPosition = newPosition.clamp(
                    _trackMargin.left,
                    _trackMargin.left + trackWidth,
                  );
                  final newValue = widget.minValue +
                      ((clampedPosition - _trackMargin.left) / trackWidth) *
                          range;
                  _handleRangeChanged(
                    WdsRangeValues(start: widget.values.start, end: newValue),
                  );
                },
                onPanEnd: () => setState(() => _isDraggingEnd = false),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasTitle) {
      return Column(
        children: [
          _buildTitle(),
          const SizedBox(height: 12),
          _buildSlider(),
        ],
      );
    }

    return _buildSlider();
  }
}

class _KnobPainter extends CustomPainter {
  const _KnobPainter({
    required this.knobColor,
    required this.borderColor,
    required this.borderWidth,
  });

  final Color knobColor;
  final Color borderColor;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw knob
    final knobPaint = Paint()
      ..color = knobColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, knobPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(center, radius - borderWidth / 2, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _KnobPainter oldDelegate) {
    return knobColor != oldDelegate.knobColor ||
        borderColor != oldDelegate.borderColor ||
        borderWidth != oldDelegate.borderWidth;
  }
}
