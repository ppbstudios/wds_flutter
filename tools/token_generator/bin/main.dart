import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('input',
        abbr: 'i', help: '입력 JSON 경로', valueHelp: 'path/to/tokens.json')
    ..addOption('out',
        abbr: 'o', help: '생성된 Dart 파일 루트 디렉터리', valueHelp: 'path/to/output')
    ..addOption('library',
        abbr: 'l', help: '라이브러리 이름', defaultsTo: 'wds_tokens')
    ..addOption('kind',
        abbr: 'k',
        help: '생성 모드: atomic 또는 semantic',
        allowed: ['atomic', 'semantic'],
        defaultsTo: 'atomic')
    ..addFlag('overwrite', abbr: 'f', help: '기존 파일 덮어쓰기', defaultsTo: true)
    ..addFlag('verbose', abbr: 'v', help: '로그 출력', defaultsTo: true)
    ..addFlag('sync',
        abbr: 's',
        help: 'JSON 기준으로 출력 디렉터리 동기화(불필요 파일 삭제 + export 인덱스 생성)',
        defaultsTo: true);

  final argResult = parser.parse(arguments);
  final inputPath = argResult['input'] as String?;
  final outDir = argResult['out'] as String?;
  final libraryName = argResult['library'] as String;
  final kind = argResult['kind'] as String;
  final verbose = argResult['verbose'] as bool;
  final sync = argResult['sync'] as bool;

  if (inputPath == null || outDir == null) {
    stderr.writeln('사용법: wds_tokens -i <tokens.json> -o <outputDir>');
    stderr.writeln(parser.usage);
    exitCode = 64;
    return;
  }

  final inputFile = File(inputPath);
  if (!await inputFile.exists()) {
    stderr.writeln('입력 파일을 찾을 수 없습니다: $inputPath');
    exitCode = 66;
    return;
  }

  final jsonMap =
      jsonDecode(await inputFile.readAsString()) as Map<String, dynamic>;

  if (kind == 'atomic') {
    await _generateAtomic(
        jsonMap: jsonMap,
        outDir: outDir,
        libraryName: libraryName,
        verbose: verbose,
        sync: sync);
  } else {
    await _generateSemantic(
        jsonMap: jsonMap,
        outDir: outDir,
        libraryName: libraryName,
        verbose: verbose,
        sync: sync);
  }
}

Future<void> _generateAtomic({
  required Map<String, dynamic> jsonMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
  required bool sync,
}) async {
  final Set<String> generatedBasenames = {};
  bool generatedColorLibrary = false;
  final Set<String> generatedColorPartBasenames = {};
  bool generatedFontLibrary = false;
  final Set<String> generatedFontPartBasenames = {};

  final hasFontRoot =
      jsonMap.keys.whereType<String>().any((k) => k.toLowerCase() == 'font');

  for (final MapEntry(:key, :value)
      in jsonMap.entries.where((e) => e.value is Map<String, dynamic>)) {
    final rootKey = key;
    final rootMap = value as Map<String, dynamic>;

    if (rootKey.toLowerCase() == 'color') {
      await _generateColorLibrary(
        rootMap: rootMap,
        outDir: outDir,
        libraryName: libraryName,
        verbose: verbose,
        generatedPartBasenames: generatedColorPartBasenames,
      );
      generatedColorLibrary = true;
      continue;
    }

    if (rootKey.toLowerCase() == 'font') {
      await _generateFontLibrary(
        rootMap: rootMap,
        outDir: outDir,
        libraryName: libraryName,
        verbose: verbose,
        generatedPartBasenames: generatedFontPartBasenames,
      );
      generatedFontLibrary = true;
      continue;
    }

    // font 루트가 존재하면, 중복되는 상위 루트(fontSize/lineHeights/letterSpacing)는 스킵
    final lower = rootKey.toLowerCase();
    if (hasFontRoot &&
        (lower == 'fontsize' ||
            lower == 'lineheights' ||
            lower == 'letterspacing')) {
      if (verbose) stdout.writeln('스킵: $rootKey (font 루트에 포함되어 중복)');
      continue;
    }

    // paragraphSpacing만 전역 스킵
    final dominantType = _inferDominantType(rootMap);
    if (dominantType == 'paragraphSpacing') {
      if (verbose) stdout.writeln('스킵: $rootKey (paragraphSpacing)');
      continue;
    }

    final basename = 'wds_atomic_${_toSnake(rootKey)}.dart';
    generatedBasenames.add(basename);
    await _generateForRoot(
        rootKey: rootKey,
        rootMap: rootMap,
        outDir: outDir,
        libraryName: libraryName,
        verbose: verbose);
  }

  if (sync) {
    await _syncAtomicOutputs(
      outDir: outDir,
      libraryName: libraryName,
      generatedBasenames: generatedBasenames,
      generatedColorLibrary: generatedColorLibrary,
      generatedColorPartBasenames: generatedColorPartBasenames,
      generatedFontLibrary: generatedFontLibrary,
      generatedFontPartBasenames: generatedFontPartBasenames,
      verbose: verbose,
    );
  }
}

