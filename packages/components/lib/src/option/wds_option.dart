part of '../../wds_components.dart';

enum WdsOptionVariant {
  normal(
    maxHeight: 521,
    scrollThreshold: 6,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    itemHeight: 44,
  ),
  power(
    maxHeight: 289,
    scrollThreshold: 6,
    padding: EdgeInsets.symmetric(horizontal: 16),
    itemHeight: 47,
  ),
  product(
    maxHeight: 401,
    scrollThreshold: 5,
    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
    itemHeight: 63,
  );

  const WdsOptionVariant({
    required this.maxHeight,
    required this.scrollThreshold,
    required this.padding,
    required this.itemHeight,
  });

  /// 고정된 최대 높이 (모든 border 포함)
  final double maxHeight;

  /// 스크롤이 필요한 최소 아이템 개수
  final int scrollThreshold;

  final EdgeInsets padding;

  final double itemHeight;
}

/// Select 영역에서 원하는 옵션을 선택할 수 있도록 돕는 컴포넌트
///
/// Select가 열리면(`isExpanded: true`) 여러 OptionItem들을 감싸고 있는 Option이 보이게 됩니다.
/// 이 때, Option은 left, right, 그리고 bottom에 `WdsColors.primary`로 칠해진 stroke를 가지며,
/// 배경 색상은 `WdsColors.backgroundNormal`을 가집니다.
class WdsOption extends StatelessWidget {
  const WdsOption.normal({
    required this.items,
    super.key,
  }) : variant = WdsOptionVariant.normal;

  const WdsOption.power({
    required this.items,
    super.key,
  }) : variant = WdsOptionVariant.power;

  const WdsOption.product({
    required this.items,
    super.key,
  }) : variant = WdsOptionVariant.product;

  /// Option의 variant
  final WdsOptionVariant variant;

  /// OptionItem들의 리스트
  final List<WdsOptionItem> items;

  static const BoxDecoration _decoration = BoxDecoration(
    color: WdsColors.backgroundNormal,
    border: Border(
      left: BorderSide(color: WdsColors.primary),
      right: BorderSide(color: WdsColors.primary),
      bottom: BorderSide(color: WdsColors.primary),
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(WdsRadius.radius8),
      bottomRight: Radius.circular(WdsRadius.radius8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: _decoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    if (items.length == 1) {
      return WdsOptionItemWrapper(
        item: items.first,
        variant: variant,
        isLast: true,
      );
    }

    /// 스크롤이 필요한지 확인
    final shouldScroll = _shouldShowScroll();

    /// 스크롤이 필요한 경우 고정 높이로 스크롤 영역 생성
    if (shouldScroll) {
      return SizedBox(
        height: variant.maxHeight,
        child: SingleChildScrollView(
          child: Column(
            children: _buildItems(),
          ),
        ),
      );
    }

    /// 스크롤이 필요 없는 경우 wrap 높이로 생성
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _buildItems(),
    );
  }

  /// 스크롤이 필요한지 판단하는 메서드
  bool _shouldShowScroll() {
    return items.length > variant.scrollThreshold;
  }

  List<Widget> _buildItems() {
    final List<Widget> widgets = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      widgets.add(
        WdsOptionItemWrapper(
          item: item,
          variant: variant,
          isLast: isLast,
        ),
      );
    }

    return widgets;
  }
}

/// OptionItem을 감싸는 래퍼 위젯
/// 성능 최적화를 위해 RepaintBoundary 적용
class WdsOptionItemWrapper extends StatelessWidget {
  const WdsOptionItemWrapper({
    required this.item,
    required this.variant,
    required this.isLast,
    super.key,
  });

  final WdsOptionItem item;
  final WdsOptionVariant variant;
  final bool isLast;

  static const BoxDecoration _topBorderDecoration = BoxDecoration(
    border: Border(
      top: BorderSide(color: WdsColors.borderAlternative),
    ),
  );

