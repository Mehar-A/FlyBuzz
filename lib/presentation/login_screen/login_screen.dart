import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/role_toggle_widget.dart';
import './widgets/sign_up_link_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedRole = 'Consumer';
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  // Mock credentials for testing
  final Map<String, Map<String, String>> _mockCredentials = {
    'Business Owner': {
      'email': 'business@flyerbuzz.com',
      'password': 'business123',
    },
    'Consumer': {
      'email': 'consumer@flyerbuzz.com',
      'password': 'consumer123',
    },
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleRoleChange(String role) {
    if (!_isLoading) {
      setState(() {
        _selectedRole = role;
      });
    }
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Check mock credentials
    final mockCreds = _mockCredentials[_selectedRole];
    final isValidCredentials = mockCreds != null &&
        mockCreds['email'] == email &&
        mockCreds['password'] == password;

    if (isValidCredentials) {
      // Success haptic feedback
      HapticFeedback.lightImpact();

      // Navigate based on role
      if (_selectedRole == 'Business Owner') {
        Navigator.pushReplacementNamed(context, '/business-dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/consumer-home-feed');
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid credentials. Please check your email and password.',
            style: TextStyle(color: AppTheme.lightTheme.colorScheme.onError),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Try Demo',
            textColor: AppTheme.lightTheme.colorScheme.onError,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Demo: ${mockCreds?['email']} / ${mockCreds?['password']}',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _handleBackButton() {
    Navigator.pushReplacementNamed(context, '/splash-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // App Bar with Back Button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _isLoading ? null : _handleBackButton,
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 12.w), // Balance the back button
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 4.h),

                      // App Logo
                      AppLogoWidget(),

                      SizedBox(height: 4.h),

                      // Role Toggle
                      RoleToggleWidget(
                        selectedRole: _selectedRole,
                        onRoleChanged: _handleRoleChange,
                        isEnabled: !_isLoading,
                      ),

                      SizedBox(height: 3.h),

                      // Login Form
                      LoginFormWidget(
                        selectedRole: _selectedRole,
                        onLogin: _handleLogin,
                        isLoading: _isLoading,
                      ),

                      SizedBox(height: 2.h),

                      // Sign Up Link
                      SignUpLinkWidget(
                        selectedRole: _selectedRole,
                        isEnabled: !_isLoading,
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
