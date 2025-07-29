import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/business_dashboard/business_dashboard.dart';
import '../presentation/consumer_home_feed/consumer_home_feed.dart';
import '../presentation/flyer_detail/flyer_detail.dart';
import '../presentation/create_flyer/create_flyer.dart';
import '../presentation/profile_settings/profile_settings.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String splashScreen = '/splash-screen';
  static const String businessDashboard = '/business-dashboard';
  static const String consumerHomeFeed = '/consumer-home-feed';
  static const String flyerDetail = '/flyer-detail';
  static const String createFlyer = '/create-flyer';
  static const String profileSettings = '/profile-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => SplashScreen(),
    loginScreen: (context) => LoginScreen(),
    splashScreen: (context) => SplashScreen(),
    businessDashboard: (context) => BusinessDashboard(),
    consumerHomeFeed: (context) => ConsumerHomeFeed(),
    flyerDetail: (context) => FlyerDetail(),
    createFlyer: (context) => CreateFlyer(),
    profileSettings: (context) => const ProfileSettings(),
    // TODO: Add your other routes here
  };
}