Future<void> _generateSemantic({
  required Map<String, dynamic> jsonMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
  required bool sync,
}) async {
  // semantic/color
  final semanticDir = Directory(p.join(outDir, 'lib', 'semantic'));
  final semanticColorParts = <String>{};
  bool generatedSemanticColor = false;
  bool generatedSemanticTypography = false;
  final topLevelColorEntries = <(String key, Map<String, dynamic> node)>[];
  for (final e in jsonMap.entries) {
    if (e.value is Map<String, dynamic>) {
      final map = e.value as Map<String, dynamic>;
      if (map.containsKey(r'$type') && map.containsKey(r'$value')) {
        final t = map[r'$type'] as String;
        if (t == 'color') {
          topLevelColorEntries.add((e.key, map));
        }
      }
    }
  }

  final colorGroup = jsonMap['color'] as Map<String, dynamic>?;
  if (topLevelColorEntries.isNotEmpty || colorGroup != null) {
    await semanticDir.create(recursive: true);
    final colorDir = Directory(p.join(semanticDir.path, 'color'));
    await colorDir.create(recursive: true);

    final partsMeta = <(
      String className,
      String fieldName,
      String partRelativePath,
      String partFileName
    )>[];

    if (colorGroup != null) {
      final groupKeys = colorGroup.keys.toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      for (final gk in groupKeys) {
        final sub = colorGroup[gk];
        if (sub is! Map<String, dynamic>) continue;

        final className = 'WdsSemanticColor${_pascalCase(gk)}';
        final fieldName = _camelCase(gk);
        final partFileName = 'wds_semantic_color_${_toSnake(gk)}.dart';
        final partRelativePath = 'color/$partFileName';

        final cb = StringBuffer()
          ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
          ..writeln("part of '../color.dart';")
          ..writeln()
          ..writeln('class $className {')
          ..writeln('  const $className._();');

        final entries = sub.entries.toList()
          ..sort((a, b) => _keyCompare(a.key, b.key));
        final Set<String> fieldNames = {};
        for (final e in entries) {
          final v = e.value;
          if (v is Map<String, dynamic> &&
              v.containsKey(r'$type') &&
              v.containsKey(r'$value')) {
            final type = v[r'$type'] as String;
            if (type != 'color') continue;
            final value = v[r'$value'];
            final expr = _convertSemanticColorValue(value);
            final identifier = _identifierFromKey(e.key);
            if (expr != null && fieldNames.add(identifier)) {
              cb.writeln('  static const Color $identifier = $expr;');
            }
          }
        }

        cb.writeln('}');
        final partFile = File(p.join(colorDir.path, partFileName));
        await partFile.create(recursive: true);
        await partFile.writeAsString(cb.toString());
        semanticColorParts.add(partFileName);
        partsMeta.add((className, fieldName, partRelativePath, partFileName));
        if (verbose) stdout.writeln('생성 완료: ${partFile.path}');
      }
    }

    final colorLib = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln(
          '// ignore_for_file: constant_identifier_names, non_constant_identifier_names')
      ..writeln('import "package:flutter/material.dart";')
      ..writeln('import "../atomic/color.dart";')
      ..writeln();
    for (final meta in partsMeta) {
      colorLib.writeln("part '${meta.$3}';");
    }
    colorLib.writeln();
    // 최상위 색상 토큰을 개별 const로 노출 (클래스 없이)
    for (final (k, node) in topLevelColorEntries
      ..sort((a, b) => a.$1.toLowerCase().compareTo(b.$1.toLowerCase()))) {
      final expr = _convertSemanticColorValue(node[r'$value']);
      if (expr != null) {
        colorLib.writeln('const Color ${_identifierFromKey(k)} = $expr;');
      }
    }
    // 그룹 클래스는 part 파일로만 제공

    final colorLibFile = File(p.join(semanticDir.path, 'color.dart'));
    await colorLibFile.create(recursive: true);
    await colorLibFile.writeAsString(colorLib.toString());
    generatedSemanticColor = true;
    if (verbose) stdout.writeln('생성 완료: ${colorLibFile.path}');
  }

  // semantic/typography
  final typographyRoot = jsonMap.entries.firstWhere(
      (e) =>
          e.key.toString().toLowerCase() == 'typography' &&
          e.value is Map<String, dynamic>,
      orElse: () => const MapEntry('', null));
  if (typographyRoot.value is Map<String, dynamic>) {
    final tyMap = typographyRoot.value as Map<String, dynamic>;
    final sb = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln(
          '// ignore_for_file: constant_identifier_names, non_constant_identifier_names')
      ..writeln('import "package:flutter/material.dart";')
      ..writeln('import "../atomic/atomic.dart";')
      ..writeln();
    sb.writeln('class WdsSemanticTypography {');
    sb.writeln('  const WdsSemanticTypography._();');

    for (final MapEntry(:key, :value)
        in tyMap.entries.where((e) => e.value is Map<String, dynamic>)) {
      final styleName = key; // e.g., Heading18
      final variants = value as Map<String, dynamic>;
      for (final MapEntry(:key, :value)
          in variants.entries.where((e) => e.value is Map<String, dynamic>)) {
        final variantName = key; // e.g., bold
        final props = value as Map<String, dynamic>;
        final fieldName = _camelCase('${styleName}_${variantName}');

        final familyExpr = _resolveTypographyFamily(props['family']);
        final weightExpr = _resolveTypographyWeight(props['weight']);
        final sizeExpr =
            _resolveTypographyNumberClassed(props['size'], 'WdsFontSize');
        final lineHeightExpr = _resolveTypographyNumberClassed(
            props['lineheight'], 'WdsFontLineheight');
        final letterSpacingExpr =
            _resolveTypographyLetterSpacing(props['letterSpacing']);

        final lines = <String>[];
        if (familyExpr != null) lines.add('fontFamily: $familyExpr');
        if (weightExpr != null) lines.add('fontWeight: $weightExpr');
        if (sizeExpr != null) lines.add('fontSize: $sizeExpr');
        if (lineHeightExpr != null) lines.add('height: $lineHeightExpr');
        if (letterSpacingExpr != null)
          lines.add('letterSpacing: $letterSpacingExpr');

        sb.writeln('  static const TextStyle $fieldName = TextStyle(');
        for (int i = 0; i < lines.length; i++) {
          sb.writeln('    ${lines[i]},');
        }
        sb.writeln('  );');
      }
    }

    sb.writeln('}');
    final file = File(p.join(semanticDir.path, 'typography.dart'));
    await file.create(recursive: true);
    await file.writeAsString(sb.toString());
    generatedSemanticTypography = true;
    if (verbose) stdout.writeln('생성 완료: ${file.path}');
  }

  if (sync) {
    await _syncSemanticOutputs(
      outDir: outDir,
      generatedSemanticColor: generatedSemanticColor,
      generatedSemanticTypography: generatedSemanticTypography,
      generatedSemanticColorPartBasenames: semanticColorParts,
      verbose: verbose,
    );
  }
}

