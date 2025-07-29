import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_options_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/flyer_type_selector_widget.dart';
import './widgets/image_upload_widget.dart';
import './widgets/location_targeting_widget.dart';
import './widgets/preview_modal_widget.dart';
import './widgets/pricing_section_widget.dart';

class CreateFlyer extends StatefulWidget {
  const CreateFlyer({Key? key}) : super(key: key);

  @override
  State<CreateFlyer> createState() => _CreateFlyerState();
}

class _CreateFlyerState extends State<CreateFlyer>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _salePriceController = TextEditingController();

  String _selectedType = 'Sale';
  XFile? _selectedImage;
  DateTime? _startDate;
  DateTime? _endDate;
  double _radiusValue = 5.0;
  List<String> _selectedTags = [];
  bool _notificationEnabled = true;
  bool _isDraftSaving = false;
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _startDraftSaving();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  void _startDraftSaving() {
    // Auto-save draft every 30 seconds
    Future.delayed(Duration(seconds: 30), () {
      if (mounted) {
        _saveDraft();
        _startDraftSaving();
      }
    });
  }

  void _saveDraft() {
    if (_titleController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _selectedImage != null) {
      setState(() {
        _isDraftSaving = true;
      });

      // Simulate draft saving
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isDraftSaving = false;
          });
        }
      });
    }
  }

  bool _isFormValid() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedImage != null &&
        _startDate != null &&
        _endDate != null &&
        (_selectedType == 'Event' ||
            _originalPriceController.text.isNotEmpty) &&
        (_selectedType != 'Sale' || _salePriceController.text.isNotEmpty);
  }

  void _showPreview() {
    showDialog(
      context: context,
      builder: (context) => PreviewModalWidget(
        title: _titleController.text,
        description: _descriptionController.text,
        selectedType: _selectedType,
        originalPrice: _originalPriceController.text,
        salePrice: _salePriceController.text,
        startDate: _startDate,
        endDate: _endDate,
        selectedTags: _selectedTags,
        selectedImage: _selectedImage,
        radiusValue: _radiusValue,
      ),
    );
  }

  void _publishFlyer() async {
    if (!_formKey.currentState!.validate() || !_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all required fields'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isPublishing = true;
    });

    // Simulate publishing process
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isPublishing = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text('Flyer Published!'),
            ],
          ),
          content: Text(
            'Your flyer is now live and visible to customers within ${_radiusValue.round()} miles.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
              child: Text('Create Another'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/business-dashboard');
              },
              child: Text('View Dashboard'),
            ),
          ],
        ),
      );
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _originalPriceController.clear();
    _salePriceController.clear();
    setState(() {
      _selectedType = 'Sale';
      _selectedImage = null;
      _startDate = null;
      _endDate = null;
      _radiusValue = 5.0;
      _selectedTags.clear();
      _notificationEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Create Flyer'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (_isDraftSaving)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Saving...',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          if (_isFormValid())
            TextButton(
              onPressed: _showPreview,
              child: Text('Preview'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Upload Section
                    ImageUploadWidget(
                      selectedImage: _selectedImage,
                      onImageSelected: (image) {
                        setState(() {
                          _selectedImage = image;
                        });
                      },
                    ),
                    SizedBox(height: 4.h),

                    // Flyer Type Selector
                    FlyerTypeSelectorWidget(
                      selectedType: _selectedType,
                      onTypeSelected: (type) {
                        setState(() {
                          _selectedType = type;
                          // Clear pricing fields when switching to Event
                          if (type == 'Event') {
                            _originalPriceController.clear();
                            _salePriceController.clear();
                          }
                        });
                      },
                    ),
                    SizedBox(height: 4.h),

                    // Title Field
                    Text(
                      'Title',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 2.h),
                    TextFormField(
                      controller: _titleController,
                      maxLength: 60,
                      decoration: InputDecoration(
                        hintText: 'Enter flyer title...',
                        counterText: '${_titleController.text.length}/60',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Description Field
                    Text(
                      'Description',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 2.h),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      maxLength: 300,
                      decoration: InputDecoration(
                        hintText: 'Describe your offer, event, or product...',
                        counterText:
                            '${_descriptionController.text.length}/300',
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Pricing Section
                    PricingSectionWidget(
                      selectedType: _selectedType,
                      originalPriceController: _originalPriceController,
                      salePriceController: _salePriceController,
                    ),
                    if (_selectedType != 'Event') SizedBox(height: 4.h),

                    // Date Picker
                    DatePickerWidget(
                      startDate: _startDate,
                      endDate: _endDate,
                      onStartDateSelected: (date) {
                        setState(() {
                          _startDate = date;
                        });
                      },
                      onEndDateSelected: (date) {
                        setState(() {
                          _endDate = date;
                        });
                      },
                    ),
                    SizedBox(height: 4.h),

                    // Location Targeting
                    LocationTargetingWidget(
                      radiusValue: _radiusValue,
                      onRadiusChanged: (value) {
                        setState(() {
                          _radiusValue = value;
                        });
                      },
                    ),
                    SizedBox(height: 4.h),

                    // Advanced Options
                    AdvancedOptionsWidget(
                      selectedTags: _selectedTags,
                      notificationEnabled: _notificationEnabled,
                      onTagsChanged: (tags) {
                        setState(() {
                          _selectedTags = tags;
                        });
                      },
                      onNotificationChanged: (enabled) {
                        setState(() {
                          _notificationEnabled = enabled;
                        });
                      },
                    ),
                    SizedBox(height: 10.h), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed:
                  _isFormValid() && !_isPublishing ? _publishFlyer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid()
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                foregroundColor: _isFormValid()
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              child: _isPublishing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text('Publishing...'),
                      ],
                    )
                  : Text(
                      'Publish Flyer',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: _isFormValid()
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
