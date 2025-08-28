part of '../../wds_components.dart';

enum WdsTextFieldVariant { outlined, box }

/// 디자인 시스템 TextField (outlined, box)
class WdsTextField extends StatefulWidget {
  const WdsTextField.outlined({
    this.controller,
    this.focusNode,
    this.enabled = true,
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
    this.enabled = true,
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
  final bool enabled;
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

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChangedInternal);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChangedInternal);
    _focusNode.removeListener(_onFocusChanged);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onChangedInternal() => setState(() {});
  void _onFocusChanged() => setState(() {});

  bool get _hasValue => _controller.text.isNotEmpty;
  bool get _hasFocus => _focusNode.hasFocus;
  bool get _hasError =>
      (widget.errorText != null && widget.errorText!.isNotEmpty);

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case WdsTextFieldVariant.outlined:
        return _buildOutlined(context);
      case WdsTextFieldVariant.box:
        return _buildBox(context);
    }
  }

  Widget _buildOutlined(BuildContext context) {
    final String? label = widget.label;

    // Underline 색/굵기
    final BorderSide enabledSide = BorderSide(
      color: WdsSemanticColorBorder.alternative,
      width: 1,
    );
    final BorderSide focusedSide = BorderSide(
      color: _hasError
          ? WdsSemanticColorStatus.destructive
          : WdsSemanticColorStatus.positive,
      width: 2,
    );
    final BorderSide disabledSide = BorderSide(
      color: WdsSemanticColorBorder.alternative,
      width: 1,
    );
    final BorderSide errorSide = BorderSide(
      color: WdsSemanticColorStatus.destructive,
      width: 2,
    );

    final TextStyle inputStyle =
        WdsSemanticTypography.body15NormalRegular.copyWith(
      color: widget.enabled
          ? WdsSemanticColorText.normal
          : WdsSemanticColorText.alternative,
    );
    // hint 색: enabled -> alternative, disabled -> disable, 기타(포커스/값/에러) -> normal
    final bool _otherState = _hasFocus || _hasValue || _hasError;
    final TextStyle hintStyle =
        WdsSemanticTypography.body15NormalRegular.copyWith(
      color: !widget.enabled
          ? WdsSemanticColorText.disable
          : (_otherState
              ? WdsSemanticColorText.normal
              : WdsSemanticColorText.alternative),
    );

    final InputDecoration decoration = InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
      hintText: widget.hintText,
      hintStyle: hintStyle,
      border: const UnderlineInputBorder(borderSide: BorderSide(width: 1)),
      enabledBorder: UnderlineInputBorder(borderSide: enabledSide),
      focusedBorder: UnderlineInputBorder(borderSide: focusedSide),
      disabledBorder: UnderlineInputBorder(borderSide: disabledSide),
      errorBorder: UnderlineInputBorder(borderSide: errorSide),
      focusedErrorBorder: UnderlineInputBorder(borderSide: errorSide),
    );

    final List<Widget> column = [];
    if (label != null && label.isNotEmpty) {
      column.add(
        Text(
          label,
          style: WdsSemanticTypography.body13NormalRegular.copyWith(
            color: widget.enabled
                ? WdsSemanticColorText.alternative
                : WdsSemanticColorText.disable,
          ),
        ),
      );
      column.add(const SizedBox(height: 6));
    }

    column.add(
      // 포커스 시 underline 두께(2px)로 인해 전체 높이가 커 보이는 점을 방지하기 위해
      // 비포커스 상태일 때만 바닥 패딩 1px을 추가해 총 높이를 동일하게 유지합니다.
      Padding(
        padding: EdgeInsets.only(bottom: (_hasFocus || _hasError) ? 0 : 1),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          style: inputStyle,
          maxLines: 1,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          decoration: decoration,
        ),
      ),
    );

    // helper / error
    final String? error = widget.errorText;
    final String? helper = widget.helperText;
    if ((error != null && error.isNotEmpty) ||
        (helper != null && helper.isNotEmpty)) {
      column.add(const SizedBox(height: 6));
      if (error != null && error.isNotEmpty) {
        column.add(
          Text(
            error,
            style: WdsSemanticTypography.caption12Regular.copyWith(
              color: WdsSemanticColorStatus.destructive,
            ),
          ),
        );
      } else if (helper != null && helper.isNotEmpty) {
        column.add(
          Text(
            helper,
            style: WdsSemanticTypography.caption12Regular.copyWith(
              color: WdsSemanticColorText.alternative,
            ),
          ),
        );
      }
    }

    return ConstrainedBox(
      constraints:
          const BoxConstraints(minWidth: 250, maxWidth: double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: column,
      ),
    );
  }

  Widget _buildBox(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(WdsAtomicRadius.v8);
    final EdgeInsets contentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10);

    // 상태별 보더 색
    Color borderColor = WdsSemanticColorBorder.alternative;
    if (_hasError) {
      borderColor = WdsSemanticColorStatus.destructive;
    } else if (_hasFocus) {
      borderColor = WdsSemanticColorStatus.positive;
    }

    final TextStyle inputStyle =
        WdsSemanticTypography.body13NormalRegular.copyWith(
      color: widget.enabled
          ? WdsSemanticColorText.normal
          : WdsSemanticColorText.alternative,
    );

    // hint: enabled/disabled -> alternative, 나머지 -> normal
    final bool otherState = _hasFocus || _hasValue || _hasError;
    final TextStyle hintStyle =
        WdsSemanticTypography.body13NormalRegular.copyWith(
      color: !widget.enabled
          ? WdsSemanticColorText.alternative
          : (otherState
              ? WdsSemanticColorText.normal
              : WdsSemanticColorText.alternative),
    );

    final InputBorder noBorder = const OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, width: 0),
      borderRadius: BorderRadius.all(Radius.circular(0)),
    );

    final bool showClear = (_hasValue || _hasFocus) && widget.enabled;

    final Widget field = Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: LimitedBox(
        maxHeight: 22,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          maxLines: 1,
          style: inputStyle,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: widget.hintText,
            hintStyle: hintStyle,
            border: noBorder,
            enabledBorder: noBorder,
            focusedBorder: noBorder,
            disabledBorder: noBorder,
          ),
        ),
      ),
    );

    final Row row = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Expanded(child: field),
        if (showClear)
          GestureDetector(
            onTap: _clear,
            child: WdsIcon.circleFilledClose.build(),
          ),
      ],
    );

    final Widget core = DecoratedBox(
      decoration: ShapeDecoration(
        color: WdsSemanticColorBackgroud.normal,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Padding(
        padding: contentPadding,
        child: row,
      ),
    );

    // helper / error
    final List<Widget> column = [
      ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: 44, // 22(Text) + 2(padding) + 20(content padding) = 44
          child: core,
        ),
      ),
    ];
    final String? error = widget.errorText;
    final String? helper = widget.helperText;
    if ((error != null && error.isNotEmpty) ||
        (helper != null && helper.isNotEmpty)) {
      column.add(const SizedBox(height: 8));
      if (error != null && error.isNotEmpty) {
        column.add(
          Text(
            error,
            style: WdsSemanticTypography.caption12Regular.copyWith(
              color: WdsSemanticColorStatus.destructive,
            ),
          ),
        );
      } else if (helper != null && helper.isNotEmpty) {
        column.add(
          Text(
            helper,
            style: WdsSemanticTypography.caption12Regular.copyWith(
              color: WdsSemanticColorText.alternative,
            ),
          ),
        );
      }
    }

    return ConstrainedBox(
      constraints:
          const BoxConstraints(minWidth: 250, maxWidth: double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: column,
      ),
    );
  }
}
