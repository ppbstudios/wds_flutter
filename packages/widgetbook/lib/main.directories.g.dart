// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:wds_widgetbook/src/tokens/atomic/color/main.dart'
    as _wds_widgetbook_src_tokens_atomic_color_main;
import 'package:wds_widgetbook/src/tokens/atomic/typography/main.dart'
    as _wds_widgetbook_src_tokens_atomic_typography_main;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'color',
    children: [
      _widgetbook.WidgetbookLeafComponent(
        name: 'Color',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'Atomic Color',
          builder: _wds_widgetbook_src_tokens_atomic_color_main
              .buildWdsAtomicColorsUseCase,
          designLink:
              'https://www.figma.com/design/jZaYUOtWAtNGDL9h6dTjK6/WDS--WINC-Design-System-?node-id=2-24',
        ),
      )
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'typography',
    children: [
      _widgetbook.WidgetbookLeafComponent(
        name: 'TextStyle',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'Typography',
          builder: _wds_widgetbook_src_tokens_atomic_typography_main
              .buildWdsTypographyUseCase,
          designLink:
              'https://www.figma.com/design/jZaYUOtWAtNGDL9h6dTjK6/WDS--WINC-Design-System-?node-id=2-24',
        ),
      )
    ],
  ),
];
