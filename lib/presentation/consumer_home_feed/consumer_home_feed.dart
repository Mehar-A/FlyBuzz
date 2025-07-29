import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/flyer_card_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/skeleton_card_widget.dart';

class ConsumerHomeFeed extends StatefulWidget {
  const ConsumerHomeFeed({Key? key}) : super(key: key);

  @override
  State<ConsumerHomeFeed> createState() => _ConsumerHomeFeedState();
}

class _ConsumerHomeFeedState extends State<ConsumerHomeFeed>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isLoadingMore = false;
  Map<String, dynamic> _currentFilters = {};
  String _currentLocation = "Downtown Seattle, WA";

  // Mock data for flyers
  final List<Map<String, dynamic>> _flyers = [
    {
      "id": 1,
      "title": "50% Off Summer Collection",
      "description":
          "Get amazing discounts on our entire summer collection. Limited time offer with exclusive deals on trendy outfits.",
      "businessName": "Fashion Forward",
      "businessLogo":
          "https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg?auto=compress&cs=tinysrgb&w=100&h=100&dpr=1",
      "image":
          "https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&dpr=1",
      "distance": 0.3,
      "timeAgo": "2 hours ago",
      "tag": "Hot Deal",
      "originalPrice": "\$120.00",
      "salePrice": "\$60.00",
      "isSaved": false,
      "category": "Retail",
      "dealType": "Sale"
    },
    {
      "id": 2,
      "title": "Grand Opening Celebration",
      "description":
          "Join us for our grand opening! Free appetizers, live music, and special opening week discounts for all customers.",
      "businessName": "Bella Vista Restaurant",
      "businessLogo":
          "https://images.pixabay.com/photo/2016/12/26/17/28/spaghetti-1932466_960_720.jpg",
      "image":
          "https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&dpr=1",
      "distance": 0.8,
      "timeAgo": "4 hours ago",
      "tag": "New",
      "originalPrice": null,
      "salePrice": null,
      "isSaved": true,
      "category": "Restaurant",
      "dealType": "Event"
    },
    {
      "id": 3,
      "title": "Flash Sale - 24 Hours Only",
      "description":
          "Everything must go! Massive clearance sale on electronics, home goods, and more. Don't miss out on these incredible deals.",
      "businessName": "TechMart Electronics",
      "businessLogo":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=100&h=100&fit=crop&crop=center",
      "image":
          "https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=800&h=600&q=80",
      "distance": 1.2,
      "timeAgo": "6 hours ago",
      "tag": "Expiring Soon",
      "originalPrice": "\$299.99",
      "salePrice": "\$149.99",
      "isSaved": false,
      "category": "Electronics",
      "dealType": "Clearance"
    },
    {
      "id": 4,
      "title": "Yoga Classes - New Member Special",
      "description":
          "Start your wellness journey with us! First month free for new members. All levels welcome with expert instructors.",
      "businessName": "Zen Wellness Studio",
      "businessLogo":
          "https://images.pexels.com/photos/3822622/pexels-photo-3822622.jpeg?w=100&h=100&fit=crop&crop=center",
      "image":
          "https://images.pexels.com/photos/3822622/pexels-photo-3822622.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&dpr=1",
      "distance": 2.1,
      "timeAgo": "1 day ago",
      "tag": "New",
      "originalPrice": "\$89.00",
      "salePrice": "Free",
      "isSaved": false,
      "category": "Sports & Fitness",
      "dealType": "New Product"
    },
    {
      "id": 5,
      "title": "Weekend Brunch Special",
      "description":
          "Join us for an amazing weekend brunch experience. Fresh ingredients, artisanal coffee, and bottomless mimosas available.",
      "businessName": "Morning Glory Cafe",
      "businessLogo":
          "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=100&h=100&fit=crop&crop=center",
      "image":
          "https://images.unsplash.com/photo-1551218808-94e220e084d2?auto=format&fit=crop&w=800&h=600&q=80",
      "distance": 0.5,
      "timeAgo": "8 hours ago",
      "tag": "Hot Deal",
      "originalPrice": "\$25.00",
      "salePrice": "\$18.00",
      "isSaved": true,
      "category": "Restaurant",
      "dealType": "Limited Time"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreFlyers();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMoreFlyers() async {
    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more data
    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshFeed() async {
    // Simulate pull-to-refresh
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      // Refresh data
    });
  }

  void _toggleSaveFlyer(int flyerId) {
    setState(() {
      final flyerIndex = _flyers.indexWhere((flyer) => flyer["id"] == flyerId);
      if (flyerIndex != -1) {
        _flyers[flyerIndex]["isSaved"] =
            !(_flyers[flyerIndex]["isSaved"] as bool);
      }
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_flyers.firstWhere((f) => f["id"] == flyerId)["isSaved"]
            ? 'Flyer saved!'
            : 'Flyer removed from saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareFlyer(Map<String, dynamic> flyer) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${flyer["title"]}"'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openFlyerDetail(Map<String, dynamic> flyer) {
    Navigator.pushNamed(context, '/flyer-detail', arguments: flyer);
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => FilterBottomSheetWidget(
          currentFilters: _currentFilters,
          onFiltersChanged: (filters) {
            setState(() {
              _currentFilters = filters;
            });
          },
        ),
      ),
    );
  }

  void _openLocationSettings() {
    // Navigate to location settings
    Navigator.pushNamed(context, '/profile-settings');
  }

  void _expandSearchRadius() {
    _openFilterBottomSheet();
  }

  List<Map<String, dynamic>> get _filteredFlyers {
    List<Map<String, dynamic>> filtered = List.from(_flyers);

    // Apply distance filter
    if (_currentFilters['distanceRange'] != null) {
      final maxDistance = _currentFilters['distanceRange'] as double;
      filtered = filtered
          .where((flyer) => (flyer['distance'] as double) <= maxDistance)
          .toList();
    }

    // Apply category filter
    if (_currentFilters['categories'] != null &&
        (_currentFilters['categories'] as List).isNotEmpty) {
      final categories = _currentFilters['categories'] as List<String>;
      filtered = filtered
          .where((flyer) => categories.contains(flyer['category']))
          .toList();
    }

    // Apply deal type filter
    if (_currentFilters['dealTypes'] != null &&
        (_currentFilters['dealTypes'] as List).isNotEmpty) {
      final dealTypes = _currentFilters['dealTypes'] as List<String>;
      filtered = filtered
          .where((flyer) => dealTypes.contains(flyer['dealType']))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          LocationHeaderWidget(
            currentLocation: _currentLocation,
            onSettingsPressed: _openLocationSettings,
          ),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHomeFeed(),
                _buildSavedFlyers(),
                _buildProfile(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _openFilterBottomSheet,
              child: CustomIconWidget(
                iconName: 'tune',
                color: Colors.white,
                size: 24,
              ),
              backgroundColor: AppTheme.primaryLight,
            )
          : null,
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderLight),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _tabController.index == 0
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            text: 'Home',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'bookmark',
              color: _tabController.index == 1
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            text: 'Saved',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _tabController.index == 2
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            text: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeFeed() {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => SkeletonCardWidget(),
      );
    }

    final filteredFlyers = _filteredFlyers;

    if (filteredFlyers.isEmpty) {
      return EmptyStateWidget(
        onExpandRadius: _expandSearchRadius,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshFeed,
      child: ListView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: filteredFlyers.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= filteredFlyers.length) {
            return Padding(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryLight,
                ),
              ),
            );
          }

          final flyer = filteredFlyers[index];
          return FlyerCardWidget(
            flyer: flyer,
            onTap: () => _openFlyerDetail(flyer),
            onSave: () => _toggleSaveFlyer(flyer["id"] as int),
            onShare: () => _shareFlyer(flyer),
          );
        },
      ),
    );
  }

  Widget _buildSavedFlyers() {
    final savedFlyers =
        _flyers.where((flyer) => flyer["isSaved"] == true).toList();

    if (savedFlyers.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'bookmark_border',
                color: AppTheme.textSecondaryLight,
                size: 20.w,
              ),
              SizedBox(height: 4.h),
              Text(
                'No Saved Flyers',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Save flyers you\'re interested in to view them later.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: savedFlyers.length,
      itemBuilder: (context, index) {
        final flyer = savedFlyers[index];
        return FlyerCardWidget(
          flyer: flyer,
          onTap: () => _openFlyerDetail(flyer),
          onSave: () => _toggleSaveFlyer(flyer["id"] as int),
          onShare: () => _shareFlyer(flyer),
        );
      },
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),
          CircleAvatar(
            radius: 15.w,
            backgroundColor: AppTheme.primaryLight,
            child: CustomIconWidget(
              iconName: 'person',
              color: Colors.white,
              size: 15.w,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'John Consumer',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'john.consumer@email.com',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 4.h),
          _buildProfileSettingsOption(),
          _buildProfileOption(
            icon: 'location_on',
            title: 'Location Settings',
            subtitle: 'Manage your location preferences',
            onTap: _openLocationSettings,
          ),
          _buildProfileOption(
            icon: 'notifications',
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () => Navigator.pushNamed(context, '/profile-settings'),
          ),
          _buildProfileOption(
            icon: 'help',
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () => Navigator.pushNamed(context, '/profile-settings'),
          ),
          _buildProfileOption(
            icon: 'logout',
            title: 'Sign Out',
            subtitle: 'Sign out of your account',
            onTap: () => Navigator.pushNamed(context, '/login-screen'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
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
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.textSecondaryLight,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildProfileSettingsOption() {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: 'settings',
          color: AppTheme.primaryLight,
          size: 24,
        ),
        title: Text(
          'Profile Settings',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Manage your account and preferences',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.textSecondaryLight,
          size: 20,
        ),
        onTap: () => Navigator.pushNamed(context, '/profile-settings'),
      ),
    );
  }
}
