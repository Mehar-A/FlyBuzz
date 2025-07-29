import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class RelatedFlyersSection extends StatelessWidget {
  final List<Map<String, dynamic>> relatedFlyers;
  final Function(Map<String, dynamic>) onFlyerTap;

  const RelatedFlyersSection({
    Key? key,
    required this.relatedFlyers,
    required this.onFlyerTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (relatedFlyers.isEmpty) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              "More Deals Nearby",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 35.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: relatedFlyers.length,
              itemBuilder: (context, index) {
                final flyer = relatedFlyers[index];
                return _buildRelatedFlyerCard(flyer);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedFlyerCard(Map<String, dynamic> flyer) {
    return GestureDetector(
      onTap: () => onFlyerTap(flyer),
      child: Container(
        width: 60.w,
        margin: EdgeInsets.only(right: 3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.getCardShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 20.h,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    child: CustomImageWidget(
                      imageUrl: flyer["image"] ?? "",
                      width: double.infinity,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Tags
                  if (flyer["tags"] != null &&
                      (flyer["tags"] as List).isNotEmpty)
                    Positioned(
                      top: 2.w,
                      left: 2.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getTagColor((flyer["tags"] as List).first)
                              .withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          (flyer["tags"] as List).first,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Distance
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${(flyer["distance"] ?? 0.0).toStringAsFixed(1)} mi",
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Business Name
                    Text(
                      flyer["businessName"] ?? "Business",
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),

                    // Title
                    Text(
                      flyer["title"] ?? "Deal Title",
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Spacer(),

                    // Price
                    if (flyer["salePrice"] != null)
                      Row(
                        children: [
                          if (flyer["originalPrice"] != null) ...[
                            Text(
                              flyer["originalPrice"],
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(width: 2.w),
                          ],
                          Text(
                            flyer["salePrice"],
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.accentLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
