import 'package:flutter/material.dart';
import 'app_localizations.dart';

class L10n {
  static final List<Locale> supportedLocales = [
    const Locale('ar', ''),
    const Locale('en', ''),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  static Locale? localeResolutionCallback(
    List<Locale>? locales,
    Iterable<Locale> supportedLocales,
  ) {
    if (locales == null || locales.isEmpty) {
      return const Locale('ar', '');
    }

    for (final locale in locales) {
      if (supportedLocales.contains(locale)) {
        return locale;
      }
    }

    return const Locale('ar', '');
  }
}
