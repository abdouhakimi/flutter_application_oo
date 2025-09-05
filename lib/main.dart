// ignore_for_file: prefer_const_constructors, avoid_print
// تجاهل التحذيرات المتعلقة بالثوابت والطباعة في الكونسول

import 'package:flutter/material.dart'; // استيراد مكتبة المواد
import 'package:intl/intl.dart'; // استيراد مكتبة تنسيق التاريخ
import 'package:firebase_core/firebase_core.dart'; // استيراد مكتبة Firebase الأساسية
import 'firebase_options.dart'; // استيراد إعدادات Firebase
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Firestore
import 'package:logging/logging.dart'; // استيراد مكتبة السجلات
import 'package:uuid/uuid.dart'; // استيراد مكتبة UUID لإنشاء معرفات فريدة
// استيراد مكتبة شريط التبويب المتحر
import 'package:dropdown_button2/dropdown_button2.dart'; // استيراد مكتبة DropdownButton2
import 'package:flutter/services.dart'; // استيراد مكتبة الخدمات لـ Flutter

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // التأكد من تهيئة الواجهات
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // تهيئة Firebase
  FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true); // تمكين الاستمرارية في Firestore
  Logger.root.level = Level.ALL; // تعيين مستوى السجل
  Logger.root.onRecord.listen((record) {
    print(
        '${record.level.name}: ${record.time}: ${record.message}'); // طباعة السجلات
  });
  runApp(const ProfitCalculatorApp()); // تشغيل التطبيق
}

class FirestoreHelper {
  static final FirebaseFirestore _db =
      FirebaseFirestore.instance; // إنشاء مثيل Firestore
  static final CollectionReference _productsCollection =
      _db.collection('products'); // الوصول إلى مجموعة المنتجات
  static final CollectionReference _quantitiesCollection =
      _db.collection('quantities'); // الوصول إلى مجموعة الكميات

  static Future<bool> checkIfNameExists(String name) async {
    final result = await _productsCollection
        .where('name', isEqualTo: name)
        .limit(1)
        .get(); // التحقق من وجود الاسم
    return result.docs.isNotEmpty; // إرجاع صحيح إذا وجد الاسم
  }

  static Future<void> addProduct(Product product) async {
    try {
      String uniqueId = Uuid().v4(); // إنشاء UUID
      product.id = uniqueId; // تعيين UUID كمعرف للمنتج
      await _productsCollection
          .doc(uniqueId)
          .set(product.toMap()); // إضافة المنتج
      await _quantitiesCollection
          .doc(uniqueId)
          .set({'quantity': 0}); // تهيئة الكمية
      print('Product added with UUID: $uniqueId'); // طباعة رسالة الإضافة
    } catch (e) {
      print('Error adding product: $e'); // طباعة رسالة الخطأ
    }
  }

  static Future<void> updateProduct(Product product) async {
    try {
      await _productsCollection
          .doc(product.id)
          .update(product.toMap()); // تحديث المنتج
      print(
          'Product updated successfully with ID: ${product.id}'); // طباعة رسالة التحديث
    } catch (e) {
      print('Error updating product: $e'); // طباعة رسالة الخطأ
    }
  }

  static Future<void> deleteProductByName(String productName) async {
    try {
      QuerySnapshot querySnapshot = await _productsCollection
          .where('name', isEqualTo: productName)
          .get(); // البحث عن المنتجات بالاسم

      for (var doc in querySnapshot.docs) {
        await _productsCollection.doc(doc.id).delete(); // حذف المنتجات
      }
      print(
          'All products with name $productName have been deleted successfully'); // طباعة رسالة الحذف
    } catch (e) {
      print('Error deleting products by name: $e'); // طباعة رسالة الخطأ
    }
  }

  static Future<void> updateProductDetails(Product product) async {
    try {
      await _quantitiesCollection
          .doc(product.id)
          .update(product.toMap()); // تحديث جميع بيانات المنتج
      print(
          'Product details updated successfully with ID: ${product.id}'); // طباعة رسالة التحديث
    } catch (e) {
      print('Error updating product details: $e'); // طباعة رسالة الخطأ
    }
  }

