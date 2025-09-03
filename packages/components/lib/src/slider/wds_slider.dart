part of '../../wds_components.dart';

//// 슬라이더의 범위 값을 나타내는 클래스
class WdsRangeValues {
  //// 범위 값 생성자
  const WdsRangeValues({
    required this.start,
    required this.end,
  });

  //// 시작 값
  final double start;

  //// 끝 값
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

//// 특정 범위 내에서 값을 선택할 수 있는 범위 슬라이더 컴포넌트
class WdsSlider extends StatefulWidget {
  //// 슬라이더 생성자
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

  //// 최소값
  final double minValue;

  //// 최대값
  final double maxValue;

  //// 현재 선택된 범위 값
  final WdsRangeValues values;

  //// 값이 변경될 때 호출되는 콜백
  final ValueChanged<WdsRangeValues>? onChanged;

  //// 슬라이더의 구간 수 (null이면 연속값)
  final int? divisions;

  //// 제목 표시 여부
  final bool hasTitle;

  //// 활성화 상태
  final bool isEnabled;

  @override
  State<WdsSlider> createState() => _WdsSliderState();
}

class _WdsSliderState extends State<WdsSlider> {
  /// 트랙 크기
  static const double _trackHeight = 4;
  static const EdgeInsets _trackMargin = EdgeInsets.symmetric(horizontal: 8);

  /// 노브 크기
  static const double _knobSize = 20;
  static const double _knobInteractionSize = 32;
  static const double _knobBorderWidth = 2;

  /// 상호작용 상태
  bool _isDraggingStart = false;
  bool _isDraggingEnd = false;
  bool _isHoveringStart = false;
  bool _isHoveringEnd = false;

  /// 드래그 시작점 저장
  double? _dragStartX;
  double? _dragStartValue;

  /// 성능을 위한 정적 색상
  static const Color _trackColor = WdsColors.borderAlternative;
  static const Color _activeTrackColor = WdsColors.primary;
  static const Color _knobColor = WdsColors.primary;
  static const Color _knobBorderColor = WdsColors.white;
  static const Color _disabledTrackColor = WdsColors.borderAlternative;
  static const Color _disabledKnobColor = WdsColors.borderAlternative;
  static const Color _titleColor = WdsColors.textNormal;
  static const Color _disabledTitleColor = WdsColors.textDisable;
  static final Color _interactionColor =
      WdsColors.cta.withAlpha(WdsOpacity.opacity5.toAlpha());

  @override
  void didUpdateWidget(WdsSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 활성화 상태가 변경되면 상태를 업데이트
    if (oldWidget.isEnabled != widget.isEnabled) {
      setState(() {});
    }
  }

  //// 범위 값 변경 처리
  void _handleRangeChanged(WdsRangeValues newValues) {
    if (!widget.isEnabled) return;

    /// 유효한 범위로 값 제한
    final clampedStart =
        newValues.start.clamp(widget.minValue, widget.maxValue);
    final clampedEnd = newValues.end.clamp(widget.minValue, widget.maxValue);

    /// start <= end가 되도록 순서 보장 (필요시 교체)
    final orderedStart = clampedStart < clampedEnd ? clampedStart : clampedEnd;
    final orderedEnd = clampedStart < clampedEnd ? clampedEnd : clampedStart;

    WdsRangeValues adjustedValues = WdsRangeValues(
      start: orderedStart,
      end: orderedEnd,
    );

    /// 구간이 지정된 경우 적용
    if (widget.divisions == null) {
      widget.onChanged?.call(adjustedValues);
      return;
    }

    final step = (widget.maxValue - widget.minValue) / widget.divisions!;
    final finalValues = WdsRangeValues(
      start: widget.minValue +
          (((adjustedValues.start - widget.minValue) / step).round() * step),
      end: widget.minValue +
          (((adjustedValues.end - widget.minValue) / step).round() * step),
    );

    widget.onChanged?.call(finalValues);
  }

  //// 트랙 색상 반환
  Color _getTrackColor() {
    if (widget.isEnabled) return _trackColor;

    return _disabledTrackColor;
  }

  //// 활성 트랙 색상 반환
  Color _getActiveTrackColor() {
    if (widget.isEnabled) return _activeTrackColor;

    return _disabledTrackColor;
  }

