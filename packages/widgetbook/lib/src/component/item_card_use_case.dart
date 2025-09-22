import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const String productThumbnailUrl =
    'https://cdn.winc.app/uploads/ppb/image/src/81732/ppb_image_file-e110f7.jpg';

const String productLensPatternImageUrl =
    'https://cdn.winc.app/uploads/ppb/image/src/81734/ppb_image_file-3a9d58.png';

const String etcProductThumbnailUrl =
    'https://cdn.winc.app/uploads/ppb/image/src/20619/ppb_image_file-341e67.png';

const String setProductThumbnailUrl =
    'https://cdn.winc.app/uploads/ppb/image/src/84398/ppb_image_file-c06e8d.jpg';

@widgetbook.UseCase(
  name: 'ItemCard',
  type: ItemCard,
  path: '[component]/',
)
Widget buildWdsItemCardUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Item Card',
    description:
        '아이템 카드(Item cards)란 사용자에게 상품 정보를 집약적으로 전달하기 위한 요소입니다. 상품 정보(가격, 상품명, 리뷰, 혜택)를 명확하게 전달해 상세 페이지로 유도하는 목적을 가집니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      const _BuildDemonstrationSection(),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final size = context.knobs.object.dropdown<String>(
    label: 'size',
    options: ['xlarge', 'large', 'medium', 'xsmall'],
    initialOption: 'large',
    description: '카드의 크기와 레이아웃을 정의해요',
  );

  final thumbnailImageUrl = context.knobs.string(
    label: 'thumbnailImageUrl',
    description: '썸네일 이미지 URL을 설정해요',
    initialValue: productThumbnailUrl,
  );

  final lensPatternImageUrl = context.knobs.string(
    label: 'lensPatternImageUrl',
    description: '렌즈 패턴 이미지 URL을 설정해요',
    initialValue: productLensPatternImageUrl,
  );

  final brandName = context.knobs.string(
    label: 'brandName',
    initialValue: '하파크리스틴',
    description: '브랜드명을 설정해요',
  );

  final productName = context.knobs.string(
    label: 'productName',
    initialValue: '빈 크리스틴 원데이 드립브라운',
    description: '상품명을 설정해요',
  );

  final lensType = context.knobs.string(
    label: 'lensType',
    initialValue: '하루용',
    description: '렌즈 타입을 설정해요',
  );

  final diameter = context.knobs.string(
    label: 'diameter',
    initialValue: '14.2mm',
    description: '렌즈 직경을 설정해요',
  );

  final originalPrice = context.knobs.double.input(
    label: 'originalPrice',
    initialValue: 29900,
    description: '정상가를 설정해요',
  );

  final salePrice = context.knobs.double.input(
    label: 'salePrice',
    initialValue: 19900,
    description: '판매가를 설정해요',
  );

  final rating = context.knobs.double.slider(
    label: 'rating',
    initialValue: 4.5,
    min: 1,
    max: 5,
    description: '평점을 설정해요',
  );

  final reviewCount = context.knobs.int.input(
    label: 'reviewCount',
    initialValue: 4492,
    description: '리뷰 개수를 설정해요',
  );
  const int initialLikeCount = 2374;
  int likeCount = context.knobs.int.input(
    label: 'likeCount',
    initialValue: initialLikeCount,
    description: '좋아요 개수를 설정해요',
  );

  bool hasLiked = context.knobs.boolean(
    label: 'hasLiked',
    description: '좋아요 상태를 설정해요',
  );

  final showTags = context.knobs.boolean(
    label: 'showTags',
    initialValue: true,
    description: '태그 표시 여부를 설정해요',
  );

  final tags = showTags
      ? [
          const WdsTag.normal(label: 'NEW'),
          const WdsTag(label: 'HOT', color: WdsColors.secondary),
          const WdsTag.filled(label: '바로드림'),
        ]
      : <WdsTag>[];

  void onLiked() {
    debugPrint('Item liked: hasLiked=$hasLiked');

    final state = WidgetbookState.maybeOf(context);

    hasLiked = !hasLiked;
    likeCount = initialLikeCount + (hasLiked ? 1 : 0);

    state?.updateQueryField(
      group: 'knobs',
      field: 'hasLiked',
      value: hasLiked.toString(),
    );

    state?.updateQueryField(
      group: 'knobs',
      field: 'likeCount',
      value: likeCount.toString(),
    );
  }

  final sizeValue = switch (size) {
    'xlarge' => WdsItemCardSize.xlarge,
    'large' => WdsItemCardSize.large,
    'medium' => WdsItemCardSize.medium,
    'xsmall' => WdsItemCardSize.xsmall,
    _ => WdsItemCardSize.large,
  };

  final itemCard = switch (sizeValue) {
    WdsItemCardSize.xlarge => WdsItemCard.xlarge(
        onLiked: onLiked,
        thumbnailImageUrl: thumbnailImageUrl,
        lensPatternImageUrl: lensPatternImageUrl,
        brandName: brandName,
        productName: productName,
        lensType: lensType,
        diameter: diameter,
        originalPrice: originalPrice,
        salePrice: salePrice,
        rating: rating,
        reviewCount: reviewCount,
        likeCount: likeCount,
        hasLiked: hasLiked,
        tags: tags,
      ),
    WdsItemCardSize.large => WdsItemCard.large(
        onLiked: onLiked,
        thumbnailImageUrl: thumbnailImageUrl,
        lensPatternImageUrl: lensPatternImageUrl,
        brandName: brandName,
        productName: productName,
        lensType: lensType,
        diameter: diameter,
        originalPrice: originalPrice,
        salePrice: salePrice,
        rating: rating,
        reviewCount: reviewCount,
        likeCount: likeCount,
        hasLiked: hasLiked,
        tags: tags,
      ),
    WdsItemCardSize.medium => WdsItemCard.medium(
        onLiked: onLiked,
        thumbnailImageUrl: thumbnailImageUrl,
        lensPatternImageUrl: lensPatternImageUrl,
        brandName: brandName,
        productName: productName,
        lensType: lensType,
        diameter: diameter,
        originalPrice: originalPrice,
        salePrice: salePrice,
        rating: rating,
        reviewCount: reviewCount,
        likeCount: likeCount,
        hasLiked: hasLiked,
        tags: tags,
      ),
    WdsItemCardSize.xsmall => WdsItemCard.xsmall(
        onLiked: onLiked,
        thumbnailImageUrl: thumbnailImageUrl,
        productName: productName,
        lensType: lensType,
        diameter: diameter,
        originalPrice: originalPrice,
        salePrice: salePrice,
        rating: rating,
        reviewCount: reviewCount,
        likeCount: likeCount,
        hasLiked: hasLiked,
        tags: tags,
      ),
  };

  return WidgetbookPlayground(
    info: [
      'Size: $size',
      'Brand: $brandName',
      'Product: $productName',
      'Original Price: ${originalPrice.toInt()}원',
      'Sale Price: ${salePrice.toInt()}원',
      'Rating: ${rating.toStringAsFixed(1)}',
      'Reviews: $reviewCount',
      'Likes: $likeCount',
      'Has Liked: $hasLiked',
      'Tags: ${showTags ? 'Visible' : 'Hidden'}',
    ],
    child: Center(
      child: SizedBox(
        width: sizeValue == WdsItemCardSize.xlarge ||
                sizeValue == WdsItemCardSize.large
            ? switch (sizeValue) {
                WdsItemCardSize.xlarge => WdsThumbnailSize.xlarge.size.width,
                _ => WdsThumbnailSize.large.size.width,
              }
            : 350, // Horizontal cards - wider
        child: itemCard,
      ),
    ),
  );
}

