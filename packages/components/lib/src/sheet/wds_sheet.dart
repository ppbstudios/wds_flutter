part of '../../wds_components.dart';

enum WdsSheetVariant {
  fixed(maxHeightRatio: 0.88, minHeightRatio: 0.35),
  draggable(maxHeightRatio: 0.93, minHeightRatio: 0.50),
  nudging(maxHeightRatio: 0.494, minHeightRatio: 0.31);

  const WdsSheetVariant({
    required this.maxHeightRatio,
    required this.minHeightRatio,
  });

  final double maxHeightRatio;
  final double minHeightRatio;
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
  static const double nudgingContentSpacing = 10;
}

/// 디자인 시스템 규칙을 따르는 시트
abstract class WdsSheet extends StatelessWidget {
  const WdsSheet._({super.key});

  factory WdsSheet.fixed({
    required VoidCallback onClose,
    required VoidCallback onAction,
    required String headerTitle,
    required Widget content,
    required String actionTitle,
    bool isActionEnabled = true,
    Key? key,
  }) =>
      _WdsFixedSheet(
        onClose: onClose,
        onAction: onAction,
        headerTitle: headerTitle,
        content: content,
        actionTitle: actionTitle,
        isActionEnabled: isActionEnabled,
        key: key,
      );

  factory WdsSheet.draggable({
    required String headerTitle,
    required Widget content,
    Key? key,
  }) =>
      _WdsDraggableSheet(
        headerTitle: headerTitle,
        content: content,
        key: key,
      );

  factory WdsSheet.nudging({
    required VoidCallback onClose,
    required VoidCallback onAction,
    required String actionTitle,
    required Widget image,
    required String contentTitle,
    required String contentDescription,
    bool isActionEnabled = true,
    Key? key,
  }) {
    assert(contentTitle.isNotEmpty, 'contentTitle cannot be empty');
    assert(contentDescription.isNotEmpty, 'contentDescription cannot be empty');

    return _WdsNudgingSheet(
      onClose: onClose,
      onAction: onAction,
      actionTitle: actionTitle,
      image: image,
      contentTitle: contentTitle,
      contentDescription: contentDescription,
      isActionEnabled: isActionEnabled,
      key: key,
    );
  }
}

/// 공통 시트 컨테이너 - 성능 최적화를 위한 별도 위젯
class _WdsSheetContainer extends StatelessWidget {
  const _WdsSheetContainer({
    required this.variant,
    required this.children,
    this.useIntrinsicHeight = false,
  });

  final WdsSheetVariant variant;
  final List<Widget> children;
  final bool useIntrinsicHeight;

  @override
  Widget build(BuildContext context) {
    if (useIntrinsicHeight) {
      return _buildIntrinsicContainer(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight * variant.maxHeightRatio;
        final minHeight = constraints.maxHeight * variant.minHeightRatio;

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: maxHeight,
            minHeight: minHeight,
            minWidth: constraints.minWidth,
          ),
          child: _buildDecoratedContainer(),
        );
      },
    );
  }

  Widget _buildIntrinsicContainer(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight * variant.maxHeightRatio;

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: maxHeight,
            minWidth: constraints.minWidth,
          ),
          child: IntrinsicHeight(
            child: _buildDecoratedContainer(),
          ),
        );
      },
    );
  }

  Widget _buildDecoratedContainer() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: WdsColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(WdsRadius.lg),
          topRight: Radius.circular(WdsRadius.lg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

/// Fixed 타입 시트 - RepaintBoundary로 성능 최적화
class _WdsFixedSheet extends WdsSheet {
  const _WdsFixedSheet({
    required this.onClose,
    required this.onAction,
    required this.headerTitle,
    required this.content,
    required this.actionTitle,
    this.isActionEnabled = true,
    super.key,
  }) : super._();

  final VoidCallback onClose;
  final VoidCallback onAction;
  final String headerTitle;
  final Widget content;
  final String actionTitle;
  final bool isActionEnabled;

  @override
  Widget build(BuildContext context) {
    return _WdsSheetContainer(
      variant: WdsSheetVariant.fixed,
      children: [
        RepaintBoundary(
          child: _WdsSheetHeader(
            title: headerTitle,
            onClose: onClose,
          ),
        ),
        Flexible(
          child: RepaintBoundary(
            child: SingleChildScrollView(
              padding: _SheetPaddingByArea.view,
              child: content,
            ),
          ),
        ),
        RepaintBoundary(
          child: _WdsSheetBottom(
            onTap: onAction,
            title: actionTitle,
            isEnabled: isActionEnabled,
          ),
        ),
      ],
    );
  }
}

/// Draggable 타입 시트 - RepaintBoundary로 성능 최적화
class _WdsDraggableSheet extends WdsSheet {
  const _WdsDraggableSheet({
    required this.headerTitle,
    required this.content,
    super.key,
  }) : super._();

  final String headerTitle;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return _WdsSheetContainer(
      variant: WdsSheetVariant.draggable,
      children: [
        const RepaintBoundary(child: _WdsSheetHandle()),
        RepaintBoundary(
          child: _WdsSheetHeader(title: headerTitle),
        ),
        Flexible(
          child: RepaintBoundary(
            child: Padding(
              padding: _SheetPaddingByArea.view,
              child: content,
            ),
          ),
        ),
      ],
    );
  }
}

