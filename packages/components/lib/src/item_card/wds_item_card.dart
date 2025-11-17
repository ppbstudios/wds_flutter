part of '../../wds_components.dart';

enum WdsItemCardSize {
  xlarge(
    cardHeight: 340,
    thumbnailSize: WdsThumbnailSize.xlarge,
  ),
  large(
    cardHeight: 287,
    thumbnailSize: WdsThumbnailSize.large,
  ),
  medium(
    cardHeight: 328,
    thumbnailSize: WdsThumbnailSize.medium,
  ),
  xsmall(
    cardHeight: 329,
    thumbnailSize: WdsThumbnailSize.xsmall,
  );

  const WdsItemCardSize({
    required this.cardHeight,
    required this.thumbnailSize,
  });

  final double cardHeight;
  final WdsThumbnailSize thumbnailSize;

  Size? get lensPatternSize => switch (this) {
    WdsItemCardSize.xlarge || WdsItemCardSize.large => const Size.square(40),
    WdsItemCardSize.medium => const Size.square(30),
    WdsItemCardSize.xsmall => null,
  };
}

class WdsItemCard extends StatefulWidget {
  /// [WdsThumbnailSize.xlarge]과 함께 세로로 구성되는 상품 정보
  ///
  /// '세트상품'일 때만 상품명 2줄 처리
  const WdsItemCard.xlarge({
    required this.onLiked,
    required this.thumbnailImageUrl,
    required this.brandName,
    required this.productName,
    required this.lensType,
    required this.diameter,
    required this.originalPrice,
    required this.salePrice,
    required this.rating,
    required this.reviewCount,
    required this.likeCount,
    this.hasLiked = false,
    this.tags = const [],
    this.lensPatternImageUrl,
    this.isSoldOut = false,
    this.productNameMaxLines = 1,
    this.leftThumbnailTags = const [],
    this.rightThumbnailTag,
    this.scaleFactor = 1,
    super.key,
  }) : size = WdsItemCardSize.xlarge,
       indexTag = null,
       assert(
         productNameMaxLines == 1,
         '세트상품일 때만 상품명 2줄 처리하고 나머지는 1줄 처리해야 합니다.',
       );

  /// [WdsThumbnailSize.large]와 함께 세로로 구성되는 상품 정보
  const WdsItemCard.large({
    required this.onLiked,
    required this.thumbnailImageUrl,
    required this.brandName,
    required this.productName,
    required this.lensType,
    required this.diameter,
    required this.originalPrice,
    required this.salePrice,
    required this.rating,
    required this.reviewCount,
    required this.likeCount,
    this.hasLiked = false,
    this.tags = const [],
    this.lensPatternImageUrl,
    this.isSoldOut = false,
    this.productNameMaxLines = 1,
    this.leftThumbnailTags = const [],
    this.rightThumbnailTag,
    this.indexTag,
    this.scaleFactor = 1,
    super.key,
  }) : size = WdsItemCardSize.large;

  /// [WdsThumbnailSize.medium]와 함께 가로로 구성되는 상품 정보
  const WdsItemCard.medium({
    required this.onLiked,
    required this.thumbnailImageUrl,
    required this.brandName,
    required this.productName,
    required this.lensType,
    required this.diameter,
    required this.originalPrice,
    required this.salePrice,
    required this.rating,
    required this.reviewCount,
    required this.likeCount,
    this.hasLiked = false,
    this.tags = const [],
    this.lensPatternImageUrl,
    this.isSoldOut = false,
    this.scaleFactor = 1,
    super.key,
  }) : size = WdsItemCardSize.medium,
       productNameMaxLines = 1,
       indexTag = null,
       leftThumbnailTags = const [],
       rightThumbnailTag = null;

