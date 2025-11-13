part of '../../wds_components.dart';

/// 디자인 시스템 TextArea
class WdsTextArea extends StatefulWidget {
  const WdsTextArea({
    required this.label,
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    this.autofocus = false,
    this.hintText,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool isEnabled;

  final bool autofocus;

  final String label;

  /// 힌트 텍스트
  final String? hintText;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  /// 내부 검증을 위한 validator 및 자동검증 모드
  final String? Function(String value)? validator;

  final AutovalidateMode autovalidateMode;

  @override
  State<WdsTextArea> createState() => _WdsTextAreaState();
}

class _WdsTextAreaState extends State<WdsTextArea> {
  static const int _$maxLength = 2000;
  static const double _$maxHeight = 120;
  static const double _$maxContentHeight = 64;

  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  // Cache expensive computations - using non-nullable fields to avoid memory overhead
  TextStyle _inputStyle = const TextStyle();
  TextStyle _hintStyle = const TextStyle();
  TextStyle _labelStyle = const TextStyle();

  String? _internalErrorText;
  bool _userInteracted = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChangedInternal);
    _focusNode.addListener(_onFocusChanged);
    _precomputeStyles();
    // 초기 값 존재 시 즉시 검증 필요할 수 있음
    _runValidation(force: widget.autovalidateMode == AutovalidateMode.always);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChangedInternal);
    _focusNode.removeListener(_onFocusChanged);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _precomputeStyles() {
    _inputStyle = WdsTypography.body13ReadingRegular;
    _hintStyle = WdsTypography.body13ReadingRegular;
    _labelStyle = WdsTypography.body13NormalRegular;
  }

  void _onChangedInternal() {
    _userInteracted = true;
    _runValidation();
    if (mounted) setState(() {});
  }

  void _onFocusChanged() {
    // 포커스를 잃을 때 강제 검증 (disabled 모드에서도 blur 시 검증하도록)
    if (!_hasFocus) {
      _runValidation(force: true);
    }
    if (mounted) setState(() {});
  }

  bool get _hasFocus => _focusNode.hasFocus;

  void _runValidation({bool force = false}) {
    if (widget.validator == null) return;

    final shouldValidate = switch (widget.autovalidateMode) {
      AutovalidateMode.disabled => force,
      AutovalidateMode.always => true,
      AutovalidateMode.onUserInteraction => _userInteracted,
      AutovalidateMode.onUnfocus => false,
    };

    if (!shouldValidate) return;

    _internalErrorText = widget.validator!.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(WdsRadius.radius8));
    const noBorder = OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, width: 0),
      borderRadius: BorderRadius.all(Radius.circular(0)),
    );

    final labelColor = widget.isEnabled
        ? WdsColors.textNormal
        : WdsColors.textDisable;

    final inputColor = widget.isEnabled
        ? WdsColors.textNormal
        : WdsColors.textDisable;

    final hintColor = !widget.isEnabled
        ? WdsColors.textDisable
        : WdsColors.textAlternative;

    final filledColor = widget.isEnabled
        ? WdsColors.backgroundNormal
        : WdsColors.neutral50;

    final borderColor = switch (_hasFocus) {
      true => WdsColors.statusPositive,
      false => WdsColors.borderAlternative,
    };

    final area = RepaintBoundary(
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: filledColor,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: borderColor),
          ),
        ),
        child: SizedBox(
          height: _$maxHeight,
          child: Stack(
            children: [
              Positioned(
                left: 16,
                top: 5,
                right: 3,
                bottom: 31,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.isEnabled,
                  autofocus: widget.autofocus,
                  cursorColor: WdsColors.textNormal,
                  cursorRadius: const Radius.circular(WdsRadius.radius9999),
                  scrollPadding: const EdgeInsets.all(3),
                  textAlignVertical: TextAlignVertical.top,
                  style: _inputStyle.copyWith(color: inputColor),
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  maxLengthEnforcement:
                      MaxLengthEnforcement.truncateAfterCompositionEnds,
                  maxLines: null,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(_$maxLength),
                  ],
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.only(
                      top: 8,
                      bottom: 12,
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: _$maxContentHeight,
                      minHeight: _$maxContentHeight,
                    ),
                    hintText: widget.hintText,
                    hintStyle: _hintStyle.copyWith(color: hintColor),
                    border: noBorder,
                    enabledBorder: noBorder,
                    focusedBorder: noBorder,
                    disabledBorder: noBorder,
                    // filled: filledColor != null,
                    // fillColor: filledColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 250,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          RepaintBoundary(
            child: Text(
              widget.label,
              style: _labelStyle.copyWith(color: labelColor),
            ),
          ),
          ClipRRect(borderRadius: radius, child: area),
          // COUNTER
          Align(
            alignment: Alignment.centerRight,
            child: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, value, __) {
                if (value.text.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Text(
                  '${value.text.length.toFormat()}/${_$maxLength.toFormat()}',
                  style: WdsTypography.body13NormalRegular.copyWith(
                    color: widget.isEnabled
                        ? WdsColors.textAssistive
                        : WdsColors.textDisable,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
