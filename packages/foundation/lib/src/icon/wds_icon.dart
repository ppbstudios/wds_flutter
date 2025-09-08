part of '../wds_icon.dart';

enum WdsIcon implements IconBuilder {
  ask(path: 'assets/vector/ask.svg'),
  blank(path: 'assets/vector/blank.svg'),
  call(path: 'assets/vector/call.svg'),
  camera(path: 'assets/vector/camera.svg'),
  card(path: 'assets/vector/card.svg'),
  cart(path: 'assets/vector/cart.svg'),
  chevronDown(path: 'assets/vector/chevron_down.svg'),
  chevronLeft(path: 'assets/vector/chevron_left.svg'),
  chevronRight(path: 'assets/vector/chevron_right.svg'),
  chevronUp(path: 'assets/vector/chevron_up.svg'),
  circleFilledAdd(path: 'assets/vector/circle_filled_add.svg'),
  circleFilledClose(path: 'assets/vector/circle_filled_close.svg'),
  clock(path: 'assets/vector/clock.svg'),
  close(path: 'assets/vector/close.svg'),
  comment(path: 'assets/vector/comment.svg'),
  download(path: 'assets/vector/download.svg'),
  image(path: 'assets/vector/image.svg'),
  info(path: 'assets/vector/info.svg'),
  minus(path: 'assets/vector/minus.svg'),
  parking(path: 'assets/vector/parking.svg'),
  pin(path: 'assets/vector/pin.svg'),
  plus(path: 'assets/vector/plus.svg'),
  productTag(path: 'assets/vector/product_tag.svg'),
  question(path: 'assets/vector/question.svg'),
  refund(path: 'assets/vector/refund.svg'),
  scan(path: 'assets/vector/scan.svg'),
  search(path: 'assets/vector/search.svg'),
  settings(path: 'assets/vector/settings.svg'),
  share(path: 'assets/vector/share.svg'),
  starFilled(path: 'assets/vector/star_filled.svg'),
  support(path: 'assets/vector/support.svg'),
  wincLogo(path: 'assets/vector/winc_logo.svg'),
  ;

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
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      width: iconWidth,
      height: iconHeight,
      fit: BoxFit.scaleDown,
    );
  }
}
