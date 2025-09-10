part of '../../wds_components.dart';

enum WdsHeadingSize { lg, md }

class _HeadingMaxLinesBySize {
  const _HeadingMaxLinesBySize._();

  static int of(WdsHeadingSize size) {
    return switch (size) {
      WdsHeadingSize.lg => 2,
      WdsHeadingSize.md => 1,
    };
  }
}

class _HeadingTextButtonVariantBySize {
  const _HeadingTextButtonVariantBySize._();

  static WdsTextButtonVariant of(WdsHeadingSize size) {
    return switch (size) {
      WdsHeadingSize.lg => WdsTextButtonVariant.text,
      WdsHeadingSize.md => WdsTextButtonVariant.icon,
    };
  }
}

/// 페이지 및 템플릿의 역할 및 기능을 나타내는 헤딩 컴포넌트
class WdsHeading extends StatelessWidget {
  const WdsHeading.lg({
    required this.title,
    this.moreText,
    this.onMoreTap,
    super.key,
  }) : size = WdsHeadingSize.lg;

  const WdsHeading.md({
    required this.title,
    this.moreText,
    this.onMoreTap,
    super.key,
  }) : size = WdsHeadingSize.md;

  final String title;

  final WdsHeadingSize size;

  final String? moreText;

  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    const EdgeInsets containerPadding = EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 4,
    );
    const EdgeInsets titlePadding = EdgeInsets.symmetric(vertical: 2);
    final int maxLines = _HeadingMaxLinesBySize.of(size);
    final WdsTextButtonVariant buttonVariant =
        _HeadingTextButtonVariantBySize.of(size);

    Widget titleWidget = Padding(
      padding: titlePadding,
      child: Text(
        title,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: switch (size) {
          WdsHeadingSize.lg => WdsTypography.heading17Bold,
          WdsHeadingSize.md => WdsTypography.heading16Bold,
        }
            .copyWith(color: WdsColors.textNormal),
      ),
    );

    Widget content;
    if (moreText != null && onMoreTap != null) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Expanded(child: titleWidget),
          WdsTextButton(
            onTap: onMoreTap,
            variant: buttonVariant,
            size: WdsTextButtonSize.small,
            color: WdsColors.textAssistive,
            child: Text(moreText!),
          ),
        ],
      );
    } else {
      content = titleWidget;
    }

    return Padding(
      padding: containerPadding,
      child: content,
    );
  }
}
