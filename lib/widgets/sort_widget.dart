import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class SortWidget extends StatelessWidget {
  final String? selectedSort;
  final List<SortOption> sortOptions;
  final ValueChanged<String?> onSortChanged;
  final bool isAscending;
  final VoidCallback? onToggleOrder;

  const SortWidget({
    super.key,
    this.selectedSort,
    required this.sortOptions,
    required this.onSortChanged,
    this.isAscending = true,
    this.onToggleOrder,
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
                Icons.sort,
                color: AppConstants.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              const Text(
                'ترتيب',
                style: AppConstants.bodyStyle,
              ),
              const Spacer(),
              if (onToggleOrder != null)
                CustomButton(
                  text: isAscending ? 'تصاعدي' : 'تنازلي',
                  onPressed: onToggleOrder,
                  icon: isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  height: 32,
                ),
            ],
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Wrap(
            spacing: AppConstants.smallPadding,
            runSpacing: AppConstants.smallPadding,
            children: [
              _buildSortChip('الافتراضي', null),
              ...sortOptions.map((option) => _buildSortChip(option.label, option.value)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String? value) {
    final isSelected = selectedSort == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onSortChanged(selected ? value : null);
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

class SortOption {
  final String label;
  final String value;

  const SortOption({
    required this.label,
    required this.value,
  });
}
