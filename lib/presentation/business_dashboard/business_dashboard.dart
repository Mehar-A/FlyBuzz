import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/analytics_card_widget.dart';
import './widgets/business_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/flyer_card_widget.dart';

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({super.key});

  @override
  State<BusinessDashboard> createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _lastUpdated = '';

  // Mock business data
  final Map<String, dynamic> _businessData = {
    "id": 1,
    "name": "Fresh Market Grocery",
    "location": "Downtown Seattle, WA",
    "logo":
        "https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "hasNotifications": true,
  };

  // Mock analytics data
  final List<Map<String, dynamic>> _analyticsData = [
    {
      "title": "Active Flyers",
      "value": "12",
      "trend": "+3",
      "isPositive": true,
      "icon": "campaign",
    },
    {
      "title": "Views This Week",
      "value": "2.4K",
      "trend": "+18%",
      "isPositive": true,
      "icon": "visibility",
    },
    {
      "title": "Engagement Rate",
      "value": "8.2%",
      "trend": "-2%",
      "isPositive": false,
      "icon": "trending_up",
    },
  ];

  // Mock flyers data
  final List<Map<String, dynamic>> _flyersData = [
    {
      "id": 1,
      "title": "Fresh Organic Produce Sale - 30% Off All Vegetables",
      "image":
          "https://images.pexels.com/photos/1300972/pexels-photo-1300972.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "status": "Hot Deal",
      "location": "Downtown Seattle",
      "views": 1250,
      "saves": 89,
      "shares": 34,
      "date": "Dec 15",
      "type": "sale",
      "originalPrice": "\$50.00",
      "salePrice": "\$35.00",
    },
    {
      "id": 2,
      "title": "Holiday Baking Essentials - Premium Flour & Sugar",
      "image":
          "https://images.pexels.com/photos/1775043/pexels-photo-1775043.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "status": "New",
      "location": "Downtown Seattle",
      "views": 892,
      "saves": 67,
      "shares": 23,
      "date": "Dec 14",
      "type": "product",
      "originalPrice": "\$25.00",
      "salePrice": "\$20.00",
    },
    {
      "id": 3,
      "title": "Weekend Farmers Market - Local Vendors Welcome",
      "image":
          "https://images.pexels.com/photos/1435904/pexels-photo-1435904.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "status": "Expiring Soon",
      "location": "Downtown Seattle",
      "views": 567,
      "saves": 45,
      "shares": 12,
      "date": "Dec 13",
      "type": "event",
      "originalPrice": "\$0.00",
      "salePrice": "\$0.00",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _lastUpdated = _formatLastUpdated();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatLastUpdated() {
    final now = DateTime.now();
    return 'Last updated: ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _lastUpdated = _formatLastUpdated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          BusinessHeaderWidget(
            businessData: _businessData,
            onNotificationTap: _handleNotificationTap,
          ),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildCreateTab(),
                _buildProfileTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _navigateToCreateFlyer,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'Create Flyer',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _tabController.index == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            text: 'Dashboard',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'add_circle',
              color: _tabController.index == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            text: 'Create',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _tabController.index == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            text: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child:
          _flyersData.isEmpty ? _buildEmptyState() : _buildDashboardContent(),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          _buildAnalyticsSection(),
          SizedBox(height: 3.h),
          _buildQuickActionsSection(),
          SizedBox(height: 3.h),
          _buildActiveFlyersSection(),
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Analytics Overview',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _lastUpdated,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _analyticsData.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final data = _analyticsData[index];
              return AnalyticsCardWidget(
                title: data['title'],
                value: data['value'],
                trend: data['trend'],
                isPositive: data['isPositive'],
                icon: CustomIconWidget(
                  iconName: data['icon'],
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'View Analytics',
                  'analytics',
                  () => _navigateToAnalytics(),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionCard(
                  'Edit Profile',
                  'edit',
                  () => _navigateToProfile(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
      String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.getCardShadow(),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFlyersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Flyers (${_flyersData.length})',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => _navigateToAllFlyers(),
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _flyersData.length,
          itemBuilder: (context, index) {
            final flyer = _flyersData[index];
            return FlyerCardWidget(
              flyerData: flyer,
              onTap: () => _navigateToFlyerDetail(flyer),
              onEdit: () => _navigateToEditFlyer(flyer),
              onDuplicate: () => _duplicateFlyer(flyer),
              onShare: () => _shareFlyer(flyer),
              onAnalytics: () => _navigateToFlyerAnalytics(flyer),
              onDelete: () => _deleteFlyer(flyer),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 70.h,
        child: EmptyStateWidget(
          onCreateFlyer: _navigateToCreateFlyer,
        ),
      ),
    );
  }

  Widget _buildCreateTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'add_circle_outline',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 80,
          ),
          SizedBox(height: 2.h),
          Text(
            'Create New Flyer',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Tap to start creating your promotional flyer',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: _navigateToCreateFlyer,
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'person_outline',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 80,
          ),
          SizedBox(height: 2.h),
          Text(
            'Business Profile',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Manage your business information and settings',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: _navigateToProfile,
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToCreateFlyer() {
    Navigator.pushNamed(context, '/create-flyer');
  }

  void _navigateToFlyerDetail(Map<String, dynamic> flyer) {
    Navigator.pushNamed(context, '/flyer-detail', arguments: flyer);
  }

  void _navigateToEditFlyer(Map<String, dynamic> flyer) {
    Navigator.pushNamed(context, '/create-flyer', arguments: flyer);
  }

  void _navigateToAnalytics() {
    // Navigate to analytics screen
  }

  void _navigateToProfile() {
    // Navigate to profile screen
  }

  void _navigateToAllFlyers() {
    // Navigate to all flyers screen
  }

  void _navigateToFlyerAnalytics(Map<String, dynamic> flyer) {
    // Navigate to flyer analytics screen
  }

  // Action methods
  void _handleNotificationTap() {
    // Handle notification tap
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'You have 3 new engagement notifications',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _duplicateFlyer(Map<String, dynamic> flyer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Flyer duplicated successfully',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareFlyer(Map<String, dynamic> flyer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Flyer shared successfully',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteFlyer(Map<String, dynamic> flyer) {
    setState(() {
      _flyersData.removeWhere((item) => item['id'] == flyer['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Flyer deleted successfully',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _flyersData.add(flyer);
            });
          },
        ),
      ),
    );
  }
}
