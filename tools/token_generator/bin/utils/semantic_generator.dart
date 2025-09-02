part of '../main.dart';

String? _resolveTypographyFamily(dynamic node) {
  if (node is Map<String, dynamic> && node.containsKey(r'$value')) {
    final v = node[r'$value'];
    if (v is String && v.startsWith('{') && v.endsWith('}')) {
      final path = v.substring(1, v.length - 1);
      final parts = path.split('.');
      if (parts.length >= 3 &&
          parts[0].toLowerCase() == 'font' &&
          parts[1].toLowerCase() == 'family') {
        final name = parts[2];
        final field = _identifierFromKey(name);
        return 'WdsAtomicFontFamily.$field';
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
        return 'WdsAtomicFontWeight.$field';
      }
    } else if (v is num) {
      weight = v.toInt();
    }
  }
  return weight != null ? 'FontWeight.w$weight' : 'FontWeight.w400';
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
      if (parts.length == 2) {
        final key = parts[1];
        final tokenField = _identifierFromKey(key);
        return '$className.$tokenField';
      }
    } else if (v is num) {
      return v.toDouble().toString();
    }
  }
  return null;
}

String? _resolveTypographyLetterSpacing(
  dynamic node, {
  required double baseFontSize,
  String? sizeExpr,
}) {
  if (node is Map<String, dynamic> && node.containsKey(r'$value')) {
    final v = node[r'$value'];
    if (v is num) {
      return v.toDouble().toString();
    }
    if (v is String) {
      final asNumber = double.tryParse(v);
      if (asNumber != null) {
        return asNumber.toString();
      }
      if (v.endsWith('%')) {
        final percentValue = double.tryParse(v.replaceAll('%', ''));
        if (percentValue != null) {
          final em = percentValue / 100.0;
          return em.toString();
        }
      }
    }
  }
  return null;
}

bool _isTypographyLeafNode(dynamic node) {
  if (node is! Map<String, dynamic>) return false;
  const keys = {
    'family',
    'weight',
    'size',
    'lineHeight',
    'letterSpacing',
  };
  for (final k in keys) {
    if (node.containsKey(k)) return true;
  }
  return false;
}

String? _composeFlutterHeight({String? lineHeightExpr, String? sizeExpr}) {
  if (lineHeightExpr == null || lineHeightExpr.isEmpty) return null;
  if (lineHeightExpr == '1.0') return '1.0';
  if (sizeExpr != null && sizeExpr.isNotEmpty) {
    return '($lineHeightExpr) / ($sizeExpr)';
  }
  return null;
}

Map<String, dynamic>? _asMap(dynamic v) => v is Map<String, dynamic> ? v : null;

