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
    this.onChanged,
    this.onSubmitted,
    Key? key,
  })  : variant = WdsTextFieldVariant.outlined,
        super(key: key);

  const WdsTextField.box({
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    this.autofocus = false,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    Key? key,
  })  : variant = WdsTextFieldVariant.box,
        super(key: key);

  final WdsTextFieldVariant variant;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool isEnabled;

  final bool autofocus;

  final String? label; // outlined 전용 라벨 (상단 고정)

  final String? hintText;

  final String? helperText; // 하단 보조 텍스트 (error 미노출 시)

  final String? errorText; // 오류 메시지 (우선 노출)

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

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

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChangedInternal);
    _focusNode.addListener(_onFocusChanged);
    _precomputeStyles();
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
        ? WdsSemanticTypography.body15NormalRegular
        : WdsSemanticTypography.body13NormalRegular;

    _hintStyle = isOutlined
        ? WdsSemanticTypography.body15NormalRegular
        : WdsSemanticTypography.body13NormalRegular;

    _labelStyle = WdsSemanticTypography.body13NormalRegular;
    _helperStyle = WdsSemanticTypography.caption12Regular;
    _errorStyle = WdsSemanticTypography.caption12Regular;
  }

  void _onChangedInternal() {
    if (mounted) setState(() {});
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  bool get _hasValue => _controller.text.isNotEmpty;
  bool get _hasFocus => _focusNode.hasFocus;
  bool get _hasError => widget.errorText?.isNotEmpty == true;

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  Widget _buildHelperErrorText() {
    if (widget.errorText?.isNotEmpty == true) {
      return Text(
        widget.errorText!,
        style: _errorStyle.copyWith(color: WdsSemanticColorStatus.destructive),
      );
    }
    
    return Text(
      widget.helperText!,
      style: _helperStyle.copyWith(color: WdsSemanticColorText.alternative),
    );
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
        ? WdsSemanticColorText.normal
        : WdsSemanticColorText.alternative;
    
    final hintColor = widget.isEnabled
        ? WdsSemanticColorText.alternative
        : WdsSemanticColorText.disable;
    
    final labelColor = widget.isEnabled
        ? WdsSemanticColorText.alternative
        : WdsSemanticColorText.disable;

    final borderSide = switch ((_hasError, _hasFocus)) {
      (true, _) => const BorderSide(color: WdsSemanticColorStatus.destructive, width: 2),
      (false, true) => const BorderSide(color: WdsSemanticColorStatus.positive, width: 2),
      (false, false) => const BorderSide(color: WdsSemanticColorBorder.alternative, width: 1),
    };

    final decoration = InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
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
      constraints:
          const BoxConstraints(minWidth: 250, maxWidth: double.infinity),
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
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: (_hasFocus || _hasError) ? 0 : 1),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.isEnabled,
                  autofocus: widget.autofocus,
                  cursorColor: WdsSemanticColorText.normal,
                  cursorWidth: 2,
                  cursorRadius: const Radius.circular(WdsAtomicRadius.full),
                  style: _inputStyle.copyWith(color: inputColor),
                  maxLines: 1,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  decoration: decoration,
                ),
              ),
            ),
            // Helper/Error text
            if (widget.errorText?.isNotEmpty == true ||
                widget.helperText?.isNotEmpty == true)
              RepaintBoundary(child: _buildHelperErrorText()),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(WdsAtomicRadius.v8));
    const contentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    const noBorder = OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, width: 0),
      borderRadius: BorderRadius.all(Radius.circular(0)),
    );

    final inputColor = widget.isEnabled
        ? WdsSemanticColorText.normal
        : WdsSemanticColorText.alternative;
    
    final hintColor = widget.isEnabled
        ? WdsSemanticColorText.alternative
        : WdsSemanticColorText.disable;
    
    final borderColor = switch ((_hasError, _hasFocus)) {
      (true, _) => WdsSemanticColorStatus.destructive,
      (false, true) => WdsSemanticColorStatus.positive,
      (false, false) => WdsSemanticColorBorder.alternative,
    };

    final showClear = (_hasValue || _hasFocus) && widget.isEnabled;

    // TextField with optimized styling
    final textField = RepaintBoundary(
      child: SizedBox(
        height: 44,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: WdsSemanticColorBackgroud.normal,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: borderColor, width: 1),
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
                        cursorColor: WdsSemanticColorText.normal,
                        cursorWidth: 2,
                        cursorRadius:
                            const Radius.circular(WdsAtomicRadius.full),
                        maxLines: 1,
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
                    child: WdsIcon.circleFilledClose.build(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    return ConstrainedBox(
      constraints:
          const BoxConstraints(minWidth: 250, maxWidth: double.infinity),
      child: RepaintBoundary(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            ClipRRect(borderRadius: radius, child: textField),
            // Helper/Error text
            if (widget.errorText?.isNotEmpty == true ||
                widget.helperText?.isNotEmpty == true)
              RepaintBoundary(child: _buildHelperErrorText()),
          ],
        ),
      ),
    );
  }
}
