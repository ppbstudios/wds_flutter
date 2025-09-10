import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const String productThumbnailUrl =
    'https://cdn.winc.app/uploads/ppb/image/src/81732/ppb_image_file-e110f7.jpg';

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
    options: ['xl', 'lg', 'md', 'xs'],
    initialOption: 'lg',
    description: '카드의 크기와 레이아웃을 정의해요',
  );

  final thumbnailImageUrl = context.knobs.string(
    label: 'thumbnailImageUrl',
    description: '썸네일 이미지 URL을 설정해요',
    initialValue: productThumbnailUrl,
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

  int likeCount = context.knobs.int.input(
    label: 'likeCount',
    initialValue: 2374,
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

    state?.updateQueryField(
      group: 'knobs',
      field: 'hasLiked',
      value: hasLiked.toString(),
    );
    state?.updateQueryField(
      group: 'knobs',
      field: 'likeCount',
      value: (likeCount + 1).toString(),
    );
  }

  final sizeValue = switch (size) {
    'xl' => WdsItemCardSize.xl,
    'lg' => WdsItemCardSize.lg,
    'md' => WdsItemCardSize.md,
    'xs' => WdsItemCardSize.xs,
    _ => WdsItemCardSize.lg,
  };

  final itemCard = switch (sizeValue) {
    WdsItemCardSize.xl => WdsItemCard.xl(
        onLiked: onLiked,
        thumbnailImageUrl: thumbnailImageUrl,
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
    WdsItemCardSize.lg => WdsItemCard.lg(
        onLiked: onLiked,
        thumbnailImageUrl: thumbnailImageUrl,
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
    WdsItemCardSize.md => WdsItemCard.md(
        onLiked: onLiked,
        thumbnailImageUrl: thumbnailImageUrl,
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
    WdsItemCardSize.xs => WdsItemCard.xs(
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
        width:
            sizeValue == WdsItemCardSize.xl || sizeValue == WdsItemCardSize.lg
                ? switch (sizeValue) {
                    WdsItemCardSize.xl => WdsThumbnailSize.xl.size.width,
                    _ => WdsThumbnailSize.lg.size.width,
                  }
                : 350, // Horizontal cards - wider
        child: itemCard,
      ),
    ),
  );
}

class _BuildDemonstrationSection extends StatefulWidget {
  const _BuildDemonstrationSection({super.key});

  @override
  State<_BuildDemonstrationSection> createState() =>
      __BuildDemonstrationSectionState();
}

class __BuildDemonstrationSectionState
    extends State<_BuildDemonstrationSection> {
  final hasLikedMap = {
    WdsItemCardSize.xl: false,
    WdsItemCardSize.lg: false,
    WdsItemCardSize.md: false,
    WdsItemCardSize.xs: false,
  };

  int getLikeCount(WdsItemCardSize size) {
    return 9878 + ((hasLikedMap[size] ?? false) ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return WidgetbookSection(
      title: 'ItemCard',
      children: [
        WidgetbookSubsection(
          title: 'variant',
          labels: ['xl', 'lg', 'md', 'xs'],
          content: Wrap(
            runSpacing: 24,
            spacing: 24,
            children: [
              SizedBox(
                width: WdsThumbnailSize.xl.size.width,
                child: WdsItemCard.xl(
                  onLiked: () => setState(
                    () => hasLikedMap[WdsItemCardSize.xl] =
                        !(hasLikedMap[WdsItemCardSize.xl] ?? false),
                  ),
                  hasLiked: hasLikedMap[WdsItemCardSize.xl] ?? false,
                  thumbnailImageUrl: productThumbnailUrl,
                  brandName: '하파크리스틴',
                  productName: '빈 크리스틴 원데이 드립브라운',
                  lensType: '하루용',
                  diameter: '14.2mm',
                  originalPrice: 29900,
                  salePrice: 19900,
                  rating: 4.5,
                  reviewCount: 4342,
                  likeCount: getLikeCount(WdsItemCardSize.xl),
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
                width: WdsThumbnailSize.lg.size.width,
                child: WdsItemCard.lg(
                  onLiked: () => setState(
                    () => hasLikedMap[WdsItemCardSize.lg] =
                        !(hasLikedMap[WdsItemCardSize.lg] ?? false),
                  ),
                  hasLiked: hasLikedMap[WdsItemCardSize.lg] ?? false,
                  thumbnailImageUrl: productThumbnailUrl,
                  brandName: '하파크리스틴',
                  productName: '빈 크리스틴 원데이 드립브라운',
                  lensType: '하루용',
                  diameter: '14.2mm',
                  originalPrice: 29900,
                  salePrice: 19900,
                  rating: 4.5,
                  reviewCount: 4342,
                  likeCount: getLikeCount(WdsItemCardSize.lg),
                  tags: const [
                    WdsTag.normal(label: '신상품'),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                height: WdsThumbnailSize.md.size.height,
                child: WdsItemCard.md(
                  onLiked: () => setState(
                    () => hasLikedMap[WdsItemCardSize.md] =
                        !(hasLikedMap[WdsItemCardSize.md] ?? false),
                  ),
                  hasLiked: hasLikedMap[WdsItemCardSize.md] ?? false,
                  thumbnailImageUrl: productThumbnailUrl,
                  brandName: '하파크리스틴',
                  productName: '빈 크리스틴 원데이 드립브라운',
                  lensType: '하루용',
                  diameter: '14.2mm',
                  originalPrice: 29900,
                  salePrice: 19900,
                  rating: 4.5,
                  reviewCount: 1234,
                  likeCount: getLikeCount(WdsItemCardSize.md),
                  tags: const [
                    WdsTag.filled(label: '베스트'),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                height: WdsThumbnailSize.xs.size.height,
                child: WdsItemCard.xs(
                  onLiked: () => setState(
                    () => hasLikedMap[WdsItemCardSize.xs] =
                        !(hasLikedMap[WdsItemCardSize.xs] ?? false),
                  ),
                  hasLiked: hasLikedMap[WdsItemCardSize.xs] ?? false,
                  thumbnailImageUrl: productThumbnailUrl,
                  productName: '빈 크리스틴 원데이 드립브라운',
                  lensType: '하루용',
                  diameter: '14.2mm',
                  originalPrice: 29900,
                  salePrice: 19900,
                  rating: 4.5,
                  reviewCount: 127,
                  likeCount: getLikeCount(WdsItemCardSize.xs),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
