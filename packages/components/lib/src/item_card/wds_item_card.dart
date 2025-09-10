part of '../../wds_components.dart';

enum WdsItemCardSize {
  xl,
  lg,
  md,
  xs;

  Size get thumnbnailSize => switch (this) {
        WdsItemCardSize.xl => WdsThumbnailSize.xl.size,
        WdsItemCardSize.lg => WdsThumbnailSize.lg.size,
        WdsItemCardSize.md => WdsThumbnailSize.md.size,
        WdsItemCardSize.xs => WdsThumbnailSize.xs.size,
      };

  Size? get lensPatternSize => switch (this) {
        WdsItemCardSize.xl || WdsItemCardSize.lg => const Size.square(40),
        WdsItemCardSize.md => const Size.square(30),
        WdsItemCardSize.xs => null,
      };
}

class WdsItemCard extends StatefulWidget {
  /// [WdsThumbnailSize.xl]과 함께 세로로 구성되는 상품 정보
  const WdsItemCard.xl({
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
    super.key,
  }) : size = WdsItemCardSize.xl;

  /// [WdsThumbnailSize.lg]와 함께 세로로 구성되는 상품 정보
  const WdsItemCard.lg({
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
    super.key,
  }) : size = WdsItemCardSize.lg;

  /// [WdsThumbnailSize.md]와 함께 가로로 구성되는 상품 정보
  const WdsItemCard.md({
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
    super.key,
  }) : size = WdsItemCardSize.md;

  /// [WdsThumbnailSize.xs]와 함께 가로로 구성되는 상품 정보
  const WdsItemCard.xs({
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
    super.key,
  })  : size = WdsItemCardSize.xs,
        brandName = '',
        lensPatternImageUrl = null;

  final VoidCallback onLiked;

  final String thumbnailImageUrl;

  final String? lensPatternImageUrl;

  final String brandName;

  final String productName;

  final String lensType;

  final String diameter;

  final double originalPrice;

  final double salePrice;

  final List<WdsTag> tags;

  final double rating;

  final int reviewCount;

  final int likeCount;

  final bool hasLiked;