  static const BoxDecoration _topBottomBorderDecoration = BoxDecoration(
    border: Border(
      top: BorderSide(color: WdsColors.borderAlternative),
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(WdsRadius.radius8),
      bottomRight: Radius.circular(WdsRadius.radius8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final decoration = isLast
        ? _topBottomBorderDecoration
        : _topBorderDecoration;

    return RepaintBoundary(
      child: DecoratedBox(
        decoration: decoration,
        child: Padding(
          padding: variant.padding,
          child: SizedBox(
            height: variant.itemHeight,
            child: item.build(context, variant),
          ),
        ),
      ),
    );
  }
}

/// Option 내부의 개별 아이템을 나타내는 추상 클래스
abstract class WdsOptionItem {
  const WdsOptionItem();

  /// OptionItem을 렌더링하는 메서드
  Widget build(BuildContext context, WdsOptionVariant variant);
}

/// Normal variant용 OptionItem
class WdsNormalOptionItem extends WdsOptionItem {
  const WdsNormalOptionItem({
    required this.label,
    this.onTap,
  });

  /// 필수 라벨
  final String label;

  /// 탭 콜백
  final VoidCallback? onTap;

  static const TextStyle _labelStyle = WdsTypography.body14NormalRegular;

  @override
  Widget build(BuildContext context, WdsOptionVariant variant) {
    assert(
      variant == WdsOptionVariant.normal,
      'NormalOptionItem은 normal variant에서만 사용 가능합니다',
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: _labelStyle.copyWith(
                color: WdsColors.textNormal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Power variant용 OptionItem
class WdsPowerOptionItem extends WdsOptionItem {
  const WdsPowerOptionItem({
    required this.label,
    this.tags = const [],
    this.isSoldOut = false,
    this.hasRegistered = false,
    this.onTap,
  });

  /// 필수 라벨
  final String label;

  /// 선택적 태그들 (최대 2개)
  final List<WdsTag> tags;

  /// 품절 상태
  final bool isSoldOut;

  /// 입고알림 등록 여부
  final bool hasRegistered;

  /// 탭 콜백
  final VoidCallback? onTap;

  static const TextStyle _labelStyle = WdsTypography.body14NormalRegular;

  static const SizedBox _tagSpacing = SizedBox(width: 8);
  static const SizedBox _trailingSpacing = SizedBox(width: 10);

  @override
  Widget build(BuildContext context, WdsOptionVariant variant) {
    assert(
      variant == WdsOptionVariant.power,
      'PowerOptionItem은 power variant에서만 사용 가능합니다',
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // Label (고정 너비 40px)
          SizedBox(
            width: 40,
            height: 20,
            child: Text(
              label,
              style: _labelStyle.copyWith(
                color: isSoldOut ? WdsColors.textDisable : WdsColors.textNormal,
              ),
              textAlign: TextAlign.start,
            ),
          ),

          // Tags 영역 (Expanded)
          if (tags.isNotEmpty || isSoldOut) ...[
            _tagSpacing,
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 2,
                children: [
                  /// 품절 태그가 있으면 맨 앞에 추가
                  if (isSoldOut) ...[
                    const WdsTag.$soldOut(),
                  ],

                  /// 기존 태그들
                  if (tags.isNotEmpty) ...[
                    ...tags
                        .take(2)
                        .expand((tag) => [tag])
                        .take(tags.length * 2 - 1), // 마지막 spacing 제거
                  ],
                ],
              ),
            ),
          ],

          /// Trailing (품절 상태일 때만 표시)
          if (isSoldOut) ...[
            _trailingSpacing,
            if (hasRegistered)
              WdsChip.pill(
                onTap: onTap,
                label: '알림받는중',
                value: 1,
                groupValues: {1},
                size: WdsChipSize.xsmall,
                variant: WdsChipVariant.solid,
              )
            else
              WdsChip.pill(
                onTap: onTap,
                label: '입고알림',
                value: 0,
                groupValues: {},
                size: WdsChipSize.xsmall,
              ),
          ],
        ],
      ),
    );
  }
}

/// Product variant용 OptionItem
class WdsProductOptionItem extends WdsOptionItem {
  const WdsProductOptionItem({
    required this.index,
    required this.thumbnail,
    required this.title,
    required this.description,
    this.trailing,
    this.onTap,
    this.isSoldOut = false,
  });

  /// 필수 인덱스
  final String index;

  /// 필수 썸네일
  final Widget thumbnail;

  /// 필수 제목
  final String title;

  /// 필수 설명
  final String description;

  /// 선택적 trailing 위젯
  final Widget? trailing;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 품절 상태
  final bool isSoldOut;

  // 성능 최적화: 정적 스타일들을 미리 생성
  static const TextStyle _titleStyle = WdsTypography.body14NormalMedium;
  static const TextStyle _descriptionStyle = WdsTypography.body13NormalRegular;

  static const SizedBox _thumbnailSpacing = SizedBox(width: 4);
  static const SizedBox _contentSpacing = SizedBox(width: 10);
  static const SizedBox _titleSpacing = SizedBox(height: 4);
  static const SizedBox _trailingSpacing = SizedBox(width: 4);

  @override
  Widget build(BuildContext context, WdsOptionVariant variant) {
    assert(
      variant == WdsOptionVariant.product,
      'ProductOptionItem은 product variant에서만 사용 가능합니다',
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          /// 좌측 영역: index + thumbnail (고정 크기 86x64)
          SizedBox(
            width: 86,
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Index (고정 크기 18x20)
                SizedBox(
                  width: 18,
                  height: 20,
                  child: Text(
                    index,
                    style: _titleStyle.copyWith(
                      color: isSoldOut
                          ? WdsColors.textDisable
                          : WdsColors.textNormal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _thumbnailSpacing,

                /// Thumbnail (나머지 공간)
                Expanded(
                  child: isSoldOut
                      ? Opacity(
                          opacity: WdsOpacity.opacity40,
                          child: thumbnail,
                        )
                      : thumbnail,
                ),
              ],
            ),
          ),

          _contentSpacing,

          /// 우측 영역: title + description (Expanded)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Title + Trailing
                Row(
                  spacing: 4,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: _titleStyle.copyWith(
                          color: isSoldOut
                              ? WdsColors.textDisable
                              : WdsColors.textNormal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (trailing != null) ...[
                      _trailingSpacing,
                      trailing!,
                    ],
                  ],
                ),
                _titleSpacing,

                /// Description
                Text(
                  description,
                  style: _descriptionStyle.copyWith(
                    color: isSoldOut
                        ? WdsColors.textDisable
                        : WdsColors.textAlternative,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
