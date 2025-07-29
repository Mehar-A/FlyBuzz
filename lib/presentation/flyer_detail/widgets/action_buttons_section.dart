import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ActionButtonsSection extends StatefulWidget {
  final Map<String, dynamic> flyerData;
  final bool isSaved;
  final VoidCallback onSaveToggle;

  const ActionButtonsSection({
    Key? key,
    required this.flyerData,
    required this.isSaved,
    required this.onSaveToggle,
  }) : super(key: key);

  @override
  State<ActionButtonsSection> createState() => _ActionButtonsSectionState();
}

class _ActionButtonsSectionState extends State<ActionButtonsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Save Button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onSaveToggle();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  decoration: BoxDecoration(
                    color: widget.isSaved
                        ? AppTheme.lightTheme.colorScheme.primaryContainer
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.isSaved
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName:
                            widget.isSaved ? 'favorite' : 'favorite_border',
                        color: widget.isSaved
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        widget.isSaved ? "Saved" : "Save",
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: widget.isSaved
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),

            // Share Button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _shareFlyer();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Share",
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),

            // Call Business Button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _callBusiness();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'phone',
                        color: Colors.white,
                        size: 6.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Call",
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareFlyer() {
    final String shareText = """
Check out this deal from ${widget.flyerData["businessName"] ?? "Local Business"}!

${widget.flyerData["title"] ?? "Great Deal"}

${widget.flyerData["description"] ?? ""}

${widget.flyerData["salePrice"] != null ? "Sale Price: ${widget.flyerData["salePrice"]}" : ""}

Download FlyerBuzz to discover more local deals!
    """
        .trim();

    Share.share(
      shareText,
      subject: widget.flyerData["title"] ?? "Local Deal",
    );
  }

  void _callBusiness() {
    // This would typically launch the phone dialer
    // For now, we'll show a snackbar as a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Calling ${widget.flyerData["businessName"] ?? "business"}..."),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
