import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertSettings{
  final int stockLimit;
  final int expiryDays;

  const AlertSettings({
    this.expiryDays = 15,
    this.stockLimit = 2,
  });
}

class AlertSettingsNotifier extends StateNotifier<AlertSettings> {
  AlertSettingsNotifier() : super(const AlertSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final stock = prefs.getInt('stockLimit') ?? 2;
    final expiry = prefs.getInt('expiryDays') ?? 15;
    state = AlertSettings(expiryDays: expiry, stockLimit: stock);
  }

  Future<void> updateStockLimit(int limit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stockLimit', limit);
    state = AlertSettings(expiryDays: state.expiryDays, stockLimit: limit);
  }

  Future<void> updateExpiryDays(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('expiryDays', days);
    state = AlertSettings(expiryDays: days, stockLimit: state.stockLimit);
  }
}

    final alertSettingsProvider = StateNotifierProvider<AlertSettingsNotifier, AlertSettings>((ref){
      return AlertSettingsNotifier();
    });