class _BuildDemonstrationSection extends StatefulWidget {
  const _BuildDemonstrationSection();

  @override
  State<_BuildDemonstrationSection> createState() =>
      __BuildDemonstrationSectionState();
}

class __BuildDemonstrationSectionState
    extends State<_BuildDemonstrationSection> {
  final hasLikedMap = {
    WdsItemCardSize.xlarge: false,
    WdsItemCardSize.large: false,
    WdsItemCardSize.medium: false,
    WdsItemCardSize.xsmall: false,
  };

  late final likedMapByTitle = {
    'variant': Map<WdsItemCardSize, bool>.from(hasLikedMap),
    'case_0': Map<WdsItemCardSize, bool>.from(hasLikedMap),
    'case_1': Map<WdsItemCardSize, bool>.from(hasLikedMap),
    'case_2': Map<WdsItemCardSize, bool>.from(hasLikedMap),
    'case_3': Map<WdsItemCardSize, bool>.from(hasLikedMap),
    'case_4': Map<WdsItemCardSize, bool>.from(hasLikedMap),
  };

  int getLikeCount(String key, WdsItemCardSize size) {
    if (!likedMapByTitle.containsKey(key) ||
        !likedMapByTitle[key]!.containsKey(size)) {
      return 0;
    }

    final hasLiked = likedMapByTitle[key]![size] ?? false;

    return 9878 + (hasLiked ? 1 : 0);
  }

  bool getHasLiked(String key, WdsItemCardSize size) {
    if (!likedMapByTitle.containsKey(key) ||
        !likedMapByTitle[key]!.containsKey(size)) {
      return false;
    }

    return likedMapByTitle[key]![size] ?? false;
  }

  void onLiked(String key, WdsItemCardSize size) {
    if (!likedMapByTitle.containsKey(key) ||
        !likedMapByTitle[key]!.containsKey(size)) {
      return;
    }

    final hasLiked = likedMapByTitle[key]![size] ?? false;
    setState(() => likedMapByTitle[key]![size] = !hasLiked);
  }

  @override
  Widget build(BuildContext context) {
    return WidgetbookSection(
      title: 'ItemCard',
      children: [
        WidgetbookSubsection(
          title: 'variant',
          labels: ['xlarge', 'large', 'medium', 'xsmall'],
          content: Wrap(
            runSpacing: 24,
            spacing: 24,
            children: [
              SizedBox(
                width: WdsThumbnailSize.xlarge.size.width,
                child: WdsItemCard.xlarge(
                  onLiked: () => onLiked('variant', WdsItemCardSize.xlarge),
                  hasLiked: getHasLiked('variant', WdsItemCardSize.xlarge),
                  thumbnailImageUrl: productThumbnailUrl,
                  lensPatternImageUrl: productLensPatternImageUrl,
                  brandName: '하파크리스틴',
                  productName: '빈 크리스틴 원데이 드립브라운',
                  lensType: '하루용',
                  diameter: '14.2mm',
                  originalPrice: 29900,
                  salePrice: 19900,
                  rating: 4.5,
                  reviewCount: 4342,
                  likeCount: getLikeCount('variant', WdsItemCardSize.xlarge),
                  tags: const [
                    WdsTag.normal(label: 'NEW'),
                    WdsTag(
                      label: '새학기',
                      color: WdsColors.blue400,
                      backgroundColor: WdsColors.coolNeutral50,
                    ),
                    WdsTag.filled(label: '베스트'),
                  ],
                ),
              ),
              SizedBox(
                width: WdsThumbnailSize.large.size.width,
                child: WdsItemCard.large(
                  onLiked: () => onLiked('variant', WdsItemCardSize.large),
                  hasLiked: getHasLiked('variant', WdsItemCardSize.large),
                  thumbnailImageUrl: productThumbnailUrl,
                  lensPatternImageUrl: productLensPatternImageUrl,
                  brandName: '하파크리스틴',
                  productName: '빈 크리스틴 원데이 드립브라운',
                  lensType: '하루용',
                  diameter: '14.2mm',
                  originalPrice: 29900,
                  salePrice: 19900,
                  rating: 4.5,
                  reviewCount: 4342,
                  likeCount: getLikeCount('variant', WdsItemCardSize.large),
                  tags: const [
                    WdsTag.normal(label: '신상품'),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                height: WdsThumbnailSize.medium.size.height,
                child: WdsItemCard.medium(
                  onLiked: () => onLiked('variant', WdsItemCardSize.medium),
                  hasLiked: getHasLiked('variant', WdsItemCardSize.medium),
                  thumbnailImageUrl: productThumbnailUrl,
                  lensPatternImageUrl: productLensPatternImageUrl,
                  brandName: '하파크리스틴',
                  productName: '빈 크리스틴 원데이 드립브라운',
                  lensType: '하루용',
                  diameter: '14.2mm',
                  originalPrice: 29900,
                  salePrice: 19900,
                  rating: 4.5,
                  reviewCount: 1234,
                  likeCount: getLikeCount('variant', WdsItemCardSize.medium),
                  tags: const [
                    WdsTag.filled(label: '베스트'),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                height: WdsThumbnailSize.xsmall.size.height,
                child: WdsItemCard.xsmall(
                  onLiked: () => onLiked('variant', WdsItemCardSize.xsmall),
                  hasLiked: getHasLiked('variant', WdsItemCardSize.xsmall),
                  thumbnailImageUrl: productThumbnailUrl,
                  productName: '빈 크리스틴 원데이 드립브라운',
                  lensType: '하루용',
                  diameter: '14.2mm',
                  originalPrice: 29900,
                  salePrice: 19900,
                  rating: 4.5,
                  reviewCount: 127,
                  likeCount: getLikeCount('variant', WdsItemCardSize.xsmall),
                ),
              ),
            ],
          ),
        ),

        /// case
        WidgetbookSubsection(
          title: 'case',
          labels: ['일반상품(정가))', '일반상품(할인)', '품절', 'ETC', '세트상품'],
          content: Wrap(
            runSpacing: 24,
            spacing: 24,
            children: [
              /// 일반상품(정가)
              Wrap(
                runSpacing: 24,
                spacing: 24,
                children: [
                  SizedBox(
                    width: WdsThumbnailSize.xlarge.size.width,
                    child: WdsItemCard.xlarge(
                      onLiked: () => onLiked('case_0', WdsItemCardSize.xlarge),
                      thumbnailImageUrl: productThumbnailUrl,
                      lensPatternImageUrl: productLensPatternImageUrl,
                      brandName: '하파크리스틴',
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_0', WdsItemCardSize.xlarge),
                      likeCount: getLikeCount('case_0', WdsItemCardSize.xlarge),
                      tags: [
                        const WdsTag.normal(label: '내 도수보유'),
                        const WdsTag(label: '바로드림', color: WdsColors.primary),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: WdsThumbnailSize.large.size.width,
                    child: WdsItemCard.large(
                      onLiked: () => onLiked('case_0', WdsItemCardSize.large),
                      thumbnailImageUrl: productThumbnailUrl,
                      lensPatternImageUrl: productLensPatternImageUrl,
                      brandName: '하파크리스틴',
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_0', WdsItemCardSize.large),
                      likeCount: getLikeCount('case_0', WdsItemCardSize.large),
                      tags: [
                        const WdsTag.normal(label: '내 도수보유'),
                        const WdsTag(label: '바로드림', color: WdsColors.primary),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: WdsThumbnailSize.medium.size.height,
                    child: WdsItemCard.medium(
                      onLiked: () => onLiked('case_0', WdsItemCardSize.medium),
                      thumbnailImageUrl: productThumbnailUrl,
                      lensPatternImageUrl: productLensPatternImageUrl,
                      brandName: '하파크리스틴',
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_0', WdsItemCardSize.medium),
                      likeCount: getLikeCount('case_0', WdsItemCardSize.medium),
                      tags: [
                        const WdsTag.normal(label: '내 도수보유'),
                        const WdsTag(label: '바로드림', color: WdsColors.primary),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: WdsThumbnailSize.xsmall.size.height,
                    child: WdsItemCard.xsmall(
                      onLiked: () => onLiked('case_0', WdsItemCardSize.xsmall),
                      thumbnailImageUrl: productThumbnailUrl,
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_0', WdsItemCardSize.xsmall),
                      likeCount: getLikeCount('case_0', WdsItemCardSize.xsmall),
                    ),
                  ),
                ],
              ),

              /// 일반상품(할인)
              Wrap(
                runSpacing: 24,
                spacing: 24,
                children: [
                  SizedBox(
                    width: WdsThumbnailSize.xlarge.size.width,
                    child: WdsItemCard.xlarge(
                      onLiked: () => onLiked('case_1', WdsItemCardSize.xlarge),
                      thumbnailImageUrl: productThumbnailUrl,
                      lensPatternImageUrl: productLensPatternImageUrl,
                      brandName: '하파크리스틴',
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_1', WdsItemCardSize.xlarge),
                      likeCount: getLikeCount('case_1', WdsItemCardSize.xlarge),
                      tags: const [
                        WdsTag.normal(label: '내 도수보유'),
                        WdsTag(label: '바로드림', color: WdsColors.primary),
                      ],
                      leftThumbnailTags: const [
                        WdsTag.$new(),
                        WdsTag.$sale(),
                        WdsTag.$best(),
                      ],
                      rightThumbnailTag: const WdsTag.$coupon(),
                    ),
                  ),
                  SizedBox(
                    width: WdsThumbnailSize.large.size.width,
                    child: WdsItemCard.large(
                      onLiked: () => onLiked('case_1', WdsItemCardSize.large),
                      thumbnailImageUrl: productThumbnailUrl,
                      lensPatternImageUrl: productLensPatternImageUrl,
                      brandName: '하파크리스틴',
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_1', WdsItemCardSize.large),
                      likeCount: getLikeCount('case_1', WdsItemCardSize.large),
                      tags: const [
                        WdsTag.normal(label: '내 도수보유'),
                        WdsTag(label: '바로드림', color: WdsColors.primary),
                      ],
                      leftThumbnailTags: const [
                        WdsTag.$new(),
                        WdsTag.$sale(),
                        WdsTag.$best(),
                      ],
                      rightThumbnailTag: const WdsTag.$coupon(),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: WdsThumbnailSize.medium.size.height,
                    child: WdsItemCard.medium(
                      onLiked: () => onLiked('case_1', WdsItemCardSize.medium),
                      thumbnailImageUrl: productThumbnailUrl,
                      lensPatternImageUrl: productLensPatternImageUrl,
                      brandName: '하파크리스틴',
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_1', WdsItemCardSize.medium),
                      likeCount: getLikeCount('case_1', WdsItemCardSize.medium),
                      tags: [
                        const WdsTag.normal(label: '내 도수보유'),
                        const WdsTag(label: '바로드림', color: WdsColors.primary),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: WdsThumbnailSize.xsmall.size.height,
                    child: WdsItemCard.xsmall(
                      onLiked: () => onLiked('case_1', WdsItemCardSize.xsmall),
                      thumbnailImageUrl: productThumbnailUrl,
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_1', WdsItemCardSize.xsmall),
                      likeCount: getLikeCount('case_1', WdsItemCardSize.xsmall),
                      tags: [
                        const WdsTag.normal(label: '내 도수보유'),
                        const WdsTag(label: '바로드림', color: WdsColors.primary),
                      ],
                    ),
                  ),
                ],
              ),

              /// 품절
              Wrap(
                runSpacing: 24,
                spacing: 24,
                children: [
                  SizedBox(
                    width: WdsThumbnailSize.xlarge.size.width,
                    child: WdsItemCard.xlarge(
                      onLiked: () => onLiked('case_2', WdsItemCardSize.xlarge),
                      thumbnailImageUrl: productThumbnailUrl,
                      lensPatternImageUrl: productLensPatternImageUrl,
                      brandName: '하파크리스틴',
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      isSoldOut: true,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_2', WdsItemCardSize.xlarge),
                      likeCount: getLikeCount('case_2', WdsItemCardSize.xlarge),
                      tags: const [
                        WdsTag.normal(label: '내 도수보유'),
                        WdsTag(label: '바로드림', color: WdsColors.primary),
                      ],
                      leftThumbnailTags: const [
                        WdsTag.$new(),
                        WdsTag.$sale(),
                        WdsTag.$best(),
                      ],
                      rightThumbnailTag: const WdsTag.$coupon(),
                    ),
                  ),
                  SizedBox(
                    width: WdsThumbnailSize.large.size.width,
                    child: WdsItemCard.large(
                      onLiked: () => onLiked('case_2', WdsItemCardSize.large),
                      thumbnailImageUrl: productThumbnailUrl,
                      lensPatternImageUrl: productLensPatternImageUrl,
                      brandName: '하파크리스틴',
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      isSoldOut: true,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_2', WdsItemCardSize.large),
                      likeCount: getLikeCount('case_2', WdsItemCardSize.large),
                      leftThumbnailTags: const [
                        WdsTag.$new(),
                      ],
                      rightThumbnailTag: const WdsTag.$coupon(),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: WdsThumbnailSize.medium.size.height,
                    child: WdsItemCard.medium(
                      onLiked: () => onLiked('case_2', WdsItemCardSize.medium),
                      thumbnailImageUrl: productThumbnailUrl,
                      lensPatternImageUrl: productLensPatternImageUrl,
                      brandName: '하파크리스틴',
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      isSoldOut: true,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_2', WdsItemCardSize.medium),
                      likeCount: getLikeCount('case_2', WdsItemCardSize.medium),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: WdsThumbnailSize.xsmall.size.height,
                    child: WdsItemCard.xsmall(
                      onLiked: () => onLiked('case_2', WdsItemCardSize.xsmall),
                      thumbnailImageUrl: productThumbnailUrl,
                      productName: '빈 크리스틴 원데이 드립브라운',
                      lensType: '하루용',
                      diameter: '14.2mm',
                      originalPrice: 29900,
                      salePrice: 29900,
                      isSoldOut: true,
                      rating: 4.51,
                      reviewCount: 12345,
                      hasLiked: getHasLiked('case_2', WdsItemCardSize.xsmall),
                      likeCount: getLikeCount('case_2', WdsItemCardSize.xsmall),
                    ),
                  ),
                ],
              ),

              /// ETC
              Wrap(
                runSpacing: 24,
                spacing: 24,
                children: [
                  SizedBox(
                    width: WdsThumbnailSize.xlarge.size.width,
                    child: WdsItemCard.xlarge(
                      onLiked: () => onLiked('case_3', WdsItemCardSize.xlarge),
                      thumbnailImageUrl: etcProductThumbnailUrl,
                      brandName: '젬아워',
                      productName: '젬아워 렌즈케이스 퍼플',
                      lensType: null,
                      diameter: null,
                      originalPrice: 3000,
                      salePrice: 3000,
                      rating: 4.23,
                      reviewCount: 123,
                      hasLiked: getHasLiked('case_3', WdsItemCardSize.xlarge),
                      likeCount: getLikeCount('case_3', WdsItemCardSize.xlarge),
                    ),
                  ),
                  SizedBox(
                    width: WdsThumbnailSize.large.size.width,
                    child: WdsItemCard.large(
                      onLiked: () => onLiked('case_3', WdsItemCardSize.large),
                      thumbnailImageUrl: etcProductThumbnailUrl,
                      brandName: '젬아워',
                      productName: '젬아워 렌즈케이스 퍼플',
                      lensType: null,
                      diameter: null,
                      originalPrice: 3000,
                      salePrice: 3000,
                      rating: 4.23,
                      reviewCount: 123,
                      hasLiked: getHasLiked('case_3', WdsItemCardSize.large),
                      likeCount: getLikeCount('case_3', WdsItemCardSize.large),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: WdsThumbnailSize.medium.size.height,
                    child: WdsItemCard.medium(
                      onLiked: () => onLiked('case_3', WdsItemCardSize.medium),
                      thumbnailImageUrl: etcProductThumbnailUrl,
                      brandName: '젬아워',
                      productName: '젬아워 렌즈케이스 퍼플',
                      lensType: null,
                      diameter: null,
                      originalPrice: 3000,
                      salePrice: 3000,
                      rating: 4.23,
                      reviewCount: 123,
                      hasLiked: getHasLiked('case_3', WdsItemCardSize.medium),
                      likeCount: getLikeCount('case_3', WdsItemCardSize.medium),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: WdsThumbnailSize.xsmall.size.height,
                    child: WdsItemCard.xsmall(
                      onLiked: () => onLiked('case_3', WdsItemCardSize.xsmall),
                      thumbnailImageUrl: etcProductThumbnailUrl,
                      productName: '젬아워 렌즈케이스 퍼플',
                      lensType: null,
                      diameter: null,
                      originalPrice: 3000,
                      salePrice: 3000,
                      rating: 4.23,
                      reviewCount: 123,
                      hasLiked: getHasLiked('case_3', WdsItemCardSize.xsmall),
                      likeCount: getLikeCount('case_3', WdsItemCardSize.xsmall),
                    ),
                  ),
                ],
              ),

              /// 새트상품
              Wrap(
                runSpacing: 24,
                spacing: 24,
                children: [
                  SizedBox(
                    width: WdsThumbnailSize.xlarge.size.width,
                    child: WdsItemCard.xlarge(
                      onLiked: () => onLiked('case_4', WdsItemCardSize.xlarge),
                      thumbnailImageUrl: setProductThumbnailUrl,
                      brandName: '윙크',
                      productName: '[원데이] 첫사랑 렌즈 2팩 골라담기',
                      lensType: null,
                      diameter: null,
                      originalPrice: 50000,
                      salePrice: 50000,
                      rating: 3.95,
                      reviewCount: 99,
                      hasLiked: getHasLiked('case_4', WdsItemCardSize.xlarge),
                      likeCount: getLikeCount('case_4', WdsItemCardSize.xlarge),
                      rightThumbnailTag: const WdsTag.$coupon(),
                    ),
                  ),
                  SizedBox(
                    width: WdsThumbnailSize.large.size.width,
                    child: WdsItemCard.large(
                      onLiked: () => onLiked('case_4', WdsItemCardSize.large),
                      thumbnailImageUrl: setProductThumbnailUrl,
                      brandName: '윙크',
                      productName: '[원데이] 첫사랑 렌즈 2팩 골라담기',
                      lensType: null,
                      diameter: null,
                      originalPrice: 50000,
                      salePrice: 50000,
                      rating: 3.95,
                      reviewCount: 99,
                      hasLiked: getHasLiked('case_4', WdsItemCardSize.large),
                      likeCount: getLikeCount('case_4', WdsItemCardSize.large),
                      rightThumbnailTag: const WdsTag.$coupon(),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: WdsThumbnailSize.medium.size.height,
                    child: WdsItemCard.medium(
                      onLiked: () => onLiked('case_4', WdsItemCardSize.medium),
                      thumbnailImageUrl: setProductThumbnailUrl,
                      brandName: '윙크',
                      productName: '[원데이] 첫사랑 렌즈 2팩 골라담기',
                      lensType: null,
                      diameter: null,
                      originalPrice: 50000,
                      salePrice: 50000,
                      rating: 3.95,
                      reviewCount: 99,
                      hasLiked: getHasLiked('case_4', WdsItemCardSize.medium),
                      likeCount: getLikeCount('case_4', WdsItemCardSize.medium),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: WdsThumbnailSize.xsmall.size.height,
                    child: WdsItemCard.xsmall(
                      onLiked: () => onLiked('case_4', WdsItemCardSize.xsmall),
                      thumbnailImageUrl: setProductThumbnailUrl,
                      productName: '[원데이] 첫사랑 렌즈 2팩 골라담기',
                      lensType: null,
                      diameter: null,
                      originalPrice: 50000,
                      salePrice: 50000,
                      rating: 3.95,
                      reviewCount: 99,
                      hasLiked: getHasLiked('case_4', WdsItemCardSize.xsmall),
                      likeCount: getLikeCount('case_4', WdsItemCardSize.xsmall),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
