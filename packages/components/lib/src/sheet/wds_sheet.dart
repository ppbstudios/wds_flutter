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

  static const EdgeInsets header = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 13,
  );
  static const EdgeInsets view = EdgeInsets.all(16);
  static const EdgeInsets bottom = EdgeInsets.all(16);
}

class _SheetDimensions {
  const _SheetDimensions._();

  static const double handleWidth = 40;
  static const double handleHeight = 5;
  static const double handlePaddingTop = 7;
  static const double headerHeight = 50;
}

/// 디자인 시스템 규칙을 따르는 시트
abstract class WdsSheet extends StatelessWidget {
  const WdsSheet({
    required this.variant,
    required this.headerTitle,
    this.onClose,
    this.onAction,
    this.actionTitle,
    super.key,
  });

  factory WdsSheet.fixed({
    required VoidCallback onClose,
    required VoidCallback onAction,
    required String headerTitle,
    required Widget content,
    required String actionTitle,
    Key? key,
  }) =>
      _FixedSheet(
        onClose: onClose,
        onAction: onAction,
        headerTitle: headerTitle,
        content: content,
        actionTitle: actionTitle,
        key: key,
      );

  factory WdsSheet.draggable({
    required VoidCallback onAction,
    required String headerTitle,
    required String actionTitle,
    required List<Widget> children,
    Key? key,
  }) =>
      _DraggableSheet(
        onAction: onAction,
        headerTitle: headerTitle,
        actionTitle: actionTitle,
        key: key,
        children: children,
      );

  final WdsSheetVariant variant;
  final VoidCallback? onClose;
  final VoidCallback? onAction;
  final String headerTitle;
  final String? actionTitle;
}

class _FixedSheet extends WdsSheet {
  const _FixedSheet({
    required super.onClose,
    required super.headerTitle,
    required this.content,
    super.onAction,
    super.actionTitle,
    super.key,
  }) : super(variant: WdsSheetVariant.fixed);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: variant.maxHeightRatio,
      maxChildSize: variant.maxHeightRatio,
      builder: (context, _) {
        return __SheetContainer(
          variant: variant,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                child: __SheetHeader(
                  title: headerTitle,
                  onClose: onClose,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: _SheetPaddingByArea.view,
                  child: content,
                ),
              ),
              if (onAction != null && actionTitle != null)
                RepaintBoundary(
                  child: __SheetBottom(
                    onTap: onAction!,
                    title: actionTitle!,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DraggableSheet extends WdsSheet {
  const _DraggableSheet({
    required super.headerTitle,
    required this.children,
    super.onAction,
    super.actionTitle,
    super.key,
  }) : super(
          onClose: null,
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
              RepaintBoundary(child: __SheetHeader(title: headerTitle)),

              /// CONTENT
              Flexible(
                child: ListView(
                  controller: scrollController,
                  padding: _SheetPaddingByArea.view,
                  children: children,
                ),
              ),

              /// ACTION
              if (onAction != null && actionTitle != null)
                RepaintBoundary(
                  child: __SheetBottom(
                    onTap: onAction!,
                    title: actionTitle!,
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
      padding: EdgeInsets.only(top: _SheetDimensions.handlePaddingTop),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: WdsColors.borderAlternative,
            borderRadius: BorderRadius.all(Radius.circular(WdsRadius.radius9999)),
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
    this.title,
    this.onClose,
  });

  final String? title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _SheetDimensions.headerHeight,
      child: Padding(
        padding: _SheetPaddingByArea.header,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.square(dimension: 24),

            /// Title
            if (title?.isNotEmpty == true)
              Flexible(
                child: Text(
                  title!,
                  style: WdsTypography.heading17Bold.copyWith(
                    color: WdsColors.textNormal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            /// Close Button
            if (onClose != null)
              SizedBox.square(
                dimension: 24,
                child: GestureDetector(
                  onTap: onClose,
                  child: Semantics(
                    label: 'Close sheet',
                    button: true,
                    child: WdsIcon.close.build(),
                  ),
                ),
              )
            else
              const SizedBox.square(dimension: 24),
          ],
        ),
      ),
    );
  }
}

class __SheetBottom extends StatelessWidget {
  const __SheetBottom({
    required this.onTap,
    required this.title,
  });

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: _SheetPaddingByArea.bottom,
        child: WdsButton(
          onTap: onTap,
          size: WdsButtonSize.xlarge,
          child: Text(title),
        ),
      ),
    );
  }
}
