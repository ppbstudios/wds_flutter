part of '../../wds_components.dart';

enum WdsSearchFieldSize { small, medium }

class _SearchFieldHeightBySize {
  const _SearchFieldHeightBySize._();

  static double of(WdsSearchFieldSize size) {
    return switch (size) {
      WdsSearchFieldSize.small => 36,
      WdsSearchFieldSize.medium => 46,
    };
  }
}

class _SearchFieldPaddingBySize {
  const _SearchFieldPaddingBySize._();

  static EdgeInsets of(WdsSearchFieldSize size) {
    return switch (size) {
      WdsSearchFieldSize.small =>
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      WdsSearchFieldSize.medium =>
        const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    };
  }
}

class _SearchFieldIconBySize {
  const _SearchFieldIconBySize._();

  static WdsIcon? of(WdsSearchFieldSize size) {
    return switch (size) {
      WdsSearchFieldSize.small => null,
      WdsSearchFieldSize.medium => WdsIcon.search,
    };
  }
}

/// 검색 입력에 사용하는 SearchField
/// - 반경: WdsRadius.full
/// - 배경: WdsColors.backgroundAlternative
/// - 타이포: WdsTypography.body15NormalRegular
/// - 텍스트 색: enabled -> WdsColors.textNormal, disabled -> WdsColors.textAlternative
/// - trailing: enabled && text.isNotEmpty 일 때 clear 아이콘 버튼(텍스트와 가로 8px 간격)
class WdsSearchField extends StatefulWidget {
  const WdsSearchField({
    this.controller,
    this.hintText,
    this.enabled = true,
    this.size = WdsSearchFieldSize.small,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool enabled;
  final WdsSearchFieldSize size;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  @override
  State<WdsSearchField> createState() => _WdsSearchFieldState();
}

class _WdsSearchFieldState extends State<WdsSearchField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChangedInternal);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChangedInternal);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChangedInternal() {
    if (mounted) setState(() {});
  }

  void _clearText() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final double height = _SearchFieldHeightBySize.of(widget.size);

    final EdgeInsets fieldPadding = _SearchFieldPaddingBySize.of(widget.size);

    final WdsIcon? icon = _SearchFieldIconBySize.of(widget.size);

    const BorderRadius borderRadius = BorderRadius.all(
      Radius.circular(WdsRadius.full),
    );

    final TextStyle textStyle = WdsTypography.body15NormalRegular.copyWith(
      color: widget.enabled ? WdsColors.textNormal : WdsColors.textAlternative,
    );

    const InputBorder noBorder = OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, width: 0),
      borderRadius: BorderRadius.zero,
    );

    // 텍스트 필드: 고정 높이 24 + 상하 1px padding 가이드 준수
    final Widget textField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: LimitedBox(
        maxHeight: 22,
        child: TextSelectionTheme(
          data: TextSelectionThemeData(
            selectionHandleColor: WdsColors.primary,
            selectionColor: WdsColors.primary.withAlpha(40),
          ),
          child: TextField(
            controller: _controller,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: textStyle,
            cursorColor: WdsColors.textNormal,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: widget.hintText,
              hintStyle: WdsTypography.body15NormalRegular.copyWith(
                color: WdsColors.textAlternative,
              ),
              prefixIcon: icon?.build(
                color: WdsColors.cta,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
              border: noBorder,
              enabledBorder: noBorder,
              focusedBorder: noBorder,
              disabledBorder: noBorder,
            ),
          ),
        ),
      ),
    );

    final bool showTrailing = widget.enabled && _controller.text.isNotEmpty;

    final Widget core = DecoratedBox(
      decoration: const ShapeDecoration(
        color: WdsColors.backgroundAlternative,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      child: Padding(
        padding: fieldPadding,
        child: SizedBox(
          height: height - fieldPadding.vertical,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Expanded(child: textField),
              if (showTrailing)
                GestureDetector(
                  onTap: _clearText,
                  child: WdsIcon.circleFilledClose.build(),
                ),
            ],
          ),
        ),
      ),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 250,
          minHeight: height,
          maxHeight: height,
        ),
        child: core,
      ),
    );
  }
}
