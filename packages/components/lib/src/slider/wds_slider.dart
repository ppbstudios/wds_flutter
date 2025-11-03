part of '../../wds_components.dart';

/// 슬라이더의 범위 값을 나타내는 클래스
class WdsRangeValues {
  /// 범위 값 생성자
  const WdsRangeValues({
    required this.start,
    required this.end,
  });

  /// 시작 값
  final double start;

  /// 끝 값
  final double end;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WdsRangeValues && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'WdsRangeValues(start: $start, end: $end)';
}

/// 특정 범위 내에서 값을 선택할 수 있는 범위 슬라이더 컴포넌트
class WdsSlider extends StatefulWidget {
  /// 슬라이더 생성자
  const WdsSlider({
    required this.minValue,
    required this.maxValue,
    required this.values,
    required this.divisions,
    required this.onChanged,
    this.hasTitle = false,
    this.isEnabled = true,
    super.key,
  });

  /// 최소값
  final double minValue;

  /// 최대값
  final double maxValue;

  /// 현재 선택된 범위 값
  final WdsRangeValues values;

  /// 값이 변경될 때 호출되는 콜백
  final ValueChanged<WdsRangeValues>? onChanged;

  /// 슬라이더의 구간 수
  final int divisions;

  /// 제목 표시 여부
  final bool hasTitle;

  /// 활성화 상태
  final bool isEnabled;

  @override
  State<WdsSlider> createState() => _WdsSliderState();
}

class _WdsSliderState extends State<WdsSlider> {
  /// 성능을 위한 정적 색상
  static const Color _trackColor = WdsColors.borderAlternative;
  static const Color _activeTrackColor = WdsColors.primary;
  static const Color _knobColor = WdsColors.primary;
  static const Color _knobBorderColor = WdsColors.white;
  static const Color _disabledTrackColor = WdsColors.borderAlternative;
  static const Color _disabledKnobColor = WdsColors.borderAlternative;

  /// 상호작용 상태
  bool _isDraggingStart = false;
  bool _isDraggingEnd = false;
  bool _isHoveringStart = false;
  bool _isHoveringEnd = false;

  /// 드래그 시작점 저장
  double? _dragStartX;
  double? _dragStartValue;

  /// 최소 범위 계산
  double _getMinRange() {
    return (widget.maxValue - widget.minValue) / widget.divisions;
  }

  /// 범위 값 변경 처리
  void _handleRangeChanged(WdsRangeValues newValues) {
    if (!widget.isEnabled) return;

    final clampedStart = newValues.start.clamp(
      widget.minValue,
      widget.maxValue,
    );
    final clampedEnd = newValues.end.clamp(
      widget.minValue,
      widget.maxValue,
    );

    final orderedStart = clampedStart < clampedEnd ? clampedStart : clampedEnd;
    final orderedEnd = clampedStart < clampedEnd ? clampedEnd : clampedStart;

    WdsRangeValues adjustedValues = WdsRangeValues(
      start: orderedStart,
      end: orderedEnd,
    );

    final step = (widget.maxValue - widget.minValue) / widget.divisions;
    final finalValues = WdsRangeValues(
      start:
          widget.minValue +
          (((adjustedValues.start - widget.minValue) / step).round() * step),
      end:
          widget.minValue +
          (((adjustedValues.end - widget.minValue) / step).round() * step),
    );

    final minRange = step;
    final actualRange = finalValues.end - finalValues.start;

    if (actualRange < minRange) {
      final center = (finalValues.start + finalValues.end) / 2;
      final halfMinRange = minRange / 2;

      final adjustedStart = (center - halfMinRange).clamp(
        widget.minValue,
        widget.maxValue - minRange,
      );
      final adjustedEnd = (center + halfMinRange).clamp(
        widget.minValue + minRange,
        widget.maxValue,
      );

      widget.onChanged?.call(
        WdsRangeValues(
          start: adjustedStart,
          end: adjustedEnd,
        ),
      );
      return;
    }

    widget.onChanged?.call(finalValues);
  }

  Color _getTrackColor() {
    if (!widget.isEnabled) return _disabledTrackColor;
    return _trackColor;
  }

  Color _getActiveTrackColor() {
    if (!widget.isEnabled) return _disabledTrackColor;
    return _activeTrackColor;
  }

  Color _getKnobColor() {
    if (!widget.isEnabled) return _disabledKnobColor;
    return _knobColor;
  }

  void _handleMouseEnter(bool isStartKnob) {
    setState(() {
      if (isStartKnob) {
        _isHoveringStart = true;
        return;
      }
      _isHoveringEnd = true;
    });
  }

