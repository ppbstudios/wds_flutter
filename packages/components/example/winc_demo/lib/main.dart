import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wds_components/wds_components.dart';
import 'package:wds_foundation/wds_foundation.dart';

part 'src/data/mock_products.dart';

const double $maxMobileWidth = 767;
const double $maxMobileCrossAxisCountForTwo = 375;

extension on String {
  WdsTag toTag() => switch (this) {
    'NEW' => const WdsTag.$new(),
    'SALE' => const WdsTag.$sale(),
    'BEST' => const WdsTag.$best(),
    '쿠폰사용가능' => const WdsTag.$coupon(),
    _ => WdsTag.normal(label: this),
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const app = CupertinoApp(
      title: 'WDS Demo',
      home: WDSDemo(),
      debugShowCheckedModeBanner: false,
    );

    if (screenWidth > $maxMobileWidth) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: $maxMobileWidth,
            minWidth: 360,
          ),
          child: app,
        ),
      );
    }

    return app;
  }
}

class WDSDemo extends StatefulWidget {
  const WDSDemo({super.key});

  @override
  State<WDSDemo> createState() => _WDSDemoState();
}

class _WDSDemoState extends State<WDSDemo> {
  final PageController pageController = PageController();

  int currentIndex = 0;

  void onPageChanged(int index) {
    if (!mounted) return;

    pageController.jumpToPage(index);
    setState(() => currentIndex = index);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomeView(),
          const Center(child: Text('내 예약매장')),
          const Center(child: Text('카테고리')),
          const Center(child: Text('좋아요')),
          const Center(child: Text('마이윙크')),
        ],
      ),
      bottomNavigationBar: WdsBottomNavigation(
        items: [
          const WdsBottomNavigationItem(
            activeIcon: WdsIcon.homeFilled,
            inactiveIcon: WdsIcon.home,
            label: '홈',
          ),
          const WdsBottomNavigationItem(
            activeIcon: WdsIcon.storeFilled,
            inactiveIcon: WdsIcon.store,
            label: '내 예약매장',
          ),
          const WdsBottomNavigationItem(
            activeIcon: WdsIcon.categoryFilled,
            inactiveIcon: WdsIcon.category,
            label: '카테고리',
          ),
          const WdsBottomNavigationItem(
            activeIcon: WdsIcon.likeFilled,
            inactiveIcon: WdsIcon.like,
            label: '좋아요',
          ),
          const WdsBottomNavigationItem(
            activeIcon: WdsIcon.myFilled,
            inactiveIcon: WdsIcon.my,
            label: '마이윙크',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onPageChanged,
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final WdsTabsController tabController = WdsTabsController(length: 6);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WdsColors.white,
      appBar: WdsHeader.logo(
        actions: [
          WdsIconButton(
            onTap: () {
              debugPrint('search');
            },
            icon: WdsIcon.search.build(),
          ),
          WdsIconButton(
            onTap: () {
              debugPrint('cart');
            },
            icon: WdsIcon.cart.build(),
          ),
        ],
      ),
      body: Column(
        children: [
          ColoredBox(
            color: WdsColors.white,
            child: WdsTextTabs(
              controller: tabController,
              tabs: [
                const WdsTextTab(label: '추천'),
                const WdsTextTab(
                  label: '매장 단독 혜택',
                  badgeAlignment: Alignment.topRight,
                ),
                const WdsTextTab(label: '신상'),
                const WdsTextTab(label: '할인'),
                const WdsTextTab(label: '브랜드'),
                const WdsTextTab(label: '베스트'),
              ],
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: tabController,
              builder: (context, _) {
                return IndexedStack(
                  alignment: Alignment.topCenter,
                  index: tabController.index,
                  children: [
                    const HomeTab(),
                    const Center(child: Text('매장 단독 혜택')),
                    const Center(child: Text('신상')),
                    const Center(child: Text('할인')),
                    const Center(child: Text('브랜드')),
                    const Center(child: Text('베스트')),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  static const List<String> bannerImageUrls = [
    'https://cdn.winc.app/uploads/ppb/file/file/20220/main05__2_-459835.jpg',
    'https://cdn.winc.app/uploads/ppb/file/file/20632/main04__3_-84f6f7.jpg',
    'https://cdn.winc.app/uploads/ppb/file/file/19637/%EC%97%90%EC%96%B4%EB%A6%AC%EB%A1%9C%EC%A6%88-d793be.jpg',
    'https://cdn.winc.app/uploads/ppb/file/file/18703/%EB%A7%88%EC%9D%B4%ED%94%BC%ED%94%88-%EB%9D%BC%EB%B8%90-%EC%83%81%EC%8B%9C%EB%B0%B0%EB%84%88-2d4416.jpg',
    'https://cdn.winc.app/uploads/ppb/file/file/20766/main02__6_-80f52c.jpg',
    'https://cdn.winc.app/uploads/ppb/file/file/19635/%ED%82%A4%EC%9D%B4%EB%9D%BC-abeedd.jpg',
  ];

  static const List<(String, String)> quickMenuItems = [
    (
      '윙크스토어',
      'https://cdn.winc.app/uploads/ppb/file/file/18981/%EB%A7%88%EC%9D%B4%ED%94%BC%ED%94%88_%EC%BD%9C%EB%9D%BC%EB%B3%B4_%ED%80%B5%EB%A9%94%EB%89%B4-4a0a1f.png',
    ),
    (
      '한달용',
      'https://cdn.winc.app/uploads/ppb/file/file/12450/main-month-2bbf67.svg',
    ),
    (
      '하루용',
      'https://cdn.winc.app/uploads/ppb/file/file/12449/main-day-840bc3.svg',
    ),
    (
      '쿠폰함',
      'https://cdn.winc.app/uploads/ppb/file/file/12815/main-coupon-a13dd2.svg',
    ),
    (
      '매장찾기',
      'https://cdn.winc.app/uploads/ppb/file/file/12453/main-store-seache-f79fbc.svg',
    ),
    (
      '친구초대',
      'https://cdn.winc.app/uploads/ppb/file/file/12451/main-friend-4d9b03.svg',
    ),
  ];

  static const List<String> heading1Tabs = [
    '이번주신상',
    '블랙렌즈',
    '빅직경',
    '톤업렌즈',
    '작은직경',
    '브라운렌즈',
  ];

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final PageController pageController = PageController();

  Timer? timer;

  int heading1SelectedIndex = 0;

  int heading2SelectedIndex = 0;

  Set<int> heading1SelectedValues = {0};

  Set<int> heading2SelectedValues = {0};

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 5), (t) {
      if (!t.isActive || !pageController.hasClients) return;

      final currentPage = pageController.page?.toInt() ?? 0;

      if (currentPage == HomeTab.bannerImageUrls.length - 1) {
        pageController.jumpToPage(0);
      } else {
        pageController.animateToPage(
          currentPage + 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final ratio = MediaQuery.devicePixelRatioOf(context);

    final fixedCarouselHeight = min(size.width, $maxMobileWidth) * 0.92;

    return CustomScrollView(
      slivers: [
        /// CAROUSEL
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(WdsRadius.radius16),
              ),
              child: SizedBox(
                height: fixedCarouselHeight,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: pageController,
                      itemCount: HomeTab.bannerImageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          HomeTab.bannerImageUrls[index],
                          width: fixedCarouselHeight,
                          height: fixedCarouselHeight,
                          fit: BoxFit.cover,
                          cacheWidth: (fixedCarouselHeight * ratio).toInt(),
                        );
                      },
                    ),

                    /// INDICATOR
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: AnimatedBuilder(
                        animation: pageController,
                        builder: (_, __) => WdsCountPagination(
                          currentPage: (pageController.page?.toInt() ?? 0) + 1,
                          totalPage: HomeTab.bannerImageUrls.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        /// QUICK MENU ITEMS
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: SizedBox(
              height: 87,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: HomeTab.quickMenuItems.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = HomeTab.quickMenuItems[index];
                  final url = item.$2;

                  Widget icon;

                  if (url.isEmpty) {
                    icon = const _DefaultQuickItem();
                  } else if (url.endsWith('.svg')) {
                    icon = SvgPicture.network(
                      url,
                      width: 62,
                      height: 62,
                      errorBuilder: (_, __, ___) => const _DefaultQuickItem(),
                    );
                  } else {
                    icon = Image.network(url, width: 62, height: 62);
                  }

                  return SizedBox(
                    width: 62,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        icon,
                        const SizedBox(height: 9),
                        Text(
                          item.$1,
                          style: WdsTypography.caption12NormalRegular.copyWith(
                            color: WdsColors.textNormal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        /// HEADING: 키워드로 보는 인기 렌즈
        SliverToBoxAdapter(
          child: WdsHeading.large(
            title: '키워드로 보는 인기렌즈',
            moreText: '더보기',
            onMoreTap: () => debugPrint('more tapped'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 6)),

        /// CHIPS: 키워드로 보는 인기 렌즈
        SliverToBoxAdapter(
          child: SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: HomeTab.heading1Tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                EdgeInsets padding;
                if (index == 0) {
                  padding = const EdgeInsets.only(left: 16);
                } else if (index == HomeTab.heading1Tabs.length - 1) {
                  padding = const EdgeInsets.only(right: 16);
                } else {
                  padding = const EdgeInsets.symmetric(horizontal: 2);
                }

                final tab = HomeTab.heading1Tabs[index];

                return Padding(
                  padding: padding,
                  child: WdsChip.pill(
                    label: tab,
                    value: index,
                    groupValues: heading1SelectedValues,
                    onTap: () => setState(() {
                      heading1SelectedIndex = index;
                      heading1SelectedValues.clear();
                      heading1SelectedValues.add(index);
                    }),
                  ),
                );
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        /// PRODUCTS
        SliverLayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.crossAxisExtent;

            final crossAxisCount = width <= $maxMobileCrossAxisCountForTwo
                ? 2
                : 3;

            final scaleFactor =
                width /
                (WdsItemCardSize.xlarge.thumbnailSize.size.width *
                    crossAxisCount);

            final scaledThumnailHeight =
                WdsItemCardSize.xlarge.thumbnailSize.size.height * scaleFactor;

            final otherElementHeight =
                WdsItemCardSize.xlarge.cardHeight -
                WdsItemCardSize.xlarge.thumbnailSize.size.height;

            final totalCardHeight = scaledThumnailHeight + otherElementHeight;

            final itemWidth = width / crossAxisCount - 2 * (crossAxisCount - 1);

            final childAspectRatio = itemWidth / totalCardHeight;

            return SliverGrid.count(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: 30,
              crossAxisSpacing: 2,
              children: $dummyProducts
                  .map(
                    (product) => WdsItemCard.xlarge(
                      onLiked: () {},
                      thumbnailImageUrl: product.thumbnailImageUrl,
                      lensPatternImageUrl: product.lensPatternImageUrl,
                      brandName: product.brandName,
                      productName: product.productName,
                      lensType: product.lensType,
                      diameter: product.diameter,
                      originalPrice: product.originalPrice,
                      salePrice: product.salePrice ?? 0,
                      rating: product.rating,
                      reviewCount: product.reviewCount,
                      likeCount: product.likeCount,
                      tags: product.tags.map((tag) => tag.toTag()).toList(),
                      leftThumbnailTags: product.leftThumbnailTags
                          .map((tag) => tag.toTag())
                          .toList(),
                      rightThumbnailTag: product.rightThumbnailTag?.toTag(),
                      isSoldOut: product.isSoldOut,
                      scaleFactor: scaleFactor,
                    ),
                  )
                  .take(crossAxisCount == 2 ? 6 : 9)
                  .toList(),
            );
          },
        ),

        /// HEADING2: 키워드로 보는 인기 렌즈
        SliverToBoxAdapter(
          child: WdsHeading.large(
            title: '키워드로 보는 인기렌즈2',
            moreText: '더보기',
            onMoreTap: () => debugPrint('more tapped'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 6)),

        /// CHIPS2: 키워드로 보는 인기 렌즈
        SliverToBoxAdapter(
          child: SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: HomeTab.heading1Tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                EdgeInsets padding;
                if (index == 0) {
                  padding = const EdgeInsets.only(left: 16);
                } else if (index == HomeTab.heading1Tabs.length - 1) {
                  padding = const EdgeInsets.only(right: 16);
                } else {
                  padding = const EdgeInsets.symmetric(horizontal: 2);
                }

                final tab = HomeTab.heading1Tabs[index];

                return Padding(
                  padding: padding,
                  child: WdsChip.pill(
                    label: tab,
                    value: index,
                    groupValues: heading2SelectedValues,
                    onTap: () => setState(() {
                      heading2SelectedIndex = index;
                      heading2SelectedValues.clear();
                      heading2SelectedValues.add(index);
                    }),
                  ),
                );
              },
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final ratio = MediaQuery.devicePixelRatioOf(context);
              final scaleFactor = constraints.crossAxisExtent / 375;

              return SliverToBoxAdapter(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(WdsRadius.radius16),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        'https://cdn.winc.app/uploads/ppb/file/file/19157/%E1%84%89%E1%85%B3%E1%84%91%E1%85%B3%E1%86%AF%E1%84%85%E1%85%A2%E1%84%89%E1%85%B5_%E1%84%8B%E1%85%B5%E1%84%86%E1%85%B5%E1%84%8C%E1%85%B5_03-9c8383.jpg',
                        width: constraints.crossAxisExtent,
                        height: 200 * scaleFactor,
                        fit: BoxFit.cover,
                        cacheWidth: (constraints.crossAxisExtent * ratio)
                            .toInt(),
                        alignment: const Alignment(0, -0.25),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text(
                              '하파크리스틴',
                              style: WdsTypography.heading16Bold.copyWith(
                                color: WdsColors.white,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4,
                              children: [
                                WdsIcon.like.build(
                                  width: 12,
                                  height: 12,
                                  color: WdsColors.white,
                                ),
                                Text(
                                  '109명이 좋아합니다',
                                  style: WdsTypography.caption12NormalMedium
                                      .copyWith(color: WdsColors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        /// PRODUCTS
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.crossAxisExtent;

              final crossAxisCount = width <= $maxMobileCrossAxisCountForTwo
                  ? 2
                  : 3;

              return SliverList.separated(
                itemCount: $dummyProducts
                    .take(crossAxisCount == 2 ? 3 : 5)
                    .length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final product = $dummyProducts[index];

                  return WdsItemCard.small(
                    onLiked: () {},
                    thumbnailImageUrl: product.thumbnailImageUrl,
                    productName: product.productName,
                    lensType: product.lensType,
                    diameter: product.diameter,
                    originalPrice: product.originalPrice,
                    salePrice: product.salePrice ?? 0,
                    rating: product.rating,
                    reviewCount: product.reviewCount,
                    likeCount: product.likeCount,
                    tags: product.tags.map((tag) => tag.toTag()).toList(),
                    isSoldOut: product.isSoldOut,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DefaultQuickItem extends StatelessWidget {
  const _DefaultQuickItem();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: WdsColors.neutral50,
        borderRadius: BorderRadius.all(Radius.circular(WdsRadius.radius16)),
      ),
      child: SizedBox.square(dimension: 62),
    );
  }
}