  final WdsItemCardSize size;

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
      WdsItemCardSize.xl => WdsThumbnail.xl(
          imagePath: widget.thumbnailImageUrl,
        ),
      WdsItemCardSize.lg => WdsThumbnail.lg(
          imagePath: widget.thumbnailImageUrl,
          hasRadius: true,
        ),
      WdsItemCardSize.md => WdsThumbnail.md(
          imagePath: widget.thumbnailImageUrl,
          hasRadius: true,
        ),
      WdsItemCardSize.xs => WdsThumbnail.xs(
          imagePath: widget.thumbnailImageUrl,
          hasRadius: true,
        ),
    };

    Widget? thumbnailImageWithLensPattern;
    if (widget.lensPatternImageUrl != null &&
        widget.lensPatternImageUrl!.isNotEmpty &&
        widget.size.lensPatternSize != null) {
      thumbnailImageWithLensPattern = Stack(
        children: [
          thumbnail,

          /// LENS PATTERN IMAGE
          Positioned(
            right: 10,
            bottom: 10,
            child: CachedNetworkImage(
              imageUrl: widget.lensPatternImageUrl!,
              width: widget.size.lensPatternSize!.width,
              height: widget.size.lensPatternSize!.height,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }

    if (widget.size == WdsItemCardSize.xl ||
        widget.size == WdsItemCardSize.lg) {
      return _VerticalLayout(
        thumbnail: thumbnailImageWithLensPattern ?? thumbnail,
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
      );
    }

    return _HorizontalLayout(
      thumbnail: thumbnailImageWithLensPattern ?? thumbnail,
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
  });

  final Widget thumbnail;
  final String brandName;
  final String productName;
  final String lensType;
  final String diameter;
  final double originalPrice;
  final double salePrice;
  final double rating;
  final int reviewCount;
  final int likeCount;
  final bool hasLiked;
  final List<WdsTag> tags;
  final VoidCallback onLiked;
  final WdsItemCardSize size;

  @override
  Widget build(BuildContext context) {
    final information = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: Text(
                brandName,
                style: WdsTypography.body13NormalRegular.copyWith(
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
        SizedBox(
          width: 155,
          child: Text(
            productName,
            style: WdsTypography.body13NormalMedium.copyWith(
              color: WdsColors.textNormal,
            ),
            maxLines: size == WdsItemCardSize.xl ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        __LensInfo.bySize(
          size: size,
          lensType: lensType,
          diameter: diameter,
        ),
        const SizedBox(height: 6),
        __PriceInfo.bySize(
          size: size,
          originalPrice: originalPrice,
          salePrice: salePrice,
        ),
        const SizedBox(height: 8),
        if (tags.isNotEmpty) ...[
          Row(spacing: 2, children: tags),
          const SizedBox(height: 12),
        ],
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
        if (size == WdsItemCardSize.xl)
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
  });

  final Widget thumbnail;
  final String brandName;
  final String productName;
  final String lensType;
  final String diameter;
  final double originalPrice;
  final double salePrice;
  final int likeCount;
  final bool hasLiked;
  final List<WdsTag> tags;
  final VoidCallback onLiked;
  final WdsItemCardSize size;

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = size == WdsItemCardSize.md ? 4.0 : 2.0;
    final horizontalSpacing = size == WdsItemCardSize.md ? 16.0 : 12.0;

    return SizedBox(
      height: size.thumnbnailSize.height,
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
                if (size == WdsItemCardSize.md) ...[
                  Text(
                    brandName,
                    style: WdsTypography.caption12Regular.copyWith(
                      color: WdsColors.textNeutral,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  productName,
                  style: switch (size) {
                    WdsItemCardSize.xl ||
                    WdsItemCardSize.lg =>
                      WdsTypography.body13NormalRegular,
                    _ => WdsTypography.caption12Medium,
                  }
                      .copyWith(color: WdsColors.textNormal),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                __LensInfo.bySize(
                  size: size,
                  lensType: lensType,
                  diameter: diameter,
                ),
                SizedBox(height: verticalSpacing),
                __PriceInfo.bySize(
                  size: size,
                  originalPrice: originalPrice,
                  salePrice: salePrice,
                ),
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
          __LikeButton(
            onTap: onLiked,
            hasLiked: hasLiked,
            isVertical: size == WdsItemCardSize.xs,
            likeCount: size == WdsItemCardSize.xs ? likeCount : null,
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
    final textStyle = switch (size) {
      WdsItemCardSize.xs => WdsTypography.caption11Regular,
      _ => WdsTypography.caption12Regular,
    }
        .copyWith(
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
  });

  final double originalPrice;

  final double salePrice;

  final WdsItemCardSize size;

  @override
  Widget build(BuildContext context) {
    final rate = originalPrice.getDiscountRate(salePrice);

    final finalSalePrice = Text(
      salePrice.toKRWFormat(),
      style: switch (size) {
        WdsItemCardSize.xl ||
        WdsItemCardSize.lg =>
          WdsTypography.body15NormalBold,
        WdsItemCardSize.md => WdsTypography.body13NormalBold,
        WdsItemCardSize.xs => WdsTypography.caption12Bold
      }
          .copyWith(color: WdsColors.textNormal),
    );

    if (rate <= 0) {
      return finalSalePrice;
    }

    final discountRate = Text(
      '$rate%',
      style: switch (size) {
        WdsItemCardSize.xl ||
        WdsItemCardSize.lg =>
          WdsTypography.body15NormalBold,
        WdsItemCardSize.md => WdsTypography.body13NormalBold,
        WdsItemCardSize.xs => WdsTypography.caption12Bold
      }
          .copyWith(color: WdsColors.secondary),
    );

    final salePriceAndDiscountRate = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        discountRate,
        const SizedBox(width: 4),
        finalSalePrice,
      ],
    );

    if (size != WdsItemCardSize.xl) {
      return salePriceAndDiscountRate;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
      height: 13,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          WdsIcon.starFilled.build(
            color: WdsColors.neutral200,
            width: 10,
            height: 10,
          ),
          Text(
            '${rating.clamp(0.0, 5.0).toStringAsFixed(1)}(${reviewCount.clamp(0, 999999).toFormat()})',
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
      height: 13,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          WdsNavigationIcon.like.build(
            color: WdsColors.neutral200,
            width: 10,
            height: 10,
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
    final icon = WdsNavigationIcon.like.build(
      color: hasLiked ? WdsColors.secondary : WdsColors.neutral200,
      isActive: hasLiked,
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
