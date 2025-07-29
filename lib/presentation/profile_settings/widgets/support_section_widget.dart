import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SupportSectionWidget extends StatelessWidget {
  final VoidCallback onHelpCenter;
  final VoidCallback onContactSupport;

  const SupportSectionWidget({
    Key? key,
    required this.onHelpCenter,
    required this.onContactSupport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support & Information',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Help Center
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'help_center',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Help Center'),
              subtitle: Text('Find answers to common questions'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onTap: onHelpCenter,
            ),

            Divider(color: AppTheme.borderLight),

            // Contact Support
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'support_agent',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Contact Support'),
              subtitle: Text('Get help from our support team'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onTap: onContactSupport,
            ),

            Divider(color: AppTheme.borderLight),

            // App Version
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'info',
                color: AppTheme.textSecondaryLight,
                size: 24,
              ),
              title: Text('App Version'),
              subtitle: Text('FlyerBuzz v1.0.0'),
            ),
          ],
        ),
      ),
    );
  }
}
