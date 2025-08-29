part of 'widgetbook_components.dart';

class WidgetbookTitle extends StatelessWidget {
  const WidgetbookTitle({
    required this.title,
    this.description,
    super.key,
  });

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Text(
          title,
          style: WdsSemanticTypography.title32Bold,
        ),
        if (description != null && description!.isNotEmpty)
          Text(
            description!,
            style: WdsSemanticTypography.heading16Regular,
          ),
        const Divider(
          height: 4,
          thickness: 4,
          color: WdsColorCommon.black,
        ),
      ],
    );
  }
}
