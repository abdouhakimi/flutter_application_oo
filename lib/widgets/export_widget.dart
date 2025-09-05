import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../providers/product_provider.dart';
import '../providers/inventory_provider.dart';
import '../utils/constants.dart';
import '../utils/error_handler.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';

class ExportWidget extends StatefulWidget {
  const ExportWidget({super.key});

  @override
  State<ExportWidget> createState() => _ExportWidgetState();
}

class _ExportWidgetState extends State<ExportWidget> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تصدير البيانات',
            style: AppConstants.titleStyle,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          
          const Text(
            'يمكنك تصدير بيانات المنتجات والمخزون إلى ملفات JSON',
            style: AppConstants.bodyStyle,
          ),
          
          const SizedBox(height: AppConstants.defaultPadding),
          
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'تصدير المنتجات',
                  onPressed: _isExporting ? null : _exportProducts,
                  isLoading: _isExporting,
                  icon: Icons.file_download,
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                child: CustomButton(
                  text: 'تصدير المخزون',
                  onPressed: _isExporting ? null : _exportInventory,
                  isLoading: _isExporting,
                  icon: Icons.inventory,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          CustomButton(
            text: 'تصدير الكل',
            onPressed: _isExporting ? null : _exportAll,
            isLoading: _isExporting,
            icon: Icons.download,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Future<void> _exportProducts() async {
    setState(() => _isExporting = true);
    
    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final products = productProvider.products.map((p) => p.toMap()).toList();
      
      await _saveToFile('products_${DateTime.now().millisecondsSinceEpoch}.json', products);
      
      ErrorHandler.showSuccessSnackBar(context, 'تم تصدير المنتجات بنجاح');
    } catch (e) {
      ErrorHandler.showErrorSnackBar(context, 'فشل في تصدير المنتجات: ${e.toString()}');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportInventory() async {
    setState(() => _isExporting = true);
    
    try {
      final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
      final inventory = inventoryProvider.inventoryItems.map((i) => i.toMap()).toList();
      
      await _saveToFile('inventory_${DateTime.now().millisecondsSinceEpoch}.json', inventory);
      
      ErrorHandler.showSuccessSnackBar(context, 'تم تصدير المخزون بنجاح');
    } catch (e) {
      ErrorHandler.showErrorSnackBar(context, 'فشل في تصدير المخزون: ${e.toString()}');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportAll() async {
    setState(() => _isExporting = true);
    
    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
      
      final data = {
        'products': productProvider.products.map((p) => p.toMap()).toList(),
        'inventory': inventoryProvider.inventoryItems.map((i) => i.toMap()).toList(),
        'exportDate': DateTime.now().toIso8601String(),
      };
      
      await _saveToFile('all_data_${DateTime.now().millisecondsSinceEpoch}.json', data);
      
      ErrorHandler.showSuccessSnackBar(context, 'تم تصدير جميع البيانات بنجاح');
    } catch (e) {
      ErrorHandler.showErrorSnackBar(context, 'فشل في تصدير البيانات: ${e.toString()}');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _saveToFile(String fileName, dynamic data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    await file.writeAsString(jsonString);
  }
}
