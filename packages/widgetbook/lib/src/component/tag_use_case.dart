import 'package:wds_widgetbook/src/widgetbook_components/widgetbook_components.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'Tag',
  type: Tag,
  path: '[component]/',
)
Widget buildTagUseCase(BuildContext context) {
  return WidgetbookPageLayout(
    title: 'Tag',
    description: '텍스트 라벨을 표시하는 작은 컴포넌트입니다. 역할(서비스 속성 · 진행 · 종료⋅완료 · 종료⋅실패/취소 · 정보 속성)만 정하면 색이 결정됩니다.',
    children: [
      _buildPlaygroundSection(context),
      const SizedBox(height: 32),
      _buildDemonstrationSection(context),
    ],
  );
}

Widget _buildPlaygroundSection(BuildContext context) {
  final label = context.knobs.string(
    label: 'label',
    initialValue: '텍스트',
  );

  final role = context.knobs.object.dropdown<WdsTagRole>(
    label: 'role',
    options: WdsTagRole.values,
    initialOption: WdsTagRole.service,
    labelBuilder: (v) => v.name,
  );

  final hasRadius = context.knobs.boolean(
    label: 'hasRadius',
    initialValue: true,
  );

  final leadingIcon = context.knobs.objectOrNull.dropdown<WdsIcon>(
    label: 'leadingIcon',
    options: WdsIcon.values,
    labelBuilder: (v) => v.name,
  );

  final tag = _tagOf(
    role,
    label: label,
    hasRadius: hasRadius,
    leadingIcon: leadingIcon,
  );

  return WidgetbookPlayground(
    info: [
      'label: $label',
      'role: ${role.name}',
      'backgroundColor: ${tag.backgroundColor.toARGB32().toRadixString(16)}',
      'color: ${tag.color.toARGB32().toRadixString(16)}',
      'borderColor: ${tag.borderColor?.toARGB32().toRadixString(16) ?? 'null'}',
      'height: ${WdsTag.fixedHeight}px @fixed',
      'padding: ${WdsTag.fixedPadding.horizontal}px @fixed',
      'typography: ${WdsTag.fixedTypography.fontSize}px @fixed',
      'leadingIcon: ${leadingIcon?.name ?? 'null'}',
    ],
    child: Center(child: tag),
  );
}

WdsTag _tagOf(
  WdsTagRole role, {
  required String label,
  bool hasRadius = true,
  WdsIcon? leadingIcon,
}) => switch (role) {
  WdsTagRole.service => WdsTag.service(
    label: label,
    hasRadius: hasRadius,
    leadingIcon: leadingIcon,
  ),
  WdsTagRole.progress => WdsTag.progress(
    label: label,
    hasRadius: hasRadius,
    leadingIcon: leadingIcon,
  ),
  WdsTagRole.completed => WdsTag.completed(
    label: label,
    hasRadius: hasRadius,
    leadingIcon: leadingIcon,
  ),
  WdsTagRole.failed => WdsTag.failed(
    label: label,
    hasRadius: hasRadius,
    leadingIcon: leadingIcon,
  ),
  WdsTagRole.info => WdsTag.info(
    label: label,
    hasRadius: hasRadius,
    leadingIcon: leadingIcon,
  ),
};

Widget _buildDemonstrationSection(BuildContext context) {
  return const WidgetbookSection(
    title: 'Tag',
    children: [
      WidgetbookSubsection(
        title: '서비스 속성 (service)',
        labels: ['바로드림'],
        content: Wrap(
          spacing: 8,
          children: [
            WdsTag.service(label: '바로드림'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: '진행 (progress)',
        labels: ['예약신청', '예약완료', '제품준비중', '배송중', '교환 진행중', '준비완료'],
        content: Wrap(
          spacing: 8,
          children: [
            WdsTag.progress(label: '예약신청'),
            WdsTag.progress(label: '예약완료'),
            WdsTag.progress(label: '제품준비중'),
            WdsTag.progress(label: '배송중'),
            WdsTag.progress(label: '교환 진행중'),
            WdsTag.progress(label: '준비완료'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: '종료⋅완료 (completed)',
        labels: ['구매완료', '교환완료', '답변완료', '품절', '판매중지'],
        content: Wrap(
          spacing: 8,
          children: [
            WdsTag.completed(label: '구매완료'),
            WdsTag.completed(label: '교환완료'),
            WdsTag.completed(label: '답변완료'),
            WdsTag.completed(label: '품절'),
            WdsTag.completed(label: '판매중지'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: '종료⋅실패/취소 (failed)',
        labels: ['예약취소', '노쇼', '예약거절', '배송오류', '취소완료'],
        content: Wrap(
          spacing: 8,
          children: [
            WdsTag.failed(label: '예약취소'),
            WdsTag.failed(label: '노쇼'),
            WdsTag.failed(label: '예약거절'),
            WdsTag.failed(label: '배송오류'),
            WdsTag.failed(label: '취소완료'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: '정보 속성 (info)',
        labels: ['무료검안', '토요일 배송', '회원전용', '하루용', '한달용'],
        content: Wrap(
          spacing: 8,
          children: [
            WdsTag.info(label: '무료검안'),
            WdsTag.info(label: '토요일 배송'),
            WdsTag.info(label: '회원전용'),
            WdsTag.info(label: '하루용'),
            WdsTag.info(label: '한달용'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'radius',
        labels: ['true', 'false'],
        content: Wrap(
          spacing: 12,
          children: [
            WdsTag.service(label: '텍스트', hasRadius: false),
            WdsTag.service(label: '텍스트'),
            WdsTag.info(label: '텍스트', hasRadius: false),
            WdsTag.info(label: '텍스트'),
          ],
        ),
      ),
      SizedBox(height: 24),
      WidgetbookSubsection(
        title: 'icon',
        labels: ['true', 'false'],
        content: Wrap(
          spacing: 12,
          children: [
            WdsTag.completed(label: '텍스트', leadingIcon: WdsIcon.blank),
            WdsTag.completed(label: '텍스트'),
          ],
        ),
      ),
    ],
  );
}
