part of '../../wds_components.dart';

enum WdsSheetVariant {
  fixed(
    initialHeightRatio: 0.5,
    maxHeightRatio: 0.88,
  ),
  draggable(
    initialHeightRatio: 0.65,
    maxHeightRatio: 0.93,
  )
  ;

  const WdsSheetVariant({
    required this.initialHeightRatio,
    required this.maxHeightRatio,
  });

  final double initialHeightRatio;

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

  static const BorderRadius topBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(WdsRadius.radius16),
    topRight: Radius.circular(WdsRadius.radius16),
  );
}

/// 디자인 시스템 규칙을 따르는 시트
abstract class WdsSheet extends StatelessWidget {
  const WdsSheet({
    required this.variant,
    this.backgroundColor = WdsColors.white,
    this.header,
    this.actionArea,
    this.contentPadding = _SheetPaddingByArea.view,
    this.semanticLabel,
    super.key,
  });

  factory WdsSheet.fixed({
    required Widget content,
    Widget? header,
    Widget? actionArea,
    Color backgroundColor = WdsColors.white,
    EdgeInsetsGeometry contentPadding = _SheetPaddingByArea.view,
    String? semanticLabel,
    Key? key,
  }) => _FixedSheet(
    backgroundColor: backgroundColor,
    header: header,
    content: content,
    actionArea: actionArea,
    contentPadding: contentPadding,
    semanticLabel: semanticLabel,
    key: key,
  );

  factory WdsSheet.draggable({
    required List<Widget> children,
    Widget? header,
    Widget? actionArea,
    Color backgroundColor = WdsColors.white,
    EdgeInsetsGeometry contentPadding = _SheetPaddingByArea.view,
    String? semanticLabel,
    Key? key,
  }) => _DraggableSheet(
    backgroundColor: backgroundColor,
    header: header,
    actionArea: actionArea,
    contentPadding: contentPadding,
    semanticLabel: semanticLabel,
    key: key,
    children: children,
  );

  final WdsSheetVariant variant;
  final Color backgroundColor;
  final Widget? header;
  final Widget? actionArea;

  /// 콘텐츠 영역 여백
  ///
  /// 기본값은 WDS Sheet Contents 와 같은 `EdgeInsets.all(16)`.
  /// Figma 인스턴스에서 Contents 패딩을 바꾼 화면만 지정한다.
  final EdgeInsetsGeometry contentPadding;

  final String? semanticLabel;
}

class _FixedSheet extends WdsSheet {
  const _FixedSheet({
    required this.content,
    super.backgroundColor = WdsColors.white,
    super.header,
    super.actionArea,
    super.contentPadding,
    super.semanticLabel,
    super.key,
  }) : super(variant: WdsSheetVariant.fixed);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: __SheetContainer(
        variant: variant,
        backgroundColor: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null)
              RepaintBoundary(
                child: __SheetHeader(
                  header: header!,
                ),
              ),
            Padding(
              padding: contentPadding,
              child: content,
            ),
            if (actionArea != null)
              RepaintBoundary(
                child: __SheetBottom(
                  actionArea: actionArea!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DraggableSheet extends WdsSheet {
  const _DraggableSheet({
    required this.children,
    super.backgroundColor = WdsColors.white,
    super.header,
    super.actionArea,
    super.contentPadding,
    super.semanticLabel,
    super.key,
  }) : super(
         variant: WdsSheetVariant.draggable,
       );

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Header 있으면 흰색으로
    // Header 없으면 backgroundColor로 지정
    final handleBackgroundColor = header != null
        ? WdsColors.white
        : backgroundColor;

    return Semantics(
      container: true,
      label: semanticLabel,
      child: DraggableScrollableSheet(
      initialChildSize: variant.initialHeightRatio,
      maxChildSize: variant.maxHeightRatio,
      builder: (context, scrollController) {
        return __SheetContainer(
          variant: variant,
          backgroundColor: backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// HANDLE
              RepaintBoundary(
                child: ColoredBox(
                  color: handleBackgroundColor,
                  child: const __SheetHandle(),
                ),
              ),

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
                  padding: contentPadding,
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
    ),
    );
  }
}

/// 공통 시트 컨테이너 - 성능 최적화를 위한 별도 위젯
class __SheetContainer extends StatelessWidget {
  const __SheetContainer({
    required this.variant,
    required this.backgroundColor,
    required this.child,
  });

  final WdsSheetVariant variant;
  final Color backgroundColor;
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
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: _SheetDimensions.topBorderRadius,
          ),
          child: ClipRRect(
            borderRadius: _SheetDimensions.topBorderRadius,
            child: child,
          ),
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
