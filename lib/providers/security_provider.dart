import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityState{
  final String? appPin;
  final bool useBiometrics;

  SecurityState({
    this.appPin, this.useBiometrics = false,
  });
}

class SecurityNotifier extends StateNotifier<SecurityState>{
  SecurityNotifier() : super(SecurityState()){
    _loadSecuritySettings();
  }

  Future<void> _loadSecuritySettings() async{
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString('app_pin');
    final biometrics = prefs.getBool('use_biometrics') ?? false;
    state = SecurityState(appPin: pin, useBiometrics: biometrics);
  }

  Future<void> setAppPin(String pin) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_pin', pin);
    state = SecurityState(appPin: pin, useBiometrics: state.useBiometrics);
  }

  Future<void> toggleBiometrics(bool value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_biometrics', value);
    state = SecurityState(appPin: state.appPin, useBiometrics: value);
  }
}

final securityProvider = StateNotifierProvider<SecurityNotifier, SecurityState>((ref) => SecurityNotifier());