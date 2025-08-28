import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'interface/icon.dart';

enum WdsOrderStatusIcon implements IconBuilder {
  requested(
    activePath: 'assets/vector/order_status/0_requested_active.svg',
    inactivePath: 'assets/vector/order_status/0_requested_inactive.svg',
  ),
  accepted(
    activePath: 'assets/vector/order_status/1_accepted_active.svg',
    inactivePath: 'assets/vector/order_status/1_accepted_inactive.svg',
  ),
  packed(
    activePath: 'assets/vector/order_status/2_packed_active.svg',
    inactivePath: 'assets/vector/order_status/2_packed_inactive.svg',
  ),
  delivering(
    activePath: 'assets/vector/order_status/3_delivering_active.svg',
    inactivePath: 'assets/vector/order_status/3_delivering_inactive.svg',
  ),
  delivered(
    activePath: 'assets/vector/order_status/4_delivered_active.svg',
    inactivePath: 'assets/vector/order_status/4_delivered_inactive.svg',
  ),
  prepared(
    activePath: 'assets/vector/order_status/5_prepared_active.svg',
    inactivePath: 'assets/vector/order_status/5_prepared_inactive.svg',
  ),
  paid(
    activePath: 'assets/vector/order_status/6_paid_active.svg',
    inactivePath: 'assets/vector/order_status/6_paid_inactive.svg',
  ),
  ;

  const WdsOrderStatusIcon({
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