Future<void> _generateForRoot({
  required String rootKey,
  required Map<String, dynamic> rootMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
}) async {
  // 타입별로 적절한 생성 함수 호출
  final dominantType = _inferDominantType(rootMap);
  await _generateTokenFamily(
      rootKey, rootMap, dominantType, outDir, libraryName, verbose);
}

String _inferDominantType(Map<String, dynamic> node) {
  final typeCounts = <String, int>{};

  void walk(dynamic n) {
    switch (n) {
      case Map<String, dynamic> map
          when map.containsKey(r'$type') && map.containsKey(r'$value'):
        final type = map[r'$type'] as String;
        typeCounts[type] = (typeCounts[type] ?? 0) + 1;
      case Map<String, dynamic> map:
        for (final v in map.values) {
          walk(v);
        }
    }
  }

  walk(node);

  if (typeCounts.isEmpty) return 'mixed';

  // 가장 많은 타입을 반환
  return typeCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
}

Future<void> _generateTokenFamily(
    String rootKey,
    Map<String, dynamic> rootMap,
    String dominantType,
    String outDir,
    String libraryName,
    bool verbose) async {
  final classPrefix = 'WdsAtomic${_pascalCase(rootKey)}';
  final rootPrefix = _pascalCase(rootKey);
  final buf = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln(
        '// ignore_for_file: constant_identifier_names, non_constant_identifier_names')
    ..writeln('library $libraryName;')
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln()
    ..writeln('class $classPrefix {')
    ..writeln('  const $classPrefix._();');

  // 그룹(서브맵) 노출 + 직접 토큰 처리
  final keys = rootMap.keys.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  final Set<String> exposedTopLevelNames = {};
  final Set<String> exposedGroupClassNames = {};
  for (final k in keys) {
    final child = rootMap[k];
    if (child is Map<String, dynamic>) {
      if (child.containsKey(r'$value') && child.containsKey(r'$type')) {
        final type = child[r'$type'] as String;
        final value = child[r'$value'];
        final convertedValue = _convertValueByType(type, value);
        final identifier = _identifierFromKey(k);
        if (convertedValue != null && exposedTopLevelNames.add(identifier)) {
          buf.writeln(
              '  static const ${_getDartTypeForToken(type)} $identifier = $convertedValue;');
        }
      } else {
        // 그룹 클래스로 노출
        final groupClassBase = _pascalCase(k);
        final groupClass =
            groupClassBase.isEmpty ? '' : '${rootPrefix}${groupClassBase}';
        if (groupClass.isNotEmpty && exposedGroupClassNames.add(groupClass)) {
          buf.writeln(
              '  static const $groupClass ${_camelCase(k)} = $groupClass._();');
        }
      }
    }
  }

  buf.writeln('}');
  buf.writeln();

  // 그룹 클래스들 생성 (numeric shade 등), 중복 클래스명 방지
  final Set<String> generatedGroupClassNames = {};
  for (final k in keys) {
    final child = rootMap[k];
    if (child is Map<String, dynamic> &&
        !(child.containsKey(r'$value') && child.containsKey(r'$type'))) {
      final classNameBase = _pascalCase(k);
      final className =
          classNameBase.isEmpty ? '' : '${rootPrefix}${classNameBase}';
      if (className.isEmpty || !generatedGroupClassNames.add(className))
        continue;
      final cb = StringBuffer()
        ..writeln('class $className {')
        ..writeln('  const $className._();');
      final entries = child.entries.toList()
        ..sort((a, b) => _keyCompare(a.key, b.key));
      final Set<String> fieldNames = {};
      for (final e in entries) {
        final v = e.value;
        if (v is Map<String, dynamic> &&
            v.containsKey(r'$type') &&
            v.containsKey(r'$value')) {
          final type = v[r'$type'] as String;
          final value = v[r'$value'];
          final convertedValue = _convertValueByType(type, value);
          final identifier = _identifierFromKey(e.key);
          if (convertedValue != null && fieldNames.add(identifier)) {
            cb.writeln(
                '  static const ${_getDartTypeForToken(type)} $identifier = $convertedValue;');
          }
        }
      }
      cb.writeln('}');
      buf.writeln(cb.toString());
      buf.writeln();
    }
  }

  final outPath =
      p.join(outDir, 'lib', 'atomic', 'wds_atomic_${_toSnake(rootKey)}.dart');
  final outFile = File(outPath);
  await outFile.create(recursive: true);
  await outFile.writeAsString(buf.toString());
  if (verbose) stdout.writeln('생성 완료: $outPath');
}

