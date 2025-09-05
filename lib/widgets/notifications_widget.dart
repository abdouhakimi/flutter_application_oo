import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_card.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final outOfStockItems = inventoryProvider.getOutOfStockItems();
    final lowStockItems = inventoryProvider.getLowStockItems();

    if (outOfStockItems.isEmpty && lowStockItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications,
                color: AppConstants.warningColor,
                size: 24,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              const Text(
                'التنبيهات',
                style: AppConstants.titleStyle,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          
          if (outOfStockItems.isNotEmpty) ...[
            _buildNotificationItem(
              icon: Icons.warning,
              title: 'نفدت الكمية',
              message: '${outOfStockItems.length} عنصر نفدت كميته',
              color: AppConstants.errorColor,
            ),
            const SizedBox(height: AppConstants.smallPadding),
          ],
          
          if (lowStockItems.isNotEmpty) ...[
            _buildNotificationItem(
              icon: Icons.trending_down,
              title: 'كمية قليلة',
              message: '${lowStockItems.length} عنصر كميته قليلة',
              color: AppConstants.warningColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppConstants.bodyStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  message,
                  style: AppConstants.captionStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
