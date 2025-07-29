import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PricingSectionWidget extends StatelessWidget {
  final String selectedType;
  final TextEditingController originalPriceController;
  final TextEditingController salePriceController;

  const PricingSectionWidget({
    Key? key,
    required this.selectedType,
    required this.originalPriceController,
    required this.salePriceController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedType == 'Event') {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedType == 'Sale' ? 'Original Price' : 'Price',
                    style: AppTheme.lightTheme.textTheme.labelLarge,
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: originalPriceController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      hintText: '\$0.00',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'attach_money',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price is required';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'Enter valid price';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            if (selectedType == 'Sale') ...[
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sale Price',
                      style: AppTheme.lightTheme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: salePriceController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        hintText: '\$0.00',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'local_offer',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Sale price required';
                        }
                        final salePrice = double.tryParse(value);
                        final originalPrice =
                            double.tryParse(originalPriceController.text);

                        if (salePrice == null || salePrice <= 0) {
                          return 'Enter valid price';
                        }

                        if (originalPrice != null &&
                            salePrice >= originalPrice) {
                          return 'Must be less than original';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        if (selectedType == 'Sale' &&
            originalPriceController.text.isNotEmpty &&
            salePriceController.text.isNotEmpty) ...[
          SizedBox(height: 2.h),
          _buildSavingsIndicator(),
        ],
      ],
    );
  }

  Widget _buildSavingsIndicator() {
    final originalPrice = double.tryParse(originalPriceController.text);
    final salePrice = double.tryParse(salePriceController.text);

    if (originalPrice == null ||
        salePrice == null ||
        salePrice >= originalPrice) {
      return SizedBox.shrink();
    }

    final savings = originalPrice - salePrice;
    final percentage = ((savings / originalPrice) * 100).round();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'savings',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            'Save \$${savings.toStringAsFixed(2)} ($percentage% off)',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
