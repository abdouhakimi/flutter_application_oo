import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int>? onItemsPerPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
    this.onItemsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        children: [
          // Items per page selector
          if (onItemsPerPageChanged != null) ...[
            Row(
              children: [
                const Text('عناصر في الصفحة:'),
                const SizedBox(width: AppConstants.smallPadding),
                DropdownButton<int>(
                  value: itemsPerPage,
                  items: [10, 25, 50, 100].map((value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onItemsPerPageChanged!(value);
                    }
                  },
                ),
                const Spacer(),
                Text('إجمالي: $totalItems'),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            const Divider(),
            const SizedBox(height: AppConstants.smallPadding),
          ],
          
          // Pagination controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First page
              CustomButton(
                text: 'الأولى',
                onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
                height: 32,
                icon: Icons.first_page,
              ),
              
              const SizedBox(width: AppConstants.smallPadding),
              
              // Previous page
              CustomButton(
                text: 'السابقة',
                onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
                height: 32,
                icon: Icons.chevron_left,
              ),
              
              const SizedBox(width: AppConstants.smallPadding),
              
              // Page numbers
              ..._buildPageNumbers(),
              
              const SizedBox(width: AppConstants.smallPadding),
              
              // Next page
              CustomButton(
                text: 'التالية',
                onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
                height: 32,
                icon: Icons.chevron_right,
              ),
              
              const SizedBox(width: AppConstants.smallPadding),
              
              // Last page
              CustomButton(
                text: 'الأخيرة',
                onPressed: currentPage < totalPages ? () => onPageChanged(totalPages) : null,
                height: 32,
                icon: Icons.last_page,
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          // Page info
          Text(
            'الصفحة $currentPage من $totalPages',
            style: AppConstants.captionStyle,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageNumbers = [];
    
    int startPage = (currentPage - 2).clamp(1, totalPages);
    int endPage = (currentPage + 2).clamp(1, totalPages);
    
    if (startPage > 1) {
      pageNumbers.add(_buildPageNumber(1));
      if (startPage > 2) {
        pageNumbers.add(const Text('...'));
      }
    }
    
    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(_buildPageNumber(i));
    }
    
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageNumbers.add(const Text('...'));
      }
      pageNumbers.add(_buildPageNumber(totalPages));
    }
    
    return pageNumbers;
  }

  Widget _buildPageNumber(int page) {
    final isSelected = page == currentPage;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: CustomButton(
        text: page.toString(),
        onPressed: () => onPageChanged(page),
        height: 32,
        width: 32,
        backgroundColor: isSelected ? AppConstants.primaryColor : Colors.grey[300],
        textColor: isSelected ? Colors.white : Colors.black87,
      ),
    );
  }
}