  /// [WdsThumbnailSize.xsmall]와 함께 가로로 구성되는 상품 정보
  const WdsItemCard.xsmall({
    required this.onLiked,
    required this.thumbnailImageUrl,
    required this.productName,
    required this.lensType,
    required this.diameter,
    required this.originalPrice,
    required this.salePrice,
    required this.rating,
    required this.reviewCount,
    required this.likeCount,
    this.hasLiked = false,
    this.tags = const [],
    this.isSoldOut = false,
    this.productNameMaxLines = 1,
    this.scaleFactor = 1,
    super.key,
  }) : size = WdsItemCardSize.xsmall,
       brandName = '',
       lensPatternImageUrl = null,
       indexTag = null,
       leftThumbnailTags = const [],
       rightThumbnailTag = null;

  final VoidCallback onLiked;

  final String thumbnailImageUrl;

  final String? lensPatternImageUrl;

  final List<WdsTag> leftThumbnailTags;

  final WdsTag? rightThumbnailTag;

  final int? indexTag;

  final String brandName;

  final String productName;

  final String? lensType;

  final String? diameter;

  final double originalPrice;

  final double salePrice;

  final List<WdsTag> tags;

  final double rating;

  final int reviewCount;

  final int likeCount;

  final bool hasLiked;

  final WdsItemCardSize size;

  final bool isSoldOut;

  final int productNameMaxLines;

  final double scaleFactor;

  @override
  State<WdsItemCard> createState() => _WdsItemCardState();
}

class _WdsItemCardState extends State<WdsItemCard> {
  @override
  void didUpdateWidget(covariant WdsItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.hasLiked != widget.hasLiked) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail = switch (widget.size) {
      WdsItemCardSize.xlarge => WdsThumbnail.xlarge(
        imagePath: widget.thumbnailImageUrl,
        scaleFactor: widget.scaleFactor,
      ),
      WdsItemCardSize.large => WdsThumbnail.large(
        imagePath: widget.thumbnailImageUrl,
        hasRadius: true,
        scaleFactor: widget.scaleFactor,
      ),
      WdsItemCardSize.medium => WdsThumbnail.medium(
        imagePath: widget.thumbnailImageUrl,
        hasRadius: true,
        scaleFactor: widget.scaleFactor,
      ),
      WdsItemCardSize.xsmall => WdsThumbnail.xsmall(
        imagePath: widget.thumbnailImageUrl,
        hasRadius: true,
        scaleFactor: widget.scaleFactor,
      ),
    };

