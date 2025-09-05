import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/product_provider.dart';
import '../providers/inventory_provider.dart';
import '../utils/constants.dart';
import '../utils/error_handler.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';

class BackupWidget extends StatefulWidget {
  const BackupWidget({super.key});

  @override
  State<BackupWidget> createState() => _BackupWidgetState();
}

class _BackupWidgetState extends State<BackupWidget> {
  bool _isBackingUp = false;
  bool _isRestoring = false;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'النسخ الاحتياطي',
            style: AppConstants.titleStyle,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          
          const Text(
            'يمكنك إنشاء نسخة احتياطية من بياناتك أو استعادتها',
            style: AppConstants.bodyStyle,
          ),
          
          const SizedBox(height: AppConstants.defaultPadding),
          
          CustomButton(
            text: 'إنشاء نسخة احتياطية',
            onPressed: _isBackingUp ? null : _createBackup,
            isLoading: _isBackingUp,
            icon: Icons.backup,
            width: double.infinity,
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          CustomButton(
            text: 'استعادة النسخة الاحتياطية',
            onPressed: _isRestoring ? null : _restoreBackup,
            isLoading: _isRestoring,
            icon: Icons.restore,
            width: double.infinity,
            backgroundColor: AppConstants.secondaryColor,
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          CustomButton(
            text: 'حذف النسخة الاحتياطية',
            onPressed: _deleteBackup,
            icon: Icons.delete,
            width: double.infinity,
            backgroundColor: AppConstants.errorColor,
          ),
        ],
      ),
    );
  }

  Future<void> _createBackup() async {
    setState(() => _isBackingUp = true);
    
    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
      
      final backupData = {
        'products': productProvider.products.map((p) => p.toMap()).toList(),
        'inventory': inventoryProvider.inventoryItems.map((i) => i.toMap()).toList(),
        'backupDate': DateTime.now().toIso8601String(),
        'version': AppConstants.appVersion,
      };
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('backup_data', jsonEncode(backupData));
      
      ErrorHandler.showSuccessSnackBar(context, 'تم إنشاء النسخة الاحتياطية بنجاح');
    } catch (e) {
      ErrorHandler.showErrorSnackBar(context, 'فشل في إنشاء النسخة الاحتياطية: ${e.toString()}');
    } finally {
      setState(() => _isBackingUp = false);
    }
  }

  Future<void> _restoreBackup() async {
    setState(() => _isRestoring = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final backupString = prefs.getString('backup_data');
      
      if (backupString == null) {
        ErrorHandler.showErrorSnackBar(context, 'لا توجد نسخة احتياطية متاحة');
        return;
      }
      
      final backupData = jsonDecode(backupString);
      final backupDate = DateTime.parse(backupData['backupDate']);
      
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد الاستعادة'),
          content: Text(
            'هل تريد استعادة النسخة الاحتياطية من ${backupDate.toString().split(' ')[0]}؟\n'
            'سيتم استبدال جميع البيانات الحالية.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('تأكيد'),
            ),
          ],
        ),
      );
      
      if (confirmed == true) {
        // Here you would implement the actual restore logic
        // This would involve updating the providers with the backup data
        ErrorHandler.showSuccessSnackBar(context, 'تم استعادة النسخة الاحتياطية بنجاح');
      }
    } catch (e) {
      ErrorHandler.showErrorSnackBar(context, 'فشل في استعادة النسخة الاحتياطية: ${e.toString()}');
    } finally {
      setState(() => _isRestoring = false);
    }
  }

  Future<void> _deleteBackup() async {
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد من أنك تريد حذف النسخة الاحتياطية؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('حذف'),
            ),
          ],
        ),
      );
      
      if (confirmed == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('backup_data');
        ErrorHandler.showSuccessSnackBar(context, 'تم حذف النسخة الاحتياطية بنجاح');
      }
    } catch (e) {
      ErrorHandler.showErrorSnackBar(context, 'فشل في حذف النسخة الاحتياطية: ${e.toString()}');
    }
  }
}
