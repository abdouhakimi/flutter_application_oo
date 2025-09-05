# تطبيق حاسبة الأرباح 📊

تطبيق Flutter احترافي لإدارة المخزون وحساب الأرباح مع تكامل Firebase.

## ✨ المميزات الرئيسية

- 📦 **إدارة المخزون**: إضافة وتعديل وحذف المنتجات
- 💰 **حساب الأرباح**: حساب تلقائي للأرباح ونسب الربح
- 📊 **تتبع المبيعات**: متابعة المبيعات والكميات
- 🔍 **البحث والفلترة**: بحث متقدم بالاسم والتاريخ
- 📱 **واجهة عصرية**: تصميم Material 3 مع دعم الثيمات
- ☁️ **تخزين سحابي**: تكامل مع Firebase Firestore
- 🔄 **تحديث فوري**: بيانات متزامنة في الوقت الفعلي

## 🏗️ البنية المعمارية

التطبيق يتبع مبادئ Clean Architecture:

```
lib/
├── models/           # نماذج البيانات
│   ├── product.dart
│   ├── inventory_item.dart
│   └── enums.dart
├── services/         # خدمات قاعدة البيانات
│   └── firestore_service.dart
├── providers/        # إدارة الحالة (Provider Pattern)
│   ├── product_provider.dart
│   ├── inventory_provider.dart
│   └── app_provider.dart
├── screens/          # شاشات التطبيق
│   ├── main_screen.dart
│   ├── add_product_screen.dart
│   ├── product_list_screen.dart
│   ├── inventory_screen.dart
│   └── store_display_screen.dart
├── widgets/          # مكونات قابلة لإعادة الاستخدام
│   ├── custom_text_field.dart
│   ├── loading_widget.dart
│   ├── error_widget.dart
│   └── custom_button.dart
├── utils/            # أدوات مساعدة
│   ├── constants.dart
│   ├── validators.dart
│   ├── error_handler.dart
│   └── theme_config.dart
└── main.dart         # نقطة البداية
```

## 🔧 التقنيات المستخدمة

- **Flutter SDK**: إطار العمل الرئيسي
- **Firebase Core & Firestore**: قاعدة البيانات السحابية
- **Provider**: إدارة الحالة
- **Material 3**: نظام التصميم
- **Intl**: تنسيق التواريخ والأرقام
- **UUID**: إنشاء معرفات فريدة
- **Logging**: تسجيل الأخطاء والأحداث

## 📱 الشاشات

### 1. شاشة إضافة المنتجات
- اختيار المنتج من المخزون
- إدخال أسعار الجملة والتجزئة
- حساب تلقائي للربح
- التحقق من صحة البيانات

### 2. شاشة عرض المنتجات
- عرض قائمة المنتجات
- البحث والفلترة
- تعديل وحذف المنتجات
- عرض تفاصيل الربح

### 3. شاشة إدارة المخزون
- إضافة عناصر جديدة للمخزون
- تتبع الكميات
- تحديد حالة المخزون (متوفر/نفذ/قليل)

### 4. شاشة عرض المتجر
- عرض حالة المخزون
- مؤشرات بصرية للكميات
- إدارة العناصر

## 🚀 التشغيل

### المتطلبات
- Flutter SDK (>= 2.17.0)
- Dart SDK
- حساب Firebase
- Android Studio / VS Code

### خطوات التشغيل

1. **استنساخ المشروع**
```bash
git clone <repository-url>
cd flutter_application_oo
```

2. **تثبيت التبعيات**
```bash
flutter pub get
```

3. **إعداد Firebase**
- إنشاء مشروع Firebase جديد
- تفعيل Firestore Database
- تحميل ملف `google-services.json` (Android)
- تحميل ملف `GoogleService-Info.plist` (iOS)

4. **تشغيل التطبيق**
```bash
flutter run
```

## 📊 نماذج البيانات

### Product Model
```dart
class Product {
  String? id;
  String name;
  int wholesalePrice;
  int retailPrice;
  DateTime savedAt;
  
  int calculateProfit() => retailPrice - wholesalePrice;
  double calculateProfitPercentage() => ((retailPrice - wholesalePrice) / wholesalePrice) * 100;
}
```

### InventoryItem Model
```dart
class InventoryItem {
  String? id;
  String name;
  int wholesalePrice;
  int quantity;
  int originalQuantity;
  DateTime addedDate;
  
  InventoryStatus get status; // available, outOfStock, lowStock
  bool get isOutOfStock;
  double get stockPercentage;
}
```

## 🔒 معالجة الأخطاء

- **معالجة شاملة للأخطاء**: Firebase exceptions, network errors, validation errors
- **رسائل خطأ واضحة**: رسائل باللغة العربية للمستخدم
- **تسجيل الأخطاء**: نظام logging متقدم للتتبع
- **إعادة المحاولة**: آليات للتعافي من الأخطاء

## ✅ التحقق من البيانات

- **التحقق من الأسعار**: قيم صحيحة وموجبة
- **التحقق من الكميات**: قيم صحيحة وغير سالبة
- **التحقق من الأسماء**: طول مناسب وأحرف صحيحة
- **مقارنة الأسعار**: سعر التجزئة أكبر من سعر الجملة

## 🎨 التصميم

- **Material Design 3**: أحدث معايير Google للتصميم
- **ثيم موحد**: ألوان وخطوط متسقة
- **تجربة مستخدم سلسة**: انتقالات ناعمة وتفاعل بديهي
- **دعم اللغة العربية**: واجهة باللغة العربية بالكامل

## 📈 الأداء

- **تحميل كسول**: تحميل البيانات عند الحاجة
- **تحديث فوري**: استخدام Streams للتحديث المباشر
- **إدارة ذاكرة فعالة**: تنظيف الموارد تلقائياً
- **تحسين الشبكة**: تقليل استهلاك البيانات

## 🧪 الاختبار

```bash
# تشغيل الاختبارات
flutter test

# تحليل الكود
flutter analyze

# فحص الأداء
flutter build apk --analyze-size
```

## 📱 البناء للإنتاج

### Android
```bash
flutter build apk --release
# أو
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 المساهمة

1. Fork المشروع
2. إنشاء branch جديد (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add amazing feature'`)
4. Push إلى Branch (`git push origin feature/amazing-feature`)
5. فتح Pull Request

## 📄 الرخصة

هذا المشروع مرخص تحت رخصة MIT - راجع ملف [LICENSE](LICENSE) للتفاصيل.

## 📞 التواصل

- **المطور**: [اسمك]
- **البريد الإلكتروني**: [بريدك الإلكتروني]
- **GitHub**: [رابط GitHub]

---

**ملاحظة**: هذا التطبيق تم تطويره باتباع أفضل الممارسات في تطوير Flutter وهو جاهز للاستخدام التجاري.