  void _handleMouseExit(bool isStartKnob) {
    setState(() {
      if (isStartKnob) {
        _isHoveringStart = false;
        return;
      }
      _isHoveringEnd = false;
    });
  }

  @override
  void didUpdateWidget(WdsSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 활성화 상태가 변경되면 상태를 업데이트
    if (oldWidget.isEnabled != widget.isEnabled) {
      setState(() {});
    }
  }

  void _handleStartPanStart(DragStartDetails details) {
    setState(() {
      _isDraggingStart = true;
      _dragStartX = details.localPosition.dx;
      _dragStartValue = widget.values.start;
    });
  }

  void _handleStartPanUpdate(double dx, double trackWidth, double range) {
    if (_dragStartX == null || _dragStartValue == null) return;

    final deltaX = dx - _dragStartX!;
    final deltaValue = (deltaX / trackWidth) * range;
    final newValue = (_dragStartValue! + deltaValue).clamp(
      widget.minValue,
      widget.maxValue,
    );

    final minRange = _getMinRange();
    final maxStartValue = widget.values.end - minRange;
    final clampedNewValue = newValue.clamp(widget.minValue, maxStartValue);

    _handleRangeChanged(
      WdsRangeValues(
        start: clampedNewValue,
        end: widget.values.end,
      ),
    );
  }

  void _handleStartPanEnd() {
    setState(() {
      _isDraggingStart = false;
      _dragStartX = null;
      _dragStartValue = null;
    });
  }

  void _handleEndPanStart(DragStartDetails details) {
    setState(() {
      _isDraggingEnd = true;
      _dragStartX = details.localPosition.dx;
      _dragStartValue = widget.values.end;
    });
  }

  void _handleEndPanUpdate(double dx, double trackWidth, double range) {
    if (_dragStartX == null || _dragStartValue == null) return;

    final deltaX = dx - _dragStartX!;
    final deltaValue = (deltaX / trackWidth) * range;
    final newValue = (_dragStartValue! + deltaValue).clamp(
      widget.minValue,
      widget.maxValue,
    );

    final minRange = _getMinRange();
    final minEndValue = widget.values.start + minRange;
    final clampedNewValue = newValue.clamp(minEndValue, widget.maxValue);

    _handleRangeChanged(
      WdsRangeValues(
        start: widget.values.start,
        end: clampedNewValue,
      ),
    );
  }

