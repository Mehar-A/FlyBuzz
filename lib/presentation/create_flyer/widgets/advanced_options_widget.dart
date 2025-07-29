import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedOptionsWidget extends StatefulWidget {
  final List<String> selectedTags;
  final bool notificationEnabled;
  final Function(List<String>) onTagsChanged;
  final Function(bool) onNotificationChanged;

  const AdvancedOptionsWidget({
    Key? key,
    required this.selectedTags,
    required this.notificationEnabled,
    required this.onTagsChanged,
    required this.onNotificationChanged,
  }) : super(key: key);

  @override
  State<AdvancedOptionsWidget> createState() => _AdvancedOptionsWidgetState();
}

class _AdvancedOptionsWidgetState extends State<AdvancedOptionsWidget> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> availableTags = [
    {
      'name': 'New',
      'color': Color(0xFF10B981),
      'icon': 'fiber_new',
    },
    {
      'name': 'Hot Deal',
      'color': Color(0xFFFF6B35),
      'icon': 'local_fire_department',
    },
    {
      'name': 'Limited Time',
      'color': Color(0xFFF59E0B),
      'icon': 'schedule',
    },
  ];

  void _toggleTag(String tagName) {
    final List<String> updatedTags = List.from(widget.selectedTags);
    if (updatedTags.contains(tagName)) {
      updatedTags.remove(tagName);
    } else {
      updatedTags.add(tagName);
    }
    widget.onTagsChanged(updatedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'tune',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Advanced Options',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                ),
                CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flyer Tags',
                  style: AppTheme.lightTheme.textTheme.labelLarge,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Add tags to help customers find your flyer',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: availableTags.map((tag) {
                    final isSelected =
                        widget.selectedTags.contains(tag['name']);
                    return GestureDetector(
                      onTap: () => _toggleTag(tag['name']),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (tag['color'] as Color).withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme
                                  .surfaceContainerHighest,
                          border: Border.all(
                            color: isSelected
                                ? tag['color'] as Color
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: tag['icon'],
                              color: isSelected
                                  ? tag['color'] as Color
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              tag['name'],
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: isSelected
                                    ? tag['color'] as Color
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Push Notifications',
                            style: AppTheme.lightTheme.textTheme.labelLarge,
                          ),
                          Text(
                            'Notify nearby customers when flyer goes live',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: widget.notificationEnabled,
                      onChanged: widget.onNotificationChanged,
                    ),
                  ],
                ),
                if (widget.notificationEnabled) ...[
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'notifications_active',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Notifications will be sent to users within your target radius',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
