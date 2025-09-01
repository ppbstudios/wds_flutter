part of '../../wds_components.dart';

enum WdsSwitchSize {
  small(spec: Size(39, 24), padding: EdgeInsets.all(3), knobSize: 18),
  large(spec: Size(52, 32), padding: EdgeInsets.all(4), knobSize: 24);

  const WdsSwitchSize({
    required this.spec,
    required this.padding,
    required this.knobSize,
  });

  final Size spec;

  final EdgeInsets padding;

  final double knobSize;
}

/// 디자인 시스템 규칙을 따르는 스위치
class WdsSwitch extends StatefulWidget {
  const WdsSwitch.small({
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
    super.key,
  }) : size = WdsSwitchSize.small;

  const WdsSwitch.large({
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
    super.key,
  }) : size = WdsSwitchSize.large;

  final bool value;

  final ValueChanged<bool>? onChanged;

  final bool isEnabled;

  final WdsSwitchSize size;

  @override
  State<WdsSwitch> createState() => _WdsSwitchState();
}

class _WdsSwitchState extends State<WdsSwitch> {
  static const Duration _duration = Duration(milliseconds: 200);

  void _toggle() {
    if (!widget.isEnabled) return;
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final trackColor = widget.value ? primary : WdsColorNeutral.v200;

    final knobAlign =
        widget.value ? Alignment.centerRight : Alignment.centerLeft;

    Widget knob = DecoratedBox(
      decoration: const BoxDecoration(
        color: WdsColorCommon.white,
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(
        dimension: widget.size.knobSize,
      ),
    );

    Widget track = ClipRRect(
      borderRadius: BorderRadius.circular(widget.size.spec.height / 2),
      child: ColoredBox(
        color: trackColor,
        child: Padding(
          padding: widget.size.padding,
          child: AnimatedAlign(
            duration: _duration,
            curve: Curves.easeIn,
            alignment: knobAlign,
            child: knob,
          ),
        ),
      ),
    );

    Widget result = SizedBox.fromSize(
      size: widget.size.spec,
      child: track,
    );

    result = GestureDetector(
      onTap: widget.isEnabled ? _toggle : null,
      behavior: HitTestBehavior.opaque,
      child: result,
    );

    if (!widget.isEnabled) {
      return Opacity(opacity: 0.4, child: result);
    }

    return result;
  }
}
