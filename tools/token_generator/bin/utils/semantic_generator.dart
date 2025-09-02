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

  final semanticDir = Directory(p.join(outDir, 'lib', 'semantic'));
  final semanticIndex = StringBuffer()
    ..writeln('library;')
    ..writeln("export 'wds_semantic_color.dart';")
    ..writeln("export 'wds_semantic_typography.dart';");
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
