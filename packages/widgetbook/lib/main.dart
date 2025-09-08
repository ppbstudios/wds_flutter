import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as wb;
import 'package:widgetbook_size_inspector/widgetbook_size_inspector.dart';

import 'main.directories.g.dart';
import 'src/widgetbook_components/widgetbook_components.dart' as wbc;

void main() {
  runApp(const WidgetbookApp());
}

@wb.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  static const _categoryOrder = {
    'foundation': 0,
    'component': 1,
  };

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories
        ..sort(
          (p0, p1) {
            if (p0 is WidgetbookCategory && p1 is WidgetbookCategory) {
              return _categoryOrder[p0.name]!.compareTo(
                _categoryOrder[p1.name]!,
              );
            }

            return 0;
          },
        ),
      themeMode: ThemeMode.light,
      lightTheme: wbc.WidgetbookCustomTheme.lightTheme,
      darkTheme: wbc.WidgetbookCustomTheme.darkTheme,
      initialRoute: 'about',
      addons: [
        GridAddon(),
        InspectorAddon(),
        SizeInspectorAddon(), // New accurate inspector
        ZoomAddon(),
        ViewportAddon(Viewports.all),
        SemanticsAddon(),
        TextScaleAddon(),
      ],
    );
  }
}
