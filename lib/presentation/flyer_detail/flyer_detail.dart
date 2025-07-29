import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/action_buttons_section.dart';
import './widgets/business_info_card.dart';
import './widgets/flyer_content_section.dart';
import './widgets/hero_image_section.dart';
import './widgets/location_map_section.dart';
import './widgets/related_flyers_section.dart';

class FlyerDetail extends StatefulWidget {
  const FlyerDetail({Key? key}) : super(key: key);

  @override
  State<FlyerDetail> createState() => _FlyerDetailState();
}

class _FlyerDetailState extends State<FlyerDetail> {
  bool _isSaved = false;
  late Map<String, dynamic> _flyerData;
  late Map<String, dynamic> _businessData;
  late List<Map<String, dynamic>> _relatedFlyers;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    _flyerData = {
      "id": 1,
      "title": "50% Off Summer Collection",
      "description":
          """Get ready for summer with our amazing collection of trendy outfits! 
      
Discover the latest fashion trends with our premium summer collection featuring lightweight fabrics, vibrant colors, and comfortable designs perfect for the warm weather. From casual wear to elegant evening outfits, we have everything you need to look your best this season.

Our summer collection includes:
• Breathable cotton t-shirts and tops
• Stylish shorts and skirts
• Comfortable sandals and summer shoes
• Lightweight dresses for any occasion
• Accessories to complete your look

Don't miss this limited-time offer to refresh your wardrobe with high-quality pieces at unbeatable prices. Visit our store today and take advantage of this incredible deal!""",
      "image":
          "https://images.unsplash.com/photo-1441986300917-64674bd600d8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "businessName": "Fashion Forward Boutique",
      "originalPrice": "\$120.00",
      "salePrice": "\$60.00",
      "startDate": "2025-07-25",
      "endDate": "2025-08-15",
      "distance": 0.8,
      "tags": ["Hot Deal", "New"],
      "category": "Fashion",
    };

    _businessData = {
      "name": "Fashion Forward Boutique",
      "category": "Fashion & Clothing",
      "address": "123 Main Street, Downtown District, City Center, NY 10001",
      "phone": "+1 (555) 123-4567",
      "logo":
          "https://images.unsplash.com/photo-1441986300917-64674bd600d8?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
      "distance": 0.8,
    };

    _relatedFlyers = [
      {
        "id": 2,
        "title": "Buy 2 Get 1 Free Pizza Deal",
        "businessName": "Tony's Pizza Palace",
        "image":
            "https://images.unsplash.com/photo-1513104890138-7c749659a591?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "originalPrice": "\$45.00",
        "salePrice": "\$30.00",
        "distance": 1.2,
        "tags": ["Hot Deal"],
      },
      {
        "id": 3,
        "title": "Free Coffee with Pastry Purchase",
        "businessName": "Morning Brew Café",
        "image":
            "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "originalPrice": "\$8.50",
        "salePrice": "\$5.00",
        "distance": 0.5,
        "tags": ["New"],
      },
      {
        "id": 4,
        "title": "20% Off All Electronics",
        "businessName": "TechHub Store",
        "image":
            "https://images.unsplash.com/photo-1498049794561-7780e7231661?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "originalPrice": "\$299.99",
        "salePrice": "\$239.99",
        "distance": 2.1,
        "tags": ["Expiring Soon"],
      },
      {
        "id": 5,
        "title": "Spa Day Package Special",
        "businessName": "Serenity Wellness Spa",
        "image":
            "https://images.unsplash.com/photo-1544161515-4ab6ce6db874?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "originalPrice": "\$150.00",
        "salePrice": "\$99.00",
        "distance": 1.8,
        "tags": ["Hot Deal"],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image Section
                  HeroImageSection(
                    flyerData: _flyerData,
                    onBackPressed: () => Navigator.pop(context),
                  ),

                  // Flyer Content Section
                  FlyerContentSection(flyerData: _flyerData),

                  // Business Info Card
                  BusinessInfoCard(businessData: _businessData),

                  // Location Map Section
                  LocationMapSection(businessData: _businessData),

                  // Related Flyers Section
                  RelatedFlyersSection(
                    relatedFlyers: _relatedFlyers,
                    onFlyerTap: _navigateToFlyerDetail,
                  ),

                  // Bottom padding for action buttons
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),

          // Action Buttons Section (Fixed at bottom)
          ActionButtonsSection(
            flyerData: _flyerData,
            isSaved: _isSaved,
            onSaveToggle: _toggleSave,
          ),
        ],
      ),
    );
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSaved
              ? "Flyer saved successfully!"
              : "Flyer removed from saved items",
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 15.h,
          left: 4.w,
          right: 4.w,
        ),
      ),
    );
  }

  void _navigateToFlyerDetail(Map<String, dynamic> flyerData) {
    // Navigate to another flyer detail page
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Opening ${flyerData["title"]}..."),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
