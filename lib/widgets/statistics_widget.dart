import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/inventory_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_card.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الإحصائيات',
            style: AppConstants.titleStyle,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Products Statistics
          _buildStatItem(
            icon: Icons.shopping_cart,
            title: 'إجمالي المنتجات',
            value: productProvider.products.length.toString(),
            color: AppConstants.primaryColor,
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          _buildStatItem(
            icon: Icons.inventory,
            title: 'عناصر المخزون',
            value: inventoryProvider.inventoryItems.length.toString(),
            color: AppConstants.secondaryColor,
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          _buildStatItem(
            icon: Icons.warning,
            title: 'نفدت الكمية',
            value: inventoryProvider.getOutOfStockItems().length.toString(),
            color: AppConstants.errorColor,
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          _buildStatItem(
            icon: Icons.trending_down,
            title: 'كمية قليلة',
            value: inventoryProvider.getLowStockItems().length.toString(),
            color: AppConstants.warningColor,
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          _buildStatItem(
            icon: Icons.attach_money,
            title: 'قيمة المخزون',
            value: 'DZ ${inventoryProvider.getTotalInventoryValue().toStringAsFixed(2)}',
            color: AppConstants.successColor,
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          _buildStatItem(
            icon: Icons.inventory_2,
            title: 'إجمالي الكمية',
            value: inventoryProvider.getTotalItemsCount().toString(),
            color: AppConstants.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: AppConstants.smallPadding),
        Expanded(
          child: Text(
            title,
            style: AppConstants.bodyStyle,
          ),
        ),
        Text(
          value,
          style: AppConstants.bodyStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
