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
    ..addFlag('overwrite', abbr: 'f', help: '기존 파일 덮어쓰기', defaultsTo: true)
    ..addFlag('verbose', abbr: 'v', help: '로그 출력', defaultsTo: true);

  final argResult = parser.parse(arguments);
  final inputPath = argResult['input'] as String?;
  final outDir = argResult['out'] as String?;
  final libraryName = argResult['library'] as String;
  final verbose = argResult['verbose'] as bool;

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

  // 루트 키를 기준으로 순회하며 타입 판별 후 생성
  final rootKeys = jsonMap.keys.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  for (final root in rootKeys) {
    final node = jsonMap[root];
    if (node is Map<String, dynamic>) {
      await _generateForRoot(
          rootKey: root,
          rootMap: node,
          outDir: outDir,
          libraryName: libraryName,
          verbose: verbose);
    }
  }
}

Future<void> _generateForRoot({
  required String rootKey,
  required Map<String, dynamic> rootMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
}) async {
  // leaf 타입 스캔: color가 하나라도 있으면 color 패밀리로 생성
  final type = _inferDominantType(rootMap);
  if (type == 'color') {
    await _generateColorFamily(rootKey, rootMap, outDir, libraryName, verbose);
  } else {
    await _generateStringFamily(rootKey, rootMap, outDir, libraryName, verbose);
  }
}

String? _inferDominantType(Map<String, dynamic> node) {
  int colorCount = 0;
  int stringCount = 0;
  void walk(dynamic n) {
    if (n is Map<String, dynamic>) {
      if (n.containsKey(r'$type') && n.containsKey(r'$value')) {
        final t = n[r'$type'];
        if (t == 'color') colorCount++;
        stringCount++;
      } else {
        for (final v in n.values) {
          walk(v);
        }
      }
    }
  }

  walk(node);
  if (colorCount > 0 && colorCount >= stringCount / 2) return 'color';
  return 'string';
}

Future<void> _generateColorFamily(String rootKey, Map<String, dynamic> rootMap,
    String outDir, String libraryName, bool verbose) async {
  final classPrefix = 'WdsAtomic' + _pascalCase(rootKey);
  final buf = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln(
        '// ignore_for_file: constant_identifier_names, non_constant_identifier_names')
    ..writeln('library ' + libraryName + ';')
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln("import '../base/token_family.dart';")
    ..writeln()
    ..writeln('class ' + classPrefix + ' extends TokenColorFamily {')
    ..writeln('  const ' + classPrefix + '._();');

  // 그룹(서브맵) 노출 + 직접 토큰 처리
  final keys = rootMap.keys.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  for (final k in keys) {
    final child = rootMap[k];
    if (child is Map<String, dynamic>) {
      if (child.containsKey(r'$value') && child[r'$type'] == 'color') {
        final hex = child[r'$value'] as String?;
        if (hex != null) {
          buf.writeln('  static const Color ' +
              _identifierFromKey(k) +
              ' = ' +
              _hexToColorLiteral(hex) +
              ';');
        }
      } else {
        // 그룹 클래스로 노출
        final groupClass = _pascalCase(k);
        buf.writeln('  static const ' +
            groupClass +
            ' ' +
            _camelCase(k) +
            ' = ' +
            groupClass +
            '._();');
      }
    }
  }

  buf.writeln('}');
  buf.writeln();

  // 그룹 클래스들 생성 (numeric shade 등)
  for (final k in keys) {
    final child = rootMap[k];
    if (child is Map<String, dynamic> &&
        !(child.containsKey(r'$value') && child[r'$type'] == 'color')) {
      final className = _pascalCase(k);
      final cb = StringBuffer()
        ..writeln('class ' + className + ' {')
        ..writeln('  const ' + className + '._();');
      final entries = child.entries.toList()
        ..sort((a, b) => _keyCompare(a.key, b.key));
      for (final e in entries) {
        final v = e.value;
        if (v is Map<String, dynamic> && v[r'$type'] == 'color') {
          final hex = v[r'$value'] as String?;
          if (hex != null)
            cb.writeln('  static const Color ' +
                _identifierFromKey(e.key) +
                ' = ' +
                _hexToColorLiteral(hex) +
                ';');
        }
      }
      cb.writeln('}');
      buf.writeln(cb.toString());
      buf.writeln();
    }
  }

  final outPath = p.join(
      outDir, 'lib', 'atomic', 'wds_atomic_' + _toSnake(rootKey) + '.g.dart');
  final outFile = File(outPath);
  await outFile.create(recursive: true);
  await outFile.writeAsString(buf.toString());
  if (verbose) stdout.writeln('생성 완료: ' + outPath);
}

Future<void> _generateStringFamily(String rootKey, Map<String, dynamic> rootMap,
    String outDir, String libraryName, bool verbose) async {
  final classPrefix = 'WdsAtomic' + _pascalCase(rootKey);
  final buf = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln(
        '// ignore_for_file: constant_identifier_names, non_constant_identifier_names')
    ..writeln('library ' + libraryName + ';')
    ..writeln("import '../base/token_family.dart';")
    ..writeln()
    ..writeln('class ' + classPrefix + ' extends TokenNumberFamily {')
    ..writeln('  const ' + classPrefix + '._();');

  final entries = rootMap.entries.toList()
    ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));
  for (final e in entries) {
    final key = e.key;
    final val = e.value;
    if (val is Map<String, dynamic>) {
      final value = val[r'$value'];
      if (value is String) {
        buf.writeln("  static const String " +
            _identifierFromKey(key) +
            " = '" +
            value +
            "';");
      }
    }
  }

  buf.writeln('}');

  final outPath = p.join(
      outDir, 'lib', 'atomic', 'wds_atomic_' + _toSnake(rootKey) + '.g.dart');
  final outFile = File(outPath);
  await outFile.create(recursive: true);
  await outFile.writeAsString(buf.toString());
  if (verbose) stdout.writeln('생성 완료: ' + outPath);
}

int _keyCompare(String a, String b) {
  final an = RegExp(r'^\d+$').hasMatch(a);
  final bn = RegExp(r'^\d+$').hasMatch(b);
  if (an && bn) return int.parse(a).compareTo(int.parse(b));
  if (an) return -1;
  if (bn) return 1;
  return a.toLowerCase().compareTo(b.toLowerCase());
}

String _pascalCase(String input) {
  final cleaned = input.replaceAll(RegExp('[^A-Za-z0-9]+'), ' ').trim();
  if (cleaned.isEmpty) return '';
  final parts = cleaned.split(RegExp(' +'));
  return parts
      .map((p) => p.substring(0, 1).toUpperCase() + p.substring(1))
      .join();
}

String _camelCase(String input) {
  final pas = _pascalCase(input);
  if (pas.isEmpty) return '';
  return pas.substring(0, 1).toLowerCase() + pas.substring(1);
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
  if (int.tryParse(key) != null) return 's' + key;
  var id = _camelCase(key);
  if (id.isNotEmpty && int.tryParse(id[0]) != null) id = 'v' + id;
  if (_dartReserved.contains(id)) id = id + '_';
  return id;
}

String _hexToColorLiteral(String hex) {
  final cleaned = hex.replaceFirst('#', '').toUpperCase();
  if (cleaned.length == 6) return 'Color(0xFF' + cleaned + ')';
  return 'Color(0xFF000000)';
}