  static Future<List<Map<String, dynamic>>> getAllQuantities() async {
    try {
      final querySnapshot =
          await _quantitiesCollection.get(); // الحصول على جميع الكميات
      return querySnapshot.docs
          .map((doc) => {
                'name': (doc.data() as Map<String, dynamic>)['name'],
                'quantity':
                    (doc.data() as Map<String, dynamic>)['quantity'] ?? 0,
                'wholesalePrice':
                    (doc.data() as Map<String, dynamic>)['wholesalePrice'] ?? 0
              })
          .toList(); // تحويل النتائج إلى قائمة
    } catch (e) {
      print('Error getting quantities: $e'); // طباعة رسالة الخطأ
      return []; // إرجاع قائمة فارغة في حالة الخطأ
    }
  }

  static Future<void> addInventoryItem(Map<String, dynamic> itemData) async {
    try {
      String uniqueId = Uuid().v4(); // إنشاء UUID
      itemData['id'] = uniqueId; // تعيين UUID كمعرف للعنصر
      // تسجيل التاريخ والوقت الحاليين
      itemData['addedDate'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
      itemData['addedTime'] = DateFormat('HH:mm:ss').format(DateTime.now());
      itemData['originalQuantity'] =
          itemData['quantity']; // تخزين الكمية الأصلية
      await _quantitiesCollection.doc(uniqueId).set(itemData); // إضافة العنصر
      print('Inventory item added with ID: $uniqueId'); // طباعة رسالة الإضافة
    } catch (e) {
      print('Error adding inventory item: $e'); // طباعة رسالة الخطأ
    }
  }

  static Future<void> updateInventoryItem(
      String id, Map<String, dynamic> itemData) async {
    try {
      await _quantitiesCollection.doc(id).update(itemData);
      print('Inventory item updated successfully with ID: $id');
    } catch (e) {
      print('Error updating inventory item: $e');
    }
  }
}

class ProfitCalculatorApp extends StatelessWidget {
  const ProfitCalculatorApp({super.key}); // البناء

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حاسبة الأرباح', // عنوان التطبيق
      theme: ThemeData(
        primarySwatch: Colors.blue, // اللون الأساسي
      ),
      home: const ProfitCalculatorScreen(), // الشاشة الرئيسية
    );
  }
}

class Product {
  String? id; // تغيير النوع من int? إلى String?
  String name; // اسم المنتج
  int wholesalePrice; // سعر الجملة
  int retailPrice; // سعر التجزئة
  DateTime savedAt; // تاريخ الحفظ

  Product({
    this.id,
    required this.name, // الاسم مطلوب
    required this.wholesalePrice, // سعر الجملة مطلوب
    required this.retailPrice, // سعر التجزئة مطلوب
    required this.savedAt, // تاريخ الحفظ مطلوب
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, // معرف المنتج
      'name': name, // اسم المنتج
      'wholesale_price': wholesalePrice, // سعر الجملة
      'retail_price': retailPrice, // سعر التجزئة
      'saved_at': DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(savedAt), // تنسيق تاريخ الحفظ
    };
  }

  int calculateProfit() {
    return retailPrice - wholesalePrice; // حساب الربح
  }

  static DateTime parseSavedAt(dynamic savedAt) {
    if (savedAt is Timestamp) {
      return savedAt.toDate(); // تحويل الطابع الزمني إلى تاريخ
    } else if (savedAt is String) {
      try {
        return DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(savedAt, true); // تحليل التاريخ من النص
      } catch (e) {
        print('Error parsing date: $e'); // طباعة رسالة الخطأ
        return DateTime.now(); // استخدام التاريخ الحالي كقيمة افتراضية
      }
    } else {
      print(
          'Unknown date format: $savedAt'); // طباعة رسالة تنسيق التاريخ غير معروف
      return DateTime.now(); // استخدام التاريخ الحالي كقيمة افتراضية
    }
  }

  factory Product.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    print("Fetching product with ID: ${doc.id}"); // طباعة رسالة جلب المنتج
    return Product(
      id: doc.id, // معرف المنتج
      name: doc.data()['name'], // اسم المنتج
      wholesalePrice:
          (doc.data()['wholesale_price'] as num).toInt(), // سعر الجملة
      retailPrice: (doc.data()['retail_price'] as num).toInt(), // سعر التجزئة
      savedAt: parseSavedAt(doc.data()['saved_at']), // تاريخ الحفظ
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'], // معرف المنتج
      name: map['name'], // اسم المنتج
      wholesalePrice: map['wholesalePrice'], // سعر الجملة
      retailPrice: map['retailPrice'] ?? 0, // سعر التجزئة
      savedAt: map['savedAt'] ?? DateTime.now(), // تاريخ الحفظ
    );
  }
}

