part of '../../wds_components.dart';

enum WdsTextFieldVariant { outlined, box }

/// 디자인 시스템 TextField (outlined, box)
class WdsTextField extends StatefulWidget {
  const WdsTextField.outlined({
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    this.autofocus = false,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onSubmitted,
    super.key,
  }) : variant = WdsTextFieldVariant.outlined;

  const WdsTextField.box({
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    this.autofocus = false,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onSubmitted,
    super.key,
  }) : variant = WdsTextFieldVariant.box;

  final WdsTextFieldVariant variant;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool isEnabled;

  final bool autofocus;

  /// outlined 전용 라벨 (상단 고정)
  final String? label;

  /// 힌트 텍스트
  final String? hintText;

  /// 하단 보조 텍스트 (error 미노출 시)
  final String? helperText;

  /// 오류 메시지 (우선 노출)
  final String? errorText;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  /// 내부 검증을 위한 validator 및 자동검증 모드
  final String? Function(String value)? validator;

  final AutovalidateMode autovalidateMode;

  @override
  State<WdsTextField> createState() => _WdsTextFieldState();
}

class _WdsTextFieldState extends State<WdsTextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  // Cache expensive computations - using non-nullable fields to avoid memory overhead
  TextStyle _inputStyle = const TextStyle();
  TextStyle _hintStyle = const TextStyle();
  TextStyle _labelStyle = const TextStyle();
  TextStyle _helperStyle = const TextStyle();
  TextStyle _errorStyle = const TextStyle();

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
    final isOutlined = widget.variant == WdsTextFieldVariant.outlined;

    _inputStyle = isOutlined
        ? WdsTypography.body15NormalRegular
        : WdsTypography.body13NormalRegular;

    _hintStyle = isOutlined
        ? WdsTypography.body15NormalRegular
        : WdsTypography.body13NormalRegular;

    _labelStyle = WdsTypography.body13NormalRegular;
    _helperStyle = WdsTypography.caption12NormalRegular;
    _errorStyle = WdsTypography.caption12NormalRegular;
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

  bool get _hasValue => _controller.text.isNotEmpty;
  bool get _hasFocus => _focusNode.hasFocus;
  String? get _effectiveErrorText => widget.errorText?.isNotEmpty == true
      ? widget.errorText
      : _internalErrorText;
  bool get _hasError => _effectiveErrorText?.isNotEmpty == true;

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

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  Widget _buildHelperErrorText() {
    final hasError = _effectiveErrorText?.isNotEmpty == true;
    final hasHelper = widget.helperText?.isNotEmpty == true;

    if (hasError) {
      return Text(
        _effectiveErrorText!,
        style: _errorStyle.copyWith(color: WdsColors.statusDestructive),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    if (hasHelper) {
      return Text(
        widget.helperText!,
        style: _helperStyle.copyWith(color: WdsColors.textAlternative),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.variant) {
      WdsTextFieldVariant.outlined => _buildOutlined(context),
      WdsTextFieldVariant.box => _buildBox(context),
    };
  }

  Widget _buildOutlined(BuildContext context) {
    final inputColor = widget.isEnabled
        ? WdsColors.textNormal
        : WdsColors.textAlternative;

    final hintColor = widget.isEnabled
        ? WdsColors.textAlternative
        : WdsColors.textDisable;

    final labelColor = widget.isEnabled
        ? WdsColors.textAlternative
        : WdsColors.textDisable;

    final borderSide = switch ((_hasError, _hasFocus)) {
      (true, _) => const BorderSide(
        color: WdsColors.statusDestructive,
        width: 2,
      ),
      (false, true) => const BorderSide(
        color: WdsColors.statusPositive,
        width: 2,
      ),
      (false, false) => const BorderSide(color: WdsColors.borderAlternative),
    };

    final decoration = InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 7),
      hintText: widget.hintText,
      hintStyle: _hintStyle.copyWith(color: hintColor),
      border: UnderlineInputBorder(borderSide: borderSide),
      enabledBorder: UnderlineInputBorder(borderSide: borderSide),
      focusedBorder: UnderlineInputBorder(borderSide: borderSide),
      disabledBorder: UnderlineInputBorder(borderSide: borderSide),
      errorBorder: UnderlineInputBorder(borderSide: borderSide),
      focusedErrorBorder: UnderlineInputBorder(borderSide: borderSide),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 250),
      child: RepaintBoundary(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            // Label
            if (widget.label?.isNotEmpty == true)
              RepaintBoundary(
                child: Text(
                  widget.label!,
                  style: _labelStyle.copyWith(color: labelColor),
                ),
              ),
            // TextField with height stabilization
            RepaintBoundary(
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  selectionHandleColor: WdsColors.primary,
                  selectionColor: WdsColors.primary.withAlpha(40),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.isEnabled,
                  autofocus: widget.autofocus,
                  cursorColor: WdsColors.textNormal,
                  cursorRadius: const Radius.circular(WdsRadius.radius9999),
                  style: _inputStyle.copyWith(color: inputColor),
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  decoration: decoration,
                ),
              ),
            ),
            // Helper/Error text
            if (_hasError || widget.helperText?.isNotEmpty == true)
              RepaintBoundary(child: _buildHelperErrorText()),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(WdsRadius.radius8));
    const contentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    const noBorder = OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, width: 0),
      borderRadius: BorderRadius.all(Radius.circular(0)),
    );

    final inputColor = widget.isEnabled
        ? WdsColors.textNormal
        : WdsColors.textAlternative;

    final hintColor = !widget.isEnabled
        ? WdsColors.textDisable
        : WdsColors.textAlternative;

    final borderColor = switch ((_hasError, _hasFocus)) {
      (true, _) => WdsColors.statusDestructive,
      (false, true) => WdsColors.statusPositive,
      (false, false) => WdsColors.borderAlternative,
    };

    final showClear = (_hasValue || _hasFocus) && widget.isEnabled;

    // TextField with optimized styling
    final textField = RepaintBoundary(
      child: SizedBox(
        height: 44,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: WdsColors.backgroundNormal,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: borderColor),
            ),
          ),
          child: Padding(
            padding: contentPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: LimitedBox(
                      maxHeight: 22,
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: widget.isEnabled,
                        autofocus: widget.autofocus,
                        cursorColor: WdsColors.textNormal,
                        cursorRadius: const Radius.circular(
                          WdsRadius.radius9999,
                        ),
                        style: _inputStyle.copyWith(color: inputColor),
                        onChanged: widget.onChanged,
                        onSubmitted: widget.onSubmitted,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: widget.hintText,
                          hintStyle: _hintStyle.copyWith(color: hintColor),
                          border: noBorder,
                          enabledBorder: noBorder,
                          focusedBorder: noBorder,
                          disabledBorder: noBorder,
                        ),
                      ),
                    ),
                  ),
                ),
                if (showClear)
                  GestureDetector(
                    onTap: _clear,
                    child: WdsIcon.circleCloseFilled.build(
                      color: WdsColors.neutral200,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 250),
      child: RepaintBoundary(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            ClipRRect(borderRadius: radius, child: textField),
            // Helper/Error text
            if (_hasError || widget.helperText?.isNotEmpty == true)
              RepaintBoundary(child: _buildHelperErrorText()),
          ],
        ),
      ),
    );
  }
}
