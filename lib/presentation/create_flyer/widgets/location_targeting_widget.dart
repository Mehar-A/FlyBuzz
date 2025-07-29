import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationTargetingWidget extends StatelessWidget {
  final double radiusValue;
  final Function(double) onRadiusChanged;

  const LocationTargetingWidget({
    Key? key,
    required this.radiusValue,
    required this.onRadiusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location Targeting',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Container(
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
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Address',
                          style: AppTheme.lightTheme.textTheme.labelLarge,
                        ),
                        Text(
                          '123 Main Street, Downtown, NY 10001',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to address editing
                    },
                    child: Text('Edit'),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Text(
                'Target Radius: ${radiusValue.round()} miles',
                style: AppTheme.lightTheme.textTheme.labelLarge,
              ),
              SizedBox(height: 1.h),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
                  inactiveTrackColor: AppTheme.lightTheme.colorScheme.outline,
                  thumbColor: AppTheme.lightTheme.colorScheme.primary,
                  overlayColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                ),
                child: Slider(
                  value: radiusValue,
                  min: 1.0,
                  max: 50.0,
                  divisions: 49,
                  onChanged: onRadiusChanged,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1 mile',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  Text(
                    '50 miles',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'map',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Map Preview',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${radiusValue.round()} mile radius',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '~${_getEstimatedReach(radiusValue)} people',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getEstimatedReach(double radius) {
    // Rough estimation based on population density
    final baseReach = (radius * radius * 3.14159 * 100).round();
    if (baseReach < 1000) {
      return baseReach.toString();
    } else if (baseReach < 10000) {
      return '${(baseReach / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(baseReach / 1000).round()}K';
    }
  }
}
