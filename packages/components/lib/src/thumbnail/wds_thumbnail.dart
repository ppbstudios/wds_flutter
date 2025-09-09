part of '../../wds_components.dart';

/// 썸네일 크기를 정의하는 열거형
enum WdsThumbnailSize {
  xxs(size: Size(64, 64)),
  xs(size: Size(74, 74)),
  sm(size: Size(90, 90)),
  md(size: Size(106, 106)),
  lg(size: Size(140, 140)),
  xl(size: Size(179, 179)),
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

  static const double _placeholderIconScale = 0.3;

  /// 이미지 경로 (URL 또는 에셋 경로)
  final String imagePath;

  /// 썸네일 크기
  final WdsThumbnailSize size;

  /// 모서리 둥글기 적용 여부
  final bool hasRadius;

  @override
  Widget build(BuildContext context) {
    final imageWidget =
        _isNetworkImage(imagePath) ? _buildNetworkImage() : _buildAssetImage();

    return _buildImageWidget(imageWidget);
  }

  /// 이미지 위젯을 적절한 컨테이너로 감싸기
  Widget _buildImageWidget(Widget imageWidget) {
    final sizedWidget = SizedBox.fromSize(
      size: size.size,
      child: hasRadius
          ? ClipRRect(
              borderRadius:
                  const BorderRadius.all(Radius.circular(WdsRadius.xs)),
              child: imageWidget,
            )
          : imageWidget,
    );

    return RepaintBoundary(child: sizedWidget);
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
      imageBuilder: (context, imageProvider) => DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// 고정 placeholder 빌드 (Container 대신 const 위젯 사용)
  Widget _buildPlaceholder() {
    return ColoredBox(
      color: WdsColors.coolNeutral100,
      child: Center(
        child: WdsIcon.thumbnail.build(
          color: WdsColors.coolNeutral200,
          width: size.size.width * _placeholderIconScale,
          height: size.size.height * _placeholderIconScale,
        ),
      ),
    );
  }
}
