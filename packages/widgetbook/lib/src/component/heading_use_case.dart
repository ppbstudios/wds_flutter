import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Heading',
  type: Heading,
  path: '[component]/',
)
Widget buildWdsHeadingUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Heading',
    description:
        '헤딩(Heading)은 페이지 및 템플릿의 역할 및 기능을 나타내는 컴포넌트입니다. 텍스트와 관련 엘리먼트가 결합한 컴포넌트로 정보 계층 구조에 따라 사용을 유의합니다.',
    children: [
      _buildPlaygroundSection(context),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final size = context.knobs.object.dropdown<WdsHeadingSize>(
    label: 'size',
    options: WdsHeadingSize.values,
    initialOption: WdsHeadingSize.large,
    labelBuilder: (value) => value.name,
    description: '크기를 선택할 수 있어요',
  );
  final title = context.knobs.string(
    label: 'title',
    initialValue: '타이틀은 최대 2줄까지 작성해요',
    description: '제목 텍스트예요',
  );
  final enableMore = context.knobs.boolean(
    label: 'hasMore',
    initialValue: true,
    description: '더보기 버튼을 표시할지 여부예요',
  );
  final moreText = context.knobs.string(
    label: 'moreText',
    initialValue: '더보기',
    description: '더보기 버튼의 텍스트예요',
  );

  String? effectiveMoreText = enableMore ? moreText : null;
  VoidCallback? onMoreTap = enableMore ? () => debugPrint('more tapped') : null;

  return WidgetbookPlayground(
    layout: PlaygroundLayout.stretch,
    backgroundColor: WdsColors.coolNeutral50,
    info: [
      'layout: stretch',
      'size: ${size.name}',
      'hasMore: $enableMore',
      if (enableMore) 'moreText: $moreText',
    ],
    child: switch (size) {
      WdsHeadingSize.large => WdsHeading.large(
          title: title,
          moreText: effectiveMoreText,
          onMoreTap: onMoreTap,
        ),
      WdsHeadingSize.medium => WdsHeading.medium(
          title: title,
          moreText: effectiveMoreText,
          onMoreTap: onMoreTap,
        ),
    },
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return WidgetbookSection(
    title: 'Heading',
    spacing: 32,
    children: [
      WidgetbookSubsection(
        title: 'size',
        labels: ['large', 'medium'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            WdsHeading.large(
              title: '타이틀은 최대 2줄까지 작성해요',
              moreText: '더보기',
              onMoreTap: () => debugPrint('more tapped'),
            ),
            WdsHeading.medium(
              title: '타이틀은 최대 2줄까지 작성해요',
              moreText: '더보기',
              onMoreTap: () => debugPrint('more tapped'),
            ),
          ],
        ),
      ),
      WidgetbookSubsection(
        title: 'textButton',
        labels: const ['true', 'false'],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            WdsHeading.large(
              title: '더보기 버튼이 있는 헤딩',
              moreText: '더보기',
              onMoreTap: () => debugPrint('more tapped'),
            ),
            const WdsHeading.large(
              title: '더보기 버튼이 없는 헤딩',
            ),
          ],
        ),
      ),
    ],
  );
}