/// Nudging 타입 시트 - content 크기에 맞춰 동적 높이 조정
class _WdsNudgingSheet extends WdsSheet {
  const _WdsNudgingSheet({
    required this.onClose,
    required this.onAction,
    required this.actionTitle,
    required this.image,
    required this.contentTitle,
    required this.contentDescription,
    this.isActionEnabled = true,
    super.key,
  }) : super._();

  final VoidCallback onClose;
  final VoidCallback onAction;
  final String actionTitle;
  final Widget image;
  final String contentTitle;
  final String contentDescription;
  final bool isActionEnabled;

  @override
  Widget build(BuildContext context) {
    return _WdsSheetContainer(
      variant: WdsSheetVariant.nudging,
      useIntrinsicHeight: true, // content 기반 높이 조정
      children: [
        Flexible(
          child: Stack(
            children: [
              /// Content View
              Padding(
                padding:
                    const EdgeInsets.only(top: 16) + _SheetPaddingByArea.view,
                child: _NudgingContent(
                  image: image,
                  contentTitle: contentTitle,
                  contentDescription: contentDescription,
                ),
              ),

              /// Header
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: _WdsSheetHeader(onClose: onClose),
              ),
            ],
          ),
        ),
        _WdsSheetBottom(
          onTap: onAction,
          title: actionTitle,
          isEnabled: isActionEnabled,
        ),
      ],
    );
  }
}

/// Nudging content를 별도 위젯으로 분리하여 const 최적화
class _NudgingContent extends StatelessWidget {
  const _NudgingContent({
    required this.image,
    required this.contentTitle,
    required this.contentDescription,
  });

  final Widget image;
  final String contentTitle;
  final String contentDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Image (조건부 렌더링)
        if (image is! SizedBox || (image as SizedBox).width != 0) ...[
          Center(child: image),
          const SizedBox(height: 16),
        ],

        /// Title
        Text(
          contentTitle,
          style: WdsTypography.heading18Bold,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: _SheetDimensions.nudgingContentSpacing),

        /// Description
        Text(
          contentDescription,
          style: WdsTypography.body15NormalRegular,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _WdsSheetHandle extends StatelessWidget {
  const _WdsSheetHandle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: _SheetDimensions.handlePaddingTop),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: WdsColors.borderAlternative,
            borderRadius: BorderRadius.all(Radius.circular(WdsRadius.full)),
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

class _WdsSheetHeader extends StatelessWidget {
  const _WdsSheetHeader({
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

class _WdsSheetBottom extends StatelessWidget {
  const _WdsSheetBottom({
    required this.onTap,
    required this.title,
    required this.isEnabled,
  });

  final VoidCallback onTap;
  final String title;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: _SheetPaddingByArea.bottom,
        child: WdsButton(
          onTap: onTap,
          size: WdsButtonSize.xlarge,
          isEnabled: isEnabled,
          child: Text(title),
        ),
      ),
    );
  }
}
