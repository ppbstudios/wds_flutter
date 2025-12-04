part of '../wds_icon.dart';

enum WdsIcon implements IconBuilder {
  ask(path: 'assets/vector/ask.svg'),
  blank(path: 'assets/vector/blank.svg'),
  call(path: 'assets/vector/call.svg'),
  camera(path: 'assets/vector/camera.svg'),
  card(path: 'assets/vector/card.svg'),
  cart(path: 'assets/vector/cart.svg'),
  category(path: 'assets/vector/category.svg'),
  categoryFilled(path: 'assets/vector/category_filled.svg'),
  check(path: 'assets/vector/check.svg'),
  chevronDown(path: 'assets/vector/chevron_down.svg'),
  chevronLeft(path: 'assets/vector/chevron_left.svg'),
  chevronRight(path: 'assets/vector/chevron_right.svg'),
  chevronUp(path: 'assets/vector/chevron_up.svg'),
  circleCheckedFilled(path: 'assets/vector/circle_checked_filled.svg'),
  circleClose(path: 'assets/vector/circle_close.svg'),
  circleCloseFilled(path: 'assets/vector/circle_close_filled.svg'),
  clock(path: 'assets/vector/clock.svg'),
  close(path: 'assets/vector/close.svg'),
  circle(path: 'assets/vector/circle.svg'),
  comment(path: 'assets/vector/comment.svg'),
  download(path: 'assets/vector/download.svg'),
  home(path: 'assets/vector/home.svg'),
  homeFilled(path: 'assets/vector/home_filled.svg'),
  image(path: 'assets/vector/image.svg'),
  info(path: 'assets/vector/info.svg'),
  infoFilled(path: 'assets/vector/info_filled.svg'),
  minus(path: 'assets/vector/minus.svg'),
  like(path: 'assets/vector/like.svg'),
  likeFilled(path: 'assets/vector/like_filled.svg'),
  my(path: 'assets/vector/my.svg'),
  myFilled(path: 'assets/vector/my_filled.svg'),
  parking(path: 'assets/vector/parking.svg'),
  pin(path: 'assets/vector/pin.svg'),
  plus(path: 'assets/vector/plus.svg'),
  priceDown(path: 'assets/vector/price_down.svg'),
  productTag(path: 'assets/vector/product_tag.svg'),
  question(path: 'assets/vector/question.svg'),
  questionFilled(path: 'assets/vector/question_filled.svg'),
  refund(path: 'assets/vector/refund.svg'),
  refresh(path: 'assets/vector/refresh.svg'),
  sale(path: 'assets/vector/sale.svg'),
  scan(path: 'assets/vector/scan.svg'),
  search(path: 'assets/vector/search.svg'),
  settings(path: 'assets/vector/settings.svg'),
  share(path: 'assets/vector/share.svg'),
  star(path: 'assets/vector/star.svg'),
  starFilled(path: 'assets/vector/star_filled.svg'),
  starHalfFilled(path: 'assets/vector/star_half_filled.svg'),
  store(path: 'assets/vector/store.svg'),
  storeFilled(path: 'assets/vector/store_filled.svg'),
  support(path: 'assets/vector/support.svg'),
  thumbnail(path: 'assets/vector/thumbnail.svg'),
  wincLogo(path: 'assets/vector/winc_logo.svg'),
  wincLogoKo(path: 'assets/vector/winc_logo_ko.svg'),
  officialWincLogo(path: 'assets/vector/official_winc_logo.svg');

  const WdsIcon({
    required this.path,
  });

  final String path;

  @override
  Widget build({
    Color? color,
    double? width,
    double? height,
  }) {
    final iconWidth = width ?? 24.0;
    final iconHeight = height ?? 24.0;

    return SvgPicture.asset(
      path,
      package: 'wds_foundation',
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      width: iconWidth,
      height: iconHeight,
    );
  }
}
