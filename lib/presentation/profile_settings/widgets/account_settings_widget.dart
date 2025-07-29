import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountSettingsWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onPasswordChange;
  final VoidCallback onEmailVerification;
  final Function(bool) onTwoFactorToggle;

  const AccountSettingsWidget({
    Key? key,
    required this.userData,
    required this.onPasswordChange,
    required this.onEmailVerification,
    required this.onTwoFactorToggle,
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
              'Account Settings',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Password change
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Change Password'),
              subtitle: Text('Update your account password'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onTap: onPasswordChange,
            ),

            Divider(color: AppTheme.borderLight),

            // Email verification
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Email Verification'),
              subtitle: Row(
                children: [
                  Text(
                    userData['isEmailVerified'] == true
                        ? 'Verified'
                        : 'Not verified',
                    style: TextStyle(
                      color: userData['isEmailVerified'] == true
                          ? AppTheme.successLight
                          : AppTheme.warningLight,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  if (userData['isEmailVerified'] == true)
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.successLight,
                      size: 16,
                    ),
                ],
              ),
              trailing: userData['isEmailVerified'] == true
                  ? null
                  : TextButton(
                      onPressed: onEmailVerification,
                      child: Text('Verify'),
                    ),
            ),

            Divider(color: AppTheme.borderLight),

            // Two-factor authentication
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'security',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Two-Factor Authentication'),
              subtitle: Text('Add an extra layer of security'),
              trailing: Switch(
                value: userData['twoFactorEnabled'] ?? false,
                onChanged: onTwoFactorToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
