import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wds_components/wds_components.dart';
import 'package:wds_foundation/wds_foundation.dart';

BoxDecoration _decorationOf(WidgetTester tester) {
  final box = tester.widget<DecoratedBox>(
    find.descendant(
      of: find.byType(WdsTag),
      matching: find.byType(DecoratedBox),
    ),
  );
  return box.decoration as BoxDecoration;
}

Color? _textColorOf(WidgetTester tester, String label) =>
    tester.widget<Text>(find.text(label)).style?.color;

Future<void> _pump(WidgetTester tester, WdsTag tag) => tester.pumpWidget(
  Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: tag),
  ),
);

void main() {
  group('WdsTag 역할', () {
    final cases = <(WdsTag, WdsTagRole, Color, Color)>[
      (
        const WdsTag.service(label: '바로드림'),
        WdsTagRole.service,
        WdsColors.blue500,
        WdsColors.white,
      ),
      (
        const WdsTag.progress(label: '예약신청'),
        WdsTagRole.progress,
        WdsColors.neutral50,
        WdsColors.blue500,
      ),
      (
        const WdsTag.completed(label: '구매완료'),
        WdsTagRole.completed,
        WdsColors.neutral50,
        WdsColors.textNeutral,
      ),
      (
        const WdsTag.failed(label: '예약취소'),
        WdsTagRole.failed,
        WdsColors.neutral50,
        WdsColors.orange700,
      ),
      (
        const WdsTag.info(label: '무료검안'),
        WdsTagRole.info,
        WdsColors.white,
        WdsColors.textNeutral,
      ),
    ];

    for (final (tag, role, background, text) in cases) {
      testWidgets('${role.name} 는 역할 토큰으로 그린다', (tester) async {
        await _pump(tester, tag);

        expect(tag.role, role);
        expect(_decorationOf(tester).color, background);
        expect(_textColorOf(tester, tag.label), text);
      });
    }

    testWidgets('info 만 테두리를 그린다', (tester) async {
      for (final (tag, role, _, _) in cases) {
        await _pump(tester, tag);
        final border = _decorationOf(tester).border;

        if (role == WdsTagRole.info) {
          expect(border, Border.all(color: WdsColors.borderNeutral));
        } else {
          expect(border, isNull);
        }
      }
    });

    testWidgets('역할 지정 라벨 생성자는 역할을 따른다', (tester) async {
      expect(const WdsTag.$barodrim().role, WdsTagRole.service);
      expect(const WdsTag.$soldOut().role, WdsTagRole.completed);
      expect(const WdsTag.$myPower().role, WdsTagRole.info);
      expect(const WdsTag.$upto2days().role, WdsTagRole.info);
    });

    test('머천다이징 태그와 색 직접 지정은 역할이 없다', () {
      expect(const WdsTag.$new().role, isNull);
      expect(const WdsTag.$coupon().role, isNull);
      expect(
        const WdsTag(label: 'HOT', color: WdsColors.secondary).role,
        isNull,
      );
    });
  });
}
