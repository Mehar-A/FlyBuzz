import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;

import '../../../../core/app_export.dart';

class LocationMapSection extends StatelessWidget {
  final Map<String, dynamic> businessData;

  const LocationMapSection({
    Key? key,
    required this.businessData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      height: 30.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.getCardShadow(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Map Placeholder with Business Location
            Container(
              width: double.infinity,
              height: 30.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primaryContainer,
                    AppTheme.lightTheme.colorScheme.secondaryContainer,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Grid Pattern for Map Effect
                  CustomPaint(
                    size: Size(double.infinity, 30.h),
                    painter: MapGridPainter(),
                  ),

                  // Business Location Pin
                  Positioned(
                    top: 12.h,
                    left: 45.w,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: 'location_on',
                            color: Colors.white,
                            size: 6.w,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            businessData["name"] ?? "Business",
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // User Location Indicator
                  Positioned(
                    top: 8.h,
                    right: 15.w,
                    child: Container(
                      padding: EdgeInsets.all(1.5.w),
                      decoration: BoxDecoration(
                        color: AppTheme.successLight,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: 'my_location',
                        color: Colors.white,
                        size: 4.w,
                      ),
                    ),
                  ),

                  // Distance Line
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DistanceLinePainter(),
                    ),
                  ),
                ],
              ),
            ),

            // Map Controls Overlay
            Positioned(
              top: 2.h,
              right: 4.w,
              child: Column(
                children: [
                  _buildMapControl(Icons.add, () {}),
                  SizedBox(height: 1.h),
                  _buildMapControl(Icons.remove, () {}),
                  SizedBox(height: 1.h),
                  _buildMapControl(Icons.my_location, () {}),
                ],
              ),
            ),

            // Distance Info
            Positioned(
              bottom: 2.h,
              left: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'directions_walk',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "${(businessData["distance"] ?? 0.0).toStringAsFixed(1)} miles away",
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControl(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: CustomIconWidget(
          iconName: icon.toString().split('.').last,
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 5.w,
        ),
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Draw grid lines
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DistanceLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw dashed line between user and business location
    final path = Path();
    path.moveTo(size.width * 0.75, size.height * 0.3);
    path.lineTo(size.width * 0.45, size.height * 0.5);

    // Create dashed effect
    final dashPath = Path();
    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final double nextDistance = distance + 10;
        final Path extractPath = pathMetric.extractPath(distance, nextDistance);
        dashPath.addPath(extractPath, Offset.zero);
        distance = nextDistance + 5;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
