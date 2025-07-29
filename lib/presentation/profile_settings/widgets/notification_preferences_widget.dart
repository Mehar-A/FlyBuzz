import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(String, bool) onSettingChanged;

  const NotificationPreferencesWidget({
    Key? key,
    required this.settings,
    required this.onSettingChanged,
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
              'Notification Preferences',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Push Notifications
            _buildNotificationTile(
              icon: 'notifications',
              title: 'Push Notifications',
              subtitle: 'Receive push notifications on your device',
              value: settings['pushNotifications'] ?? true,
              onChanged: (value) =>
                  onSettingChanged('pushNotifications', value),
            ),

            Divider(color: AppTheme.borderLight),

            // Email Alerts
            _buildNotificationTile(
              icon: 'email',
              title: 'Email Alerts',
              subtitle: 'Receive important updates via email',
              value: settings['emailAlerts'] ?? true,
              onChanged: (value) => onSettingChanged('emailAlerts', value),
            ),

            Divider(color: AppTheme.borderLight),

            // Promotional Updates
            _buildNotificationTile(
              icon: 'local_offer',
              title: 'Promotional Updates',
              subtitle: 'Receive notifications about special offers',
              value: settings['promotionalUpdates'] ?? false,
              onChanged: (value) =>
                  onSettingChanged('promotionalUpdates', value),
            ),

            Divider(color: AppTheme.borderLight),

            // Engagement Notifications
            _buildNotificationTile(
              icon: 'favorite',
              title: 'Engagement Notifications',
              subtitle: 'Get notified when businesses interact with you',
              value: settings['engagementNotifications'] ?? true,
              onChanged: (value) =>
                  onSettingChanged('engagementNotifications', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.primaryLight,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondaryLight,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