Future<void> _syncAtomicOutputs({
  required String outDir,
  required String libraryName,
  required Set<String> generatedBasenames,
  required bool generatedColorLibrary,
  required Set<String> generatedColorPartBasenames,
  required bool generatedFontLibrary,
  required Set<String> generatedFontPartBasenames,
  required bool verbose,
}) async {
  // 1) 불필요한 이전 산출물 삭제 (atomic/*.dart 중 이번에 생성되지 않은 wds_atomic_* 파일)
  final atomicDir = Directory(p.join(outDir, 'lib', 'atomic'));
  if (await atomicDir.exists()) {
    await for (final entity
        in atomicDir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        final isAtomic =
            name.startsWith('wds_atomic_') && name.endsWith('.dart');
        final isLegacy =
            name.startsWith('wds_atomic_') && name.endsWith('.g.dart');
        if ((isAtomic && !generatedBasenames.contains(name)) || isLegacy) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
  }

  // 1-1) color part 산출물 정리 (lib/atomic/color/*.dart)
  final colorPartsDir = Directory(p.join(outDir, 'lib', 'atomic', 'color'));
  if (await colorPartsDir.exists()) {
    await for (final entity
        in colorPartsDir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        final isGenerated =
            name.startsWith('wds_color_') && name.endsWith('.dart');
        if (isGenerated && !generatedColorPartBasenames.contains(name)) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
  }

  // 1-2) font part 산출물 정리 (lib/atomic/font/*.dart)
  final fontPartsDir = Directory(p.join(outDir, 'lib', 'atomic', 'font'));
  if (await fontPartsDir.exists()) {
    await for (final entity
        in fontPartsDir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        final isGenerated =
            name.startsWith('wds_font_') && name.endsWith('.dart');
        if (isGenerated && !generatedFontPartBasenames.contains(name)) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
  }

  // 2) atomic/atomic.dart aggregator 생성
  final exportsInAtomic = <String>[];
  if (generatedColorLibrary) exportsInAtomic.add('color.dart');
  if (generatedFontLibrary) exportsInAtomic.add('font.dart');
  exportsInAtomic.addAll(generatedBasenames);
  exportsInAtomic.sort();
  final atomicIndex = StringBuffer()
    ..writeln('library;')
    ..writeln("export 'color.dart';")
    ..writeln("export 'font.dart';");
  for (final e in exportsInAtomic) {
    if (e.endsWith('.dart') && e.startsWith('wds_atomic_')) {
      atomicIndex.writeln("export '$e';");
    }
  }
  final atomicIndexFile = File(p.join(outDir, 'lib', 'atomic', 'atomic.dart'));
  await atomicIndexFile.create(recursive: true);
  await atomicIndexFile.writeAsString(atomicIndex.toString());
  if (verbose) stdout.writeln('생성 완료: ${atomicIndexFile.path}');

  // 3) wds_tokens.dart export 인덱스 생성
  final exports = <String>[];
  exports.add('atomic/atomic.dart');
  exports.sort();
  final indexBuf = StringBuffer();
  for (final entry in exports) {
    indexBuf.writeln("export '$entry';");
  }
  final indexFile = File(p.join(outDir, 'lib', 'wds_tokens.dart'));
  await indexFile.create(recursive: true);
  await indexFile.writeAsString(indexBuf.toString());
  if (verbose) stdout.writeln('인덱스 생성 완료: ${indexFile.path}');
}

Future<void> _syncSemanticOutputs({
  required String outDir,
  required bool generatedSemanticColor,
  required bool generatedSemanticTypography,
  required Set<String> generatedSemanticColorPartBasenames,
  required bool verbose,
}) async {
  // semantic/color parts cleanup
  final semanticColorDir =
      Directory(p.join(outDir, 'lib', 'semantic', 'color'));
  if (await semanticColorDir.exists()) {
    await for (final entity
        in semanticColorDir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        final isGenerated =
            name.startsWith('wds_semantic_color_') && name.endsWith('.dart');
        if (isGenerated &&
            !generatedSemanticColorPartBasenames.contains(name)) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
  }

  // semantic/semantic.dart aggregator 생성 및 wds_tokens.dart 갱신
  final semanticDir = Directory(p.join(outDir, 'lib', 'semantic'));
  final semanticIndex = StringBuffer()
    ..writeln('library;')
    ..writeln("export 'color.dart';")
    ..writeln("export 'typography.dart';");
  final semanticIndexFile = File(p.join(semanticDir.path, 'semantic.dart'));
  await semanticIndexFile.create(recursive: true);
  await semanticIndexFile.writeAsString(semanticIndex.toString());

  final exports = <String>[];
  final atomicIndexFile = File(p.join(outDir, 'lib', 'atomic', 'atomic.dart'));
  if (await atomicIndexFile.exists()) exports.add('atomic/atomic.dart');
  exports.add('semantic/semantic.dart');
  exports.sort();

  final indexBuf = StringBuffer();
  for (final entry in exports) {
    indexBuf.writeln("export '$entry';");
  }
  final indexFile = File(p.join(outDir, 'lib', 'wds_tokens.dart'));
  await indexFile.create(recursive: true);
  await indexFile.writeAsString(indexBuf.toString());
  if (verbose) stdout.writeln('인덱스 생성 완료: ${indexFile.path}');
}

String _getDartTypeForToken(String type) => switch (type) {
      'color' => 'Color',
      'dimension' ||
      'number' ||
      'fontSize' ||
      'fontSizes' ||
      'lineHeight' ||
      'lineHeights' ||
      'letterSpacing' =>
        'double',
      'text' => 'String',
      'boxShadow' => 'List<BoxShadow>',
      _ => 'String',
    };

String? _convertValueByType(String type, dynamic value) => switch (type) {
      'color' => _convertColorValue(value),
      'dimension' => _convertDimensionValue(value),
      'number' => _convertNumberValue(value),
      'text' => _convertTextValue(value),
      'boxShadow' => _convertBoxShadowValue(value),
      'lineHeight' || 'lineHeights' => _convertLineHeightValue(value),
      'fontSize' || 'fontSizes' => _convertFontSizeValue(value),
      'letterSpacing' => _convertLetterSpacingValue(value),
      // 무시 대상
      'paragraphSpacing' => null,
      _ => _convertTextValue(value),
    };

String? _convertColorValue(dynamic value) =>
    value is String ? _hexToColorLiteral(value) : null;

String? _convertDimensionValue(dynamic value) => switch (value) {
      String s when s.endsWith('rem') => () {
          final remValue = double.tryParse(s.replaceAll('rem', ''));
          return remValue != null ? (remValue * 16.0).toString() : null;
        }(),
      String s when s.endsWith('px') => () {
          final pxValue = double.tryParse(s.replaceAll('px', ''));
          return pxValue?.toString();
        }(),
      String s when double.tryParse(s) != null => double.parse(s).toString(),
      num n => n.toDouble().toString(),
      _ => null,
    };

String? _convertNumberValue(dynamic value) => switch (value) {
      num n => n.toDouble().toString(),
      String s when double.tryParse(s) != null => double.parse(s).toString(),
      _ => null,
    };

String? _convertTextValue(dynamic value) =>
    value is String ? "'${value.replaceAll("'", "\\'")}'" : null;

String? _convertBoxShadowValue(dynamic value) => switch (value) {
      List list => () {
          final shadows = [
            for (final item in list)
              if (item is Map<String, dynamic>) _convertSingleBoxShadow(item)
          ].whereType<String>().toList();
          return shadows.isNotEmpty ? '[${shadows.join(', ')}]' : null;
        }(),
      Map<String, dynamic> map => () {
          final shadow = _convertSingleBoxShadow(map);
          return shadow != null ? '[$shadow]' : null;
        }(),
      _ => null,
    };

String? _convertSingleBoxShadow(Map<String, dynamic> shadowData) {
  final color = shadowData['color'];
  final x = shadowData['x'] ?? shadowData['offsetX'] ?? 0;
  final y = shadowData['y'] ?? shadowData['offsetY'] ?? 0;
  final blur = shadowData['blur'] ?? shadowData['blurRadius'] ?? 0;
  final spread = shadowData['spread'] ?? shadowData['spreadRadius'] ?? 0;

  final colorValue = switch (color) {
    String s when s.startsWith('#') => _hexToColorLiteral(s),
    _ => 'Color(0xFF000000)',
  };

  return 'BoxShadow(offset: Offset($x, $y), blurRadius: $blur, spreadRadius: $spread, color: $colorValue)';
}

String? _convertLineHeightValue(dynamic value) => switch (value) {
      String s when s.toUpperCase() == 'AUTO' => '1.0',
      String s when double.tryParse(s) != null => double.parse(s).toString(),
      num n => n.toDouble().toString(),
      _ => '1.0',
    };

String? _convertFontSizeValue(dynamic value) => switch (value) {
      num n => n.toDouble().toString(),
      String s when double.tryParse(s) != null => double.parse(s).toString(),
      _ => null,
    };

String? _convertLetterSpacingValue(dynamic value) => switch (value) {
      String s when s.endsWith('%') => () {
          final percentValue = double.tryParse(s.replaceAll('%', ''));
          return percentValue != null
              ? ((percentValue / 100.0) * 16.0).toString()
              : null;
        }(),
      String s when double.tryParse(s) != null => double.parse(s).toString(),
      num n => n.toDouble().toString(),
      _ => null,
    };

String? _convertSemanticColorValue(dynamic raw) {
  if (raw is String) {
    if (raw.startsWith('{') && raw.endsWith('}')) {
      final path = raw.substring(1, raw.length - 1);
      final parts = path.split('.');
      if (parts.isNotEmpty && parts.first.toLowerCase() == 'color') {
        if (parts.length == 3) {
          final group = parts[1];
          final key = parts[2];
          final className = 'WdsColor${_pascalCase(group)}';
          final tokenField = _identifierFromKey(key);
          return '$className.$tokenField';
        } else if (parts.length == 2) {
          final group = parts[1];
          final className = 'WdsColor${_pascalCase(group)}';
          return className; // class reference (if used)
        }
      }
    }
    if (raw.startsWith('#')) {
      return _hexToColorLiteral(raw);
    }
  }
  return null;
}

String? _resolveTypographyFamily(dynamic node) {
  if (node is Map<String, dynamic> && node.containsKey(r'$value')) {
    final v = node[r'$value'];
    if (v is String && v.startsWith('{') && v.endsWith('}')) {
      // {font.family.Pretendard} → WdsFontFamily.pretendard
      final path = v.substring(1, v.length - 1);
      final parts = path.split('.');
      if (parts.length >= 3 &&
          parts[0].toLowerCase() == 'font' &&
          parts[1].toLowerCase() == 'family') {
        final name = parts[2];
        final field = _identifierFromKey(name);
        return 'WdsFontFamily.$field';
      }
      return null;
    }
    if (v is String) {
      return _convertTextValue(v);
    }
  }
  return null;
}

String? _resolveTypographyWeight(dynamic node) {
  int? weight;
  if (node is Map<String, dynamic> && node.containsKey(r'$value')) {
    final v = node[r'$value'];
    if (v is String && v.startsWith('{') && v.endsWith('}')) {
      final path = v.substring(1, v.length - 1);
      final parts = path.split('.');
      if (parts.length >= 3 &&
          parts[0].toLowerCase() == 'font' &&
          parts[1].toLowerCase() == 'weight') {
        final name = parts[2];
        final field = _identifierFromKey(name);
        return 'WdsFontWeight.$field';
      }
    } else if (v is num) {
      weight = v.toInt();
    }
  }
  return weight != null ? 'FontWeight.w$weight' : null;
}

String? _resolveTypographyNumber(dynamic node, {required String root}) {
  if (node is Map<String, dynamic> && node.containsKey(r'$value')) {
    final v = node[r'$value'];
    if (v is String && v.startsWith('{') && v.endsWith('}')) {
      final path = v.substring(1, v.length - 1);
      final parts = path.split('.');
      if (parts.length >= 3) {
        final group = parts[1];
        final key = parts[2];
        final groupField = _camelCase(group);
        final tokenField = _identifierFromKey(key);
        return 'WdsFont.$groupField.$tokenField';
      }
    } else if (v is num) {
      return v.toDouble().toString();
    }
  }
  return null;
}

String? _resolveTypographyNumberClassed(dynamic node, String className) {
  if (node is Map<String, dynamic> && node.containsKey(r'$value')) {
    final v = node[r'$value'];
    if (v is String && v.startsWith('{') && v.endsWith('}')) {
      final path = v.substring(1, v.length - 1);
      final parts = path.split('.');
      if (parts.length >= 3) {
        final key = parts[2];
        final tokenField = _identifierFromKey(key);
        return '$className.$tokenField';
      }
    } else if (v is num) {
      return v.toDouble().toString();
    }
  }
  return null;
}

String? _resolveTypographyLetterSpacing(dynamic node) {
  if (node is Map<String, dynamic> && node.containsKey(r'$value')) {
    final v = node[r'$value'];
    if (v is num) return v.toDouble().toString();
    if (v is String) {
      final d = double.tryParse(v);
      if (d != null) return d.toString();
    }
  }
  return null;
}

String? _convertToFontWeight(dynamic raw) {
  int? weight;
  switch (raw) {
    case num n:
      weight = n.toInt();
    case String s when double.tryParse(s) != null:
      weight = double.parse(s).toInt();
  }
  if (weight == null) return null;
  final allowed = {100, 200, 300, 400, 500, 600, 700, 800, 900};
  if (!allowed.contains(weight)) weight = 400;
  return 'FontWeight.w$weight';
}

Future<void> _generateColorLibrary({
  required Map<String, dynamic> rootMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
  required Set<String> generatedPartBasenames,
}) async {
  final atomicDir = Directory(p.join(outDir, 'lib', 'atomic'));
  final colorDir = Directory(p.join(atomicDir.path, 'color'));
  await colorDir.create(recursive: true);

  // 그룹 이름 정렬 및 중복 제거 (클래스명 기준)
  final keys = rootMap.keys.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  final Set<String> generatedClassNames = {};
  final List<
      (
        String className,
        String fieldName,
        String partRelativePath,
        String partFileName
      )> partsMeta = [];

  for (final key in keys) {
    final value = rootMap[key];
    if (value is! Map<String, dynamic>) continue;
    // leaf는 스킵(최소 한 단계 그룹이 있는 구조만 생성)
    final isLeaf = value.containsKey(r'$type') && value.containsKey(r'$value');
    if (isLeaf) continue;

    final classNameBase = _pascalCase(key);
    if (classNameBase.isEmpty) continue;
    final className = 'WdsColor$classNameBase';
    if (!generatedClassNames.add(className)) {
      // 동일 클래스명이 이미 생성됨(대소문자/공백 차이 등) → 스킵
      continue;
    }

    final fieldName = _camelCase(key);
    final partFileName = 'wds_color_${_toSnake(key)}.dart';
    final partRelativePath = 'color/$partFileName';

    // 파트 파일 생성
    final cb = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln("part of '../color.dart';")
      ..writeln()
      ..writeln('class $className {')
      ..writeln('  const $className._();');

    // 내부 토큰(leaf) 정렬
    final entries = value.entries.toList()
      ..sort((a, b) => _keyCompare(a.key, b.key));
    final Set<String> fieldNames = {};
    for (final e in entries) {
      final v = e.value;
      if (v is Map<String, dynamic> &&
          v.containsKey(r'$type') &&
          v.containsKey(r'$value')) {
        final type = v[r'$type'] as String;
        final val = v[r'$value'];
        final identifier = _identifierFromKey(e.key);
        // WdsFontWeight는 FontWeight 타입을 직접 노출
        if (className == 'WdsFontWeight') {
          final fw = _convertToFontWeight(val);
          if (fw != null && fieldNames.add(identifier)) {
            cb.writeln('  static const FontWeight $identifier = $fw;');
          }
        } else {
          final convertedValue = _convertValueByType(type, val);
          if (convertedValue != null && fieldNames.add(identifier)) {
            cb.writeln(
                '  static const ${_getDartTypeForToken(type)} $identifier = $convertedValue;');
          }
        }
      }
    }
    cb.writeln('}');

    final partFile = File(p.join(colorDir.path, partFileName));
    await partFile.create(recursive: true);
    await partFile.writeAsString(cb.toString());
    generatedPartBasenames.add(partFileName);
    if (verbose) stdout.writeln('생성 완료: ${partFile.path}');

    partsMeta.add((className, fieldName, partRelativePath, partFileName));
  }

  // color.dart (라이브러리: part만 포함, aggregator 클래스 없음)
  final libBuf = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln(
        '// ignore_for_file: constant_identifier_names, non_constant_identifier_names')
    ..writeln('import "package:flutter/material.dart";')
    ..writeln();

  for (final meta in partsMeta) {
    libBuf.writeln("part '${meta.$3}';");
  }
  // No aggregator class (all inner tokens are static)

  final colorLibFile = File(p.join(atomicDir.path, 'color.dart'));
  await colorLibFile.create(recursive: true);
  await colorLibFile.writeAsString(libBuf.toString());
  if (verbose) stdout.writeln('생성 완료: ${colorLibFile.path}');
}

Future<void> _generateFontLibrary({
  required Map<String, dynamic> rootMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
  required Set<String> generatedPartBasenames,
}) async {
  final atomicDir = Directory(p.join(outDir, 'lib', 'atomic'));
  final fontDir = Directory(p.join(atomicDir.path, 'font'));
  await fontDir.create(recursive: true);

  final keys = rootMap.keys.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

  final List<
      (
        String className,
        String fieldName,
        String partRelativePath,
        String partFileName
      )> partsMeta = [];

  // family는 단일 leaf일 수 있어 별도 처리
  String? familyConstType;
  String? familyConstValue;

  for (final key in keys) {
    final value = rootMap[key];
    if (value is! Map<String, dynamic>) continue;

    final isLeaf = value.containsKey(r'$type') && value.containsKey(r'$value');
    if (isLeaf) {
      // 예: font.family
      final type = value[r'$type'] as String;
      final converted = _convertValueByType(type, value[r'$value']);
      if (converted != null) {
        familyConstType = _getDartTypeForToken(type);
        familyConstValue = converted;
      }
      continue;
    }

    // 그룹(예: size, weight, lineheight) → part 파일 생성
    final classNameBase = _pascalCase(key);
    if (classNameBase.isEmpty) continue;
    final className = 'WdsFont$classNameBase';
    final fieldName = _camelCase(key);
    final partFileName = 'wds_font_${_toSnake(key)}.dart';
    final partRelativePath = 'font/$partFileName';

    final cb = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln("part of '../font.dart';")
      ..writeln()
      ..writeln('class $className {')
      ..writeln('  const $className._();');

    final entries = value.entries.toList()
      ..sort((a, b) => _keyCompare(a.key, b.key));
    final Set<String> fieldNames = {};
    for (final e in entries) {
      final v = e.value;
      if (v is Map<String, dynamic> &&
          v.containsKey(r'$type') &&
          v.containsKey(r'$value')) {
        final type = v[r'$type'] as String;
        final val = v[r'$value'];
        final identifier = _identifierFromKey(e.key);
        // weight 그룹은 FontWeight를 노출
        if (className == 'WdsFontWeight') {
          final fw = _convertToFontWeight(val);
          if (fw != null && fieldNames.add(identifier)) {
            cb.writeln('  static const FontWeight $identifier = $fw;');
          }
        } else {
          final convertedValue = _convertValueByType(type, val);
          if (convertedValue != null && fieldNames.add(identifier)) {
            cb.writeln(
                '  static const ${_getDartTypeForToken(type)} $identifier = $convertedValue;');
          }
        }
      }
    }
    cb.writeln('}');

    final partFile = File(p.join(fontDir.path, partFileName));
    await partFile.create(recursive: true);
    await partFile.writeAsString(cb.toString());
    generatedPartBasenames.add(partFileName);
    if (verbose) stdout.writeln('생성 완료: ${partFile.path}');

    partsMeta.add((className, fieldName, partRelativePath, partFileName));
  }

  // font.dart (라이브러리: part만 포함, aggregator 클래스 없음)
  final libBuf = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln(
        '// ignore_for_file: constant_identifier_names, non_constant_identifier_names')
    ..writeln('import "package:flutter/material.dart";')
    ..writeln();

  for (final meta in partsMeta) {
    libBuf.writeln("part '${meta.$3}';");
  }
  // No aggregator class (all inner tokens are static)

  final fontLibFile = File(p.join(atomicDir.path, 'font.dart'));
  await fontLibFile.create(recursive: true);
  await fontLibFile.writeAsString(libBuf.toString());
  if (verbose) stdout.writeln('생성 완료: ${fontLibFile.path}');
}

int _keyCompare(String a, String b) {
  final (an, bn) = (RegExp(r'^\d+$').hasMatch(a), RegExp(r'^\d+$').hasMatch(b));
  return switch ((an, bn)) {
    (true, true) => int.parse(a).compareTo(int.parse(b)),
    (true, false) => -1,
    (false, true) => 1,
    _ => a.toLowerCase().compareTo(b.toLowerCase()),
  };
}

String _pascalCase(String input) {
  final cleaned = input.replaceAll(RegExp('[^A-Za-z0-9]+'), ' ').trim();
  if (cleaned.isEmpty) return '';
  final parts = cleaned.split(RegExp(' +'));
  return parts
      .map((p) => '${p.substring(0, 1).toUpperCase()}${p.substring(1)}')
      .join();
}

String _camelCase(String input) {
  final pas = _pascalCase(input);
  if (pas.isEmpty) return '';
  return '${pas.substring(0, 1).toLowerCase()}${pas.substring(1)}';
}

String _toSnake(String input) {
  final buf = StringBuffer();
  for (int i = 0; i < input.length; i++) {
    final c = input[i];
    if (RegExp('[A-Z]').hasMatch(c)) {
      if (i != 0) buf.write('_');
      buf.write(c.toLowerCase());
    } else if (RegExp('[^a-z0-9]').hasMatch(c)) {
      buf.write('_');
    } else {
      buf.write(c);
    }
  }
  var s = buf.toString();
  s = s.replaceAll(RegExp('_+'), '_');
  s = s.replaceAll(RegExp(r'^_+'), '');
  s = s.replaceAll(RegExp(r'_+$'), '');
  return s;
}

final Set<String> _dartReserved = {
  'assert',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'do',
  'else',
  'enum',
  'extends',
  'false',
  'final',
  'finally',
  'for',
  'if',
  'in',
  'is',
  'new',
  'null',
  'rethrow',
  'return',
  'super',
  'switch',
  'this',
  'throw',
  'true',
  'try',
  'var',
  'void',
  'while',
  'with',
  'yield',
  'async',
  'await',
  'covariant',
  'deferred',
  'dynamic',
  'export',
  'extension',
  'external',
  'factory',
  'function',
  'get',
  'implements',
  'import',
  'interface',
  'late',
  'library',
  'mixin',
  'operator',
  'part',
  'required',
  'set',
  'show',
  'hide',
  'static',
  'typedef'
};

String _identifierFromKey(String key) {
  if (int.tryParse(key) != null) return 'v$key';
  var id = _camelCase(key);
  if (id.isNotEmpty && int.tryParse(id[0]) != null) id = 'v$id';
  return _dartReserved.contains(id) ? '${id}_' : id;
}

String _hexToColorLiteral(String hex) {
  final cleaned = hex.replaceFirst('#', '').toUpperCase();
  if (cleaned.length == 6) {
    return 'Color(0xFF$cleaned)';
  }
  if (cleaned.length == 8) {
    // Assume RRGGBBAA and convert to AARRGGBB
    final rrggbb = cleaned.substring(0, 6);
    final aa = cleaned.substring(6, 8);
    return 'Color(0x$aa$rrggbb)';
  }
  return 'Color(0xFF000000)';
}