  //// 노브 색상 반환
  Color _getKnobColor() {
    if (widget.isEnabled) return _knobColor;

    return _disabledKnobColor;
  }

  //// 노브 테두리 색상 반환
  Color _getKnobBorderColor() {
    return _knobBorderColor;
  }

  //// 상호작용 색상 반환
  Color? _getInteractionColor(bool isVisible) {
    if (!isVisible) return null;
    return _interactionColor;
  }

  //// 마우스 진입 처리
  void _handleMouseEnter(bool isStartKnob) {
    setState(() {
      if (isStartKnob) {
        _isHoveringStart = true;
        return;
      }

      _isHoveringEnd = true;
    });
  }

  //// 마우스 벗어남 처리
  void _handleMouseExit(bool isStartKnob) {
    setState(() {
      if (isStartKnob) {
        _isHoveringStart = false;
        return;
      }

      _isHoveringEnd = false;
    });
  }

  //// 제목 위젯 빌드
  Widget _buildTitle() {
    if (!widget.hasTitle) return const SizedBox.shrink();

    final titleColor = widget.isEnabled ? _titleColor : _disabledTitleColor;

    return Text(
      '${widget.values.start.round()} ~ ${widget.values.end.round()}',
      style: WdsTypography.heading16Bold.copyWith(color: titleColor),
    );
  }

