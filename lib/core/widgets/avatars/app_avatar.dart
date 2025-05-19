import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? placeholderText;
  final double size;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final Widget? child;
  final BoxFit fit;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const AppAvatar({
    Key? key,
    this.imageUrl,
    this.placeholderText,
    this.size = 40.0,
    this.borderColor,
    this.borderWidth = 0.0,
    this.onTap,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.child,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.loadingWidget,
  })  : assert(
          (imageUrl != null) || (placeholderText != null) || (child != null),
          'Either imageUrl, placeholderText or child must be provided',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final hasText = placeholderText != null && placeholderText!.isNotEmpty;

    final avatar = Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: borderColor != null && borderWidth > 0
            ? Border.all(
                color: borderColor!,
                width: borderWidth,
              )
            : null,
      ),
      child: ClipOval(
        child: hasImage
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: fit,
                placeholder: (context, url) => loadingWidget ?? _buildLoadingWidget(),
                errorWidget: (context, url, error) =>
                    errorWidget ?? _buildPlaceholder(hasText),
              )
            : _buildPlaceholder(hasText),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size.r / 2),
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: SizedBox(
        width: size.w / 2,
        height: size.h / 2,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool hasText) {
    if (child != null) {
      return Center(child: child);
    }

    if (hasText) {
      return Center(
        child: Text(
          _getInitials(placeholderText!),
          style: TextStyle(
            color: textColor,
            fontSize: size.sp / 2.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Icon(
      Icons.person,
      color: textColor,
      size: size.sp / 1.5,
    );
  }

  String _getInitials(String text) {
    final names = text.trim().split(' ');
    if (names.length >= 2) {
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    } else if (names.length == 1 && names.first.isNotEmpty) {
      return names.first[0].toUpperCase();
    }
    return '';
  }
}

class AppGroupAvatar extends StatelessWidget {
  final List<String> imageUrls;
  final List<String>? placeholderTexts;
  final double size;
  final double overlap;
  final int maxDisplayed;
  final Color borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color countBackgroundColor;
  final Color countTextColor;

  const AppGroupAvatar({
    Key? key,
    required this.imageUrls,
    this.placeholderTexts,
    this.size = 40.0,
    this.overlap = 0.3,
    this.maxDisplayed = 3,
    this.borderColor = Colors.white,
    this.borderWidth = 1.5,
    this.onTap,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.countBackgroundColor = AppColors.secondary,
    this.countTextColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayCount = imageUrls.length > maxDisplayed ? maxDisplayed : imageUrls.length;
    final remainingCount = imageUrls.length - displayCount;

    final avatarSize = size.w;
    final offsetAmount = avatarSize * (1 - overlap);
    final totalWidth = offsetAmount * (displayCount - 1) + avatarSize;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: totalWidth,
        height: avatarSize,
        child: Stack(
          children: [
            for (int i = 0; i < displayCount; i++)
              Positioned(
                left: i * offsetAmount,
                child: AppAvatar(
                  imageUrl: imageUrls[i],
                  placeholderText: placeholderTexts != null && i < placeholderTexts!.length
                      ? placeholderTexts![i]
                      : null,
                  size: size,
                  borderColor: borderColor,
                  borderWidth: borderWidth,
                  backgroundColor: backgroundColor,
                  textColor: textColor,
                ),
              ),
            if (remainingCount > 0)
              Positioned(
                left: displayCount * offsetAmount,
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: countBackgroundColor,
                    border: Border.all(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '+$remainingCount',
                      style: TextStyle(
                        color: countTextColor,
                        fontSize: avatarSize / 2.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
