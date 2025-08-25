// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:wds_widgetbook/src/cover.dart' as _wds_widgetbook_src_cover;
import 'package:wds_widgetbook/src/foundation/color/atomic_color_use_case.dart'
    as _wds_widgetbook_src_foundation_color_atomic_color_use_case;
import 'package:wds_widgetbook/src/foundation/color/semantic_color_use_case.dart'
    as _wds_widgetbook_src_foundation_color_semantic_color_use_case;
import 'package:wds_widgetbook/src/foundation/radius/radius_use_case.dart'
    as _wds_widgetbook_src_foundation_radius_radius_use_case;
import 'package:wds_widgetbook/src/foundation/typography/typography_use_case.dart'
    as _wds_widgetbook_src_foundation_typography_typography_use_case;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: '/',
    children: [
      _widgetbook.WidgetbookLeafComponent(
        name: 'WincDesginSystem',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'Cover',
          builder: _wds_widgetbook_src_cover.buildWdsCover,
        ),
      )
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'color',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'Color',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Atomic Color',
            builder: _wds_widgetbook_src_foundation_color_atomic_color_use_case
                .buildWdsAtomicColorsUseCase,
            designLink:
                'https://www.figma.com/design/jZaYUOtWAtNGDL9h6dTjK6/WDS--WINC-Design-System-?node-id=2-24',
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Semantic Color',
            builder:
                _wds_widgetbook_src_foundation_color_semantic_color_use_case
                    .buildWdsSemanticColorUseCase,
          ),
        ],
      )
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'radius',
    children: [
      _widgetbook.WidgetbookLeafComponent(
        name: 'BorderRadius',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'Radius',
          builder: _wds_widgetbook_src_foundation_radius_radius_use_case
              .buildWdsRadiusUseCase,
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
          builder: _wds_widgetbook_src_foundation_typography_typography_use_case
              .buildWdsTypographyUseCase,
          designLink:
              'https://www.figma.com/design/jZaYUOtWAtNGDL9h6dTjK6/WDS--WINC-Design-System-?node-id=2-24',
        ),
      )
    ],
  ),
];
