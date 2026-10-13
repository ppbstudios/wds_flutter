import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wds_foundation/wds_foundation.dart';

const _size = 48.0;

/// 변경 전 WdsIcon.build 와 동일한 렌더링 (colorFilter + srcIn).
Widget _legacy(WdsIcon icon, Color? color) => SvgPicture.asset(
  icon.path,
  package: 'wds_foundation',
  colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
  width: _size,
  height: _size,
);

typedef _Captured = ({Uint8List rgba, int width, int height});

Future<_Captured> _capture(WidgetTester tester, Widget child) async {
  final key = GlobalKey();
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(key: key, child: child),
      ),
    ),
  );
  // svg 파싱이 비동기로 끝날 때까지 대기
  for (var i = 0; i < 20; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
  }
  return (await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData();
    final captured = (
      rgba: bytes!.buffer.asUint8List(),
      width: image.width,
      height: image.height,
    );
    image.dispose();
    return captured;
  }))!;
}

/// 채널별 최대 차이.
///
/// [ignoreEdge] 이면 이미지 가장자리 1px 은 제외한다. 위젯 크기가 소수점일 때
/// 기존 경로는 clipRect 로 마지막 픽셀의 안티앨리어싱을 잘라내지만 새 경로는
/// clip 이 없어 경계 픽셀 알파만 미세하게 다르다.
int _maxDiff(_Captured a, _Captured b, {bool ignoreEdge = false}) {
  expect((a.width, a.height), (b.width, b.height));
  var max = 0;
  for (var i = 0; i < a.rgba.length; i++) {
    final px = i ~/ 4;
    final x = px % a.width;
    final y = px ~/ a.width;
    if (ignoreEdge &&
        (x == 0 || y == 0 || x == a.width - 1 || y == a.height - 1)) {
      continue;
    }
    final d = (a.rgba[i] - b.rgba[i]).abs();
    if (d > max) max = d;
  }
  return max;
}

bool _hasInk(_Captured c) {
  for (var i = 3; i < c.rgba.length; i += 4) {
    if (c.rgba[i] != 0) return true;
  }
  return false;
}

void main() {
  const colors = <Color>[
    Color(0xFF8E8E8E), // neutral 계열
    Color(0xFF5B7BF3), // primary 계열
    Color(0xFFFF5898), // secondary 계열
    Color(0xFFFFFFFF),
  ];

  for (final icon in WdsIcon.values) {
    testWidgets('${icon.name}: colorMapper 결과가 srcIn colorFilter 와 같다', (
      tester,
    ) async {
      final plainLegacy = await _capture(tester, _legacy(icon, null));
      final plainNew = await _capture(
        tester,
        icon.build(width: _size, height: _size),
      );
      expect(_hasInk(plainNew), isTrue, reason: 'svg 가 렌더링되지 않음');
      expect(_maxDiff(plainLegacy, plainNew), 0, reason: 'color 미지정');

      for (final color in colors) {
        final legacy = await _capture(tester, _legacy(icon, color));
        final next = await _capture(
          tester,
          icon.build(color: color, width: _size, height: _size),
        );
        expect(
          _maxDiff(legacy, next, ignoreEdge: true),
          // path 내부 경계 안티앨리어싱의 미세 차이(≈3%)까지 허용
          lessThanOrEqualTo(8),
          reason: 'color=$color',
        );
      }
    });
  }

  testWidgets('불투명 color 는 saveLayer 없이 그린다', (tester) async {
    await _capture(
      tester,
      WdsIcon.likeFilled.build(color: const Color(0xFFFF5898), width: 18),
    );
    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svg.colorFilter, isNull);
    expect(
      find.byType(SvgPicture),
      paintsExactlyCountTimes(#saveLayer, 0),
    );
  });

  testWidgets('반투명 color 는 기존 colorFilter 를 유지한다', (tester) async {
    await _capture(
      tester,
      WdsIcon.likeFilled.build(color: const Color(0x80FF5898), width: 18),
    );
    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svg.colorFilter, isNotNull);
  });

  testWidgets('같은 색상의 colorMapper 는 캐시 키가 같다', (tester) async {
    Object keyOf() {
      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
      return (svg.bytesLoader as SvgAssetLoader).cacheKey(null);
    }

    await _capture(tester, WdsIcon.like.build(color: const Color(0xFF8E8E8E)));
    final a = keyOf();
    await _capture(tester, WdsIcon.like.build(color: const Color(0xFF8E8E8E)));
    expect(keyOf(), a);
  });
}
