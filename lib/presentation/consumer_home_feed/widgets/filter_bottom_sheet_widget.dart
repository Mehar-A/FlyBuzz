import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  double _distanceRange = 5.0;
  List<String> _selectedCategories = [];
  List<String> _selectedDealTypes = [];

  final List<String> _categories = [
    'Restaurant',
    'Retail',
    'Services',
    'Entertainment',
    'Health & Beauty',
    'Automotive',
    'Home & Garden',
    'Sports & Fitness',
  ];

  final List<String> _dealTypes = [
    'Sale',
    'Event',
    'New Product',
    'Limited Time',
    'Clearance',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _distanceRange = (_filters['distanceRange'] as double?) ?? 5.0;
    _selectedCategories = List<String>.from(_filters['categories'] ?? []);
    _selectedDealTypes = List<String>.from(_filters['dealTypes'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDistanceSection(),
                  SizedBox(height: 3.h),
                  _buildCategoriesSection(),
                  SizedBox(height: 3.h),
                  _buildDealTypesSection(),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderLight),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Filter Flyers',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Clear All',
              style: TextStyle(color: AppTheme.textSecondaryLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distance Range',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Text(
              '0 mi',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            Expanded(
              child: Slider(
                value: _distanceRange,
                min: 0.5,
                max: 25.0,
                divisions: 49,
                onChanged: (value) {
                  setState(() {
                    _distanceRange = value;
                  });
                },
              ),
            ),
            Text(
              '25+ mi',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            'Within ${_distanceRange.toStringAsFixed(1)} miles',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _categories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              selectedColor: AppTheme.primaryLight.withValues(alpha: 0.1),
              checkmarkColor: AppTheme.primaryLight,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.primaryLight
                    : AppTheme.textPrimaryLight,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDealTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deal Types',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _dealTypes.map((dealType) {
            final isSelected = _selectedDealTypes.contains(dealType);
            return FilterChip(
              label: Text(dealType),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDealTypes.add(dealType);
                  } else {
                    _selectedDealTypes.remove(dealType);
                  }
                });
              },
              selectedColor: AppTheme.accentLight.withValues(alpha: 0.1),
              checkmarkColor: AppTheme.accentLight,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.accentLight
                    : AppTheme.textPrimaryLight,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.borderLight),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _distanceRange = 5.0;
      _selectedCategories.clear();
      _selectedDealTypes.clear();
    });
  }

  void _applyFilters() {
    final updatedFilters = {
      'distanceRange': _distanceRange,
      'categories': _selectedCategories,
      'dealTypes': _selectedDealTypes,
    };
    widget.onFiltersChanged(updatedFilters);
    Navigator.pop(context);
  }
}
