import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessSettingsWidget extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(String) onBusinessHoursChanged;
  final Function(String) onContactInfoChanged;
  final Function(List<String>) onPaymentMethodsChanged;
  final Function(bool) onAnalyticsToggle;

  const BusinessSettingsWidget({
    Key? key,
    required this.settings,
    required this.onBusinessHoursChanged,
    required this.onContactInfoChanged,
    required this.onPaymentMethodsChanged,
    required this.onAnalyticsToggle,
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
              'Business Settings',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Business Hours
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Business Hours'),
              subtitle: Text(settings['businessHours'] ?? 'Not set'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onTap: () => _showBusinessHoursDialog(context),
            ),

            Divider(color: AppTheme.borderLight),

            // Contact Information
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Contact Information'),
              subtitle: Text(settings['contactInfo'] ?? 'Not set'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onTap: () => _showContactInfoDialog(context),
            ),

            Divider(color: AppTheme.borderLight),

            // Payment Methods
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'payment',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Payment Methods'),
              subtitle: Text(
                (settings['paymentMethods'] as List<String>?)?.join(', ') ??
                    'Not configured',
              ),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onTap: () => _showPaymentMethodsDialog(context),
            ),

            Divider(color: AppTheme.borderLight),

            // Analytics Preferences
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Analytics & Insights'),
              subtitle: Text('Enable detailed business analytics'),
              trailing: Switch(
                value: settings['analyticsPreferences'] ?? true,
                onChanged: onAnalyticsToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBusinessHoursDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: settings['businessHours'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Business Hours'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Hours',
            hintText: 'e.g., 9:00 AM - 6:00 PM',
            prefixIcon: CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.primaryLight,
              size: 20,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onBusinessHoursChanged(controller.text);
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showContactInfoDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: settings['contactInfo'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Information'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            hintText: '+1 (555) 123-4567',
            prefixIcon: CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.primaryLight,
              size: 20,
            ),
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onContactInfoChanged(controller.text);
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodsDialog(BuildContext context) {
    final List<String> availableMethods = [
      'Credit Card',
      'Debit Card',
      'PayPal',
      'Apple Pay',
      'Google Pay',
      'Bank Transfer',
      'Cash',
    ];

    List<String> selectedMethods =
        List<String>.from(settings['paymentMethods'] ?? ['Credit Card']);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Payment Methods'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableMethods.length,
              itemBuilder: (context, index) {
                final method = availableMethods[index];
                final isSelected = selectedMethods.contains(method);

                return CheckboxListTile(
                  title: Text(method),
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedMethods.add(method);
                      } else {
                        selectedMethods.remove(method);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onPaymentMethodsChanged(selectedMethods);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
