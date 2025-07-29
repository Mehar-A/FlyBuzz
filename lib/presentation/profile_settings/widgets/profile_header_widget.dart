import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onAvatarChanged;
  final Function(String) onNameChanged;

  const ProfileHeaderWidget({
    Key? key,
    required this.userData,
    required this.onAvatarChanged,
    required this.onNameChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Avatar section
            Stack(
              children: [
                CircleAvatar(
                  radius: 20.w,
                  backgroundColor: AppTheme.primaryLight.withAlpha(26),
                  backgroundImage: userData['avatar'] != null
                      ? NetworkImage(userData['avatar'])
                      : null,
                  child: userData['avatar'] == null
                      ? CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.primaryLight,
                          size: 20.w,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onAvatarChanged,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'camera_alt',
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Name and email
            Text(
              userData['name'] ?? 'User Name',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              userData['email'] ?? 'user@email.com',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 2.h),

            // Role badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: userData['role'].toString().contains('business')
                    ? AppTheme.accentLight.withAlpha(26)
                    : AppTheme.primaryLight.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: userData['role'].toString().contains('business')
                        ? 'business'
                        : 'person',
                    color: userData['role'].toString().contains('business')
                        ? AppTheme.accentLight
                        : AppTheme.primaryLight,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    userData['role'].toString().contains('business')
                        ? 'Business Owner'
                        : 'Consumer',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: userData['role'].toString().contains('business')
                          ? AppTheme.accentLight
                          : AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
