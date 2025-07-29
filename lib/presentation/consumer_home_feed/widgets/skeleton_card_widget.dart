import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SkeletonCardWidget extends StatefulWidget {
  const SkeletonCardWidget({Key? key}) : super(key: key);

  @override
  State<SkeletonCardWidget> createState() => _SkeletonCardWidgetState();
}

class _SkeletonCardWidgetState extends State<SkeletonCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.getCardShadow(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonImage(),
              _buildSkeletonContent(),
              _buildSkeletonActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeletonImage() {
    return Container(
      width: double.infinity,
      height: 25.h,
      decoration: BoxDecoration(
        color: AppTheme.borderLight.withValues(alpha: _animation.value),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  Widget _buildSkeletonContent() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color:
                      AppTheme.borderLight.withValues(alpha: _animation.value),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                width: 25.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color:
                      AppTheme.borderLight.withValues(alpha: _animation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Spacer(),
              Container(
                width: 15.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color:
                      AppTheme.borderLight.withValues(alpha: _animation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            height: 2.h,
            decoration: BoxDecoration(
              color: AppTheme.borderLight.withValues(alpha: _animation.value),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            width: 70.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: AppTheme.borderLight.withValues(alpha: _animation.value),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Container(
                width: 20.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color:
                      AppTheme.borderLight.withValues(alpha: _animation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 4.w),
              Container(
                width: 25.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color:
                      AppTheme.borderLight.withValues(alpha: _animation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.borderLight.withValues(alpha: _animation.value),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.borderLight.withValues(alpha: _animation.value),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
