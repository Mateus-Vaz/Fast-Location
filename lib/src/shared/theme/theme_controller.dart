import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../storage/hive_config.dart';

/// Guarda o modo de tema escolhido (sistema, claro ou escuro) e o persiste.
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(_read());

  static const _key = 'theme_mode';

  static Box<String> get _box => Hive.box<String>(HiveConfig.settingsBox);

  static ThemeMode _read() {
    final saved = _box.get(_key);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  bool isDark(BuildContext context) {
    return switch (value) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
  }

  void toggle(BuildContext context) {
    value = isDark(context) ? ThemeMode.light : ThemeMode.dark;
    _box.put(_key, value.name);
  }
}
