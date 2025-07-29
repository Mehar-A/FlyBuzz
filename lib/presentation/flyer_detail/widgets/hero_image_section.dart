import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class HeroImageSection extends StatelessWidget {
  final Map<String, dynamic> flyerData;
  final VoidCallback onBackPressed;

  const HeroImageSection({
    Key? key,
    required this.flyerData,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Hero Image
          Hero(
            tag: 'flyer_${flyerData["id"]}',
            child: CustomImageWidget(
              imageUrl: flyerData["image"] ?? "",
              width: double.infinity,
              height: 50.h,
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 8.h,
            left: 4.w,
            child: GestureDetector(
              onTap: onBackPressed,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
          ),

          // Content Overlay
          Positioned(
            bottom: 4.h,
            left: 4.w,
            right: 4.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Business Name
                Text(
                  flyerData["businessName"] ?? "Business Name",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),

                // Flyer Title
                Text(
                  flyerData["title"] ?? "Flyer Title",
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),

                // Distance and Tags Row
                Row(
                  children: [
                    // Distance Indicator
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.getProximityColor(
                                flyerData["distance"] ?? 0.0)
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: Colors.white,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            "${(flyerData["distance"] ?? 0.0).toStringAsFixed(1)} mi",
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2.w),

                    // Tags
                    if (flyerData["tags"] != null)
                      ...(flyerData["tags"] as List)
                          .map((tag) => Container(
                                margin: EdgeInsets.only(right: 2.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color:
                                      _getTagColor(tag).withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ))
                          .toList(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'new':
        return AppTheme.successLight;
      case 'hot deal':
        return AppTheme.accentLight;
      case 'expiring soon':
        return AppTheme.warningLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
