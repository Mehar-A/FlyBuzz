import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/account_settings_widget.dart';
import './widgets/business_settings_widget.dart';
import './widgets/consumer_settings_widget.dart';
import './widgets/location_settings_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/privacy_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/support_section_widget.dart';

enum UserRole { business, consumer }

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  // Mock user data - in real app, this would come from state management/API
  Map<String, dynamic> _userData = {
    'name': 'John Consumer',
    'email': 'john.consumer@email.com',
    'role': UserRole.consumer,
    'avatar': null,
    'isEmailVerified': true,
    'twoFactorEnabled': false,
  };

  Map<String, dynamic> _notificationSettings = {
    'pushNotifications': true,
    'emailAlerts': true,
    'promotionalUpdates': false,
    'engagementNotifications': true,
  };

  Map<String, dynamic> _locationSettings = {
    'currentLocation': 'Downtown Seattle, WA',
    'radiusPreference': 5.0,
    'automaticLocationUpdates': true,
  };

  Map<String, dynamic> _businessSettings = {
    'businessHours': '9:00 AM - 6:00 PM',
    'contactInfo': '+1 (555) 123-4567',
    'paymentMethods': ['Credit Card', 'PayPal'],
    'analyticsPreferences': true,
  };

  Map<String, dynamic> _consumerSettings = {
    'interestCategories': ['Retail', 'Restaurant', 'Entertainment'],
    'discoveryPreferences': {
      'showNewBusinesses': true,
      'showHotDeals': true,
      'showExpiringSoon': false,
    },
  };

  @override
  void initState() {
    super.initState();
    // Get user role from arguments if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['role'] != null) {
        setState(() {
          _userData['role'] = args['role'] == 'business'
              ? UserRole.business
              : UserRole.consumer;
          if (_userData['role'] == UserRole.business) {
            _userData['name'] = 'Business Owner';
            _userData['email'] = 'owner@business.com';
          }
        });
      }
    });
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call to save settings
      await Future.delayed(Duration(milliseconds: 1500));

      setState(() {
        _hasUnsavedChanges = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Settings saved successfully'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save settings. Please try again.'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSettingChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unsaved Changes'),
        content: Text('You have unsaved changes. Do you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Discard'),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Profile Settings'),
          actions: [
            if (_hasUnsavedChanges)
              TextButton(
                onPressed: _isLoading ? null : _saveSettings,
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryLight,
                        ),
                      )
                    : Text(
                        'Save',
                        style: TextStyle(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeaderWidget(
                userData: _userData,
                onAvatarChanged: () => _onSettingChanged(),
                onNameChanged: (name) {
                  setState(() {
                    _userData['name'] = name;
                  });
                  _onSettingChanged();
                },
              ),
              SizedBox(height: 3.h),

              AccountSettingsWidget(
                userData: _userData,
                onPasswordChange: () => _onSettingChanged(),
                onEmailVerification: () => _onSettingChanged(),
                onTwoFactorToggle: (enabled) {
                  setState(() {
                    _userData['twoFactorEnabled'] = enabled;
                  });
                  _onSettingChanged();
                },
              ),
              SizedBox(height: 3.h),

              NotificationPreferencesWidget(
                settings: _notificationSettings,
                onSettingChanged: (key, value) {
                  setState(() {
                    _notificationSettings[key] = value;
                  });
                  _onSettingChanged();
                },
              ),
              SizedBox(height: 3.h),

              LocationSettingsWidget(
                settings: _locationSettings,
                onLocationChanged: (location) {
                  setState(() {
                    _locationSettings['currentLocation'] = location;
                  });
                  _onSettingChanged();
                },
                onRadiusChanged: (radius) {
                  setState(() {
                    _locationSettings['radiusPreference'] = radius;
                  });
                  _onSettingChanged();
                },
                onAutoLocationToggle: (enabled) {
                  setState(() {
                    _locationSettings['automaticLocationUpdates'] = enabled;
                  });
                  _onSettingChanged();
                },
              ),
              SizedBox(height: 3.h),

              // Role-specific settings
              if (_userData['role'] == UserRole.business) ...[
                BusinessSettingsWidget(
                  settings: _businessSettings,
                  onBusinessHoursChanged: (hours) {
                    setState(() {
                      _businessSettings['businessHours'] = hours;
                    });
                    _onSettingChanged();
                  },
                  onContactInfoChanged: (info) {
                    setState(() {
                      _businessSettings['contactInfo'] = info;
                    });
                    _onSettingChanged();
                  },
                  onPaymentMethodsChanged: (methods) {
                    setState(() {
                      _businessSettings['paymentMethods'] = methods;
                    });
                    _onSettingChanged();
                  },
                  onAnalyticsToggle: (enabled) {
                    setState(() {
                      _businessSettings['analyticsPreferences'] = enabled;
                    });
                    _onSettingChanged();
                  },
                ),
                SizedBox(height: 3.h),
              ] else ...[
                ConsumerSettingsWidget(
                  settings: _consumerSettings,
                  onInterestCategoriesChanged: (categories) {
                    setState(() {
                      _consumerSettings['interestCategories'] = categories;
                    });
                    _onSettingChanged();
                  },
                  onDiscoveryPreferenceChanged: (key, value) {
                    setState(() {
                      _consumerSettings['discoveryPreferences'][key] = value;
                    });
                    _onSettingChanged();
                  },
                ),
                SizedBox(height: 3.h),
              ],

              PrivacySectionWidget(
                onDataUsageControls: () => _onSettingChanged(),
                onAccountDeletion: () => _showAccountDeletionDialog(),
                onPrivacyPolicy: () => _openPrivacyPolicy(),
              ),
              SizedBox(height: 3.h),

              SupportSectionWidget(
                onHelpCenter: () => _openHelpCenter(),
                onContactSupport: () => _openContactSupport(),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showAccountDeletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'This action cannot be undone. All your data will be permanently deleted.'),
            SizedBox(height: 2.h),
            Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Account deletion initiated. You will receive a confirmation email.'),
        backgroundColor: AppTheme.warningLight,
      ),
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening privacy policy...')),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening help center...')),
    );
  }

  void _openContactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening contact support...')),
    );
  }
}
