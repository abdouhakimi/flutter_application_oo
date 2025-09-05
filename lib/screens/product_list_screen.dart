import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  final _dateController = TextEditingController();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupProductListener();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _setupProductListener() {
    FirestoreService.productsStream.listen((snapshot) {
      setState(() {
        _products = snapshot.docs
            .map((doc) => Product.fromFirestore(
                doc as QueryDocumentSnapshot<Map<String, dynamic>>))
            .toList();
        _filteredProducts = List.from(_products);
        _isLoading = false;
      });
    });
  }

  void _filterProducts(String criteria) {
    setState(() {
      _filteredProducts = _products
          .where((product) => product.name.toLowerCase().contains(criteria.toLowerCase()))
          .toList();
    });
  }

  void _filterProductsByDate(DateTime date) {
    setState(() {
      _filteredProducts = _products
          .where((product) => DateFormat('yyyy-MM-dd').format(product.savedAt) ==
              DateFormat('yyyy-MM-dd').format(date))
          .toList();
    });
  }

  void _resetFilter() {
    setState(() {
      _dateController.clear();
      _searchController.clear();
      _filteredProducts = List.from(_products);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _filterProductsByDate(picked);
      });
    }
  }

  Future<void> _deleteProduct(Product product) async {
    try {
      await FirestoreService.deleteProduct(product.id!);
      _showSuccessSnackBar(AppConstants.productDeletedSuccess);
    } catch (e) {
      _showErrorSnackBar('فشل في حذف المنتج: ${e.toString()}');
    }
  }

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من أنك تريد حذف المنتج "${product.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteProduct(product);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
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
        // Search and Filter Section
        Padding(
          padding: const EdgeInsets.all(AppConstants.smallPadding),
          child: Column(
            children: [
              CustomTextField(
                controller: _searchController,
                labelText: 'ابحث عن منتج',
                prefixIcon: const Icon(Icons.search, color: AppConstants.primaryColor),
                onChanged: _filterProducts,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _dateController,
                      labelText: 'تاريخ الإضافة',
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _resetFilter,
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Products List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد منتجات',
                        style: AppConstants.titleStyle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return CustomCard(
                          child: ListTile(
                            title: Text(
                              product.name,
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
                                  'سعر الجملة: DZ ${product.wholesalePrice.toStringAsFixed(2)}',
                                  style: AppConstants.bodyStyle,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'سعر التجزئة: DZ ${product.retailPrice.toStringAsFixed(2)}',
                                  style: AppConstants.bodyStyle,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'الربح: DZ ${product.calculateProfit().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppConstants.successColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'نسبة الربح: ${product.calculateProfitPercentage().toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppConstants.secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'التاريخ: ${DateFormat('yyyy-MM-dd').format(product.savedAt)}',
                                  style: AppConstants.captionStyle,
                                ),
                                Text(
                                  'الوقت: ${DateFormat('HH:mm:ss').format(product.savedAt)}',
                                  style: AppConstants.captionStyle,
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: AppConstants.errorColor),
                              onPressed: () => _showDeleteConfirmation(product),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
