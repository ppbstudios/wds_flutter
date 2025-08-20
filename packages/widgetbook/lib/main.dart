import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as wb;

import 'main.directories.g.dart';

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
      addons: [
        GridAddon(),
        InspectorAddon(),
        ZoomAddon(),
        ViewportAddon([
          Viewports.none,
          IosViewports.iPad,
          IosViewports.iPhone13ProMax,
          IosViewports.iPhone13,
          AndroidViewports.samsungGalaxyNote20,
          AndroidViewports.samsungGalaxyS20,
        ])
      ],
    );
  }
}
