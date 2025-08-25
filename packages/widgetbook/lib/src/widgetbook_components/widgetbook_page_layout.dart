import 'package:flutter/material.dart';
import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_title.dart';

class WidgetbookPageLayout extends StatelessWidget {
  const WidgetbookPageLayout({
    required this.title,
    required this.children,
    this.description,
    this.childrenSpacing = 16,
    super.key,
  });

  final String title;

  final String? description;

  final List<Widget> children;

  final double childrenSpacing;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: InteractiveViewer(
          maxScale: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: childrenSpacing,
              children: [
                WidgetbookTitle(
                  title: title,
                  description: description,
                ),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
