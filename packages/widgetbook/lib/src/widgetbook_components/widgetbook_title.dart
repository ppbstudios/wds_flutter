import 'package:flutter/material.dart';
import 'package:wds_tokens/wds_tokens.dart';

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
        Divider(
          height: 4,
          thickness: 4,
          color: WdsColorCommon.black,
        ),
      ],
    );
  }
}