    /// Thumnbnail 가공
    final thumbnailImageWithLensPattern = Stack(
      children: [
        thumbnail,

        /// LEFT TOP, [WdsItemCardSize.large] 만 사용
        if (widget.size == WdsItemCardSize.large && widget.indexTag != null)
          Positioned(
            left: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(WdsRadius.radius4),
              ),
              child: SizedBox.square(
                dimension: 18,
                child: ColoredBox(
                  color: WdsColors.cta,
                  child: Center(
                    child: Text(
                      widget.indexTag!.toString(),
                      style: WdsTypography.caption10Bold.copyWith(
                        color: WdsColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        /// LEFT THUMBNAIL TAGS
        if (widget.leftThumbnailTags.isNotEmpty)
          Positioned(
            left: 0,
            bottom: 0,
            width: 33,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 1,
              children: widget.leftThumbnailTags,
            ),
          ),

        /// RIGHT THUMBNAIL TAG: 쿠폰 사용가능
        if (widget.rightThumbnailTag != null)
          Positioned(
            right: 0,
            top: 0,
            height: 18,
            child: widget.rightThumbnailTag!,
          ),

        /// LENS PATTERN IMAGE
        if (widget.lensPatternImageUrl != null &&
            widget.lensPatternImageUrl!.isNotEmpty &&
            widget.size.lensPatternSize != null)
          Positioned(
            right: 6 * widget.scaleFactor,
            bottom: 6 * widget.scaleFactor,
            child: CachedNetworkImage(
              imageUrl: widget.lensPatternImageUrl!,
              width: widget.size.lensPatternSize!.width,
              height: widget.size.lensPatternSize!.height,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );

    if (widget.size == WdsItemCardSize.xlarge ||
        widget.size == WdsItemCardSize.large) {
      return _VerticalLayout(
        thumbnail: thumbnailImageWithLensPattern,
        brandName: widget.brandName,
        productName: widget.productName,
        lensType: widget.lensType,
        diameter: widget.diameter,
        originalPrice: widget.originalPrice,
        salePrice: widget.salePrice,
        rating: widget.rating,
        reviewCount: widget.reviewCount,
        likeCount: widget.likeCount,
        hasLiked: widget.hasLiked,
        tags: widget.tags,
        onLiked: widget.onLiked,
        size: widget.size,
        isSoldOut: widget.isSoldOut,
        productNameMaxLines: widget.productNameMaxLines,
      );
    }

    return _HorizontalLayout(
      thumbnail: thumbnailImageWithLensPattern,
      brandName: widget.brandName,
      productName: widget.productName,
      lensType: widget.lensType,
      diameter: widget.diameter,
      originalPrice: widget.originalPrice,
      salePrice: widget.salePrice,
      likeCount: widget.likeCount,
      hasLiked: widget.hasLiked,
      tags: widget.tags,
      onLiked: widget.onLiked,
      size: widget.size,
      isSoldOut: widget.isSoldOut,
      productNameMaxLines: widget.productNameMaxLines,
    );
  }
}

class _VerticalLayout extends StatelessWidget {
  const _VerticalLayout({
    required this.thumbnail,
    required this.brandName,
    required this.productName,
    required this.lensType,
    required this.diameter,
    required this.originalPrice,
    required this.salePrice,
    required this.rating,
    required this.reviewCount,
    required this.likeCount,
    required this.hasLiked,
    required this.tags,
    required this.onLiked,
    required this.size,
    required this.isSoldOut,
    required this.productNameMaxLines,
  });

  final Widget thumbnail;
  final String brandName;
  final String productName;
  final String? lensType;
  final String? diameter;
  final double originalPrice;
  final double salePrice;
  final double rating;
  final int reviewCount;
  final int likeCount;
  final bool hasLiked;
  final List<WdsTag> tags;
  final VoidCallback onLiked;
  final WdsItemCardSize size;
  final bool isSoldOut;
  final int productNameMaxLines;

  @override
  Widget build(BuildContext context) {
    final information = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 브랜드명, 좋아요 버튼
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: Text(
                brandName,
                style: WdsTypography.caption11Regular.copyWith(
                  color: WdsColors.textNeutral,
                ),
              ),
            ),
            __LikeButton(
              onTap: onLiked,
              hasLiked: hasLiked,
            ),
          ],
        ),
        const SizedBox(height: 4),

        /// 상품명
        Text(
          productName,
          style: WdsTypography.body13NormalMedium.copyWith(
            color: WdsColors.textNormal,
          ),
          maxLines: productNameMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),

        /// 렌즈 정보
        if (lensType != null && diameter != null) ...[
          __LensInfo.bySize(
            size: size,
            lensType: lensType!,
            diameter: diameter!,
          ),
          const SizedBox(height: 6),
        ],

        /// 가격 정보
        if (isSoldOut)
          __PriceInfo.soldOut(size: size)
        else
          __PriceInfo.bySize(
            size: size,
            originalPrice: originalPrice,
            salePrice: salePrice,
          ),
        const SizedBox(height: 8),

        /// 태그 정보
        if (tags.isNotEmpty) ...[
          Row(spacing: 2, children: tags),
          const SizedBox(height: 8),
        ],

        /// 평점/좋아요 정보
        Row(
          spacing: 10,
          children: [
            __ReviewInfo(
              rating: rating,
              reviewCount: reviewCount,
            ),
            __LikeInfo(
              likeCount: likeCount,
            ),
          ],
        ),
      ],
    );

    return Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        thumbnail,

        /// 상품 정보
        if (size == WdsItemCardSize.xlarge)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: information,
          )
        else
          information,
      ],
    );
  }
}

