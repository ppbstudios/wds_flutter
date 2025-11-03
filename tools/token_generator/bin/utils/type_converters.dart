part of '../main.dart';

String? _convertValueByType(String type, dynamic value) => switch (type) {
  'color' => _convertColorValue(value),
  'dimension' => _convertDimensionValue(value),
  'number' => _convertNumberValue(value),
  'text' => _convertTextValue(value),
  'boxShadow' => _convertBoxShadowValue(value),
  'lineHeight' => _convertLineHeightValue(value),
  'fontSize' => _convertFontSizeValue(value),
  'letterSpacing' => _convertLetterSpacingValue(value),
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

String? _convertTextValue(dynamic value) {
  if (value is String) {
    return "'${value.replaceAll("'", "\\\\'")}'";
  }
  return null;
}

String? _convertBoxShadowValue(dynamic value) => switch (value) {
  List list => () {
    final shadows = [
      for (final item in list)
        if (item is Map<String, dynamic>) _convertSingleBoxShadow(item),
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
    return percentValue != null ? (percentValue / 100.0).toString() : null;
  }(),
  String s when double.tryParse(s) != null => double.parse(s).toString(),
  num n => n.toDouble().toString(),
  _ => null,
};

String _hexToColorLiteral(String hex) {
  final cleaned = hex.replaceFirst('#', '').toUpperCase();
  if (cleaned.length == 6) {
    return 'Color(0xFF$cleaned)';
  }
  if (cleaned.length == 8) {
    final rrggbb = cleaned.substring(0, 6);
    final aa = cleaned.substring(6, 8);
    return 'Color(0x$aa$rrggbb)';
  }
  return 'Color(0xFF000000)';
}

String? _normalizeOpacityIfNeeded(String rootKey, String type, dynamic raw) {
  if (rootKey.toLowerCase() == 'opacity' && type == 'number') {
    double? n;
    if (raw is num) n = raw.toDouble();
    if (raw is String) n = double.tryParse(raw);
    if (n != null) {
      return (n / 100.0).toString();
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

String? _convertSemanticColorValue(dynamic raw) {
  if (raw is String) {
    if (raw.startsWith('{') && raw.endsWith('}')) {
      final path = raw.substring(1, raw.length - 1);
      final parts = path.split('.');
      if (parts.isNotEmpty && parts.first.toLowerCase() == 'color') {
        if (parts.length == 3) {
          final group = parts[1];
          final key = parts[2];
          final className = 'WdsAtomicColor${_pascalCase(group)}';
          final tokenField = _identifierFromKey(key);
          return '$className.$tokenField';
        } else if (parts.length == 2) {
          // Top-level color leaf (e.g., {color.White}) → reference generated top-level const (e.g., white)
          final leaf = parts[1];
          final identifier = _identifierFromKey(leaf);
          return '\$$identifier';
        }
      }
    }
    if (raw.startsWith('#')) {
      return _hexToColorLiteral(raw);
    }
  }
  return null;
}
