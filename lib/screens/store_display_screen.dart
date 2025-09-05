import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_card.dart';

class StoreDisplayScreen extends StatefulWidget {
  const StoreDisplayScreen({super.key});

  @override
  State<StoreDisplayScreen> createState() => _StoreDisplayScreenState();
}

class _StoreDisplayScreenState extends State<StoreDisplayScreen> {
  final _searchController = TextEditingController();
  
  List<InventoryItem> _inventoryItems = [];
  List<InventoryItem> _filteredItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupInventoryListener();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setupInventoryListener() {
    FirestoreService.inventoryStream.listen((snapshot) {
      setState(() {
        _inventoryItems = snapshot.docs
            .map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              if (data['name'] == 'اسم غير معروف' ||
                  data['quantity'] == 0 ||
                  data['wholesalePrice'] == 0) {
                return null;
              }
              return InventoryItem.fromMap({
                'id': doc.id,
                ...data,
              });
            })
            .where((item) => item != null)
            .cast<InventoryItem>()
            .toList();
        _filteredItems = List.from(_inventoryItems);
        _isLoading = false;
      });
    });
  }

  void _filterItems(String criteria) {
    setState(() {
      _filteredItems = _inventoryItems
          .where((item) => item.name.toLowerCase().contains(criteria.toLowerCase()))
          .toList();
    });
  }

  void _showOptions(BuildContext context, InventoryItem item) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('تعديل'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(item);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: AppConstants.errorColor),
                title: const Text('حذف'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(item);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(InventoryItem item) {
    final nameController = TextEditingController(text: item.name);
    final priceController = TextEditingController(text: item.wholesalePrice.toString());
    final quantityController = TextEditingController(text: item.quantity.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل العنصر'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم السلعة'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'سعر الجملة'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'الكمية'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _updateItem(item, nameController.text, priceController.text, quantityController.text);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateItem(InventoryItem item, String name, String price, String quantity) async {
    try {
      await FirestoreService.updateInventoryItem(item.id!, {
        'name': name,
        'wholesalePrice': int.tryParse(price) ?? item.wholesalePrice,
        'quantity': int.tryParse(quantity) ?? item.quantity,
      });
      _showSuccessSnackBar(AppConstants.inventoryUpdatedSuccess);
    } catch (e) {
      _showErrorSnackBar('فشل في تحديث العنصر: ${e.toString()}');
    }
  }

  void _showDeleteConfirmation(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من أنك تريد حذف العنصر "${item.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteItem(item);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(InventoryItem item) async {
    try {
      await FirestoreService.deleteInventoryItem(item.name);
      _showSuccessSnackBar(AppConstants.inventoryDeletedSuccess);
    } catch (e) {
      _showErrorSnackBar('فشل في حذف العنصر: ${e.toString()}');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Section
        Padding(
          padding: const EdgeInsets.all(AppConstants.smallPadding),
          child: CustomTextField(
            controller: _searchController,
            labelText: 'ابحث عن سلعة',
            prefixIcon: const Icon(Icons.search, color: AppConstants.primaryColor),
            onChanged: _filterItems,
          ),
        ),
        
        // Inventory Items List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد عناصر في المخزون',
                        style: AppConstants.titleStyle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return CustomCard(
                          child: ListTile(
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  item.isOutOfStock
                                      ? 'الكمية كانت: ${item.originalQuantity}'
                                      : 'الكمية: ${item.quantity}',
                                  style: AppConstants.bodyStyle,
                                ),
                                Text(
                                  'سعر الجملة: DZ ${item.wholesalePrice.toStringAsFixed(2)}',
                                  style: AppConstants.bodyStyle,
                                ),
                                Text(
                                  'تاريخ الإضافة: ${item.addedDate.toString().split(' ')[0]}',
                                  style: AppConstants.captionStyle,
                                ),
                                Text(
                                  'وقت الإضافة: ${item.addedTime.toString().split(' ')[1].substring(0, 8)}',
                                  style: AppConstants.captionStyle,
                                ),
                                if (!item.isOutOfStock) ...[
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: item.stockPercentage / 100,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      item.stockPercentage > 50
                                          ? AppConstants.successColor
                                          : item.stockPercentage > 25
                                              ? AppConstants.warningColor
                                              : AppConstants.errorColor,
                                    ),
                                  ),
                                  Text(
                                    'نسبة المخزون: ${item.stockPercentage.toStringAsFixed(1)}%',
                                    style: AppConstants.captionStyle,
                                  ),
                                ],
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.statusText,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: item.isOutOfStock
                                        ? AppConstants.errorColor
                                        : AppConstants.successColor,
                                  ),
                                ),
                                if (item.isOutOfStock)
                                  const Text(
                                    'نفدت الكمية',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppConstants.errorColor,
                                    ),
                                  ),
                              ],
                            ),
                            onLongPress: () => _showOptions(context, item),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