Future<void> _generateSemanticShadow({
  required Map<String, dynamic> jsonMap,
  required String outDir,
  required bool verbose,
  required _SemanticGenerationState state,
}) async {
  final shadowRoot = jsonMap['shadow'] as Map<String, dynamic>?;
  if (shadowRoot == null) return;

  final semanticDir = Directory(p.join(outDir, 'lib', 'semantic'));
  final shadowDir = Directory(p.join(semanticDir.path, 'shadow'));
  await shadowDir.create(recursive: true);

  // shadow는 part 목록을 모아 라이브러리에 포함한다
  final List<String> shadowPartFiles = [];

  final groupKeys = shadowRoot.keys.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  for (final gk in groupKeys) {
    final group = _asMap(shadowRoot[gk]);
    if (group == null) continue;

    final className = 'WdsSemanticShadow${_pascalCase(gk)}';
    final partFileName = 'wds_semantic_shadow_${_toSnake(gk)}.dart';

    final cb = StringBuffer()
      ..writeln(_generatedHeader)
      ..writeln(_ignoreForFile)
      ..writeln("part of '../wds_semantic_shadow.dart';")
      ..writeln()
      ..writeln('class $className {')
      ..writeln('  const $className._();');

    final variants = group.entries.toList()
      ..sort((a, b) => _keyCompare(a.key, b.key));
    final Set<String> fieldNames = {};
    for (final v in variants) {
      final variantName = v.key;
      final variantMap = _asMap(v.value);
      if (variantMap == null) continue;

      final List<String> shadows = [];
      final layers = variantMap.entries.toList()
        ..sort((a, b) => _keyCompare(a.key, b.key));
      for (final layer in layers) {
        final layerMap = _asMap(layer.value);
        if (layerMap == null) continue;

        final colorNode = _asMap(layerMap['color'] ?? layerMap['Color']);
        final blurNode = _asMap(layerMap['blur']);
        final offsetYNode = _asMap(layerMap['offsetY'] ?? layerMap['offstY']);

        String? colorExpr;
        if (colorNode != null) {
          colorExpr = _convertSemanticColorValue(colorNode[r'$value']);
        }
        final blurExpr = _resolveTypographyNumberClassed(
          blurNode,
          'WdsAtomicBlur',
        );
        final offsetYExpr = _resolveTypographyNumberClassed(
          offsetYNode,
          'WdsAtomicOffsetY',
        );

        final yExpr = offsetYExpr ?? '0.0';
        final blurVal = blurExpr ?? '0.0';
        final colorVal = colorExpr ?? 'Color(0xFF000000)';
        shadows.add(
          'BoxShadow(offset: Offset(0, $yExpr), blurRadius: $blurVal, spreadRadius: 0.0, color: $colorVal)',
        );
      }

      if (shadows.isNotEmpty) {
        final identifier = _identifierFromKey(variantName);
        if (fieldNames.add(identifier)) {
          cb.writeln(
            '  static const List<BoxShadow> $identifier = [${shadows.join(', ')}];',
          );
        }
      }
    }

    cb.writeln('}');
    final partFile = File(p.join(shadowDir.path, partFileName));
    await partFile.create(recursive: true);
    await partFile.writeAsString(cb.toString());
    state.semanticShadowParts.add(partFileName);
    shadowPartFiles.add(partFileName);
    if (verbose) stdout.writeln('생성 완료: ${partFile.path}');
  }

  final shadowLib = StringBuffer()
    ..writeln(_generatedHeader)
    ..writeln(_ignoreForFile)
    ..writeln('import "package:flutter/material.dart";')
    ..writeln('import "../atomic/atomic.dart";')
    ..writeln();
  for (final part in shadowPartFiles..sort()) {
    shadowLib.writeln("part 'shadow/$part';");
  }
  final shadowLibFile =
      File(p.join(semanticDir.path, 'wds_semantic_shadow.dart'));
  await shadowLibFile.create(recursive: true);
  await shadowLibFile.writeAsString(shadowLib.toString());
  state.generatedSemanticShadow = true;
  if (verbose) stdout.writeln('생성 완료: ${shadowLibFile.path}');
}

Future<void> _syncSemanticOutputs({
  required String outDir,
  required _SemanticGenerationState state,
  required bool verbose,
}) async {
  final semanticColorDir =
      Directory(p.join(outDir, 'lib', 'semantic', 'color'));
  if (await semanticColorDir.exists()) {
    await for (final entity in semanticColorDir.list(followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        final isGenerated =
            name.startsWith('wds_semantic_color_') && name.endsWith('.dart');
        if (isGenerated && !state.semanticColorParts.contains(name)) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
  }

  // cleanup shadow parts
  final semanticShadowDir =
      Directory(p.join(outDir, 'lib', 'semantic', 'shadow'));
  if (await semanticShadowDir.exists()) {
    await for (final entity in semanticShadowDir.list(followLinks: false)) {
      if (entity is File) {
        final name = p.basename(entity.path);
        final isGenerated =
            name.startsWith('wds_semantic_shadow_') && name.endsWith('.dart');
        if (isGenerated && !state.semanticShadowParts.contains(name)) {
          await entity.delete();
          if (verbose) stdout.writeln('정리 완료(삭제): ${entity.path}');
        }
      }
    }
  }

  final semanticDir = Directory(p.join(outDir, 'lib', 'semantic'));
  final semanticIndex = StringBuffer()
    ..writeln('library;')
    ..writeln("export 'wds_semantic_color.dart';")
    ..writeln("export 'wds_semantic_typography.dart';")
    ..writeln("export 'wds_semantic_shadow.dart';");
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
