import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SignUpLinkWidget extends StatelessWidget {
  final String selectedRole;
  final bool isEnabled;

  const SignUpLinkWidget({
    Key? key,
    required this.selectedRole,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New user? ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
          ),
          TextButton(
            onPressed: isEnabled
                ? () {
                    // Navigate to registration screen with selected role
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Registration for $selectedRole coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                : null,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Sign Up',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
