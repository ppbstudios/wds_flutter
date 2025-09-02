part of '../main.dart';

Future<void> _processAtomicTokens({
  required Map<String, dynamic> jsonMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
  required bool hasFontRoot,
  required _AtomicGenerationState state,
}) async {
  for (final MapEntry(:key, :value)
      in jsonMap.entries.where((e) => e.value is Map<String, dynamic>)) {
    final rootKey = key;
    final rootMap = value as Map<String, dynamic>;

    if (await _handleSpecialRootKey(
      rootKey: rootKey,
      rootMap: rootMap,
      outDir: outDir,
      libraryName: libraryName,
      verbose: verbose,
      state: state,
    )) {
      continue;
    }

    if (_shouldSkipRootKey(rootKey, hasFontRoot, rootMap, verbose)) {
      continue;
    }

    final basename = 'wds_atomic_${_toSnake(rootKey)}.dart';
    state.generatedBasenames.add(basename);
    await _generateForRoot(
      rootKey: rootKey,
      rootMap: rootMap,
      outDir: outDir,
      libraryName: libraryName,
      verbose: verbose,
    );
  }
}

Future<bool> _handleSpecialRootKey({
  required String rootKey,
  required Map<String, dynamic> rootMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
  required _AtomicGenerationState state,
}) async {
  final lowerKey = rootKey.toLowerCase();

  if (lowerKey == 'color') {
    await _generateColorLibrary(
      rootMap: rootMap,
      outDir: outDir,
      libraryName: libraryName,
      verbose: verbose,
      generatedPartBasenames: state.generatedColorPartBasenames,
    );
    state.generatedColorLibrary = true;
    return true;
  }

  if (lowerKey == 'font') {
    await _generateFontLibrary(
      rootMap: rootMap,
      outDir: outDir,
      libraryName: libraryName,
      verbose: verbose,
      generatedPartBasenames: state.generatedFontPartBasenames,
    );
    state.generatedFontLibrary = true;
    return true;
  }

  return false;
}

bool _shouldSkipRootKey(
  String rootKey,
  bool hasFontRoot,
  Map<String, dynamic> rootMap,
  bool verbose,
) {
  final lower = rootKey.toLowerCase();

  if (hasFontRoot &&
      (lower == 'fontsize' ||
          lower == 'lineheights' ||
          lower == 'letterspacing')) {
    if (verbose) stdout.writeln('스킵: $rootKey (font 루트에 포함되어 중복)');
    return true;
  }

  final dominantType = _inferDominantType(rootMap);
  if (dominantType == 'paragraphSpacing') {
    if (verbose) stdout.writeln('스킵: $rootKey (paragraphSpacing)');
    return true;
  }

  return false;
}

Future<void> _generateForRoot({
  required String rootKey,
  required Map<String, dynamic> rootMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
}) async {
  final dominantType = _inferDominantType(rootMap);
  await _generateTokenFamily(
    rootKey,
    rootMap,
    dominantType,
    outDir,
    libraryName,
    verbose,
  );
}