class ProfitCalculatorScreen extends StatefulWidget {
  const ProfitCalculatorScreen({super.key}); // البناء

  @override
  ProfitCalculatorScreenState createState() =>
      ProfitCalculatorScreenState(); // إنشاء الحالة
}

class ProfitCalculatorScreenState extends State<ProfitCalculatorScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _wholesalePriceController =
      TextEditingController(); // تحكم في حقل سعر الجملة
  final TextEditingController _retailPriceController =
      TextEditingController(); // تحكم في حقل سعر التجزئة
  final TextEditingController _dateController =
      TextEditingController(); // تحكم جديد لتاريخ
  final TextEditingController _quantityController =
      TextEditingController(); // تحكم جديد للكمية
  final TextEditingController _productNameController =
      TextEditingController(); // تحكم جديد لاسم السلعة
  List<Product> _products = []; // قائمة المنتجات
  final List<Product> _filteredProducts = []; // قائمة المنتجات المفلترة
  late TabController _tabController; // تحكم شريط التبويب
  List<Map<String, dynamic>> _inventoryItems = []; // تخزين عناصر المخزون
  final List<Map<String, dynamic>> _filteredInventoryItems =
      []; // قائمة العناصر المفلترة
  String? selectedCategory; // لتخزين القيمة المختارة
  final List<String> categories = [
    'الفئة 1',
    'الفئة 2',
    'الفئة 3'
  ]; // قائمة الفئات
  List<String> productNames = []; // قائمة لتخزين أسماء السلع
  String? selectedProductName; // لتخزين السلعة المختارة

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _setupProductListener();
    _setupInventoryListener();
    _loadInventoryItems(); // تأكد من تحميل عناصر المخزون عند بدء التطبيق
  }

  void _setupProductListener() {
    FirestoreHelper._productsCollection
        .orderBy('saved_at', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _products = snapshot.docs
            .map((doc) => Product.fromFirestore(
                doc as QueryDocumentSnapshot<Map<String, dynamic>>))
            .toList();
        _filteredProducts.clear();
        _filteredProducts.addAll(_products);
        productNames =
            _products.map((product) => product.name).toSet().toList();
      });
    });
  }

  void _setupInventoryListener() {
    FirestoreHelper._quantitiesCollection.snapshots().listen((snapshot) {
      setState(() {
        _inventoryItems = snapshot.docs
            .map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              // Check if the item has default values
              if (data['name'] == 'اسم غير معروف' ||
                  data['quantity'] == 0 ||
                  data['wholesalePrice'] == 0) {
                // Delete the document from Firestore
                FirestoreHelper._quantitiesCollection.doc(doc.id).delete();
                print("Deleted item with ID: ${doc.id} due to default values.");
                return null; // Return null to filter out this item
              }
              return {
                'id': doc.id,
                'name': data['name'],
                'quantity': data['quantity'],
                'wholesalePrice': data['wholesalePrice'],
                'originalQuantity':
                    data['originalQuantity'], // Added original quantity
                'addedDate': data['addedDate'] ??
                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                'addedTime': data['addedTime'] ??
                    DateFormat('HH:mm:ss').format(DateTime.now()),
              };
            })
            .where((item) => item != null)
            .toList()
            .cast<Map<String, dynamic>>(); // Cast to non-nullable
        _filteredInventoryItems.clear();
        _filteredInventoryItems
            .addAll(_inventoryItems); // تحديث القائمة المفلترة
        productNames = _inventoryItems
            .map((item) => item['name'] as String)
            .toSet()
            .toList();
      });
    });
  }

  void filterInventoryItems(String criteria) {
    setState(() {
      _filteredInventoryItems.clear();
      _filteredInventoryItems.addAll(
          _inventoryItems.where((item) => item['name'].contains(criteria)));
    });
  }

  void _loadProducts() async {
    try {
      // ترتيب المنتجات حسب 'saved_at' بشكل تنازلي
      var productsSnapshot = await FirestoreHelper._productsCollection
          .orderBy('saved_at', descending: true)
          .get();
      setState(() {
        _products = productsSnapshot.docs
            .map((doc) => Product.fromFirestore(
                doc as QueryDocumentSnapshot<Map<String, dynamic>>))
            .toList();
        _filteredProducts.clear();
        _filteredProducts.addAll(_products);
        productNames = _products
            .map((product) => product.name)
            .toSet()
            .toList(); // Ensure uniqueness
        print("Loaded products: $_products");
      });
    } catch (e) {
      print('Failed to load products: $e');
    }
  }

  void _loadInventoryItems() async {
    try {
      var snapshot = await FirestoreHelper._quantitiesCollection.get();
      var items =
          <Map<String, dynamic>>[]; // Explicitly define the type of items
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        // Check if the item has default values and skip adding it if true
        if (data['name'] != 'اسم غير معروف' &&
            data['quantity'] != 0 &&
            data['wholesalePrice'] != 0) {
          items.add({
            'id': doc.id,
            'name': data['name'],
            'quantity': data['quantity'],
            'wholesalePrice': data['wholesalePrice'],
            'originalQuantity':
                data['originalQuantity'], // Added original quantity
            'addedDate': data['addedDate'] ??
                DateFormat('yyyy-MM-dd').format(DateTime.now()),
            'addedTime': data['addedTime'] ??
                DateFormat('HH:mm:ss').format(DateTime.now()),
          });
        } else {
          // Optionally, delete the document from Firestore
          await FirestoreHelper._quantitiesCollection.doc(doc.id).delete();
          print("Deleted item with ID: ${doc.id} due to default values.");
        }
      }
      setState(() {
        _inventoryItems.clear();
        _inventoryItems.addAll(items);
        _filteredInventoryItems.clear();
        _filteredInventoryItems
            .addAll(_inventoryItems); // Update the filtered list
        productNames = _inventoryItems
            .map((item) => item['name'] as String)
            .toSet()
            .toList();
        print("Updated product names: $productNames");
      });
    } catch (e) {
      print('Error loading quantities: $e');
    }
  }

  void filterProducts(String criteria) {
    setState(() {
      _filteredProducts.clear();
      _filteredProducts.addAll(
          _products.where((product) => product.name.contains(criteria)));
      print(
          "Filtered products: $_filteredProducts"); // Print filtered products for debugging
    });
  }

  void filterProductsByDate(DateTime date) {
    setState(() {
      _filteredProducts.clear();
      _filteredProducts.addAll(_products.where((product) {
        return DateFormat('yyyy-MM-dd').format(product.savedAt) ==
            DateFormat('yyyy-MM-dd').format(date);
      }).toList());
    });
  }

  void _resetFilter() {
    setState(() {
      _dateController.clear();
      _filteredProducts.clear();
      _filteredProducts.addAll(_products);
    });
  }

  @override
  void dispose() {
    _wholesalePriceController.dispose();
    _retailPriceController.dispose();
    _dateController.dispose(); // Dispose the new date controller
    _quantityController.dispose(); // Dispose the new quantity controller
    _productNameController.dispose(); // Dispose the new product name controller
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'حاسبة الأرباح',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAddProductTab(),
            _buildProductListTab(),
            _buildquantityTab(),
            _buildStoreDisplayTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
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
          currentIndex: _tabController.index,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _tabController.index = index;
            });
          },
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('تأكيد'),
            content: Text('هل تريد الخروج من التطبيق؟'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('لا'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('نعم'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget _buildAddProductTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16.0),
            DropdownButtonFormField2(
              decoration: InputDecoration(
                labelText: 'اختر منتج',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: _inventoryItems
                  .map((item) => DropdownMenuItem<String>(
                        value: item['name'] as String,
                        child: Text(item['name'] as String),
                      ))
                  .toList(),
              value: selectedProductName,
              onChanged: (value) {
                setState(() {
                  selectedProductName = value as String?;
                  _wholesalePriceController.text = _inventoryItems
                      .firstWhere((item) => item['name'] == selectedProductName,
                          orElse: () =>
                              {'wholesalePrice': '0.0'})['wholesalePrice']
                      .toString();
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _retailPriceController,
              decoration: InputDecoration(
                labelText: 'سعر التجزئة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: selectedProductName != null ? _addProduct : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5.0,
                ),
                child: const Text('إضافة منتج'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) => filterProducts(value),
            decoration: InputDecoration(
              labelText: 'ابحث عن منتج',
              labelStyle: TextStyle(color: Colors.blue),
              prefixIcon: Icon(Icons.search, color: Colors.blue),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _dateController,
            decoration: InputDecoration(
              labelText: 'تاريخ الإضافة',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: _resetFilter,
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            ),
            readOnly: true, // Set readOnly to true
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return Card(
                elevation: 4.0,
                margin: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'سعر الجملة: DZ ${product.wholesalePrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'سعر التجزئة: DZ ${product.retailPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'الربح: DZ ${product.calculateProfit().toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'التاريخ: ${DateFormat('yyyy-MM-dd').format(product.savedAt)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'الوقت: ${DateFormat('HH:mm:ss').format(product.savedAt)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _showEditProductDialog(product);
                    },
                  ),
                  onLongPress: () {
                    if (product.id != null) {
                      _confirmDeleteProduct(product.id!);
                    } else {
                      print('Product ID is null');
                      // Optionally, handle the null case, e.g., show a snackbar message
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildquantityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _productNameController,
            decoration: InputDecoration(
              labelText: 'اسم السلعة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _wholesalePriceController,
            decoration: InputDecoration(
              labelText: 'سعر الجملة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _quantityController,
            decoration: InputDecoration(
              labelText: 'الكمية',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _addInventoryItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 5.0,
              ),
              child: const Text('إضافة السلعة'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDisplayTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) => filterInventoryItems(value),
            decoration: InputDecoration(
              labelText: 'ابحث عن سلعة',
              labelStyle: TextStyle(color: Colors.blue),
              prefixIcon: Icon(Icons.search, color: Colors.blue),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredInventoryItems.length,
            itemBuilder: (context, index) {
              final item = _filteredInventoryItems[index];
              return Card(
                elevation: 4.0,
                margin: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    '${item['name']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['quantity'] == 'نفذت الكمية'
                            ? ' الكمية  كانت: ${item['originalQuantity']}'
                            : 'الكمية: ${item['quantity']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'سعر الجملة: DZ ${(item['wholesalePrice'] ?? 0).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'تاريخ الإضافة: ${item['addedDate']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'وقت الإضافة: ${item['addedTime']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Text(
                    item['quantity'] == 'نفذت الكمية'
                        ? ' الكمية نفدت'
                        : '${item['quantity']}',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: item['quantity'] == 'نفذت الكمية'
                            ? Colors.red
                            : Colors.green),
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

  void _showOptions(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('تعديل'),
                    onTap: () {
                      Navigator.pop(context);
                      _showEditInventoryItemDialog(item);
                    }),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('حذف'),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDeleteInventoryItem(item['name']);
                  },
                ),
              ],
            ),
          );
        });
  }

  void _showEditInventoryItemDialog(Map<String, dynamic> item) {
    if (item['id'] == null) {
      print("Error: Item ID is null");
      return;
    }

    TextEditingController nameController =
        TextEditingController(text: item['name']);
    TextEditingController wholesalePriceController =
        TextEditingController(text: item['wholesalePrice'].toString());
    TextEditingController quantityController =
        TextEditingController(text: item['quantity'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تعديل العنصر'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'اسم السلعة'),
                ),
                TextField(
                  controller: wholesalePriceController,
                  decoration: InputDecoration(labelText: 'سعر الجملة'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'الكمية'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('حفظ'),
              onPressed: () async {
                Navigator.of(context).pop();
                await FirestoreHelper.updateInventoryItem(item['id'], {
                  'name': nameController.text,
                  'wholesalePrice':
                      double.tryParse(wholesalePriceController.text) ??
                          item['wholesalePrice'],
                  'quantity':
                      int.tryParse(quantityController.text) ?? item['quantity'],
                });
                _loadInventoryItems(); // Refresh the inventory list after update
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteInventoryItem(String itemName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد من أنك تريد حذف العنصر $itemName؟'),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('حذف'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteInventoryItem(itemName);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteInventoryItem(String itemName) async {
    try {
      QuerySnapshot snapshot = await FirestoreHelper._quantitiesCollection
          .where('name', isEqualTo: itemName)
          .get();
      for (var doc in snapshot.docs) {
        await FirestoreHelper._quantitiesCollection.doc(doc.id).delete();
      }
      _loadInventoryItems(); // Refresh the inventory list
      showSnackbar('تم حذف العنصر بنجاح');
    } catch (e) {
      showSnackbar('فشل في حذف العنصر');
    }
  }

  void _addProduct() async {
    if (_wholesalePriceController.text.isEmpty ||
        _retailPriceController.text.isEmpty ||
        selectedProductName == null) {
      showSnackbar('يرجى ملء جميع الحقول واختيار اسم المنتج');
      return;
    }

    final product = Product(
      name: selectedProductName!,
      wholesalePrice: int.tryParse(_wholesalePriceController.text) ?? 0,
      retailPrice: int.tryParse(_retailPriceController.text) ?? 0,
      savedAt: DateTime.now(),
    );

    try {
      await _updateInventoryQuantity(
          selectedProductName!, -1); // تحديث الكمية أولاً
      await FirestoreHelper.addProduct(product);
      showSnackbar('تم إضافة المنتج بنجاح');
      _loadProducts(); // إعادة تحميل البيانات بعد إضافة متج جديد
      setState(() {
        selectedProductName = null; // إعادة تعيين القيمة المختارة لل Dropdown
      });
    } catch (e) {
      showSnackbar('نفذت الكمية في المخزن ${e.toString()}');
    }
  }

  Future<void> _updateInventoryQuantity(String productName, int change) async {
    try {
      var snapshot = await FirestoreHelper._quantitiesCollection
          .where('name', isEqualTo: productName)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        int currentQuantity = data['quantity'] ?? 0;
        int newQuantity = currentQuantity + change;
        if (newQuantity > 0) {
          await FirestoreHelper._quantitiesCollection
              .doc(doc.id)
              .update({'quantity': newQuantity});
          showSnackbar('تم تحديث الكمية بنجاح');
        } else {
          await FirestoreHelper._quantitiesCollection
              .doc(doc.id)
              .update({'quantity': 'نفذت الكمية'});
          showSnackbar('نفذت الكمية');
        }
      }
    } catch (e) {
      print('Error updating inventory quantity: $e');
      throw Exception('Error updating inventory');
    }
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showEditProductDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تعدي المنتج'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _wholesalePriceController
                    ..text = product.wholesalePrice.toString(),
                  decoration: InputDecoration(labelText: 'سعر الجملة'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _retailPriceController
                    ..text = product.retailPrice.toString(),
                  decoration: InputDecoration(labelText: 'سعر التجزئة'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('حفظ'),
              onPressed: () {
                _updateProduct(product);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProduct(Product product) async {
    product.wholesalePrice =
        int.tryParse(_wholesalePriceController.text) ?? product.wholesalePrice;
    product.retailPrice =
        int.tryParse(_retailPriceController.text) ?? product.retailPrice;

    try {
      await FirestoreHelper.updateProduct(product);
      print('Product updated successfully with ID: ${product.id}');
      _loadProducts(); // إعادة تحميل المنتجات لعس التحديث
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  void _confirmDeleteProduct(String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد من أنك تريد حذف هذا المنتج؟'),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('حذف'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProductById(productId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProductById(String productId) async {
    try {
      await FirestoreHelper._productsCollection.doc(productId).delete();
      _loadProducts(); // إعادة تحميل البيانات بعد الحذف
      showSnackbar('تم حذف المنتج بنجاح');
    } catch (e) {
      showSnackbar('فشل في حذف المنتج');
      print('Error deleting product: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        filterProductsByDate(picked); // Call filterProductsByDate
      });
    }
  }

  void _addInventoryItem() async {
    // التحقق من أن جميع الحقول مملوءة
    if (_productNameController.text.isEmpty ||
        _wholesalePriceController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      showSnackbar('يرجى ملء جميع الحقول للمخزون');
      return;
    }

    String name = _productNameController.text;
    int wholesalePrice = int.tryParse(_wholesalePriceController.text) ?? 0;
    int quantity = int.tryParse(_quantityController.text) ?? 0;

    // التحقق من وجود الاسم في المخزون
    QuerySnapshot existingItems = await FirestoreHelper._quantitiesCollection
        .where('name', isEqualTo: name)
        .get();

    if (existingItems.docs.isNotEmpty) {
      showSnackbar('اسم المنتج موجود بالفعل. يرجى اختيار اسم آخر.');
      return;
    }

    Map<String, dynamic> itemData = {
      'name': name,
      'wholesalePrice': wholesalePrice,
      'quantity': quantity,
      'originalQuantity': quantity, // تخزين الكمية الأصلية
      'addedDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'addedTime': DateFormat('HH:mm:ss').format(DateTime.now()),
    };

    try {
      await FirestoreHelper.addInventoryItem(itemData);
      print('Inventory item added with name: $name');
      _loadInventoryItems(); // إعادة تحميل العناصر لعرض التحديثات
      _clearInventoryFields();
    } catch (e) {
      print('Error adding inventory item: $e');
    }
  }

  void _clearInventoryFields() {
    setState(() {
      _productNameController.text = '';
      _wholesalePriceController.text = '';
      _quantityController.text = '';
    });
  }
}
