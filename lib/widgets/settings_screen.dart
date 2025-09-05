import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../l10n/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Settings
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.theme,
                    style: AppConstants.titleStyle,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  SwitchListTile(
                    title: Text(l10n.darkMode),
                    subtitle: Text(appProvider.isDarkMode ? l10n.darkMode : l10n.lightMode),
                    value: appProvider.isDarkMode,
                    onChanged: (value) {
                      appProvider.setTheme(value);
                    },
                    activeColor: AppConstants.primaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Language Settings
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.language,
                    style: AppConstants.titleStyle,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  ListTile(
                    title: const Text('العربية'),
                    leading: const Icon(Icons.language),
                    trailing: appProvider.language == 'ar'
                        ? const Icon(Icons.check, color: AppConstants.primaryColor)
                        : null,
                    onTap: () {
                      appProvider.setLanguage('ar');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('English'),
                    leading: const Icon(Icons.language),
                    trailing: appProvider.language == 'en'
                        ? const Icon(Icons.check, color: AppConstants.primaryColor)
                        : null,
                    onTap: () {
                      appProvider.setLanguage('en');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // App Info
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معلومات التطبيق',
                    style: AppConstants.titleStyle,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  ListTile(
                    title: const Text('اسم التطبيق'),
                    subtitle: Text(AppConstants.appName),
                    leading: const Icon(Icons.apps),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('الإصدار'),
                    subtitle: Text(AppConstants.appVersion),
                    leading: const Icon(Icons.info),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('المطور'),
                    subtitle: const Text('فريق التطوير'),
                    leading: const Icon(Icons.person),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.largePadding),

            // Reset Settings
            Center(
              child: CustomButton(
                text: 'إعادة تعيين الإعدادات',
                onPressed: () {
                  _showResetDialog(context, appProvider);
                },
                backgroundColor: AppConstants.errorColor,
                icon: Icons.restore,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد إعادة التعيين'),
        content: const Text('هل أنت متأكد من أنك تريد إعادة تعيين جميع الإعدادات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              appProvider.resetToDefaults();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إعادة تعيين الإعدادات بنجاح'),
                  backgroundColor: AppConstants.successColor,
                ),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}
