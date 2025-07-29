import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PreviewModalWidget extends StatelessWidget {
  final String title;
  final String description;
  final String selectedType;
  final String originalPrice;
  final String salePrice;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> selectedTags;
  final XFile? selectedImage;
  final double radiusValue;

  const PreviewModalWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.selectedType,
    required this.originalPrice,
    required this.salePrice,
    this.startDate,
    this.endDate,
    required this.selectedTags,
    this.selectedImage,
    required this.radiusValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 90.w,
        constraints: BoxConstraints(maxHeight: 85.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'visibility',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Flyer Preview',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How customers will see your flyer:',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Flyer Card Preview
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Section
                          if (selectedImage != null)
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Container(
                                width: double.infinity,
                                height: 25.h,
                                child: Stack(
                                  children: [
                                    CustomImageWidget(
                                      imageUrl: selectedImage!.path,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    // Tags overlay
                                    if (selectedTags.isNotEmpty)
                                      Positioned(
                                        top: 2.w,
                                        left: 2.w,
                                        child: Wrap(
                                          spacing: 1.w,
                                          children: selectedTags
                                              .map((tag) => _buildTagChip(tag))
                                              .toList(),
                                        ),
                                      ),
                                    // Distance indicator
                                    Positioned(
                                      top: 2.w,
                                      right: 2.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 1.w),
                                        decoration: BoxDecoration(
                                          color: AppTheme
                                              .lightTheme.colorScheme.surface
                                              .withValues(alpha: 0.9),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '0.5 mi away',
                                          style: AppTheme
                                              .lightTheme.textTheme.labelSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // Content Section
                          Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: _getTypeColor(selectedType)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        selectedType.toUpperCase(),
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: _getTypeColor(selectedType),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    if (endDate != null)
                                      Text(
                                        'Ends ${_formatDate(endDate!)}',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall,
                                      ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  title.isNotEmpty ? title : 'Flyer Title',
                                  style:
                                      AppTheme.lightTheme.textTheme.titleMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (description.isNotEmpty) ...[
                                  SizedBox(height: 1.h),
                                  Text(
                                    description,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                if (selectedType != 'Event' &&
                                    originalPrice.isNotEmpty) ...[
                                  SizedBox(height: 2.h),
                                  _buildPriceSection(),
                                ],
                                SizedBox(height: 2.h),
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'store',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 16,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      'Your Business Name',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                    ),
                                    Spacer(),
                                    CustomIconWidget(
                                      iconName: 'favorite_border',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 16,
                                    ),
                                    SizedBox(width: 3.w),
                                    CustomIconWidget(
                                      iconName: 'share',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Edit Flyer'),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Trigger publish action
                            },
                            child: Text('Looks Good!'),
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

  Widget _buildTagChip(String tag) {
    final tagColor = _getTagColor(tag);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: tagColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag.toUpperCase(),
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    if (selectedType == 'Sale' && salePrice.isNotEmpty) {
      final originalPriceValue = double.tryParse(originalPrice);
      final salePriceValue = double.tryParse(salePrice);

      if (originalPriceValue != null && salePriceValue != null) {
        final savings =
            ((originalPriceValue - salePriceValue) / originalPriceValue * 100)
                .round();

        return Row(
          children: [
            Text(
              '\$${salePriceValue.toStringAsFixed(2)}',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              '\$${originalPriceValue.toStringAsFixed(2)}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$savings% OFF',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      }
    }

    return Text(
      '\$${double.tryParse(originalPrice)?.toStringAsFixed(2) ?? originalPrice}',
      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
        color: AppTheme.lightTheme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Sale':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'Event':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'Product':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'New':
        return Color(0xFF10B981);
      case 'Hot Deal':
        return Color(0xFFFF6B35);
      case 'Limited Time':
        return Color(0xFFF59E0B);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
