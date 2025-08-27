// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:wds_widgetbook/src/component/button_use_case.dart'
    as _wds_widgetbook_src_component_button_use_case;
import 'package:wds_widgetbook/src/component/square_button_use_case.dart'
    as _wds_widgetbook_src_component_square_button_use_case;
import 'package:wds_widgetbook/src/component/text_button_use_case.dart'
    as _wds_widgetbook_src_component_text_button_use_case;
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
  _widgetbook.WidgetbookCategory(
    name: 'component',
    children: [
      _widgetbook.WidgetbookLeafComponent(
        name: 'Button',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'Button',
          builder: _wds_widgetbook_src_component_button_use_case
              .buildWdsButtonUseCase,
        ),
      ),
      _widgetbook.WidgetbookLeafComponent(
        name: 'SquareButton',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'SquareButton',
          builder: _wds_widgetbook_src_component_square_button_use_case
              .buildWdsSquareButtonUseCase,
        ),
      ),
      _widgetbook.WidgetbookLeafComponent(
        name: 'TextButton',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'TextButton',
          builder: _wds_widgetbook_src_component_text_button_use_case
              .buildWdsTextButtonUseCase,
        ),
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'foundation',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'Color',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Atomic',
            builder: _wds_widgetbook_src_foundation_color_atomic_color_use_case
                .buildWdsAtomicColorsUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Semantic',
            builder:
                _wds_widgetbook_src_foundation_color_semantic_color_use_case
                    .buildWdsSemanticColorUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookLeafComponent(
        name: 'Radius',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'Radius',
          builder: _wds_widgetbook_src_foundation_radius_radius_use_case
              .buildWdsRadiusUseCase,
        ),
      ),
      _widgetbook.WidgetbookLeafComponent(
        name: 'Typography',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'Typography',
          builder: _wds_widgetbook_src_foundation_typography_typography_use_case
              .buildWdsTypographyUseCase,
        ),
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'about',
    children: [
      _widgetbook.WidgetbookLeafComponent(
        name: 'Cover',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'Cover',
          builder: _wds_widgetbook_src_cover.buildWdsCover,
        ),
      )
    ],
  ),
];
