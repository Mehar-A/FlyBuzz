import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onExpandRadius;

  const EmptyStateWidget({
    Key? key,
    this.onExpandRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(),
            SizedBox(height: 4.h),
            _buildTitle(),
            SizedBox(height: 2.h),
            _buildDescription(),
            SizedBox(height: 4.h),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'location_searching',
          color: AppTheme.primaryLight,
          size: 20.w,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'No Flyers in Your Area',
      style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryLight,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Text(
      'We couldn\'t find any promotional flyers near you right now. Try expanding your search radius to discover more deals and events.',
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color: AppTheme.textSecondaryLight,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton.icon(
      onPressed: onExpandRadius,
      icon: CustomIconWidget(
        iconName: 'tune',
        color: Colors.white,
        size: 20,
      ),
      label: Text('Expand Search Radius'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
