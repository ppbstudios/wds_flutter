part of '../../wds_components.dart';

/// 썸네일 크기를 정의하는 열거형
enum WdsThumbnailSize {
  xxs(size: Size(64, 64)),
  xs(size: Size(74, 74)),
  sm(size: Size(90, 90)),
  md(size: Size(106, 106)),
  lg(size: Size(140, 140)),
  xl(size: Size(179, 250)),
  xxl(size: Size(200, 200));

  const WdsThumbnailSize({
    required this.size,
  });

  final Size size;
}

/// 네트워크 이미지와 에셋 이미지를 지원하는 썸네일 컴포넌트
class WdsThumbnail extends StatelessWidget {
  /// 썸네일 생성자 (네트워크/에셋 자동 감지)
  const WdsThumbnail({
    required this.imagePath,
    required this.size,
    this.hasRadius = false,
    super.key,
  });

  /// 이미지 경로 (URL 또는 에셋 경로)
  final String imagePath;

  /// 썸네일 크기
  final WdsThumbnailSize size;

  /// 모서리 둥글기 적용 여부
  final bool hasRadius;

  @override
  Widget build(BuildContext context) {
    final borderRadius = hasRadius
        ? const BorderRadius.all(Radius.circular(WdsRadius.xs))
        : null;

    return RepaintBoundary(
      child: SizedBox.fromSize(
        size: size.size,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: _isNetworkImage(imagePath)
              ? _buildNetworkImage()
              : _buildAssetImage(),
        ),
      ),
    );
  }

  /// 네트워크 이미지인지 확인
  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  /// 에셋 이미지 빌드
  Widget _buildAssetImage() {
    return Image.asset(
      imagePath,
      width: size.size.width,
      height: size.size.height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: child,
        );
      },
    );
  }

  /// 네트워크 이미지 빌드
  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: imagePath,
      width: size.size.width,
      height: size.size.height,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildPlaceholder(),
      imageBuilder: (context, imageProvider) {
        return DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  /// 고정 placeholder 빌드 (Container 대신 const 위젯 사용)
  Widget _buildPlaceholder() {
    return const ColoredBox(
      color: WdsColors.coolNeutral100,
    );
  }
}