class _HorizontalLayout extends StatelessWidget {
  const _HorizontalLayout({
    required this.thumbnail,
    required this.brandName,
    required this.productName,
    required this.lensType,
    required this.diameter,
    required this.originalPrice,
    required this.salePrice,
    required this.likeCount,
    required this.hasLiked,
    required this.tags,
    required this.onLiked,
    required this.size,
    required this.isSoldOut,
    required this.productNameMaxLines,
  });

  final Widget thumbnail;
  final String brandName;
  final String productName;
  final String? lensType;
  final String? diameter;
  final double originalPrice;
  final double salePrice;
  final int likeCount;
  final bool hasLiked;
  final List<WdsTag> tags;
  final VoidCallback onLiked;
  final WdsItemCardSize size;
  final bool isSoldOut;
  final int productNameMaxLines;

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = 2.0;
    final horizontalSpacing = size == WdsItemCardSize.medium ? 16.0 : 12.0;

    return SizedBox(
      height: size.thumbnailSize.size.height,
      child: Row(
        spacing: horizontalSpacing,
        children: [
          thumbnail,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 브랜드명
                if (size == WdsItemCardSize.medium)
                  Text(
                    brandName,
                    style: WdsTypography.caption11Regular.copyWith(
                      color: WdsColors.textNeutral,
                    ),
                  ),

                /// 상품명
                Text(
                  productName,
                  style: WdsTypography.body13NormalMedium.copyWith(
                    color: WdsColors.textNormal,
                  ),
                  maxLines: productNameMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),

                /// 렌즈 정보
                if (lensType != null && diameter != null) ...[
                  if (size == WdsItemCardSize.medium) const SizedBox(height: 1),
                  __LensInfo.bySize(
                    size: size,
                    lensType: lensType!,
                    diameter: diameter!,
                  ),
                ],

                SizedBox(height: verticalSpacing),

                /// 가격 정보
                if (isSoldOut)
                  __PriceInfo.soldOut(size: size)
                else
                  __PriceInfo.bySize(
                    size: size,
                    originalPrice: originalPrice,
                    salePrice: salePrice,
                  ),

                /// 태그 정보
                if (tags.isNotEmpty) ...[
                  SizedBox(height: verticalSpacing),
                  Row(
                    spacing: 2,
                    children: tags,
                  ),
                ],
              ],
            ),
          ),

          /// 좋아요 버튼
          __LikeButton(
            onTap: onLiked,
            hasLiked: hasLiked,
            isVertical: size == WdsItemCardSize.xsmall,
            likeCount: size == WdsItemCardSize.xsmall ? likeCount : null,
          ),
        ],
      ),
    );
  }
}

class __LensInfo extends StatelessWidget {
  const __LensInfo.bySize({
    required this.size,
    required this.lensType,
    required this.diameter,
  });

  final WdsItemCardSize size;

  final String lensType;

  final String diameter;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        switch (size) {
          WdsItemCardSize.xsmall => WdsTypography.caption11Regular,
          _ => WdsTypography.caption12NormalRegular,
        }.copyWith(
          color: WdsColors.textAlternative,
        );

    return SizedBox(
      height: 16,
      child: Row(
        spacing: 4,
        children: [
          Text(lensType, style: textStyle),
          const DecoratedBox(
            decoration: ShapeDecoration(
              color: WdsColors.borderNeutral,
              shape: CircleBorder(),
            ),
            child: SizedBox.square(dimension: 2),
          ),
          Text(diameter, style: textStyle),
        ],
      ),
    );
  }
}

class __PriceInfo extends StatelessWidget {
  const __PriceInfo.bySize({
    required this.size,
    required this.originalPrice,
    required this.salePrice,
  }) : isSoldOut = false;

