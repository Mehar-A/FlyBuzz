import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class FlyerContentSection extends StatelessWidget {
  final Map<String, dynamic> flyerData;

  const FlyerContentSection({
    Key? key,
    required this.flyerData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            "Description",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            flyerData["description"] ?? "No description available",
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 3.h),

          // Pricing Information
          if (flyerData["originalPrice"] != null ||
              flyerData["salePrice"] != null)
            _buildPricingSection(),

          SizedBox(height: 3.h),

          // Validity Dates
          _buildValiditySection(),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pricing",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              if (flyerData["originalPrice"] != null) ...[
                Text(
                  "Original: ",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  flyerData["originalPrice"],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: 4.w),
              ],
              if (flyerData["salePrice"] != null) ...[
                Text(
                  "Sale: ",
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                Text(
                  flyerData["salePrice"],
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
          if (flyerData["originalPrice"] != null &&
              flyerData["salePrice"] != null)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                "Save ${_calculateSavings()}%",
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.successLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildValiditySection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Validity",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Date",
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      flyerData["startDate"] ?? "N/A",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "End Date",
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      flyerData["endDate"] ?? "N/A",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isExpiringSoon())
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.warningLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.warningLight,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "Expires in ${_getDaysRemaining()} days",
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.warningLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _calculateSavings() {
    if (flyerData["originalPrice"] == null || flyerData["salePrice"] == null)
      return "0";

    try {
      final original = double.parse(flyerData["originalPrice"]
          .toString()
          .replaceAll(RegExp(r'[^\d.]'), ''));
      final sale = double.parse(
          flyerData["salePrice"].toString().replaceAll(RegExp(r'[^\d.]'), ''));
      final savings = ((original - sale) / original * 100);
      return savings.toStringAsFixed(0);
    } catch (e) {
      return "0";
    }
  }

  bool _isExpiringSoon() {
    if (flyerData["endDate"] == null) return false;
    try {
      final endDate = DateTime.parse(flyerData["endDate"]);
      final now = DateTime.now();
      final difference = endDate.difference(now).inDays;
      return difference <= 3 && difference > 0;
    } catch (e) {
      return false;
    }
  }

  int _getDaysRemaining() {
    if (flyerData["endDate"] == null) return 0;
    try {
      final endDate = DateTime.parse(flyerData["endDate"]);
      final now = DateTime.now();
      return endDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }
}
