import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FlyerCardWidget extends StatelessWidget {
  final Map<String, dynamic> flyerData;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onShare;
  final VoidCallback? onAnalytics;
  final VoidCallback? onDelete;

  const FlyerCardWidget({
    super.key,
    required this.flyerData,
    this.onTap,
    this.onEdit,
    this.onDuplicate,
    this.onShare,
    this.onAnalytics,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String status = flyerData['status'] ?? 'Active';
    final int views = flyerData['views'] ?? 0;
    final int saves = flyerData['saves'] ?? 0;

    return Dismissible(
      key: Key(flyerData['id'].toString()),
      background: _buildSwipeBackground(isLeft: true),
      secondaryBackground: _buildSwipeBackground(isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart && onDelete != null) {
          onDelete!();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _showQuickActions(context);
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        }
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.getCardShadow(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFlyerImage(),
              _buildFlyerContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlyerImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: CustomImageWidget(
            imageUrl: flyerData['image'] ?? '',
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 2.h,
          left: 3.w,
          child: _buildStatusBadge(),
        ),
        Positioned(
          top: 2.h,
          right: 3.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'visibility',
                  color: Colors.white,
                  size: 12,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${flyerData['views'] ?? 0}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final String status = flyerData['status'] ?? 'Active';
    Color badgeColor;

    switch (status.toLowerCase()) {
      case 'new':
        badgeColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'hot deal':
        badgeColor = AppTheme.lightTheme.colorScheme.secondary;
        break;
      case 'expiring soon':
        badgeColor = AppTheme.warningLight;
        break;
      case 'expired':
        badgeColor = AppTheme.lightTheme.colorScheme.error;
        break;
      default:
        badgeColor = AppTheme.lightTheme.colorScheme.primary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFlyerContent() {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            flyerData['title'] ?? 'Untitled Flyer',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 14,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  flyerData['location'] ?? 'Location not specified',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricChip('visibility', '${flyerData['views'] ?? 0}'),
              _buildMetricChip('bookmark', '${flyerData['saves'] ?? 0}'),
              _buildMetricChip('share', '${flyerData['shares'] ?? 0}'),
              Text(
                flyerData['date'] ?? '',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String iconName, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'edit' : 'delete',
                color: isLeft
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Actions' : 'Delete',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: isLeft
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildActionTile('Edit Flyer', 'edit', onEdit),
            _buildActionTile('Duplicate', 'content_copy', onDuplicate),
            _buildActionTile('Share', 'share', onShare),
            _buildActionTile('Analytics', 'analytics', onAnalytics),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, String iconName, VoidCallback? onTap) {
    return Builder(
      builder: (context) => ListTile(
        leading: CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        onTap: onTap != null
            ? () {
                Navigator.pop(context);
                onTap.call();
              }
            : null,
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    _showQuickActions(context);
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              'Delete Flyer',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            content: Text(
              'Are you sure you want to delete this flyer? This action cannot be undone.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
                child: Text(
                  'Delete',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