Future<void> _generateTokenFamily(
  String rootKey,
  Map<String, dynamic> rootMap,
  String dominantType,
  String outDir,
  String libraryName,
  bool verbose,
) async {
  final classPrefix = 'WdsAtomic${_pascalCase(rootKey)}';
  final rootPrefix = _pascalCase(rootKey);
  final buf = StringBuffer()
    ..writeln(_generatedHeader)
    ..writeln(_ignoreForFile)
    ..writeln('library $libraryName;')
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln()
    ..writeln('class $classPrefix {')
    ..writeln('  const $classPrefix._();');

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
        String? convertedValue = _convertValueByType(type, value);
        final normalizedOpacity =
            _normalizeOpacityIfNeeded(rootKey, type, value);
        if (normalizedOpacity != null) convertedValue = normalizedOpacity;
        final identifier = _identifierFromKey(k);
        if (exposedTopLevelNames.add(identifier)) {
          buf.writeln(
            '  static const ${_getDartTypeForToken(type)} $identifier = $convertedValue;',
          );
        }
      } else {
        final groupClassBase = _pascalCase(k);
        final groupClass =
            groupClassBase.isEmpty ? '' : '$rootPrefix$groupClassBase';
        if (groupClass.isNotEmpty && exposedGroupClassNames.add(groupClass)) {
          buf.writeln(
            '  static const $groupClass ${_camelCase(k)} = $groupClass._();',
          );
        }
      }
    }
  }

  buf.writeln('}');
  buf.writeln();

  final Set<String> generatedGroupClassNames = {};
  for (final k in keys) {
    final child = rootMap[k];
    if (child is Map<String, dynamic> &&
        !(child.containsKey(r'$value') && child.containsKey(r'$type'))) {
      final classNameBase = _pascalCase(k);
      final className =
          classNameBase.isEmpty ? '' : '$rootPrefix$classNameBase';
      if (className.isEmpty || !generatedGroupClassNames.add(className)) {
        continue;
      }
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
          String? convertedValue = _convertValueByType(type, value);
          final normalizedOpacity =
              _normalizeOpacityIfNeeded(rootKey, type, value);
          if (normalizedOpacity != null) convertedValue = normalizedOpacity;
          final identifier = _identifierFromKey(e.key);
          if (fieldNames.add(identifier)) {
            cb.writeln(
              '  static const ${_getDartTypeForToken(type)} $identifier = $convertedValue;',
            );
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

Future<void> _generateColorLibrary({
  required Map<String, dynamic> rootMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
  required Set<String> generatedPartBasenames,
}) async {
  final atomicDir = Directory(p.join(outDir, 'lib', 'atomic'));
  final colorDir = Directory(p.join(atomicDir.path, 'wds_atomic_color'));
  await colorDir.create(recursive: true);

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
    final isLeaf = value.containsKey(r'$type') && value.containsKey(r'$value');
    if (isLeaf) continue;

    final classNameBase = _pascalCase(key);
    if (classNameBase.isEmpty) continue;
    final className = 'WdsAtomicColor$classNameBase';
    if (!generatedClassNames.add(className)) {
      continue;
    }

    final fieldName = _camelCase(key);
    final partFileName = 'wds_atomic_color_${_toSnake(key)}.dart';
    final partRelativePath = 'wds_atomic_color/$partFileName';

    final cb = StringBuffer()
      ..writeln(_generatedHeader)
      ..writeln(_ignoreForFile)
      ..writeln("part of '../wds_atomic_color.dart';")
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
        if (className == 'WdsFontWeight') {
          final fw = _convertToFontWeight(val);
          if (fw != null && fieldNames.add(identifier)) {
            cb.writeln('  static const FontWeight $identifier = $fw;');
          }
        } else {
          final convertedValue = _convertValueByType(type, val);
          if (convertedValue != null && fieldNames.add(identifier)) {
            cb.writeln(
              '  static const ${_getDartTypeForToken(type)} $identifier = $convertedValue;',
            );
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

  final libBuf = StringBuffer()
    ..writeln(_generatedHeader)
    ..writeln(_ignoreForFile)
    ..writeln('import "package:flutter/material.dart";')
    ..writeln();

  // Top-level color leaves (e.g., white, black) → generate public const without prefix
  final topLevelLeafKeys = <String, String>{}; // identifier -> valueExpr
  for (final entry in rootMap.entries) {
    final key = entry.key;
    final value = entry.value;
    if (value is Map<String, dynamic> &&
        value.containsKey(r'$type') &&
        value.containsKey(r'$value')) {
      final type = value[r'$type'] as String;
      if (type != 'color') continue;
      final val = value[r'$value'];
      final converted = _convertValueByType(type, val);
      if (converted != null) {
        final id = _identifierFromKey(key);
        topLevelLeafKeys[id] = converted;
      }
    }
  }

  for (final meta in partsMeta) {
    libBuf.writeln("part '${meta.$3}';");
  }

  if (topLevelLeafKeys.isNotEmpty) {
    libBuf.writeln();
    final sorted = topLevelLeafKeys.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    for (final id in sorted) {
      libBuf.writeln('const Color \$$id = ${topLevelLeafKeys[id]!};');
    }
  }

  final colorLibFile = File(p.join(atomicDir.path, 'wds_atomic_color.dart'));
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
  final fontDir = Directory(p.join(atomicDir.path, 'wds_atomic_font'));
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

  for (final key in keys) {
    final value = rootMap[key];
    if (value is! Map<String, dynamic>) continue;

    final isLeaf = value.containsKey(r'$type') && value.containsKey(r'$value');
    if (isLeaf) continue;

    final classNameBase = _pascalCase(key);
    if (classNameBase.isEmpty) continue;
    final className = 'WdsAtomicFont$classNameBase';
    final fieldName = _camelCase(key);
    final partFileName = 'wds_atomic_font_${_toSnake(key)}.dart';
    final partRelativePath = 'wds_atomic_font/$partFileName';

    final cb = StringBuffer()
      ..writeln(_generatedHeader)
      ..writeln(_ignoreForFile)
      ..writeln("part of '../wds_atomic_font.dart';")
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
        if (className == 'WdsAtomicFontWeight') {
          final fw = _convertToFontWeight(val);
          if (fw != null && fieldNames.add(identifier)) {
            cb.writeln('  static const FontWeight $identifier = $fw;');
          }
        } else {
          final convertedValue = _convertValueByType(type, val);
          if (convertedValue != null && fieldNames.add(identifier)) {
            cb.writeln(
              '  static const ${_getDartTypeForToken(type)} $identifier = $convertedValue;',
            );
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

  final libBuf = StringBuffer()
    ..writeln(_generatedHeader)
    ..writeln(_ignoreForFile)
    ..writeln('import "package:flutter/material.dart";')
    ..writeln();

  for (final meta in partsMeta) {
    libBuf.writeln("part '${meta.$3}';");
  }

  final fontLibFile = File(p.join(atomicDir.path, 'wds_atomic_font.dart'));
  await fontLibFile.create(recursive: true);
  await fontLibFile.writeAsString(libBuf.toString());
  if (verbose) stdout.writeln('생성 완료: ${fontLibFile.path}');
}

Future<void> _syncAtomicOutputs({
  required String outDir,
  required String libraryName,
  required _AtomicGenerationState state,
  required bool verbose,
}) async {
  final atomicDir = Directory(p.join(outDir, 'lib', 'atomic'));
  if (await atomicDir.exists()) {
    await for (final entity in atomicDir.list(followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        final isAtomic =
            name.startsWith('wds_atomic_') && name.endsWith('.dart');
        final isLegacyGenerated =
            name.startsWith('wds_atomic_') && name.endsWith('.g.dart');

        // 최신 메인 라이브러리 보존
        final isNewMainColorLib = name == 'wds_atomic_color.dart';
        final isNewMainFontLib = name == 'wds_atomic_font.dart';
        final shouldKeep = (isNewMainColorLib && state.generatedColorLibrary) ||
            (isNewMainFontLib && state.generatedFontLibrary) ||
            state.generatedBasenames.contains(name);

        // 구 구조 파일(color.dart, font.dart) 제거
        final isOldMainLib = name == 'color.dart' || name == 'font.dart';

        if ((isAtomic && !shouldKeep) || isLegacyGenerated || isOldMainLib) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
  }

  final colorPartsDir = Directory(
    p.join(outDir, 'lib', 'atomic', 'wds_atomic_color'),
  );
  if (await colorPartsDir.exists()) {
    await for (final entity in colorPartsDir.list(followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        final isGenerated =
            name.startsWith('wds_atomic_color_') && name.endsWith('.dart');
        if (isGenerated && !state.generatedColorPartBasenames.contains(name)) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
  }

  // 구 구조 color/ 제거 (wds_color_*)
  final oldColorDir = Directory(p.join(outDir, 'lib', 'atomic', 'color'));
  if (await oldColorDir.exists()) {
    await for (final entity in oldColorDir.list(followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        if (name.startsWith('wds_color_') && name.endsWith('.dart')) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
    // 폴더 비면 삭제 시도
    if ((await oldColorDir.list(followLinks: false).length) == 0) {
      await oldColorDir.delete().catchError((_) => oldColorDir);
    }
  }

  final fontPartsDir =
      Directory(p.join(outDir, 'lib', 'atomic', 'wds_atomic_font'));
  if (await fontPartsDir.exists()) {
    await for (final entity in fontPartsDir.list(followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        final isGenerated =
            name.startsWith('wds_atomic_font_') && name.endsWith('.dart');
        if (isGenerated && !state.generatedFontPartBasenames.contains(name)) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
  }

  // 구 구조 font/ 제거 (wds_font_*)
  final oldFontDir = Directory(p.join(outDir, 'lib', 'atomic', 'font'));
  if (await oldFontDir.exists()) {
    await for (final entity in oldFontDir.list(followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        if (name.startsWith('wds_font_') && name.endsWith('.dart')) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
    if ((await oldFontDir.list(followLinks: false).length) == 0) {
      await oldFontDir.delete().catchError((_) => oldFontDir);
    }
  }

  final exportsInAtomic = <String>[];
  if (state.generatedColorLibrary) exportsInAtomic.add('wds_atomic_color.dart');
  if (state.generatedFontLibrary) exportsInAtomic.add('wds_atomic_font.dart');
  exportsInAtomic.addAll(state.generatedBasenames);
  exportsInAtomic.sort();
  final atomicIndex = StringBuffer()
    ..writeln('library;')
    ..writeln("export 'wds_atomic_color.dart';")
    ..writeln("export 'wds_atomic_font.dart';");
  for (final e in exportsInAtomic) {
    if (e.endsWith('.dart') && e.startsWith('wds_atomic_')) {
      atomicIndex.writeln("export '$e';");
    }
  }
  final atomicIndexFile = File(p.join(outDir, 'lib', 'atomic', 'atomic.dart'));
  await atomicIndexFile.create(recursive: true);
  await atomicIndexFile.writeAsString(atomicIndex.toString());
  if (verbose) stdout.writeln('생성 완료: ${atomicIndexFile.path}');

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
