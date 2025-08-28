import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'interface/icon.dart';

enum WdsNavigationIcon implements IconBuilder {
  store(
    inactivePath: 'assets/vector/navigation/store_inactive.svg',
    activePath: 'assets/vector/navigation/store_active.svg',
  ),
  home(
    inactivePath: 'assets/vector/navigation/home_inactive.svg',
    activePath: 'assets/vector/navigation/home_active.svg',
  ),
  like(
    inactivePath: 'assets/vector/navigation/like_inactive.svg',
    activePath: 'assets/vector/navigation/like_active.svg',
  ),
  category(
    inactivePath: 'assets/vector/navigation/category_inactive.svg',
    activePath: 'assets/vector/navigation/category_active.svg',
  ),
  my(
    inactivePath: 'assets/vector/navigation/my_inactive.svg',
    activePath: 'assets/vector/navigation/my_active.svg',
  );

  const WdsNavigationIcon({
    required this.activePath,
    required this.inactivePath,
  });

  final String activePath;

  final String inactivePath;

  @override
  Widget build({
    bool isActive = false,
  }) =>
      SvgPicture.asset(
        isActive ? activePath : inactivePath,
        package: 'wds_foundation',
      );
}
