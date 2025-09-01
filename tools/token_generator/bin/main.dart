import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

part 'utils/atomic_generator.dart';
part 'utils/common_utils.dart';
part 'utils/semantic_generator.dart';
part 'utils/type_converters.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'input',
      abbr: 'i',
      help: '입력 JSON 파일 경로',
      valueHelp: 'path/to/file.json',
    )
    ..addOption(
      'out',
      abbr: 'o',
      help: '출력 디렉터리 (예: packages/tokens)',
      valueHelp: 'path/to/output_dir',
    )
    ..addOption(
      'library',
      abbr: 'l',
      help: '라이브러리 이름',
      defaultsTo: 'wds_tokens',
    )
    ..addOption(
      'kind',
      abbr: 'k',
      help: '생성 모드: atomic 또는 semantic',
      allowed: ['atomic', 'semantic'],
      defaultsTo: 'atomic',
    )
    ..addFlag('overwrite', abbr: 'f', help: '기존 파일 덮어쓰기', defaultsTo: true)
    ..addFlag('verbose', abbr: 'v', help: '로그 출력', defaultsTo: true)
    ..addFlag(
      'sync',
      abbr: 's',
      help: 'JSON 기준으로 출력 디렉터리 동기화(불필요 파일 삭제 + export 인덱스 생성)',
      defaultsTo: true,
    )
    ..addOption(
      'base-font-size',
      help: 'letterSpacing 계산 시 사용할 기본 폰트 크기(px)',
      valueHelp: '16.0',
      defaultsTo: '16.0',
    );

  final argResult = parser.parse(arguments);
  final inputPath = argResult['input'] as String?;
  final outDir = argResult['out'] as String?;
  final libraryName = argResult['library'] as String;
  final kind = argResult['kind'] as String;
  final verbose = argResult['verbose'] as bool;
  final sync = argResult['sync'] as bool;
  final baseFontSize =
      double.tryParse((argResult['base-font-size'] as String?) ?? '16.0') ??
          16.0;

  if (inputPath == null || outDir == null) {
    stderr.writeln('사용법:');
    stderr.writeln('  # atomic: JSON → packages/tokens');
    stderr.writeln(
      '  dart run bin/main.dart -k atomic    -i tokens/design_system_atomic.json    -o packages/tokens',
    );
    stderr.writeln();
    stderr.writeln('  # semantic: JSON → packages/tokens');
    stderr.writeln(
      '  dart run bin/main.dart -k semantic  -i tokens/design_system_semantic.json  -o packages/tokens',
    );
    stderr.writeln();

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

  final inputJsonFile = File(inputPath);
  final Map<String, dynamic> jsonMap =
      jsonDecode(await inputJsonFile.readAsString()) as Map<String, dynamic>;

  if (kind == 'atomic') {
    await _generateAtomic(
      jsonMap: jsonMap,
      outDir: outDir,
      libraryName: libraryName,
      verbose: verbose,
      sync: sync,
    );
  } else if (kind == 'semantic') {
    await _generateSemantic(
      jsonMap: jsonMap,
      outDir: outDir,
      libraryName: libraryName,
      verbose: verbose,
      sync: sync,
      baseFontSize: baseFontSize,
    );
  }
}