  //// 노브 위젯 빌드
  Widget _buildKnob({
    required double position,
    required bool isDragging,
    required bool isHovering,
    required ValueChanged<DragStartDetails>? onPanStart,
    required ValueChanged<double>? onPanUpdate,
    required VoidCallback? onPanEnd,
    required bool isStartKnob,
  }) {
    final knobColor = _getKnobColor();
    final borderColor = _getKnobBorderColor();
    final interactionColor = _getInteractionColor(isDragging || isHovering);

    Widget knob = RepaintBoundary(
      child: CustomPaint(
        size: const Size(_knobSize, _knobSize),
        painter: _KnobPainter(
          knobColor: knobColor,
          borderColor: borderColor,
          borderWidth: _knobBorderWidth,
        ),
      ),
    );

    /// 상호작용 영역
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
        onPanStart:
            widget.isEnabled ? (details) => onPanStart?.call(details) : null,
        onPanUpdate: widget.isEnabled
            ? (details) => onPanUpdate?.call(details.localPosition.dx)
            : null,
        onPanEnd: widget.isEnabled ? (_) => onPanEnd?.call() : null,
        child: MouseRegion(
          onEnter:
              widget.isEnabled ? (_) => _handleMouseEnter(isStartKnob) : null,
          onExit:
              widget.isEnabled ? (_) => _handleMouseExit(isStartKnob) : null,
          child: interactionArea,
        ),
      ),
    );
  }

  //// 슬라이더 위젯 빌드
  Widget _buildSlider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth - _trackMargin.horizontal;
        final range = widget.maxValue - widget.minValue;

        final startPosition = _trackMargin.left +
            ((widget.values.start - widget.minValue) / range) * trackWidth;
        final endPosition = _trackMargin.left +
            ((widget.values.end - widget.minValue) / range) * trackWidth;

        /// 활성 트랙 위치 결정 (항상 왼쪽에서 오른쪽으로)
        final activeTrackStart =
            startPosition < endPosition ? startPosition : endPosition;
        final activeTrackWidth = (startPosition - endPosition).abs();

        return SizedBox(
          height: _knobInteractionSize,
          child: Stack(
            children: [
              /// 배경 트랙
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

              /// 활성 트랙
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

              /// 트랙 탭 영역 (가장 가까운 노브 이동) - 트랙 위, 노브 아래
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: widget.isEnabled
                      ? (details) {
                          final tapPosition = details.localPosition.dx;

                          /// 트랙 영역 내의 탭만 응답 (여백 제외)
                          if (tapPosition < _trackMargin.left ||
                              tapPosition > _trackMargin.left + trackWidth) {
                            return;
                          }

                          /// 탭 위치에 더 가까운 노브 계산
                          final distanceToStart =
                              (tapPosition - startPosition).abs();
                          final distanceToEnd =
                              (tapPosition - endPosition).abs();

                          /// 탭 위치의 새 값 계산
                          final newValue = widget.minValue +
                              ((tapPosition - _trackMargin.left) / trackWidth) *
                                  range;

                          /// 더 가까운 노브를 탭 위치로 이동
                          if (distanceToStart < distanceToEnd) {
                            _handleRangeChanged(
                              WdsRangeValues(
                                start: newValue,
                                end: widget.values.end,
                              ),
                            );
                            return;
                          }

                          if (distanceToEnd < distanceToStart) {
                            _handleRangeChanged(
                              WdsRangeValues(
                                start: widget.values.start,
                                end: newValue,
                              ),
                            );
                            return;
                          }

                          /// 같은 거리 - 더 작은 범위를 만드는 노브 선택
                          final rangeIfMoveStart =
                              (widget.values.end - newValue).abs();
                          final rangeIfMoveEnd =
                              (newValue - widget.values.start).abs();

                          if (rangeIfMoveStart <= rangeIfMoveEnd) {
                            _handleRangeChanged(
                              WdsRangeValues(
                                start: newValue,
                                end: widget.values.end,
                              ),
                            );
                          } else {
                            _handleRangeChanged(
                              WdsRangeValues(
                                start: widget.values.start,
                                end: newValue,
                              ),
                            );
                          }
                        }
                      : null,
                ),
              ),

              /// 시작 노브
              _buildKnob(
                position: startPosition,
                isDragging: _isDraggingStart,
                isHovering: _isHoveringStart,
                isStartKnob: true,
                onPanStart: (details) {
                  setState(() {
                    _isDraggingStart = true;
                    _dragStartX = details.localPosition.dx;
                    _dragStartValue = widget.values.start;
                  });
                },
                onPanUpdate: (dx) {
                  if (_dragStartX == null || _dragStartValue == null) return;

                  /// 드래그 시작점을 기준으로 한 상대적 이동량 계산
                  final deltaX = dx - _dragStartX!;
                  final deltaValue = (deltaX / trackWidth) * range;
                  final newValue = (_dragStartValue! + deltaValue)
                      .clamp(widget.minValue, widget.maxValue);

                  _handleRangeChanged(
                    WdsRangeValues(start: newValue, end: widget.values.end),
                  );
                },
                onPanEnd: () {
                  setState(() {
                    _isDraggingStart = false;
                    _dragStartX = null;
                    _dragStartValue = null;
                  });
                },
              ),

              /// 끝 노브
              _buildKnob(
                position: endPosition,
                isDragging: _isDraggingEnd,
                isHovering: _isHoveringEnd,
                isStartKnob: false,
                onPanStart: (details) {
                  setState(() {
                    _isDraggingEnd = true;
                    _dragStartX = details.localPosition.dx;
                    _dragStartValue = widget.values.end;
                  });
                },
                onPanUpdate: (dx) {
                  if (_dragStartX == null || _dragStartValue == null) return;

                  /// 드래그 시작점을 기준으로 한 상대적 이동량 계산
                  final deltaX = dx - _dragStartX!;
                  final deltaValue = (deltaX / trackWidth) * range;
                  final newValue = (_dragStartValue! + deltaValue)
                      .clamp(widget.minValue, widget.maxValue);

                  _handleRangeChanged(
                    WdsRangeValues(start: widget.values.start, end: newValue),
                  );
                },
                onPanEnd: () {
                  setState(() {
                    _isDraggingEnd = false;
                    _dragStartX = null;
                    _dragStartValue = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasTitle) {
      return _buildSlider();
    }

    return Column(
      children: [
        _buildTitle(),
        const SizedBox(height: 12),
        _buildSlider(),
      ],
    );
  }
}

//// 노브를 그리는 커스텀 페인터
class _KnobPainter extends CustomPainter {
  //// 노브 페인터 생성자
  const _KnobPainter({
    required this.knobColor,
    required this.borderColor,
    required this.borderWidth,
  });

  //// 노브 색상
  final Color knobColor;

  //// 테두리 색상
  final Color borderColor;

  //// 테두리 두께
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    /// 노브 그리기
    final knobPaint = Paint()
      ..color = knobColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, knobPaint);

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
