import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../widgetbook_components/widgetbook_components.dart';

@widgetbook.UseCase(
  name: 'Icon',
  type: Icon,
  path: '[foundation]/',
)
Widget buildWdsIconUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Icon',
    description: 'WDS에서 제공하는 벡터 아이콘 목록과 색상 변형을 확인합니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

// Playground: 색상 knob만 제공 (width/height knob 금지)
Widget _buildPlaygroundSection(BuildContext context) {
  final color = context.knobs.color(
    label: 'color',
    initialValue: WdsColors.textNormal,
  );

  final selected = context.knobs.object.dropdown<WdsIcon>(
    label: 'icon',
    initialOption: WdsIcon.chevronRight,
    options: WdsIcon.values,
    labelBuilder: (v) => v.name,
  );

  return WidgetbookPlayground(
    info: [
      'icon: ${selected.name}',
      'color',
      'size fixed: 24x24',
    ],
    child: selected.build(color: color, width: 24, height: 24),
  );
}

// Demonstration: 24x24 고정 크기 그리드로 모든 아이콘 나열
Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Examples',
    children: [
      WidgetbookSubsection(
        title: 'size',
        labels: const ['24 x 24'],
        content: _IconGrid(),
      ),
      WidgetbookSubsection(
        title: 'navigation',
        labels: const ['24 x 24'],
        content: _NavigationIconGrid(),
      ),
      WidgetbookSubsection(
        title: 'order status',
        labels: const ['30 x 30'],
        content: _OrderStatusIconGrid(),
      ),
    ],
  );
}

class _IconGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final icons = WdsIcon.values;
    return LayoutBuilder(
      builder: (context, constraints) {
        // 고정 폭 칩 설명 영역 내부에 표시되므로 Wrap으로 아이템을 흐르게 배치
        return Wrap(
          spacing: 16,
          runSpacing: 24,
          children: [
            for (final icon in icons)
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  icon.build(),
                  SizedBox(
                    width: 96,
                    child: Text(
                      icon.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: WdsTypography.caption11Bold,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _NavigationIconGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final icons = WdsNavigationIcon.values;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 24,
          children: [
            for (int i = 0; i < icons.length; i++)
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  icons[i].build(),
                  SizedBox(
                    width: 96,
                    child: Text(
                      icons[i].name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: WdsTypography.caption11Bold,
                    ),
                  ),
                ],
              ),
            for (int i = 0; i < icons.length; i++)
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  icons[i].build(isActive: true),
                  SizedBox(
                    width: 96,
                    child: Text(
                      icons[i].name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: WdsTypography.caption11Bold,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _OrderStatusIconGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final icons = WdsOrderStatusIcon.values;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 24,
          children: [
            for (final icon in icons)
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  icon.build(),
                  SizedBox(
                    width: 96,
                    child: Text(
                      icon.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: WdsTypography.caption11Bold,
                    ),
                  ),
                ],
              ),
            for (final icon in icons)
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  icon.build(isActive: true),
                  SizedBox(
                    width: 96,
                    child: Text(
                      icon.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: WdsTypography.caption11Bold,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
