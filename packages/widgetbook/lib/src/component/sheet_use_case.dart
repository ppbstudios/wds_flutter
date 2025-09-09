import 'package:flutter/material.dart' as material;
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Sheet', type: WdsSheet, path: '[component]/')
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

  final variant = context.knobs.object.dropdown<WdsSheetVariant>(
    label: 'variant',
    options: [
      WdsSheetVariant.fixed,
      WdsSheetVariant.draggable,
      WdsSheetVariant.nudging,
    ],
    initialOption: WdsSheetVariant.fixed,
    labelBuilder: (value) => value.name,
  );

  final size = context.knobs.object.dropdown<String>(
    label: 'size',
    options: ['max', 'min'],
    initialOption: 'max',
    labelBuilder: (value) => value,
  );

  final title = context.knobs.string(
    label: 'title',
    initialValue: '텍스트',
    description: 'Sheet의 제목을 입력해 주세요',
  );

  final actionTitle = context.knobs.string(
    label: 'actionTitle',
    initialValue: '메인액션',
  );

  final nudgingImage = context.knobs.boolean(
    label: 'image(nudging)',
    description: 'nudging variant에서 사용할 이미지를 선택해 주세요',
    initialValue: variant == WdsSheetVariant.nudging,
  );

  return WidgetbookPlayground(
    info: [
      'Variant: ${variant.name}',
      'Size: $size',
      'Title: $title',
      'Action Title: $actionTitle',
    ],
    child: material.LayoutBuilder(
      builder: (context, constraints) {
        return material.Center(
          child: WdsButton(
            onTap: () => material.showModalBottomSheet(
              context: context,
              isScrollControlled: variant == WdsSheetVariant.draggable,
              enableDrag: variant == WdsSheetVariant.draggable,
              backgroundColor: Colors.transparent,
              builder: (context) => variant == WdsSheetVariant.draggable
                  ? DraggableScrollableSheet(
                      initialChildSize: size == 'max'
                          ? variant.maxHeightRatio
                          : variant.minHeightRatio,
                      minChildSize: 0,
                      builder: (context, scrollController) =>
                          _buildSheetContent(
                        context,
                        variant: variant,
                        size: size,
                        title: title,
                        actionTitle: actionTitle,
                        nudgingImage: nudgingImage,
                        blueColors: blueColors,
                        deviceHeight: deviceHeight,
                        scrollController: scrollController,
                      ),
                    )
                  : _buildSheetContent(
                      context,
                      variant: variant,
                      size: size,
                      title: title,
                      actionTitle: actionTitle,
                      nudgingImage: nudgingImage,
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
  required String size,
  required String title,
  required String actionTitle,
  required bool nudgingImage,
  required List<Color> blueColors,
  required double deviceHeight,
  ScrollController? scrollController,
}) {
  return switch (variant) {
    WdsSheetVariant.fixed => WdsSheet.fixed(
        onClose: () => Navigator.of(context).pop(),
        onAction: () {
          debugPrint('onAction');
          Navigator.of(context).pop();
        },
        headerTitle: title,
        content: SingleChildScrollView(
          controller: scrollController,
          child: ColoredBox(
            color: WdsColors.statusPositive.withAlpha(25),
            child: SizedBox(
              height: size == 'max'
                  ? variant.maxHeightRatio * deviceHeight
                  : variant.minHeightRatio * deviceHeight,
            ),
          ),
        ),
        actionTitle: actionTitle,
      ),
    WdsSheetVariant.draggable => WdsSheet.draggable(
        headerTitle: title,
        content: ListView.builder(
          controller: scrollController,
          itemCount: blueColors.length,
          itemExtent: 100,
          itemBuilder: (context, index) => ColoredBox(
            color: blueColors[index],
            child: const SizedBox.expand(),
          ),
        ),
      ),
    WdsSheetVariant.nudging => WdsSheet.nudging(
        onClose: () => Navigator.of(context).pop(),
        onAction: () {
          debugPrint('onAction');
          Navigator.of(context).pop();
        },
        actionTitle: actionTitle,
        image: nudgingImage
            ? Container(
                width: 128,
                height: 128,
                color: WdsColors.backgroundAlternative,
                child: WdsIcon.image.build(
                  color: WdsColors.borderAlternative,
                ),
              )
            : const SizedBox.shrink(),
        contentTitle: '여기는 제목 영역이에요\n최대 두 줄로 처리합니다',
        contentDescription: '현재 상황에 대한 추가 설명을 덧붙여 사용자에게 정보를 명확히 전달합니다.',
      ),
  };
}

Widget _buildDemonstrationSection(BuildContext context) {
  const size = Size(360, 768);

  return WidgetbookSection(
    title: 'variant',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['fixed', 'draggable', 'nudging'],
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
                content: SizedBox(
                  height: size.height * WdsSheetVariant.fixed.maxHeightRatio,
                ),
                actionTitle: '메인액션',
              ),
            ),

            /// draggable
            __SheetFrame(
              size: size,
              child: WdsSheet.draggable(
                headerTitle: '텍스트',
                content: SizedBox(
                  height:
                      size.height * WdsSheetVariant.draggable.maxHeightRatio,
                ),
              ),
            ),

            /// nudging
            __SheetFrame(
              size: size,
              child: WdsSheet.nudging(
                onClose: () {
                  debugPrint('onClose');
                },
                onAction: () {
                  debugPrint('onAction');
                },
                actionTitle: '메인액션',
                image: Container(
                  width: 128,
                  height: 128,
                  color: WdsColors.backgroundAlternative,
                  child: WdsIcon.image.build(
                    color: WdsColors.borderAlternative,
                  ),
                ),
                contentTitle: '여기는 제목 영역이에요\n최대 두 줄로 처리합니다',
                contentDescription: '현재 상황에 대한 추가 설명을 덧붙여 사용자에게 정보를 명확히 전달합니다.',
              ),
            ),
          ],
        ),
      ),

      /// Size
      WidgetbookSubsection(
        title: 'size',
        labels: ['max', 'min'],
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
                content: SizedBox(
                  height: size.height * WdsSheetVariant.fixed.maxHeightRatio,
                ),
                actionTitle: '메인액션',
              ),
            ),
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
                content: SizedBox(
                  height: size.height * WdsSheetVariant.fixed.minHeightRatio,
                ),
                actionTitle: '메인액션',
              ),
            ),

            /// draggable
            __SheetFrame(
              size: size,
              child: WdsSheet.draggable(
                headerTitle: '텍스트',
                content: SizedBox(
                  height:
                      size.height * WdsSheetVariant.draggable.maxHeightRatio,
                ),
              ),
            ),
            __SheetFrame(
              size: size,
              child: WdsSheet.draggable(
                headerTitle: '텍스트',
                content: SizedBox(
                  height:
                      size.height * WdsSheetVariant.draggable.minHeightRatio,
                ),
              ),
            ),

            /// nudging
            __SheetFrame(
              size: size,
              child: WdsSheet.nudging(
                onClose: () {
                  debugPrint('onClose');
                },
                onAction: () {
                  debugPrint('onAction');
                },
                actionTitle: '메인액션',
                image: Container(
                  width: 128,
                  height: 128,
                  color: WdsColors.backgroundAlternative,
                  child: WdsIcon.image.build(
                    color: WdsColors.borderAlternative,
                  ),
                ),
                contentTitle: '여기는 제목 영역이에요\n최대 두 줄로 처리합니다',
                contentDescription: '현재 상황에 대한 추가 설명을 덧붙여 사용자에게 정보를 명확히 전달합니다.',
              ),
            ),
            __SheetFrame(
              size: size,
              child: WdsSheet.nudging(
                onClose: () {
                  debugPrint('onClose');
                },
                onAction: () {
                  debugPrint('onAction');
                },
                actionTitle: '메인액션',
                image: const SizedBox.shrink(),
                contentTitle: '여기는 제목 영역이에요\n최대 두 줄로 처리합니다',
                contentDescription: '현재 상황에 대한 추가 설명을 덧붙여 사용자에게 정보를 명확히 전달합니다.',
              ),
            ),
          ],
        ),
      ),
    ],
  );
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
