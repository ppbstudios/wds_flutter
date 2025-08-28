part of '../../wds_components.dart';

/// 검색 입력에 사용하는 SearchField
/// - 높이: 고정 36
/// - 반경: WdsAtomicRadius.full
/// - 배경: WdsSemanticColorBackgroud.alternative
/// - 패딩: EdgeInsets.symmetric(horizontal: 12, vertical: 6)
/// - 타이포: WdsSemanticTypography.body15NormalRegular
/// - 텍스트 색: enabled -> WdsSemanticColorText.normal, disabled -> WdsSemanticColorText.alternative
/// - trailing: enabled && text.isNotEmpty 일 때 clear 아이콘 버튼(텍스트와 가로 8px 간격)
class WdsSearchField extends StatefulWidget {
  const WdsSearchField({
    this.controller,
    this.hintText,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? hintText;
  final bool enabled;
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
    const double height = 36;

    const EdgeInsets fieldPadding = EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    );

    const BorderRadius borderRadius = BorderRadius.all(
      Radius.circular(WdsAtomicRadius.full),
    );

    final TextStyle textStyle =
        WdsSemanticTypography.body15NormalRegular.copyWith(
      color: widget.enabled
          ? WdsSemanticColorText.normal
          : WdsSemanticColorText.alternative,
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
        child: TextField(
          controller: _controller,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          maxLines: 1,
          style: textStyle,
          cursorColor: WdsSemanticColorText.normal,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: widget.hintText,
            hintStyle: WdsSemanticTypography.body15NormalRegular.copyWith(
              color: WdsSemanticColorText.alternative,
            ),
            border: noBorder,
            enabledBorder: noBorder,
            focusedBorder: noBorder,
            disabledBorder: noBorder,
          ),
        ),
      ),
    );

    final bool showTrailing = widget.enabled && _controller.text.isNotEmpty;

    final Widget core = DecoratedBox(
      decoration: ShapeDecoration(
        color: WdsSemanticColorBackgroud.alternative,
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
        constraints: const BoxConstraints(
          minWidth: 250,
          maxWidth: double.infinity,
          minHeight: 36,
          maxHeight: 36,
        ),
        child: core,
      ),
    );
  }
}
