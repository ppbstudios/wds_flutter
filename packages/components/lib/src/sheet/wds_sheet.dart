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

  static EdgeInsets header = const EdgeInsets.symmetric(
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
class WdsSheet extends StatefulWidget {
  const WdsSheet.fixed({
    required this.onClose,
    required this.onAction,
    required this.headerTitle,
    required this.content,
    required this.actionTitle,
    this.isActionEnabled = true,
    super.key,
  })  : variant = WdsSheetVariant.fixed,
        contentDescription = null,
        contentTitle = null,
        image = null;

  const WdsSheet.draggable({
    required this.headerTitle,
    required this.content,
    super.key,
  })  : onClose = null,
        variant = WdsSheetVariant.draggable,
        contentTitle = null,
        contentDescription = null,
        image = null,
        actionTitle = null,
        onAction = null,
        isActionEnabled = false;

  const WdsSheet.nudging({
    required this.onClose,
    required this.onAction,
    required this.actionTitle,
    required this.image,
    required this.contentTitle,
    required this.contentDescription,
    this.isActionEnabled = true,
    super.key,
  })  : variant = WdsSheetVariant.nudging,
        headerTitle = null,
        content = null,
        assert(contentTitle != null && contentTitle.length > 0),
        assert(contentDescription != null && contentDescription.length > 0);

  /// Header에 위치한 닫기 버튼 클릭 시 호출되는 콜백
  final VoidCallback? onClose;

  /// 하단 액션 버튼 클릭 시 호출되는 콜백
  final VoidCallback? onAction;

  /// 하단 액션 버튼 활성 여부
  final bool isActionEnabled;

  /// 시트 제목
  final String? headerTitle;

  /// 하단 액션 버튼 텍스트
  final String? actionTitle;

  /// 시트 타입, 외부에서 입력받지 안흥ㅁ
  final WdsSheetVariant variant;

  /// 시트 컨텐츠
  final Widget? content;

  /// nudging 타입에서 사용할 이미지
  final Widget? image;

  final String? contentTitle;

  /// nudging 타입에서 사용할 설명 텍스트
  final String? contentDescription;

  @override
  State<WdsSheet> createState() => _WdsSheetState();
}

class _WdsSheetState extends State<WdsSheet> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight * widget.variant.maxHeightRatio;

        final sheetWidgets = <Widget>[];

        /// HANDLE
        if (widget.variant == WdsSheetVariant.draggable) {
          sheetWidgets.add(const _WdsSheetHandle());
        }

        /// HEADER ~ BOTTOM
        if (widget.variant == WdsSheetVariant.nudging) {
          sheetWidgets.add(
            Flexible(
              child: Stack(
                children: [
                  /// View
                  Padding(
                    padding: const EdgeInsets.only(top: 16) +
                        _SheetPaddingByArea.view,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.image != null) ...[
                          Center(child: widget.image!),
                          const SizedBox(height: 16),
                        ],
                        Text(
                          widget.contentTitle!,
                          style: WdsTypography.heading18Bold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: _SheetDimensions.nudgingContentSpacing,
                        ),
                        Text(
                          widget.contentDescription!,
                          style: WdsTypography.body15NormalRegular,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  /// Header
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    child: _WdsSheetHeader(onClose: widget.onClose),
                  ),
                ],
              ),
            ),
          );
        } else {
          sheetWidgets.addAll([
            _WdsSheetHeader(title: widget.headerTitle, onClose: widget.onClose),
            Flexible(
              child: Padding(
                padding: _SheetPaddingByArea.view,
                child: widget.content,
              ),
            ),
          ]);
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: maxHeight,
            minWidth: constraints.minWidth,
          ),
          child: DecoratedBox(
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
              children: [
                ...sheetWidgets,

                /// Bottom
                if (widget.onAction != null &&
                    widget.variant != WdsSheetVariant.draggable)
                  _WdsSheetBottom(
                    onTap: widget.onAction!,
                    title: widget.actionTitle!,
                    isEnabled: widget.isActionEnabled,
                  ),
              ],
            ),
          ),
        );
      },
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
  const _WdsSheetHeader({this.title, this.onClose});

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
            if (title != null && title!.isNotEmpty)
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
            SizedBox.square(
              dimension: 24,
              child: onClose == null
                  ? null
                  : GestureDetector(
                      onTap: onClose,
                      child: WdsIcon.close.build(),
                    ),
            ),
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
