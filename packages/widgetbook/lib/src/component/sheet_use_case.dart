import 'package:flutter/material.dart' as material;
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

const List<Color> blueColors = [
  WdsColors.blue50,
  WdsColors.blue100,
  WdsColors.blue200,
  WdsColors.blue300,
  WdsColors.blue400,
  WdsColors.blue500,
  WdsColors.blue600,
  WdsColors.blue700,
  WdsColors.blue800,
  WdsColors.blue900,
];

@UseCase(
  name: 'Sheet',
  type: Sheet,
  path: '[component]/',
)
Widget buildWdsSheetUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Sheet',
    description: '사용자가 화면에서 다른 작업을 진행하기 전에 반드시 확인하여야 하는 대화 상자입니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  const deviceHeight = 768.0;

  final variant = context.knobs.object.dropdown<WdsSheetVariant>(
    label: 'variant',
    options: WdsSheetVariant.values,
    initialOption: WdsSheetVariant.fixed,
    labelBuilder: (value) => value.name,
  );

  final title = context.knobs.string(
    label: 'title',
    initialValue: '텍스트',
    description: 'Sheet의 제목을 입력해 주세요',
  );

  final actionTitle = context.knobs.stringOrNull(
    label: 'actionTitle',
    initialValue: '메인액션',
  );

  return WidgetbookPlayground(
    info: [
      'Variant: ${variant.name}',
      'Title: $title',
      'Action Title: $actionTitle',
    ],
    child: material.LayoutBuilder(
      builder: (context, constraints) {
        return material.Center(
          child: WdsButton(
            onTap: () => material.showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              enableDrag: variant == WdsSheetVariant.draggable,
              backgroundColor: Colors.transparent,
              builder: (context) => _buildSheetContent(
                context,
                variant: variant,
                title: title,
                actionTitle: actionTitle,
                blueColors: blueColors,
                deviceHeight: deviceHeight,
              ),
            ),
            size: WdsButtonSize.large,
            child: const Text('Sheet 열기'),
          ),
        );
      },
    ),
  );
}

Widget _buildSheetContent(
  BuildContext context, {
  required WdsSheetVariant variant,
  required String title,
  required String? actionTitle,
  required List<Color> blueColors,
  required double deviceHeight,
}) {
  return switch (variant) {
    WdsSheetVariant.fixed => WdsSheet.fixed(
        onClose: () => Navigator.of(context).pop(),
        onAction: actionTitle != null
            ? () {
                debugPrint('onAction');
                Navigator.of(context).pop();
              }
            : null,
        headerTitle: title,
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildBlueColors(),
          ),
        ),
        actionTitle: actionTitle,
      ),
    WdsSheetVariant.draggable => WdsSheet.draggable(
        onAction: actionTitle != null
            ? () {
                debugPrint('onAction');
                Navigator.of(context).pop();
              }
            : null,
        actionTitle: actionTitle,
        headerTitle: title,
        children: _buildBlueColors(),
      ),
  };
}

Widget _buildDemonstrationSection(BuildContext context) {
  const size = Size(360, 768);

  return WidgetbookSection(
    title: 'Sheet',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['fixed', 'draggable'],
        content: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            /// fixed
            __SheetFrame(
              size: size,
              child: WdsSheet.fixed(
                onClose: () {
                  debugPrint('onClose');
                },
                onAction: () {
                  debugPrint('onAction');
                },
                headerTitle: '텍스트',
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildBlueColors(),
                  ),
                ),
                actionTitle: '메인액션',
              ),
            ),

            /// draggable
            __SheetFrame(
              size: size,
              child: WdsSheet.draggable(
                onAction: () {
                  debugPrint('onAction');
                },
                actionTitle: '메인액션',
                headerTitle: '텍스트',
                children: _buildBlueColors(),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

List<Widget> _buildBlueColors() {
  return blueColors
      .map(
        (color) => ColoredBox(
          color: color,
          child: const SizedBox(height: 100),
        ),
      )
      .toList();
}

class __SheetFrame extends material.StatelessWidget {
  const __SheetFrame({
    required this.size,
    required this.child,
  });

  final Size size;

  final Widget child;

  @override
  material.Widget build(material.BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: WdsColors.borderNeutral,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            /// DIMMED
            const ColoredBox(
              color: WdsColors.materialDimmer,
              child: SizedBox.expand(),
            ),

            /// SHEET
            Align(
              alignment: Alignment.bottomCenter,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
