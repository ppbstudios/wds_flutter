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
  group('WdsTag 고정 Tag', () {
    final cases = <(WdsTag, Color, Color, Color?)>[
      (const WdsTag.$barodrim(), WdsColors.primary, WdsColors.white, null),
      (
        const WdsTag.$soldOut(),
        WdsColors.neutral50,
        WdsColors.textNeutral,
        null,
      ),
      (
        const WdsTag.$myPower(),
        WdsColors.white,
        WdsColors.textNeutral,
        WdsColors.borderNeutral,
      ),
      (
        const WdsTag.$upto2days(),
        WdsColors.white,
        WdsColors.textNeutral,
        WdsColors.borderNeutral,
      ),
    ];

    for (final (tag, background, text, border) in cases) {
      testWidgets('${tag.label} 는 Figma 토큰으로 그린다', (tester) async {
        await _pump(tester, tag);
        final decoration = _decorationOf(tester);

        expect(decoration.color, background);
        expect(_textColorOf(tester, tag.label), text);
        expect(
          decoration.border,
          border == null ? isNull : Border.all(color: border),
        );
      });
    }

    test('바로드림은 윙크 primary(#5B7BF3)로 칠한다', () {
      expect(const WdsTag.$barodrim().backgroundColor, const Color(0xFF5B7BF3));
    });

    testWidgets('색 직접 지정 Tag 는 테두리가 없다', (tester) async {
      await _pump(
        tester,
        const WdsTag(label: 'HOT', color: WdsColors.secondary),
      );

      expect(_decorationOf(tester).border, isNull);
    });
  });
}
