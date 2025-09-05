import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'product_list_screen.dart';
import 'inventory_screen.dart';
import 'store_display_screen.dart';
import '../utils/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.appName),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            AddProductScreen(),
            ProductListScreen(),
            InventoryScreen(),
            StoreDisplayScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _tabController.index,
          selectedItemColor: AppConstants.primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _tabController.index = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'إضافة منتج',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'عرض المنتجات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storage),
              label: 'الكمية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'عرض الكمية',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تأكيد'),
            content: const Text('هل تريد الخروج من التطبيق؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('لا'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('نعم'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
