part of 'widgetbook_components.dart';

class WidgetbookPageLayout extends StatefulWidget {
  const WidgetbookPageLayout({
    required this.title,
    required this.children,
    this.description,
    this.childrenSpacing = 24,
    super.key,
  });

  final String title;
  final String? description;
  final List<Widget> children;
  final double childrenSpacing;

  @override
  State<WidgetbookPageLayout> createState() => _WidgetbookPageLayoutState();
}

class _WidgetbookPageLayoutState extends State<WidgetbookPageLayout> {
  final controller = TransformationController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WdsColors.white,
      body: SafeArea(
        child: InteractiveViewer(
          maxScale: 6,
          minScale: 1,
          transformationController: controller,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: widget.childrenSpacing,
              children: [
                WidgetbookTitle(
                  title: widget.title,
                  description: widget.description,
                ),
                ...widget.children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
