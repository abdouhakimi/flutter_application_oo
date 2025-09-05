# دليل التثبيت والإعداد

## المتطلبات الأساسية

### 1. Flutter SDK
```bash
# تحميل Flutter SDK من الموقع الرسمي
# https://flutter.dev/docs/get-started/install

# إضافة Flutter إلى PATH
export PATH="$PATH:`pwd`/flutter/bin"

# التحقق من التثبيت
flutter doctor
```

### 2. Android Studio
- تحميل Android Studio من الموقع الرسمي
- تثبيت Android SDK
- إعداد Android Virtual Device (AVD)

### 3. VS Code (اختياري)
- تثبيت VS Code
- تثبيت إضافة Flutter
- تثبيت إضافة Dart

## إعداد المشروع

### 1. استنساخ المشروع
```bash
git clone <repository-url>
cd flutter_application_oo
```

### 2. تثبيت التبعيات
```bash
flutter pub get
```

### 3. إعداد Firebase
1. إنشاء مشروع جديد في [Firebase Console](https://console.firebase.google.com/)
2. إضافة تطبيق Android
3. تحميل ملف `google-services.json`
4. وضع الملف في `android/app/`

### 4. إعداد قاعدة البيانات
1. تفعيل Cloud Firestore
2. إنشاء قاعدة البيانات في وضع الإنتاج
3. إعداد قواعد الأمان:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

## تشغيل التطبيق

### 1. وضع التطوير
```bash
flutter run
```

### 2. وضع الإنتاج
```bash
flutter build apk --release
```

### 3. تثبيت APK
```bash
flutter install
```

## إعداد البيئة

### 1. متغيرات البيئة
إنشاء ملف `.env` في مجلد المشروع:

```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
```

### 2. إعداد التوقيع
إنشاء ملف `android/key.properties`:

```properties
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=your-key-alias
storeFile=path-to-your-keystore
```

### 3. تحديث `android/app/build.gradle`:

```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## استكشاف الأخطاء

### 1. مشاكل Flutter
```bash
# تنظيف المشروع
flutter clean

# إعادة تثبيت التبعيات
flutter pub get

# إعادة بناء المشروع
flutter build apk
```

### 2. مشاكل Firebase
- التحقق من ملف `google-services.json`
- التأكد من تفعيل Cloud Firestore
- فحص قواعد الأمان

### 3. مشاكل Android
```bash
# تنظيف Android
cd android
./gradlew clean
cd ..

# إعادة بناء
flutter build apk
```

## الاختبار

### 1. اختبارات الوحدة
```bash
flutter test
```

### 2. اختبارات التكامل
```bash
flutter test integration_test/
```

### 3. اختبارات الأداء
```bash
flutter test --coverage
```

## النشر

### 1. Google Play Store
1. إنشاء حساب مطور
2. إعداد التطبيق في Play Console
3. رفع APK أو AAB
4. ملء معلومات التطبيق
5. نشر التطبيق

### 2. App Store (iOS)
1. إنشاء حساب مطور Apple
2. إعداد التطبيق في App Store Connect
3. رفع التطبيق باستخدام Xcode
4. مراجعة وموافقة Apple

## الصيانة

### 1. التحديثات
```bash
# تحديث Flutter
flutter upgrade

# تحديث التبعيات
flutter pub upgrade
```

### 2. النسخ الاحتياطي
- نسخ احتياطي للكود
- نسخ احتياطي لقاعدة البيانات
- نسخ احتياطي للإعدادات

### 3. المراقبة
- مراقبة الأداء
- مراقبة الأخطاء
- مراقبة الاستخدام

## الدعم

### 1. الوثائق
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Material Design](https://material.io/design)

### 2. المجتمع
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [GitHub Issues](https://github.com/flutter/flutter/issues)

### 3. المساعدة
- فحص ملف `README.md`
- مراجعة ملفات السجل
- التواصل مع فريق التطوير

---

**ملاحظة**: تأكد من اتباع أفضل الممارسات في الأمان والخصوصية عند نشر التطبيق.