Future<void> _generateAtomic({
  required Map<String, dynamic> jsonMap,
  required String outDir,
  required String libraryName,
  required bool verbose,
  required bool sync,
}) async {
  final state = _AtomicGenerationState();
  final hasFontRoot = _hasFontRootKey(jsonMap);

  await _processAtomicTokens(
    jsonMap: jsonMap,
    outDir: outDir,
    libraryName: libraryName,
    verbose: verbose,
    hasFontRoot: hasFontRoot,
    state: state,
  );

  if (sync) {
    await _syncAtomicOutputs(
      outDir: outDir,
      libraryName: libraryName,
      state: state,
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
  required double baseFontSize,
}) async {
  final state = _SemanticGenerationState();
  final semanticDir = Directory(p.join(outDir, 'lib', 'semantic'));
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
          ..writeln(_generatedHeader)
          ..writeln(_ignoreForFile)
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
        state.semanticColorParts.add(partFileName);
        partsMeta.add((className, fieldName, partRelativePath, partFileName));
        if (verbose) stdout.writeln('생성 완료: ${partFile.path}');
      }
    }

    final colorLib = StringBuffer()
      ..writeln(_generatedHeader)
      ..writeln(_ignoreForFile)
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
        colorLib.writeln('const Color \$${_identifierFromKey(k)} = $expr;');
      }
    }
    // 그룹 클래스는 part 파일로만 제공

    final colorLibFile = File(p.join(semanticDir.path, 'color.dart'));
    await colorLibFile.create(recursive: true);
    await colorLibFile.writeAsString(colorLib.toString());
    state.generatedSemanticColor = true;
    if (verbose) stdout.writeln('생성 완료: ${colorLibFile.path}');
  }

  // semantic/typography
  final typographyRoot = jsonMap.entries.firstWhere(
    (e) =>
        e.key.toString().toLowerCase() == 'typography' &&
        e.value is Map<String, dynamic>,
    orElse: () => const MapEntry('', null),
  );
  if (typographyRoot.value is Map<String, dynamic>) {
    final tyMap = typographyRoot.value as Map<String, dynamic>;
    final sb = StringBuffer()
      ..writeln(_generatedHeader)
      ..writeln(_ignoreForFile)
      ..writeln('import "package:flutter/material.dart";')
      ..writeln('import "../atomic/atomic.dart";')
      ..writeln();
    sb.writeln('class WdsSemanticTypography {');
    sb.writeln('  const WdsSemanticTypography._();');

    for (final MapEntry(:key, :value)
        in tyMap.entries.where((e) => e.value is Map<String, dynamic>)) {
      final styleName = key; // e.g., Heading18, Body15
      final variants = value as Map<String, dynamic>;

      for (final MapEntry(:key, :value)
          in variants.entries.where((e) => e.value is Map<String, dynamic>)) {
        final variantOrGroupName = key; // e.g., bold or Normal/Reading
        final propsOrGroup = value as Map<String, dynamic>;

        // Body 계열 예외: Normal/Reading과 같은 중첩 그룹 지원
        if (!_isTypographyLeafNode(propsOrGroup)) {
          for (final MapEntry(:key, :value) in propsOrGroup.entries
              .where((e) => e.value is Map<String, dynamic>)) {
            final innerVariantName = key; // e.g., bold/medium/regular
            final innerProps = value as Map<String, dynamic>;
            if (!_isTypographyLeafNode(innerProps)) continue;

            final fieldName = _camelCase(
              '${styleName}_${variantOrGroupName}_$innerVariantName',
            );

            final familyExpr = _resolveTypographyFamily(innerProps['family']);
            final weightExpr = _resolveTypographyWeight(innerProps['weight']);
            final sizeExpr = _resolveTypographyNumberClassed(
              innerProps['size'],
              'WdsFontSize',
            );
            final lineHeightExpr = _resolveTypographyNumberClassed(
              innerProps['lineHeight'],
              'WdsFontLineHeight',
            );
            final letterSpacingExpr = _resolveTypographyLetterSpacing(
              innerProps['letterSpacing'],
              sizeExpr: sizeExpr,
              baseFontSize: baseFontSize,
            );

            final lines = <String>[];
            if (familyExpr != null) lines.add('fontFamily: $familyExpr');
            if (weightExpr != null) lines.add('fontWeight: $weightExpr');
            if (sizeExpr != null) lines.add('fontSize: $sizeExpr');
            final heightExpr = _composeFlutterHeight(
              lineHeightExpr: lineHeightExpr,
              sizeExpr: sizeExpr,
            );
            if (heightExpr != null) lines.add('height: $heightExpr');
            if (letterSpacingExpr != null) {
              lines.add('letterSpacing: $letterSpacingExpr');
            }

            sb.writeln('  static const TextStyle $fieldName = TextStyle(');
            for (int i = 0; i < lines.length; i++) {
              sb.writeln('    ${lines[i]},');
            }
            sb.writeln('  );');
          }
          continue;
        }

        // 일반(2단계) 구조 처리
        final fieldName = _camelCase('${styleName}_$variantOrGroupName');

        final familyExpr = _resolveTypographyFamily(propsOrGroup['family']);
        final weightExpr = _resolveTypographyWeight(propsOrGroup['weight']);
        final sizeExpr = _resolveTypographyNumberClassed(
          propsOrGroup['size'],
          'WdsFontSize',
        );
        final lineHeightExpr = _resolveTypographyNumberClassed(
          propsOrGroup['lineHeight'],
          'WdsFontLineHeight',
        );
        final letterSpacingExpr = _resolveTypographyLetterSpacing(
          propsOrGroup['letterSpacing'],
          sizeExpr: sizeExpr,
          baseFontSize: baseFontSize,
        );

        final lines = <String>[];
        if (familyExpr != null) lines.add('fontFamily: $familyExpr');
        if (weightExpr != null) lines.add('fontWeight: $weightExpr');
        if (sizeExpr != null) lines.add('fontSize: $sizeExpr');
        final heightExpr = _composeFlutterHeight(
          lineHeightExpr: lineHeightExpr,
          sizeExpr: sizeExpr,
        );
        if (heightExpr != null) lines.add('height: $heightExpr');
        if (letterSpacingExpr != null) {
          lines.add('letterSpacing: $letterSpacingExpr');
        }

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
    state.generatedSemanticTypography = true;
    if (verbose) stdout.writeln('생성 완료: ${file.path}');
  }

  if (sync) {
    await _syncSemanticOutputs(
      outDir: outDir,
      state: state,
      verbose: verbose,
    );
  }
}
