import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum WdsIcon {
  chevronRight(path: 'assets/vector/chevron_right.svg'),
  wincLogo(path: 'assets/vector/winc_logo.svg'),
  ;

  const WdsIcon({
    required this.path,
  });

  final String path;

  Widget build({
    Color? color,
    double? width,
    double? height,
  }) =>
      SvgPicture.asset(
        path,
        package: 'wds_foundation',
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        width: width,
        height: height,
      );
}
