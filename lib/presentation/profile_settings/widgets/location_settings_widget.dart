import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSettingsWidget extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(String) onLocationChanged;
  final Function(double) onRadiusChanged;
  final Function(bool) onAutoLocationToggle;

  const LocationSettingsWidget({
    Key? key,
    required this.settings,
    required this.onLocationChanged,
    required this.onRadiusChanged,
    required this.onAutoLocationToggle,
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
              'Location Settings',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Current Location
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Current Location'),
              subtitle: Text(settings['currentLocation'] ?? 'Location not set'),
              trailing: TextButton(
                onPressed: () => _showLocationDialog(context),
                child: Text('Change'),
              ),
            ),

            Divider(color: AppTheme.borderLight),

            // Search Radius
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'my_location',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Search Radius'),
              subtitle: Text(
                  '${(settings['radiusPreference'] ?? 5.0).toInt()} miles'),
            ),
            SizedBox(height: 1.h),
            Slider(
              value: settings['radiusPreference']?.toDouble() ?? 5.0,
              min: 1.0,
              max: 50.0,
              divisions: 49,
              label: '${(settings['radiusPreference'] ?? 5.0).toInt()} miles',
              onChanged: onRadiusChanged,
            ),

            Divider(color: AppTheme.borderLight),

            // Automatic Location Updates
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'gps_fixed',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Automatic Location Updates'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Allow the app to update your location automatically'),
                  SizedBox(height: 1.h),
                  Text(
                    'This helps show you relevant flyers in your area',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight.withAlpha(179),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              trailing: Switch(
                value: settings['automaticLocationUpdates'] ?? true,
                onChanged: onAutoLocationToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: settings['currentLocation'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Enter your location',
                hintText: 'e.g., Downtown Seattle, WA',
                prefixIcon: CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.primaryLight,
                  size: 20,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.textSecondaryLight,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'You can also use GPS to detect your current location',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Use GPS to detect location
              Navigator.of(context).pop();
              onLocationChanged('Detecting location...');
              // Simulate GPS detection
              Future.delayed(Duration(seconds: 2), () {
                onLocationChanged('Current GPS Location');
              });
            },
            child: Text('Use GPS'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onLocationChanged(controller.text);
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
