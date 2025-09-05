import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/inventory_item.dart';
import '../services/firestore_service.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _wholesalePriceController = TextEditingController();
  final _quantityController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _wholesalePriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _addInventoryItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = InventoryItem(
        name: _productNameController.text,
        wholesalePrice: int.parse(_wholesalePriceController.text),
        quantity: int.parse(_quantityController.text),
        originalQuantity: int.parse(_quantityController.text),
        addedDate: DateTime.now(),
        addedTime: DateTime.now(),
      );

      await FirestoreService.addInventoryItem(item);
      _showSuccessSnackBar(AppConstants.inventoryAddedSuccess);
      _clearForm();
    } catch (e) {
      _showErrorSnackBar('فشل في إضافة عنصر المخزون: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    setState(() {
      _productNameController.clear();
      _wholesalePriceController.clear();
      _quantityController.clear();
    });
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.defaultPadding),
            
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إضافة عنصر مخزون جديد',
                    style: AppConstants.titleStyle,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  
                  CustomTextField(
                    controller: _productNameController,
                    labelText: 'اسم السلعة',
                    validator: Validators.validateProductName,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(AppConstants.maxProductNameLength),
                    ],
                  ),
                  
                  const SizedBox(height: AppConstants.defaultPadding),
                  
                  CustomTextField(
                    controller: _wholesalePriceController,
                    labelText: 'سعر الجملة',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => Validators.validatePrice(value, 'سعر الجملة'),
                  ),
                  
                  const SizedBox(height: AppConstants.defaultPadding),
                  
                  CustomTextField(
                    controller: _quantityController,
                    labelText: 'الكمية',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: Validators.validateQuantity,
                  ),
                  
                  const SizedBox(height: AppConstants.largePadding),
                  
                  Center(
                    child: CustomButton(
                      text: 'إضافة السلعة',
                      onPressed: _addInventoryItem,
                      isLoading: _isLoading,
                      icon: Icons.add,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
