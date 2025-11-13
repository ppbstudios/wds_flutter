import 'package:flutter/material.dart' as material;
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

enum _ActionAreaOption {
  none('없음'),
  normal('normal'),
  filter('filter'),
  division('division');

  const _ActionAreaOption(this.displayName);
  final String displayName;

  WdsActionAreaVariant? get variant => switch (this) {
        _ActionAreaOption.none => null,
        _ActionAreaOption.normal => WdsActionAreaVariant.normal,
        _ActionAreaOption.filter => WdsActionAreaVariant.filter,
        _ActionAreaOption.division => WdsActionAreaVariant.division,
      };
}

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

  final actionAreaOption = context.knobs.object.dropdown<_ActionAreaOption>(
    label: 'actionArea',
    description: 'ActionArea 외에도 다양한 위젯이 추가될 수 있어요',
    options: _ActionAreaOption.values,
    initialOption: _ActionAreaOption.normal,
    labelBuilder: (value) => value.displayName,
  );

  return WidgetbookPlayground(
    info: [
      'Variant: ${variant.name}',
      'Title: $title',
      'Action Area: ${actionAreaOption.displayName}',
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
                actionAreaOption: actionAreaOption,
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
  required _ActionAreaOption actionAreaOption,
  required List<Color> blueColors,
  required double deviceHeight,
}) {
  return switch (variant) {
    WdsSheetVariant.fixed => WdsSheet.fixed(
        header: _buildHeader(context, title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildBlueColors(),
          ),
        ),
        actionArea: actionAreaOption.variant != null
            ? _buildActionArea(
                context,
                actionAreaVariant: actionAreaOption.variant!,
              )
            : null,
      ),
    WdsSheetVariant.draggable => WdsSheet.draggable(
        header: _buildHeader(context, title),
        actionArea: actionAreaOption.variant != null
            ? _buildActionArea(
                context,
                actionAreaVariant: actionAreaOption.variant!,
              )
            : null,
        children: _buildBlueColors(),
      ),
  };
}

Widget _buildHeader(BuildContext context, String title) {
  return SizedBox(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox.square(dimension: 24),
          Flexible(
            child: Text(
              title,
              style: WdsTypography.heading17Bold.copyWith(
                color: WdsColors.textNormal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox.square(
            dimension: 24,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Semantics(
                label: 'Close sheet',
                button: true,
                child: WdsIcon.close.build(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
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
                header: _buildDemoHeader(context, '텍스트'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildBlueColors(),
                  ),
                ),
                actionArea: WdsActionArea.normal(
                  primary: WdsButton(
                    onTap: () {
                      debugPrint('onAction');
                    },
                    size: WdsButtonSize.xlarge,
                    child: const Text('메인액션'),
                  ),
                ),
              ),
            ),

            /// draggable
            __SheetFrame(
              size: size,
              child: WdsSheet.draggable(
                header: _buildDemoHeader(context, '텍스트'),
                actionArea: WdsActionArea.normal(
                  primary: WdsButton(
                    onTap: () {
                      debugPrint('onAction');
                    },
                    size: WdsButtonSize.xlarge,
                    child: const Text('메인액션'),
                  ),
                ),
                children: _buildBlueColors(),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildDemoHeader(BuildContext context, String title) {
  return SizedBox(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox.square(dimension: 24),
          Flexible(
            child: Text(
              title,
              style: WdsTypography.heading17Bold.copyWith(
                color: WdsColors.textNormal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox.square(
            dimension: 24,
            child: GestureDetector(
              onTap: () {
                debugPrint('onClose');
              },
              child: Semantics(
                label: 'Close sheet',
                button: true,
                child: WdsIcon.close.build(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildActionArea(
  BuildContext context, {
  required WdsActionAreaVariant actionAreaVariant,
}) {
  final primaryButton = WdsButton(
    onTap: () {
      debugPrint('Primary action');
      Navigator.of(context).pop();
    },
    size: WdsButtonSize.xlarge,
    child: const Text('메인 액션'),
  );

  final secondaryButton = WdsButton(
    onTap: () {
      debugPrint('Secondary action');
      Navigator.of(context).pop();
    },
    variant: WdsButtonVariant.secondary,
    size: WdsButtonSize.xlarge,
    child: const Text('취소'),
  );

  return switch (actionAreaVariant) {
    WdsActionAreaVariant.normal => WdsActionArea.normal(
        primary: primaryButton,
      ),
    WdsActionAreaVariant.filter => WdsActionArea.filter(
        secondary: secondaryButton,
        primary: primaryButton,
      ),
    WdsActionAreaVariant.division => WdsActionArea.division(
        secondary: secondaryButton,
        primary: primaryButton,
      ),
  };
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
