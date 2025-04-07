import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'locale_provider.g.dart';
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  static const String _localeKey = 'app_locale';

  @override
  Locale build() {
    _loadLocale();
    return const Locale('en');
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);

    if (localeCode != null) {
      state = Locale(localeCode);
    }
  }

  void setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    state = locale;
  }
}