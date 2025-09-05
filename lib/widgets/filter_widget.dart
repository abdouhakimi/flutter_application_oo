import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class FilterWidget extends StatelessWidget {
  final String? selectedFilter;
  final List<String> filterOptions;
  final ValueChanged<String?> onFilterChanged;
  final VoidCallback? onReset;

  const FilterWidget({
    super.key,
    this.selectedFilter,
    required this.filterOptions,
    required this.onFilterChanged,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.filter_list,
                color: AppConstants.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              const Text(
                'تصفية',
                style: AppConstants.bodyStyle,
              ),
              const Spacer(),
              if (onReset != null)
                CustomButton(
                  text: 'إعادة تعيين',
                  onPressed: onReset,
                  icon: Icons.refresh,
                  height: 32,
                ),
            ],
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Wrap(
            spacing: AppConstants.smallPadding,
            runSpacing: AppConstants.smallPadding,
            children: [
              _buildFilterChip('الكل', null),
              ...filterOptions.map((option) => _buildFilterChip(option, option)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = selectedFilter == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onFilterChanged(selected ? value : null);
      },
      selectedColor: AppConstants.primaryColor.withOpacity(0.2),
      checkmarkColor: AppConstants.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppConstants.primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
