import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FlyerCardWidget extends StatelessWidget {
  final Map<String, dynamic> flyer;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onShare;

  const FlyerCardWidget({
    Key? key,
    required this.flyer,
    this.onTap,
    this.onSave,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.getCardShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFlyerImage(),
            _buildFlyerContent(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlyerImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: CustomImageWidget(
            imageUrl: flyer["image"] as String,
            width: double.infinity,
            height: 25.h,
            fit: BoxFit.cover,
          ),
        ),
        _buildImageOverlay(),
        _buildPromotionalTag(),
      ],
    );
  }

  Widget _buildImageOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 8.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.7),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          children: [
            _buildBusinessLogo(),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    flyer["title"] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    flyer["businessName"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessLogo() {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: CustomImageWidget(
          imageUrl: flyer["businessLogo"] as String,
          width: 10.w,
          height: 10.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPromotionalTag() {
    final String tag = flyer["tag"] as String;
    Color tagColor;

    switch (tag.toLowerCase()) {
      case 'new':
        tagColor = AppTheme.successLight;
        break;
      case 'hot deal':
        tagColor = AppTheme.accentLight;
        break;
      case 'expiring soon':
        tagColor = AppTheme.warningLight;
        break;
      default:
        tagColor = AppTheme.primaryLight;
    }

    return Positioned(
      top: 2.h,
      left: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: tagColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tag.toUpperCase(),
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildFlyerContent() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.textSecondaryLight,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                "${flyer["distance"]} miles away",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color:
                      AppTheme.getProximityColor(flyer["distance"] as double),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                flyer["timeAgo"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            flyer["description"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (flyer["originalPrice"] != null && flyer["salePrice"] != null) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                Text(
                  flyer["originalPrice"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  flyer["salePrice"] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onSave,
              icon: CustomIconWidget(
                iconName:
                    flyer["isSaved"] == true ? 'bookmark' : 'bookmark_border',
                color: flyer["isSaved"] == true
                    ? AppTheme.primaryLight
                    : AppTheme.textSecondaryLight,
                size: 18,
              ),
              label: Text(
                flyer["isSaved"] == true ? 'Saved' : 'Save',
                style: TextStyle(
                  color: flyer["isSaved"] == true
                      ? AppTheme.primaryLight
                      : AppTheme.textSecondaryLight,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: flyer["isSaved"] == true
                      ? AppTheme.primaryLight
                      : AppTheme.borderLight,
                ),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onShare,
              icon: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.textSecondaryLight,
                size: 18,
              ),
              label: Text(
                'Share',
                style: TextStyle(color: AppTheme.textSecondaryLight),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
