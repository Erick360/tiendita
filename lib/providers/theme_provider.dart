import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier  extends StateNotifier<ThemeMode>{
  ThemeNotifier() : super(ThemeMode.light);

  void changeTheme(ThemeMode themeMode){
    state = themeMode;
  }

}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref){
  return ThemeNotifier();
});