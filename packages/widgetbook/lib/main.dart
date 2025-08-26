import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as wb;

import 'main.directories.g.dart';
import 'src/widgetbook_components/widgetbook_components.dart' as wbc;

void main() {
  runApp(const WidgetbookApp());
}

@wb.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      themeMode: ThemeMode.light,
      lightTheme: wbc.WidgetbookCustomTheme.lightTheme,
      darkTheme: wbc.WidgetbookCustomTheme.darkTheme,
      addons: [
        GridAddon(),
        InspectorAddon(enabled: true),
        ZoomAddon(),
        ViewportAddon(Viewports.all),
        SemanticsAddon(),
        TextScaleAddon(),
      ],
    );
  }
}
