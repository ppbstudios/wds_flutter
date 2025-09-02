library;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meta/meta.dart';

part 'icon/wds_icon.dart';
part 'icon/wds_navigation_icon.dart';
part 'icon/wds_order_status_icon.dart';

abstract class IconBuilder {
  const IconBuilder();

  @mustBeOverridden
  Widget build() => throw UnimplementedError();
}
