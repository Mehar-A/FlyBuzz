import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FlyerTypeSelectorWidget extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeSelected;

  const FlyerTypeSelectorWidget({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> flyerTypes = [
      {
        'type': 'Sale',
        'icon': 'local_offer',
        'description': 'Discounts & Special Offers',
      },
      {
        'type': 'Event',
        'icon': 'event',
        'description': 'Announcements & Activities',
      },
      {
        'type': 'Product',
        'icon': 'inventory_2',
        'description': 'New Items & Services',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flyer Type',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Row(
          children: flyerTypes.map((type) {
            final isSelected = selectedType == type['type'];
            return Expanded(
              child: GestureDetector(
                onTap: () => onTypeSelected(type['type']),
                child: Container(
                  margin:
                      EdgeInsets.only(right: flyerTypes.last == type ? 0 : 2.w),
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primaryContainer
                        : AppTheme.lightTheme.colorScheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: type['icon'],
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        type['type'],
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        type['description'],
                        textAlign: TextAlign.center,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
