import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConsumerSettingsWidget extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(List<String>) onInterestCategoriesChanged;
  final Function(String, bool) onDiscoveryPreferenceChanged;

  const ConsumerSettingsWidget({
    Key? key,
    required this.settings,
    required this.onInterestCategoriesChanged,
    required this.onDiscoveryPreferenceChanged,
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
              'Consumer Preferences',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Interest Categories
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Interest Categories'),
              subtitle: Text(
                (settings['interestCategories'] as List<String>?)?.join(', ') ??
                    'None selected',
              ),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
              onTap: () => _showInterestCategoriesDialog(context),
            ),

            Divider(color: AppTheme.borderLight),

            // Discovery Preferences Section
            Text(
              'Discovery Preferences',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),

            // Show New Businesses
            _buildDiscoveryTile(
              icon: 'new_releases',
              title: 'Show New Businesses',
              subtitle: 'See flyers from newly opened businesses',
              value: settings['discoveryPreferences']?['showNewBusinesses'] ??
                  true,
              onChanged: (value) =>
                  onDiscoveryPreferenceChanged('showNewBusinesses', value),
            ),

            Divider(color: AppTheme.borderLight),

            // Show Hot Deals
            _buildDiscoveryTile(
              icon: 'local_fire_department',
              title: 'Show Hot Deals',
              subtitle: 'Prioritize popular and trending offers',
              value: settings['discoveryPreferences']?['showHotDeals'] ?? true,
              onChanged: (value) =>
                  onDiscoveryPreferenceChanged('showHotDeals', value),
            ),

            Divider(color: AppTheme.borderLight),

            // Show Expiring Soon
            _buildDiscoveryTile(
              icon: 'timer',
              title: 'Show Expiring Soon',
              subtitle: 'Highlight deals that are about to expire',
              value: settings['discoveryPreferences']?['showExpiringSoon'] ??
                  false,
              onChanged: (value) =>
                  onDiscoveryPreferenceChanged('showExpiringSoon', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryTile({
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

  void _showInterestCategoriesDialog(BuildContext context) {
    final List<String> availableCategories = [
      'Retail',
      'Restaurant',
      'Entertainment',
      'Sports & Fitness',
      'Electronics',
      'Beauty & Health',
      'Automotive',
      'Home & Garden',
      'Travel',
      'Education',
      'Professional Services',
      'Food & Grocery',
    ];

    List<String> selectedCategories =
        List<String>.from(settings['interestCategories'] ?? []);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Select Interest Categories'),
          content: Container(
            width: double.maxFinite,
            height: 60.h,
            child: ListView.builder(
              itemCount: availableCategories.length,
              itemBuilder: (context, index) {
                final category = availableCategories[index];
                final isSelected = selectedCategories.contains(category);

                return CheckboxListTile(
                  title: Text(category),
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedCategories.add(category);
                      } else {
                        selectedCategories.remove(category);
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
                onInterestCategoriesChanged(selectedCategories);
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
