import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/app/core/utils/keys.dart';
import '../../data/services/storage/services.dart';

class ThemesServices {
  final StorageService _storage = Get.find<StorageService>();

  bool loadThemeFromBox() => _storage.read(isDarkMode) ?? false;

  saveThemeFromBox(bool isDark) => _storage.write(isDarkMode, isDark);

  ThemeMode get theme => loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme(){
    Get.changeThemeMode(loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    saveThemeFromBox(!loadThemeFromBox());
  }

}
