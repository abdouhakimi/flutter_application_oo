import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../models/inventory_item.dart';
import '../services/firestore_service.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wholesalePriceController = TextEditingController();
  final _retailPriceController = TextEditingController();
  
  String? selectedProductName;
  List<InventoryItem> _inventoryItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInventoryItems();
  }

  @override
  void dispose() {
    _wholesalePriceController.dispose();
    _retailPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadInventoryItems() async {
    try {
      final snapshot = await FirestoreService.inventoryStream.first;
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
      });
    } catch (e) {
      _showErrorSnackBar('فشل في تحميل عناصر المخزون');
    }
  }

  void _onProductSelected(String? value) {
    setState(() {
      selectedProductName = value;
      if (value != null) {
        final item = _inventoryItems.firstWhere(
          (item) => item.name == value,
          orElse: () => InventoryItem(
            name: '',
            wholesalePrice: 0,
            quantity: 0,
            originalQuantity: 0,
            addedDate: DateTime.now(),
            addedTime: DateTime.now(),
          ),
        );
        _wholesalePriceController.text = item.wholesalePrice.toString();
      }
    });
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedProductName == null) {
      _showErrorSnackBar('يرجى اختيار منتج');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final product = Product(
        name: selectedProductName!,
        wholesalePrice: int.parse(_wholesalePriceController.text),
        retailPrice: int.parse(_retailPriceController.text),
        savedAt: DateTime.now(),
      );

      await FirestoreService.updateInventoryQuantity(selectedProductName!, -1);
      await FirestoreService.addProduct(product);
      
      _showSuccessSnackBar(AppConstants.productAddedSuccess);
      _clearForm();
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    setState(() {
      selectedProductName = null;
      _wholesalePriceController.clear();
      _retailPriceController.clear();
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
                    'إضافة منتج جديد',
                    style: AppConstants.titleStyle,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'اختر منتج',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                    ),
                    items: _inventoryItems
                        .map((item) => DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(item.name),
                            ))
                        .toList(),
                    value: selectedProductName,
                    onChanged: _onProductSelected,
                    validator: (value) => value == null ? 'يرجى اختيار منتج' : null,
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
                    controller: _retailPriceController,
                    labelText: 'سعر التجزئة',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => Validators.validateRetailPrice(
                      value,
                      _wholesalePriceController.text,
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.largePadding),
                  
                  Center(
                    child: CustomButton(
                      text: 'إضافة منتج',
                      onPressed: _addProduct,
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