  void _handleEndPanEnd() {
    setState(() {
      _isDraggingEnd = false;
      _dragStartX = null;
      _dragStartValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sliderTrack = _WdsSliderTrack(
      minValue: widget.minValue,
      maxValue: widget.maxValue,
      values: widget.values,
      divisions: widget.divisions,
      isEnabled: widget.isEnabled,
      trackColor: _getTrackColor(),
      activeTrackColor: _getActiveTrackColor(),
      knobColor: _getKnobColor(),
      knobBorderColor: _knobBorderColor,
      isDraggingStart: _isDraggingStart,
      isDraggingEnd: _isDraggingEnd,
      isHoveringStart: _isHoveringStart,
      isHoveringEnd: _isHoveringEnd,
      onMouseEnterStart: () => _handleMouseEnter(true),
      onMouseExitStart: () => _handleMouseExit(true),
      onMouseEnterEnd: () => _handleMouseEnter(false),
      onMouseExitEnd: () => _handleMouseExit(false),
      onPanStartStart: _handleStartPanStart,
      onPanUpdateStart: _handleStartPanUpdate,
      onPanEndStart: _handleStartPanEnd,
      onPanStartEnd: _handleEndPanStart,
      onPanUpdateEnd: _handleEndPanUpdate,
      onPanEndEnd: _handleEndPanEnd,
      onTrackTap: _handleRangeChanged,
    );

    if (!widget.hasTitle) return sliderTrack;

    return Column(
      spacing: 12,
      children: [
        _Title(
          isEnabled: widget.isEnabled,
          start: widget.values.start,
          end: widget.values.end,
        ),
        sliderTrack,
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.isEnabled,
    required this.start,
    required this.end,
  });

  static const Color _titleColor = WdsColors.textNormal;
  static const Color _disabledTitleColor = WdsColors.textDisable;

  final bool isEnabled;

  final double start;

  final double end;

  @override
  Widget build(BuildContext context) {
    final titleColor = isEnabled ? _titleColor : _disabledTitleColor;

    return Text(
      '${start.round()} ~ ${end.round()}',
      style: WdsTypography.heading16Bold.copyWith(color: titleColor),
    );
  }
}

/// 노브를 그리는 커스텀 페인터
class _KnobPainter extends CustomPainter {
  /// 노브 페인터 생성자
  const _KnobPainter({
    required this.knobColor,
    required this.borderColor,
    required this.borderWidth,
  });

  /// 노브 색상
  final Color knobColor;

  /// 테두리 색상
  final Color borderColor;

  /// 테두리 두께
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    /// 노브 그리기
    final knobPaint = Paint()
      ..color = knobColor
      ..style = PaintingStyle.fill;

    /// border 바깥으로 배경색상이 보이지 않도록 0.25px 씩 축소
    canvas.drawCircle(center, radius - 0.25, knobPaint);

    /// 테두리 그리기
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

class _WdsSliderTrack extends StatelessWidget {
  const _WdsSliderTrack({
    required this.minValue,
    required this.maxValue,
    required this.values,
    required this.divisions,
    required this.isEnabled,
    required this.trackColor,
    required this.activeTrackColor,
    required this.knobColor,
    required this.knobBorderColor,
    required this.isDraggingStart,
    required this.isDraggingEnd,
    required this.isHoveringStart,
    required this.isHoveringEnd,
    required this.onMouseEnterStart,
    required this.onMouseExitStart,
    required this.onMouseEnterEnd,
    required this.onMouseExitEnd,
    required this.onPanStartStart,
    required this.onPanUpdateStart,
    required this.onPanEndStart,
    required this.onPanStartEnd,
    required this.onPanUpdateEnd,
    required this.onPanEndEnd,
    required this.onTrackTap,
  });

  static const double _trackHeight = 4;
  static const EdgeInsets _trackMargin = EdgeInsets.symmetric(horizontal: 8);
  static const double _knobInteractionSize = 32;
  static final Color _interactionColor = WdsColors.cta.withAlpha(
    WdsOpacity.opacity5.toAlpha(),
  );

  final double minValue;
  final double maxValue;
  final WdsRangeValues values;
  final int divisions;
  final bool isEnabled;
  final Color trackColor;
  final Color activeTrackColor;
  final Color knobColor;
  final Color knobBorderColor;
  final bool isDraggingStart;
  final bool isDraggingEnd;
  final bool isHoveringStart;
  final bool isHoveringEnd;
  final VoidCallback onMouseEnterStart;
  final VoidCallback onMouseExitStart;
  final VoidCallback onMouseEnterEnd;
  final VoidCallback onMouseExitEnd;
  final ValueChanged<DragStartDetails> onPanStartStart;
  final void Function(double dx, double trackWidth, double range)
  onPanUpdateStart;
  final VoidCallback onPanEndStart;
  final ValueChanged<DragStartDetails> onPanStartEnd;
  final void Function(double dx, double trackWidth, double range)
  onPanUpdateEnd;
  final VoidCallback onPanEndEnd;
  final ValueChanged<WdsRangeValues> onTrackTap;

  double _valueToPosition(double value, double trackWidth, double range) {
    return _trackMargin.left + ((value - minValue) / range) * trackWidth;
  }

  double _positionToValue(double position, double trackWidth, double range) {
    return minValue + ((position - _trackMargin.left) / trackWidth) * range;
  }

  double _getMinRange() {
    return (maxValue - minValue) / divisions;
  }

  bool _isPositionInTrack(double position, double trackWidth) {
    return position >= _trackMargin.left &&
        position <= _trackMargin.left + trackWidth;
  }

  Color? _getInteractionColor(bool isVisible) {
    if (!isVisible) return null;
    return _interactionColor;
  }

  void _handleTrackTap(
    TapDownDetails details,
    double trackWidth,
    double range,
  ) {
    if (!isEnabled) return;

    final tapPosition = details.localPosition.dx;

    if (!_isPositionInTrack(tapPosition, trackWidth)) return;

    final startPosition = _valueToPosition(values.start, trackWidth, range);
    final endPosition = _valueToPosition(values.end, trackWidth, range);

    final distanceToStart = (tapPosition - startPosition).abs();
    final distanceToEnd = (tapPosition - endPosition).abs();

    final newValue = _positionToValue(tapPosition, trackWidth, range);

    if (distanceToStart < distanceToEnd) {
      final minRange = _getMinRange();
      final maxStartValue = values.end - minRange;
      final clampedNewValue = newValue.clamp(minValue, maxStartValue);

      onTrackTap(WdsRangeValues(start: clampedNewValue, end: values.end));
      return;
    }

    if (distanceToEnd < distanceToStart) {
      final minRange = _getMinRange();
      final minEndValue = values.start + minRange;
      final clampedNewValue = newValue.clamp(minEndValue, maxValue);

      onTrackTap(WdsRangeValues(start: values.start, end: clampedNewValue));
      return;
    }

    final rangeIfMoveStart = (values.end - newValue).abs();
    final rangeIfMoveEnd = (newValue - values.start).abs();

    if (rangeIfMoveStart <= rangeIfMoveEnd) {
      final minRange = _getMinRange();
      final maxStartValue = values.end - minRange;
      final clampedNewValue = newValue.clamp(minValue, maxStartValue);

      onTrackTap(WdsRangeValues(start: clampedNewValue, end: values.end));
    } else {
      final minRange = _getMinRange();
      final minEndValue = values.start + minRange;
      final clampedNewValue = newValue.clamp(minEndValue, maxValue);

      onTrackTap(WdsRangeValues(start: values.start, end: clampedNewValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth - _trackMargin.horizontal;
        final range = maxValue - minValue;

        final startPosition = _valueToPosition(values.start, trackWidth, range);
        final endPosition = _valueToPosition(values.end, trackWidth, range);

        final activeTrackStart = startPosition < endPosition
            ? startPosition
            : endPosition;
        final activeTrackWidth = (startPosition - endPosition).abs();

        return SizedBox(
          height: _knobInteractionSize,
          child: Stack(
            children: [
              Positioned(
                left: _trackMargin.left,
                right: _trackMargin.right,
                top: (_knobInteractionSize - _trackHeight) / 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(_trackHeight / 2),
                  ),
                  child: const SizedBox(
                    height: _trackHeight,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned(
                left: activeTrackStart,
                width: activeTrackWidth,
                top: (_knobInteractionSize - _trackHeight) / 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: activeTrackColor,
                    borderRadius: BorderRadius.circular(_trackHeight / 2),
                  ),
                  child: const SizedBox(height: _trackHeight),
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: isEnabled
                      ? (details) => _handleTrackTap(details, trackWidth, range)
                      : null,
                ),
              ),
              _WdsKnob(
                position: startPosition,
                isDragging: isDraggingStart,
                isHovering: isHoveringStart,
                isStartKnob: true,
                isEnabled: isEnabled,
                knobColor: knobColor,
                borderColor: knobBorderColor,
                interactionColor: _getInteractionColor(
                  isDraggingStart || isHoveringStart,
                ),
                onMouseEnter: onMouseEnterStart,
                onMouseExit: onMouseExitStart,
                onPanStart: onPanStartStart,
                onPanUpdate: (dx) => onPanUpdateStart(dx, trackWidth, range),
                onPanEnd: onPanEndStart,
              ),
              _WdsKnob(
                position: endPosition,
                isDragging: isDraggingEnd,
                isHovering: isHoveringEnd,
                isStartKnob: false,
                isEnabled: isEnabled,
                knobColor: knobColor,
                borderColor: knobBorderColor,
                interactionColor: _getInteractionColor(
                  isDraggingEnd || isHoveringEnd,
                ),
                onMouseEnter: onMouseEnterEnd,
                onMouseExit: onMouseExitEnd,
                onPanStart: onPanStartEnd,
                onPanUpdate: (dx) => onPanUpdateEnd(dx, trackWidth, range),
                onPanEnd: onPanEndEnd,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WdsKnob extends StatelessWidget {
  const _WdsKnob({
    required this.position,
    required this.isDragging,
    required this.isHovering,
    required this.isStartKnob,
    required this.isEnabled,
    required this.knobColor,
    required this.borderColor,
    required this.interactionColor,
    required this.onMouseEnter,
    required this.onMouseExit,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  static const double _knobSize = 20;
  static const double _knobInteractionSize = 32;
  static const double _knobBorderWidth = 2;

  final double position;
  final bool isDragging;
  final bool isHovering;
  final bool isStartKnob;
  final bool isEnabled;
  final Color knobColor;
  final Color borderColor;
  final Color? interactionColor;
  final VoidCallback onMouseEnter;
  final VoidCallback onMouseExit;
  final ValueChanged<DragStartDetails> onPanStart;
  final ValueChanged<double> onPanUpdate;
  final VoidCallback onPanEnd;

  @override
  Widget build(BuildContext context) {
    final knob = RepaintBoundary(
      child: CustomPaint(
        size: const Size(_knobSize, _knobSize),
        painter: _KnobPainter(
          knobColor: knobColor,
          borderColor: borderColor,
          borderWidth: _knobBorderWidth,
        ),
      ),
    );

    final interactionArea = SizedBox(
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
        onPanStart: isEnabled ? onPanStart : null,
        onPanUpdate: isEnabled
            ? (details) => onPanUpdate(details.localPosition.dx)
            : null,
        onPanEnd: isEnabled ? (_) => onPanEnd() : null,
        child: MouseRegion(
          onEnter: isEnabled ? (_) => onMouseEnter() : null,
          onExit: isEnabled ? (_) => onMouseExit() : null,
          child: interactionArea,
        ),
      ),
    );
  }
}
