import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/screens/home_page.dart';
import '../../providers/security_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  static String id = "auth_screen";

  @override
  ConsumerState<AuthScreen> createState() => _AuthState();
}

class _AuthState extends ConsumerState<AuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController _pinController = TextEditingController();
  bool biometricAvailable = false;
  bool _hasEnrolledBiometrics = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final security = ref.read(securityProvider);
      if (security.useBiometrics) {
        _biometricAuth();
      }
    });
  }

  void _checkBiometricAvailability() async {
    try {
      bool available = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      List<BiometricType> enrolledBiometrics = await auth.getAvailableBiometrics();

      setState(() {
        biometricAvailable = available;
        _hasEnrolledBiometrics = enrolledBiometrics.isNotEmpty;
      });
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
    }
  }

  void _onCompleted(String enteredPin) async {
    final savedPin = ref.read(securityProvider).appPin;

    if (savedPin == null || savedPin.isEmpty) {
      await ref.read(securityProvider.notifier).setAppPin(enteredPin);
      if (mounted) Navigator.pushReplacementNamed(context, HomeScreen.id);
      return;
    }

    if (enteredPin == savedPin) {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    } else {
      showErrorSnackBar(context, 'PIN Incorrecto. Intente de nuevo');
      _pinController.clear();
    }
  }

  Future<void> _biometricAuth() async {
    if (!biometricAvailable) return;

    if (!_hasEnrolledBiometrics) {
      _showNoBiometricsAlert();
      return;
    }

    setState(() { isLoading = true; });

    try {
      bool authenticate = await auth.authenticate(
        localizedReason: 'Escanea tu huella (o usa tu rostro) para ingresar.',
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );

      if (authenticate && mounted) {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    } on PlatformException catch (e) {
      debugPrint('Error al autenticar con biometricos: ${e.message}');
    } finally {
      if (mounted) {
        setState(() { isLoading = false; });
      }
    }
  }

  void _showNoBiometricsAlert() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15)),
          title: Row(
            children: [
              Icon(Icons.fingerprint, color: Colors.blue[600], size: 22),
              const SizedBox(width: 10),
              const Text("Atencion!"),
            ],
          ),
          content: const Text(
              'No tienes ninguna huella o rostro registrado en la configuración de este dispositivo.\n\nPor favor, utiliza tu PIN de 4 dígitos para ingresar.',
              style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kActiveColor),
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido', style: TextStyle(color: Colors.white))
            )
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFirstTime = ref.watch(securityProvider).appPin == null || ref.watch(securityProvider).appPin!.isEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 10, bottom: 5,left: 10, right: 10),
                decoration: const BoxDecoration(
                  color: kActiveColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Image.asset(
                  "images/tiendita_banner.png",
                  height: 130,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                isFirstTime ? 'Crear PIN' : 'Ingresar PIN',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  isFirstTime
                      ? "Crea un PIN de 4 dígitos para proteger tu negocio"
                      : "Por favor ingrese su PIN de 4 dígitos para continuar",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),

              Pinput(
                obscureText: true,
                autofocus: true,
                controller: _pinController,
                length: 4,
                onCompleted: _onCompleted,
              ),
              const Spacer(),

              if (biometricAvailable && !isFirstTime)
                Column(
                  children: [
                    const Text("O usa tus datos biometricos para iniciar", style: TextStyle(fontSize: 20, color: Colors.grey)),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: isLoading ? null : _biometricAuth,
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: isLoading
                            ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
                            : Icon(Icons.fingerprint, size: 35, color: Colors.blue[600]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Usar Biometría', style: TextStyle(color: Colors.blue[600], fontSize: 16)),
                    const SizedBox(height: 40),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}