  const __PriceInfo.soldOut({
    required this.size,
  }) : isSoldOut = true,
       originalPrice = 0,
       salePrice = 0;

  final double originalPrice;

  final double salePrice;

  final WdsItemCardSize size;

  final bool isSoldOut;

  @override
  Widget build(BuildContext context) {
    if (isSoldOut) {
      return Text(
        'SOLD OUT',
        style: WdsTypography.body15NormalBold.copyWith(
          color: WdsColors.textAssistive,
        ),
      );
    }

    final rate = originalPrice.getDiscountRate(salePrice);

    final finalSalePrice = Text(
      salePrice.toKRWFormat(),
      style: switch (size) {
        WdsItemCardSize.xlarge ||
        WdsItemCardSize.large ||
        WdsItemCardSize.medium => WdsTypography.body14NormalBold,
        WdsItemCardSize.xsmall => WdsTypography.caption12NormalBold,
      }.copyWith(color: WdsColors.textNormal),
    );

    if (rate <= 0) {
      return finalSalePrice;
    }

    final discountRate = Text(
      '$rate%',
      style: switch (size) {
        WdsItemCardSize.xlarge ||
        WdsItemCardSize.large => WdsTypography.body15NormalBold,
        WdsItemCardSize.medium => WdsTypography.body14NormalBold,
        WdsItemCardSize.xsmall => WdsTypography.caption12NormalBold,
      }.copyWith(color: WdsColors.secondary),
    );

    final salePriceAndDiscountRate = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        discountRate,
        const SizedBox(width: 4),
        finalSalePrice,
      ],
    );

    if (size != WdsItemCardSize.xlarge) {
      return salePriceAndDiscountRate;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          originalPrice.toKRWFormat(),
          style: WdsTypography.caption11Regular.copyWith(
            color: WdsColors.textAssistive,
            decoration: TextDecoration.lineThrough,
            decorationColor: WdsColors.textAssistive,
          ),
        ),
        salePriceAndDiscountRate,
      ],
    );
  }
}

class __ReviewInfo extends StatelessWidget {
  const __ReviewInfo({
    required this.rating,
    required this.reviewCount,
  });

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          WdsIcon.starFilled.build(
            color: WdsColors.neutral200,
            width: 12,
            height: 12,
          ),
          Text(
            '${rating.clamp(0.0, 5.0).toStringAsFixed(1)} (${reviewCount.clamp(0, 999999).toFormat()})',
            style: WdsTypography.caption11Regular.copyWith(
              color: WdsColors.textAssistive,
            ),
          ),
        ],
      ),
    );
  }
}

class __LikeInfo extends StatelessWidget {
  const __LikeInfo({
    required this.likeCount,
  });

  final int likeCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          WdsIcon.likeFilled.build(
            color: WdsColors.neutral200,
            width: 12,
            height: 12,
          ),
          Text(
            likeCount.clamp(0, 999999).toFormat(),
            style: WdsTypography.caption11Regular.copyWith(
              color: WdsColors.textAssistive,
            ),
          ),
        ],
      ),
    );
  }
}

class __LikeButton extends StatelessWidget {
  const __LikeButton({
    required this.onTap,
    required this.hasLiked,
    this.isVertical = false,
    this.likeCount,
  });

  final VoidCallback onTap;

  final bool hasLiked;

  final bool isVertical;

  final int? likeCount;

  @override
  Widget build(BuildContext context) {
    final icon = hasLiked
        ? WdsIcon.likeFilled.build(
            color: WdsColors.secondary,
            width: 18,
            height: 18,
          )
        : WdsIcon.like.build(
            color: WdsColors.neutral500,
            width: 18,
            height: 18,
          );

    if (isVertical && likeCount != null) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            Text(
              likeCount!.clamp(0, 999999).toFormat(),
              style: WdsTypography.caption10Regular.copyWith(
                color: WdsColors.textAlternative,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: icon,
    );
  }
}
