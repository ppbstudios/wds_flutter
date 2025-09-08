library;

import 'package:wds_tokens/atomic/wds_atomic_opacity.dart';

class WdsOpacity {
  const WdsOpacity._();

  static const double opacity5 = WdsAtomicOpacity.v5;
  static const double opacity10 = WdsAtomicOpacity.v10;
  static const double opacity20 = WdsAtomicOpacity.v20;
  static const double opacity30 = WdsAtomicOpacity.v30;
  static const double opacity40 = WdsAtomicOpacity.v40;
  static const double opacity50 = WdsAtomicOpacity.v50;
  static const double opacity60 = WdsAtomicOpacity.v60;
  static const double opacity70 = WdsAtomicOpacity.v70;
  static const double opacity80 = WdsAtomicOpacity.v80;
  static const double opacity90 = WdsAtomicOpacity.v90;
}

extension WdsOpacityToAlpha on double {
  /// withAlpha 와 같이 투명도 조절할 때 사용
  ///
  /// ``` dart
  /// WdsColors.textNeutral.withAlpha(
  ///   WdsOpacity.opacity40.toAlpha(),
  /// )
  /// ```
  int toAlpha() => (this * 255).round();
}
