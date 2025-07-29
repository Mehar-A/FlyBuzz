import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?) onStartDateSelected;
  final Function(DateTime?) onEndDateSelected;

  const DatePickerWidget({
    Key? key,
    this.startDate,
    this.endDate,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = isStartDate
        ? (startDate ?? now)
        : (endDate ??
            startDate?.add(Duration(days: 7)) ??
            now.add(Duration(days: 7)));

    final DateTime firstDate = isStartDate ? now : (startDate ?? now);
    final DateTime lastDate = now.add(Duration(days: 365));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return DatePickerTheme(
          data: DatePickerThemeData(
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
            headerForegroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.lightTheme.colorScheme.onPrimary;
              }
              return AppTheme.lightTheme.colorScheme.onSurface;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.lightTheme.colorScheme.primary;
              }
              return Colors.transparent;
            }),
            todayForegroundColor: WidgetStateProperty.all(
              AppTheme.lightTheme.colorScheme.primary,
            ),
            todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
            todayBorder: BorderSide(
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      if (isStartDate) {
        onStartDateSelected(selectedDate);
        // Reset end date if it's before the new start date
        if (endDate != null && endDate!.isBefore(selectedDate)) {
          onEndDateSelected(null);
        }
      } else {
        onEndDateSelected(selectedDate);
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Date',
                    style: AppTheme.lightTheme.textTheme.labelLarge,
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.lightTheme.colorScheme.surface,
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'calendar_today',
                            color: startDate != null
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              _formatDate(startDate),
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: startDate != null
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'End Date',
                    style: AppTheme.lightTheme.textTheme.labelLarge,
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: startDate != null
                        ? () => _selectDate(context, false)
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: startDate != null
                              ? AppTheme.lightTheme.colorScheme.outline
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: startDate != null
                            ? AppTheme.lightTheme.colorScheme.surface
                            : AppTheme.lightTheme.colorScheme.surface
                                .withValues(alpha: 0.5),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'event',
                            color: endDate != null
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              _formatDate(endDate),
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: endDate != null
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (startDate != null && endDate != null) ...[
          SizedBox(height: 2.h),
          _buildDurationIndicator(),
        ],
      ],
    );
  }

  Widget _buildDurationIndicator() {
    if (startDate == null || endDate == null) return SizedBox.shrink();

    final duration = endDate!.difference(startDate!).inDays + 1;
    final isExpiringSoon = duration <= 3;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isExpiringSoon
            ? AppTheme.lightTheme.colorScheme.secondaryContainer
                .withValues(alpha: 0.3)
            : AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isExpiringSoon ? 'schedule' : 'access_time',
            color: isExpiringSoon
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            '$duration day${duration == 1 ? '' : 's'} duration',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: isExpiringSoon
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
