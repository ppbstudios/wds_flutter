import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'SegmentedControl',
  type: WdsSegmentedControl,
  path: '[component]/',
)
Widget buildWdsSegmentedControlUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'SegmentedControl',
    description: '상품 상세 페이지에서 렌즈 종류(예: 하루용, 한달용) 와 같이 옵션을 구분할 때 사용됩니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

class _SegmentedControlPlayground extends StatefulWidget {
  const _SegmentedControlPlayground();

  @override
  State<_SegmentedControlPlayground> createState() =>
      _SegmentedControlPlaygroundState();
}

class _SegmentedControlPlaygroundState
    extends State<_SegmentedControlPlayground> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isEnabled = context.knobs.boolean(
      label: 'isEnabled',
      initialValue: true,
      description: 'SegmentedControl 활성화 여부를 설정해요',
    );

    final segmentedControl = WdsSegmentedControl(
      segments: [
        '하루용',
        '한달용',
      ],
      selectedIndex: _selectedIndex,
      onChanged: (index) => setState(() => _selectedIndex = index),
      isEnabled: isEnabled,
    );

    return WidgetbookPlayground(
      info: [
        'selectedIndex: $_selectedIndex',
        'isEnabled: $isEnabled',
      ],
      child: SizedBox(
        width: 108,
        child: segmentedControl,
      ),
    );
  }
}

Widget _buildPlaygroundSection(BuildContext context) {
  return const _SegmentedControlPlayground();
}

class _InteractiveSegmentedControl extends StatefulWidget {
  const _InteractiveSegmentedControl({
    required this.segments,
    required this.initialIndex,
    required this.label,
  });

  final List<String> segments;
  final int initialIndex;
  final String label;

  @override
  State<_InteractiveSegmentedControl> createState() =>
      _InteractiveSegmentedControlState();
}

class _InteractiveSegmentedControlState
    extends State<_InteractiveSegmentedControl> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      child: WdsSegmentedControl(
        segments: widget.segments,
        selectedIndex: _selectedIndex,
        onChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
          debugPrint('${widget.label} selected: $index');
        },
      ),
    );
  }
}

class _DisabledSegmentedControl extends StatelessWidget {
  const _DisabledSegmentedControl({
    required this.segments,
    required this.selectedIndex,
    required this.label,
  });

  final List<String> segments;
  final int selectedIndex;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      child: WdsSegmentedControl(
        segments: segments,
        selectedIndex: selectedIndex,
        onChanged: (index) {
          debugPrint('$label disabled - should not be called: $index');
        },
        isEnabled: false,
      ),
    );
  }
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'SegmentedControl',
    spacing: 32,
    children: [
      WidgetbookSubsection(
        title: 'state',
        labels: ['enabled', 'disabled'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            _InteractiveSegmentedControl(
              segments: [
                '하루용',
                '한달용',
              ],
              initialIndex: 0,
              label: 'Enabled',
            ),
            _DisabledSegmentedControl(
              segments: [
                '하루용',
                '한달용',
              ],
              selectedIndex: 1,
              label: 'Disabled',
            ),
          ],
        ),
      ),
    ],
  );
}
