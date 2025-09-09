import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'Thumbnail',
  type: Thumbnail,
  path: '[component]/',
)
Widget buildThumbnailUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Thumbnail',
    description: '일정한 비율의 이미지로 콘텐츠를 미리 보여줍니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final size = context.knobs.object.dropdown(
    label: 'size',
    options: WdsThumbnailSize.values,
    labelBuilder: (value) => value.name,
    initialOption: WdsThumbnailSize.md,
  );

  final hasRadius = context.knobs.boolean(
    label: 'radius 유무',
    initialValue: true,
  );

  final imagePath = context.knobs.string(
    label: 'image URL',
    initialValue: 'https://picsum.photos/400/300',
  );

  return WidgetbookPlayground(
    info: [
      'Size: ${size.name} (${size.size.width}x${size.size.height})',
      'Radius: $hasRadius',
      'Image URL: $imagePath',
      'Type: ${imagePath.startsWith('http') ? 'Network' : 'Asset'}',
    ],
    child: SizedBox(
      height: 200,
      child: Center(
        child: WdsThumbnail(
          imagePath: imagePath,
          size: size,
          hasRadius: hasRadius,
        ),
      ),
    ),
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Thumbnail',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['Network', 'Asset'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsThumbnail(
              imagePath: 'https://picsum.photos/200/200?random=1',
              size: WdsThumbnailSize.lg,
              hasRadius: true,
            ),
            SizedBox(width: 24),
            WdsThumbnail(
              imagePath: 'assets/images/placeholder.png',
              size: WdsThumbnailSize.lg,
              hasRadius: true,
            ),
          ],
        ),
      ),

      WidgetbookSubsection(
        title: 'size',
        labels: ['xxs', 'xs', 'sm', 'md', 'lg', 'xl', 'xxl'],
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Column(
              spacing: 8,
              children: [
                WdsThumbnail(
                  imagePath: 'https://picsum.photos/64/64?random=1',
                  size: WdsThumbnailSize.xxs,
                  hasRadius: true,
                ),
                Text('xxs (64x64)'),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                WdsThumbnail(
                  imagePath: 'https://picsum.photos/74/74?random=2',
                  size: WdsThumbnailSize.xs,
                  hasRadius: true,
                ),
                Text('xs (74x74)'),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                WdsThumbnail(
                  imagePath: 'https://picsum.photos/90/90?random=3',
                  size: WdsThumbnailSize.sm,
                  hasRadius: true,
                ),
                Text('sm (90x90)'),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                WdsThumbnail(
                  imagePath: 'https://picsum.photos/106/106?random=4',
                  size: WdsThumbnailSize.md,
                  hasRadius: true,
                ),
                Text('md (106x106)'),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                WdsThumbnail(
                  imagePath: 'https://picsum.photos/140/140?random=5',
                  size: WdsThumbnailSize.lg,
                  hasRadius: true,
                ),
                Text('lg (140x140)'),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                WdsThumbnail(
                  imagePath: 'https://picsum.photos/179/250?random=6',
                  size: WdsThumbnailSize.xl,
                  hasRadius: true,
                ),
                Text('xl (179x179)'),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                WdsThumbnail(
                  imagePath: 'https://picsum.photos/200/200?random=7',
                  size: WdsThumbnailSize.xxl,
                  hasRadius: true,
                ),
                Text('xxl (200x200)'),
              ],
            ),
          ],
        ),
      ),

      /// Radius
      WidgetbookSubsection(
        title: 'radius',
        labels: ['true', 'false'],
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WdsThumbnail(
              imagePath: 'https://picsum.photos/120/120?random=11',
              size: WdsThumbnailSize.md,
              hasRadius: true,
            ),
            SizedBox(width: 24),
            WdsThumbnail(
              imagePath: 'https://picsum.photos/120/120?random=12',
              size: WdsThumbnailSize.md,
            ),
          ],
        ),
      ),

      /// State
      WidgetbookSubsection(
        title: 'state',
        labels: ['loading', 'error', 'success'],
        content: Wrap(
          spacing: 16,
          children: [
            /// 로딩 상태 (빠른 네트워크로 인해 보이지 않을 수 있음)
            WdsThumbnail(
              imagePath: 'https://httpbin.org/delay/2',
              size: WdsThumbnailSize.md,
              hasRadius: true,
            ),

            /// 에러 상태 (존재하지 않는 URL)
            WdsThumbnail(
              imagePath:
                  'https://invalid-url-that-does-not-exist.com/image.jpg',
              size: WdsThumbnailSize.md,
              hasRadius: true,
            ),

            /// 성공 상태
            WdsThumbnail(
              imagePath: 'https://picsum.photos/120/120?random=13',
              size: WdsThumbnailSize.md,
              hasRadius: true,
            ),
          ],
        ),
      ),
    ],
  );
}
