import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart'
    hide Icon;
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Option',
  type: Option,
  path: '[component]/',
)
Widget buildWdsOptionUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Option',
    description: 'Select 영역에서 원하는 옵션을 선택할 수 있도록 돕는 컴포넌트',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final variant = context.knobs.object.dropdown<WdsOptionVariant>(
    label: 'variant',
    options: WdsOptionVariant.values,
    initialOption: WdsOptionVariant.normal,
    labelBuilder: (v) => v.name,
  );

  final itemCount = context.knobs.int.slider(
    label: 'count',
    initialValue: 3,
    min: 1,
    max: 10,
    divisions: 9,
    description: '옵션의 개수를 설정할 수 있어요',
  );

  final items = _generateOptionItems(variant, itemCount);

  return WidgetbookPlayground(
    info: [
      'Variant: ${variant.name}',
      'Item Count: $itemCount',
      'Max Height: ${variant.maxHeight}px',
      'Scroll Threshold: ${variant.scrollThreshold}',
      'Item Height: ${variant.itemHeight}px',
    ],
    child: switch (variant) {
      WdsOptionVariant.normal => WdsOption.normal(items: items),
      WdsOptionVariant.power => WdsOption.power(items: items),
      WdsOptionVariant.product => WdsOption.product(items: items),
    },
  );
}

Widget _buildDemonstrationSection(BuildContext context) {
  const String imagePath =
      'https://cdn.winc.app/uploads/ppb/image/src/60563/ppb_image_file-c9a9df.jpg';

  return WidgetbookSection(
    title: 'Option',
    children: [
      WidgetbookSubsection(
        title: 'variant',
        labels: ['normal', 'power', 'product'],
        content: Column(
          spacing: 16,
          children: [
            WdsOption.normal(
              items: [
                WdsNormalOptionItem(
                  label: '옵션 1',
                  onTap: () => debugPrint('Normal option 1 tapped'),
                ),
                WdsNormalOptionItem(
                  label: '옵션 2',
                  onTap: () => debugPrint('Normal option 2 tapped'),
                ),
                WdsNormalOptionItem(
                  label: '옵션 3',
                  onTap: () => debugPrint('Normal option 3 tapped'),
                ),
              ],
            ),
            WdsOption.power(
              items: [
                WdsPowerOptionItem(
                  label: '-0.50',
                  onTap: () => debugPrint('Power option A tapped'),
                ),
                WdsPowerOptionItem(
                  label: '-0.75',
                  tags: const [
                    WdsTag.$barodrim(),
                    WdsTag.$myPower(),
                  ],
                  onTap: () => debugPrint('Power option B tapped'),
                ),
                WdsPowerOptionItem(
                  label: '-1.00',
                  tags: const [
                    WdsTag.$upto2days(),
                    WdsTag.$myPower(),
                  ],
                  onTap: () => debugPrint('Power option C tapped'),
                ),
                WdsPowerOptionItem(
                  label: '-1.25',
                  isSoldOut: true,
                  onTap: () => debugPrint('Sold out option tapped'),
                ),
                WdsPowerOptionItem(
                  label: '-1.50',
                  isSoldOut: true,
                  tags: const [WdsTag.$myPower()],
                  hasRegistered: true,
                  onTap: () => debugPrint('Sold out option tapped'),
                ),
              ],
            ),
            WdsOption.product(
              items: [
                WdsProductOptionItem(
                  index: '1',
                  thumbnail: const ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(WdsRadius.radius4)),
                    child: WdsThumbnail.xxsmall(
                      imagePath: imagePath,
                    ),
                  ),
                  title: '아이엠 크리스틴 원데이 로우브라운',
                  description: '하루용 13.0mm',
                  onTap: () => debugPrint('Product option 1 tapped'),
                ),
                WdsProductOptionItem(
                  index: '2',
                  thumbnail: const ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(WdsRadius.radius4)),
                    child: WdsThumbnail.xxsmall(
                      imagePath: imagePath,
                    ),
                  ),
                  title: '아이엠 크리스틴 원데이 로우브라운',
                  description: '하루용 13.0mm',
                  trailing: const WdsTag.$soldOut(),
                  isSoldOut: true,
                  onTap: () => debugPrint('Product option 1 tapped'),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

List<WdsOptionItem> _generateOptionItems(
  WdsOptionVariant variant,
  int count,
) {
  const String imagePath =
      'https://cdn.winc.app/uploads/ppb/image/src/99824/ppb_image_file-c9a9df.jpg';

  if (variant == WdsOptionVariant.normal) {
    return List.generate(count, (index) {
      return WdsNormalOptionItem(
        label: '옵션 ${index + 1}',
        onTap: () => debugPrint('Normal option ${index + 1} tapped'),
      );
    });
  } else if (variant == WdsOptionVariant.power) {
    return List.generate(count, (index) {
      final label = index == 0 ? '0.00' : (-0.5 * index).toStringAsFixed(2);
      final hasTags = index % 3 == 1;
      final isSoldOut = index == count - 1;

      return WdsPowerOptionItem(
        label: label,
        tags: hasTags
            ? [
                if (index.isEven) ...[
                  const WdsTag.$barodrim(),
                  const WdsTag.$myPower(),
                ],
                if (index % 3 == 0) ...[
                  const WdsTag.$upto2days(),
                  const WdsTag.$myPower(),
                ],
              ]
            : [],
        isSoldOut: isSoldOut,
        onTap: () => debugPrint('Power option $label tapped'),
      );
    });
  } else {
    // WdsOptionVariant.product
    return List.generate(count, (index) {
      return WdsProductOptionItem(
        index: '${index + 1}',
        thumbnail: const ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(WdsRadius.radius4)),
          child: WdsThumbnail.xxsmall(
            imagePath: imagePath,
          ),
        ),
        title: '돌리 크리스틴 초코',
        description: '하루용 13.0mm',
        trailing: index.isEven ? const WdsTag.$soldOut() : null,
        isSoldOut: index.isEven,
        onTap: () => debugPrint('Product option ${index + 1} tapped'),
      );
    });
  }
}
