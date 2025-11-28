part of 'wds_helper.dart';

extension WdsNumX on num {
  /// 숫자를 원화(KRW) 형식으로 표기
  String toKRWFormat() {
    final intValue = toInt();
    final formatted = intValue.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '$formatted원';
  }

  /// 할인율 계산
  int getDiscountRate(num salePrice) {
    return ((1 - salePrice / this) * 100).round();
  }

  /// 천 단위 표기법, `NumberFormat('#,###')` 사용
  ///
  /// ``` dart
  /// 1000.toFormat() // '1,000'
  /// 10000.toFormat() // '9,999+'
  /// 100000.toFormat() // '9,999+'
  /// 100000.toFormat(shortFormat: false) // '100,000'
  /// 1000000.toFormat() // '9,999+'
  /// 1000000.toFormat(shortFormat: false) // '1,000,000'
  /// 10000000.toFormat() // '9,999+'
  /// ```
  String toFormat({bool shortFormat = true}) {
    if (this > 9999 && shortFormat) {
      return '9,999+';
    }

    final numberFormat = NumberFormat('#,###');
    final formatted = numberFormat.format(this);
    return formatted;
  }
}
