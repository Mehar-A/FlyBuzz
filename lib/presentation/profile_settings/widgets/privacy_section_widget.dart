import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySectionWidget extends StatelessWidget {
  final VoidCallback onDataUsageControls;
  final VoidCallback onAccountDeletion;
  final VoidCallback onPrivacyPolicy;

  const PrivacySectionWidget({
    Key? key,
    required this.onDataUsageControls,
    required this.onAccountDeletion,
    required this.onPrivacyPolicy,
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
              'Privacy & Security',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Data Usage Controls
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'data_usage',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Data Usage Controls'),
              subtitle: Text('Manage how your data is used'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onTap: onDataUsageControls,
            ),

            Divider(color: AppTheme.borderLight),

            // Privacy Policy
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'policy',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Privacy Policy'),
              subtitle: Text('Read our privacy policy'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onTap: onPrivacyPolicy,
            ),

            Divider(color: AppTheme.borderLight),

            // Account Deletion
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'delete_forever',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text(
                'Delete Account',
                style: TextStyle(color: AppTheme.errorLight),
              ),
              subtitle: Text('Permanently delete your account and data'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onTap: onAccountDeletion,
            ),
          ],
        ),
      ),
    );
  }
}
