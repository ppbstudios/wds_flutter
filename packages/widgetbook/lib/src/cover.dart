import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'widgetbook_components/widgetbook_components.dart';

@widgetbook.UseCase(
  name: 'Cover',
  type: Cover,
  path: 'about',
)
Widget buildWdsCover(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return ColoredBox(
        color: WdsColors.blue400,
        child: SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 96,
            children: [
              Text(
                'WINC',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  color: WdsColors.white,
                  fontFamily: WdsTypography.fontFamily,
                ),
              ),
              Text(
                '디자인시스템',
                style: TextStyle(
                  fontSize: 180,
                  fontWeight: FontWeight.w800,
                  color: WdsColors.white,
                  fontFamily: WdsTypography.fontFamily,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
