import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/image_cache_manager.dart';
import '../../theme/app_colors.dart';
import '../loading/app_shimmer.dart';

/// An optimized image widget that uses CachedNetworkImage with performance optimizations
class OptimizedImage extends StatelessWidget {
  /// The URL of the image
  final String imageUrl;
  
  /// The width of the image
  final double? width;
  
  /// The height of the image
  final double? height;
  
  /// How to fit the image in the container
  final BoxFit fit;
  
  /// The border radius of the image
  final BorderRadius? borderRadius;
  
  /// The placeholder widget to show while loading
  final Widget? placeholder;
  
  /// The error widget to show when loading fails
  final Widget? errorWidget;
  
  /// The cache manager to use
  final CacheManager? cacheManager;
  
  /// Whether to show a fade animation
  final bool fadeAnimation;
  
  /// The duration of the fade animation
  final Duration fadeAnimationDuration;
  
  /// The memory cache width
  final int? memCacheWidth;
  
  /// The memory cache height
  final int? memCacheHeight;
  
  /// The headers to use for the request
  final Map<String, String>? headers;
  
  /// Whether to use a shimmer effect for the placeholder
  final bool useShimmerPlaceholder;
  
  /// Whether to use a placeholder at all
  final bool usePlaceholder;
  
  /// The color to apply to the image
  final Color? color;
  
  /// The blend mode to use when applying the color
  final BlendMode? colorBlendMode;

  const OptimizedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.cacheManager,
    this.fadeAnimation = true,
    this.fadeAnimationDuration = const Duration(milliseconds: 300),
    this.memCacheWidth,
    this.memCacheHeight,
    this.headers,
    this.useShimmerPlaceholder = true,
    this.usePlaceholder = true,
    this.color,
    this.colorBlendMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate cache dimensions based on device pixel ratio
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final calculatedMemCacheWidth = memCacheWidth ?? 
        (width != null ? (width! * devicePixelRatio).toInt() : null);
    final calculatedMemCacheHeight = memCacheHeight ?? 
        (height != null ? (height! * devicePixelRatio).toInt() : null);
    
    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      cacheManager: cacheManager,
      fadeInDuration: fadeAnimation ? fadeAnimationDuration : Duration.zero,
      placeholderFadeInDuration: fadeAnimation ? fadeAnimationDuration : Duration.zero,
      memCacheWidth: calculatedMemCacheWidth,
      memCacheHeight: calculatedMemCacheHeight,
      maxWidthDiskCache: calculatedMemCacheWidth,
      maxHeightDiskCache: calculatedMemCacheHeight,
      httpHeaders: headers ?? const {},
      useOldImageOnUrlChange: true,
      placeholder: usePlaceholder 
          ? (context, url) => placeholder ?? _buildDefaultPlaceholder()
          : null,
      errorWidget: (context, url, error) => 
          errorWidget ?? _buildDefaultErrorWidget(),
    );
    
    // Apply border radius if specified
    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }
    
    return image;
  }
  
  Widget _buildDefaultPlaceholder() {
    if (useShimmerPlaceholder) {
      return AppShimmer(
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: AppColors.background,
        child: Center(
          child: SizedBox(
            width: 24.w,
            height: 24.h,
            child: const CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        ),
      );
    }
  }
  
  Widget _buildDefaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: AppColors.background,
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: AppColors.textSecondary,
          size: 24.sp,
        ),
      ),
    );
  }
}
