part of '../../wds_components.dart';

/// Snackbar variant enum
enum WdsSnackbarVariant {
  /// 단일 메시지와 액션 버튼
  normal,

  /// 주 메시지와 보조 설명이 함께 표시
  description,

  /// 2줄까지 표시 가능한 긴 메시지
  multiLine,
}

/// 사용자 작업 피드백을 제공하는 Snackbar 컴포넌트
class WdsSnackbar extends StatelessWidget {
  /// normal variant: 단일 메시지 + 액션 버튼
  const WdsSnackbar.normal({
    required this.message,
    required this.action,
    this.leadingIcon,
    super.key,
  })  : variant = WdsSnackbarVariant.normal,
        description = null;

  /// description variant: 메시지 + 보조 설명 + 액션 버튼
  const WdsSnackbar.description({
    required this.message,
    required this.description,
    required this.action,
    this.leadingIcon,
    super.key,
  }) : variant = WdsSnackbarVariant.description;

  /// multiLine variant: 2줄까지의 긴 메시지
  const WdsSnackbar.multiLine({
    required this.message,
    this.action,
    this.leadingIcon,
    super.key,
  })  : variant = WdsSnackbarVariant.multiLine,
        description = null;

  /// 주요 메시지
  final String message;

  /// 보조 설명(Description variant에서만 사용)
  final String? description;

  /// 선택 아이콘
  final WdsIcon? leadingIcon;

  /// 액션 버튼(normal/description에서만 사용)
  final WdsTextButton? action;

  /// Variant
  final WdsSnackbarVariant variant;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: WdsColors.cta,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 9, 16, 9),
        child: _buildRow(),
      ),
    );
  }

  Widget _buildRow() {
    final List<Widget> children = [];

    // leading icon
    if (leadingIcon != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: leadingIcon!.build(
            width: 24,
            height: 24,
            color: WdsColors.white,
          ),
        ),
      );
      children.add(const SizedBox(width: 6));
    }

    // content
    children.add(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: switch (variant) {
            WdsSnackbarVariant.normal => _buildNormalContent(),
            WdsSnackbarVariant.description => _buildDescriptionContent(),
            WdsSnackbarVariant.multiLine => _buildMultiLineContent(),
          },
        ),
      ),
    );

    // action (exists for all variants when provided)
    if (action != null) {
      children.add(const SizedBox(width: 8));
      children.add(action!);
    }

    return Row(
      children: children,
    );
  }

  Widget _buildNormalContent() {
    return Text(
      message,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: WdsTypography.body14NormalMedium.copyWith(
        color: WdsColors.white,
      ),
    );
  }

  Widget _buildDescriptionContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: WdsTypography.body14NormalMedium.copyWith(
            color: WdsColors.white,
          ),
        ),
        if (description != null)
          Text(
            description!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: WdsTypography.caption12NormalRegular.copyWith(
              color: WdsColors.textAssistive,
            ),
          ),
      ],
    );
  }

  Widget _buildMultiLineContent() {
    return Text(
      message,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: WdsTypography.caption12NormalRegular.copyWith(
        color: WdsColors.textAssistive,
      ),
    );
  }
}
