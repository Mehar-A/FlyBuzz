import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/network_error_widget.dart';
import './widgets/permission_dialog_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  String _loadingText = 'Initializing...';
  bool _showError = false;
  bool _showPermissionDialog = false;
  int _retryCount = 0;
  Timer? _timeoutTimer;

  // Mock user data for demonstration
  final Map<String, dynamic> _mockUserData = {
    'isAuthenticated': false,
    'userType': null, // 'business' or 'consumer'
    'hasCompletedOnboarding': false,
    'locationPermissionGranted': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: AppTheme.lightTheme.colorScheme.primary,
      end: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundController.repeat(reverse: true);
  }

  Future<void> _startInitialization() async {
    setState(() {
      _showError = false;
      _loadingText = 'Initializing...';
    });

    // Set timeout timer
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showError = true;
        });
      }
    });

    try {
      // Step 1: Check authentication status
      await _updateLoadingText('Checking authentication...');
      await _checkAuthenticationStatus();

      // Step 2: Request location permissions
      await _updateLoadingText('Requesting location access...');
      final locationGranted = await _requestLocationPermission();

      if (!locationGranted) {
        _showLocationPermissionDialog();
        return;
      }

      // Step 3: Load user preferences
      await _updateLoadingText('Loading preferences...');
      await _loadUserPreferences();

      // Step 4: Prepare cached data
      await _updateLoadingText('Preparing local data...');
      await _prepareCachedData();

      // Step 5: Complete initialization
      await _updateLoadingText('Almost ready...');
      await Future.delayed(const Duration(milliseconds: 500));

      _timeoutTimer?.cancel();
      _navigateToNextScreen();
    } catch (e) {
      _timeoutTimer?.cancel();
      if (mounted) {
        setState(() {
          _showError = true;
        });
      }
    }
  }

  Future<void> _updateLoadingText(String text) async {
    if (mounted) {
      setState(() {
        _loadingText = text;
      });
    }
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate checking stored authentication
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock authentication check - in real app, check secure storage
    final isLoggedIn = DateTime.now().millisecondsSinceEpoch % 3 == 0;
    final userType = DateTime.now().millisecondsSinceEpoch % 2 == 0
        ? 'business'
        : 'consumer';

    _mockUserData['isAuthenticated'] = isLoggedIn;
    _mockUserData['userType'] = isLoggedIn ? userType : null;
    _mockUserData['hasCompletedOnboarding'] = isLoggedIn;
  }

  Future<bool> _requestLocationPermission() async {
    // Simulate location permission request
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock permission result - in real app, use permission_handler
    final granted = DateTime.now().millisecondsSinceEpoch % 4 != 0;
    _mockUserData['locationPermissionGranted'] = granted;

    return granted;
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences from local storage
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _prepareCachedData() async {
    // Simulate preparing cached flyer data
    await Future.delayed(const Duration(milliseconds: 700));
  }

  void _showLocationPermissionDialog() {
    if (mounted) {
      setState(() {
        _showPermissionDialog = true;
      });
    }
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    final isAuthenticated = _mockUserData['isAuthenticated'] as bool;
    final userType = _mockUserData['userType'] as String?;
    final hasCompletedOnboarding =
        _mockUserData['hasCompletedOnboarding'] as bool;

    String nextRoute;

    if (isAuthenticated && hasCompletedOnboarding) {
      // Navigate based on user type
      if (userType == 'business') {
        nextRoute = '/business-dashboard';
      } else {
        nextRoute = '/consumer-home-feed';
      }
    } else if (!hasCompletedOnboarding) {
      // New user - would go to role selection (using login as placeholder)
      nextRoute = '/login-screen';
    } else {
      // Returning non-authenticated user
      nextRoute = '/login-screen';
    }

    // Smooth fade transition
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _handlePermissionRetry() {
    setState(() {
      _showPermissionDialog = false;
    });
    _startInitialization();
  }

  void _handlePermissionSkip() {
    setState(() {
      _showPermissionDialog = false;
    });
    _mockUserData['locationPermissionGranted'] = false;
    _navigateToNextScreen();
  }

  void _handleNetworkRetry() {
    _retryCount++;
    if (_retryCount < 3) {
      _startInitialization();
    } else {
      // After 3 retries, proceed with limited functionality
      _navigateToNextScreen();
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundAnimation.value ??
                      AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.9),
                  AppTheme.lightTheme.colorScheme.secondary,
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Main content
                  Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: const AnimatedLogoWidget(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _showError
                                ? NetworkErrorWidget(
                                    onRetry: _handleNetworkRetry,
                                  )
                                : LoadingIndicatorWidget(
                                    loadingText: _loadingText,
                                  ),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Permission dialog overlay
                  if (_showPermissionDialog)
                    Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: PermissionDialogWidget(
                          title: 'Location Access Required',
                          message:
                              'FlyerBuzz needs location access to show you nearby deals and promotions. This helps us connect you with local businesses in your area.',
                          onRetry: _handlePermissionRetry,
                          onSkip: _handlePermissionSkip,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
