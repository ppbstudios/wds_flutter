import 'package:flutter/material.dart';
import 'package:wds_tokens/atomic/font.dart';
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
      themeMode: ThemeMode.light,
      lightTheme: ThemeData(
        fontFamily: WdsFontFamily.pretendard,
      ),
      addons: [
        GridAddon(),
        InspectorAddon(),
        ZoomAddon(),
        ViewportAddon(Viewports.all),
        SemanticsAddon(),
        TextScaleAddon(),
      ],
    );
  }
}
