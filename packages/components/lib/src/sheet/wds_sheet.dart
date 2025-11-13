part of '../../wds_components.dart';

enum WdsSheetVariant {
  fixed(maxHeightRatio: 0.88),
  draggable(maxHeightRatio: 0.93);

  const WdsSheetVariant({
    required this.maxHeightRatio,
  });

  final double maxHeightRatio;
}

class _SheetPaddingByArea {
  const _SheetPaddingByArea._();

  static const EdgeInsets view = EdgeInsets.all(16);
}

class _SheetDimensions {
  const _SheetDimensions._();

  static const double handleWidth = 40;
  static const double handleHeight = 5;
  static const double handlePaddingVertical = 8.5;
}

/// 디자인 시스템 규칙을 따르는 시트
abstract class WdsSheet extends StatelessWidget {
  const WdsSheet({
    required this.variant,
    this.header,
    this.actionArea,
    super.key,
  });

  factory WdsSheet.fixed({
    required Widget content,
    Widget? header,
    Widget? actionArea,
    Key? key,
  }) =>
      _FixedSheet(
        header: header,
        content: content,
        actionArea: actionArea,
        key: key,
      );

  factory WdsSheet.draggable({
    required List<Widget> children,
    Widget? header,
    Widget? actionArea,
    Key? key,
  }) =>
      _DraggableSheet(
        header: header,
        actionArea: actionArea,
        key: key,
        children: children,
      );

  final WdsSheetVariant variant;
  final Widget? header;
  final Widget? actionArea;
}

class _FixedSheet extends WdsSheet {
  const _FixedSheet({
    required this.content,
    super.header,
    super.actionArea,
    super.key,
  }) : super(variant: WdsSheetVariant.fixed);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return __SheetContainer(
      variant: variant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null)
            RepaintBoundary(
              child: __SheetHeader(
                header: header!,
              ),
            )
          else
            const SizedBox(height: 12),
          Flexible(
            child: Padding(
              padding: _SheetPaddingByArea.view,
              child: content,
            ),
          ),
          if (actionArea != null)
            RepaintBoundary(
              child: __SheetBottom(
                actionArea: actionArea!,
              ),
            ),
        ],
      ),
    );
  }
}

class _DraggableSheet extends WdsSheet {
  const _DraggableSheet({
    required this.children,
    super.header,
    super.actionArea,
    super.key,
  }) : super(
          variant: WdsSheetVariant.draggable,
        );

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: variant.maxHeightRatio,
      maxChildSize: variant.maxHeightRatio,
      builder: (context, scrollController) {
        return __SheetContainer(
          variant: variant,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// HANDLE
              const RepaintBoundary(child: __SheetHandle()),

              /// HEADER
              if (header != null)
                RepaintBoundary(
                  child: __SheetHeader(
                    header: header!,
                  ),
                ),

              /// CONTENT
              Flexible(
                child: ListView(
                  controller: scrollController,
                  padding: _SheetPaddingByArea.view,
                  children: children,
                ),
              ),

              /// ACTION
              if (actionArea != null)
                RepaintBoundary(
                  child: __SheetBottom(
                    actionArea: actionArea!,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// 공통 시트 컨테이너 - 성능 최적화를 위한 별도 위젯
class __SheetContainer extends StatelessWidget {
  const __SheetContainer({
    required this.variant,
    required this.child,
  });

  final WdsSheetVariant variant;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight * variant.maxHeightRatio,
          minWidth: constraints.minWidth,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: WdsColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(WdsRadius.radius16),
              topRight: Radius.circular(WdsRadius.radius16),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class __SheetHandle extends StatelessWidget {
  const __SheetHandle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: _SheetDimensions.handlePaddingVertical,
      ),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: WdsColors.borderAlternative,
            borderRadius: BorderRadius.all(
              Radius.circular(WdsRadius.radius9999),
            ),
          ),
          child: SizedBox(
            width: _SheetDimensions.handleWidth,
            height: _SheetDimensions.handleHeight,
          ),
        ),
      ),
    );
  }
}

class __SheetHeader extends StatelessWidget {
  const __SheetHeader({
    required this.header,
  });

  final Widget header;

  @override
  Widget build(BuildContext context) {
    return header;
  }
}

class __SheetBottom extends StatelessWidget {
  const __SheetBottom({
    required this.actionArea,
  });

  final Widget actionArea;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: actionArea,
    );
  }
}
